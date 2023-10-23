# Walkthrough of Example

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create ai_vector_search
```

Then open VSCode in that directory:

```sh
code projects/ai_vector_search
```

Next, make sure Docker is running then start up Supabase locally:

```sh
supabase start
```

You should see a printout similar to this:

```sh
Started supabase local development setup.

         API URL: http://localhost:54321
     GraphQL URL: http://localhost:54321/graphql/v1
          DB URL: postgresql://postgres:postgres@localhost:54322/postgres
      Studio URL: http://localhost:54323
    Inbucket URL: http://localhost:54324
      JWT secret: super-secret-jwt-token-with-at-least-32-characters-long
        anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU
```

Follow the `Studio URL` link. This is a local instance of the Supabase Studio.
You can make edits to your database using this tool.

_Note: Make sure to do everything in `docs/checklist_before_first_run.md`._

## Step 1: Update supabase/seed.sql file

For the sake of this example, we will not demonstrate on how to create
embeddings for the
[Deno documentation](https://github.com/denoland/deno-docs/tree/main/deploy).
Instead, we will provide those in the `supabase/seed.sql` file. Please copy the
contents of `supabase/seed.sql` into that file in your project.

_Reference: <https://github.com/supabase/embeddings-generator>_

## Step 2: Create page_section table

Run the following command:

```sh
supabase migration new create_page_section_table
```

Then copy the following into the
`supabse/migrations/xxx_create_page_section_table.sql` file:

```sql
-- Enable pgvector extension
create extension if not exists vector;

-- Create separate docs schema and grants
create schema if not exists docs;
grant usage on schema docs to postgres, service_role;

-- Create page_section table
create table docs.page_section (
  id bigserial primary key,
  content text,
  token_count int,
  embedding vector(1536) -- size of openai embedding
);
alter table docs.page_section enable row level security;

-- Update table grants
ALTER DEFAULT PRIVILEGES IN SCHEMA docs
GRANT ALL ON TABLES TO postgres, service_role;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON ALL TABLES IN SCHEMA docs 
TO postgres, service_role;

GRANT USAGE, SELECT 
ON ALL SEQUENCES IN SCHEMA docs 
TO postgres, service_role;
```

Because we added a new schema, `docs`, we need to add this to our
`supabase/config.toml` file. Under the `[api]` section, update `schemas` to look
like this:

```toml
schemas = ["public", "storage", "graphql_public", "docs"]
```

## Step 3: add a match_page_selections function

Run the following command:

```sql
supabase migration new match_page_selections_function
```

Then copy the following into the
`supabse/migrations/xxx_match_page_selections_function.sql` file:

```sql
-- Create embedding similarity search functions
create or replace function docs.match_page_sections(embedding vector(1536), match_threshold float, match_count int, min_content_length int)
returns table (id bigint, content text, similarity float)
language plpgsql
as $$
#variable_conflict use_variable
begin
  return query
  select
    page_section.id,
    page_section.content,
    (page_section.embedding <#> embedding) * -1 as similarity
  from page_section

  -- We only care about sections that have a useful amount of content
  where length(page_section.content) >= min_content_length

  -- The dot product is negative because of a Postgres limitation, so we negate it
  and (page_section.embedding <#> embedding) * -1 > match_threshold

  -- OpenAI embeddings are normalized to length 1, so
  -- cosine similarity and dot product will produce the same results.
  -- Using dot product which can be computed slightly faster.
  --
  -- For the different syntaxes, see https://github.com/pgvector/pgvector
  order by page_section.embedding <#> embedding
  
  limit match_count;
end;
$$;
```

Let's run the following to make sure our database is in a good state:

```sh
supabase db reset
supabase stop
supabase start
```

## Step 4: Add vector_search edge function

Run the following command:

```sh
supabase functions new vector_search
```

Then copy the following into `supabase/functions/vector_search/index.ts`:

```typescript
import "xhr";
import { serve } from "std/http/server.ts";
import { createClient } from "@supabase/supabase-js";
import { codeBlock, oneLine } from "commmon-tags";
import GPT3Tokenizer from "gpt3-tokenizer";
import { Configuration, CreateCompletionRequest, OpenAIApi } from "openai";
import { assert } from "std/testing/asserts.ts";

// Throws with an assertion error if the specified environment variable is not defined
export function ensureGetEnv(key: string) {
  const value = Deno.env.get(key);
  assert(value !== undefined, `Missing ${key} environment variable`);
  return value;
}

const OPENAI_KEY = ensureGetEnv("OPENAI_KEY");
const SUPABASE_URL = ensureGetEnv("SUPABASE_URL");
const SUPABASE_SERVICE_ROLE_KEY = ensureGetEnv("SUPABASE_SERVICE_ROLE_KEY");

const supabaseClient = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  db: { schema: "docs" },
});
const openAiConfiguration = new Configuration({ apiKey: OPENAI_KEY });
const openai = new OpenAIApi(openAiConfiguration);

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

export class ApplicationError extends Error {
  // deno-lint-ignore no-explicit-any
  constructor(message: string, public data: Record<string, any> = {}) {
    super(message);
  }
}

export class UserError extends ApplicationError {}

serve(async (req) => {
  try {
    // Handle CORS
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }

    // Search query is passed in request payload
    const { query } = await req.json();

    if (!query) {
      throw new UserError("Missing query in payload");
    }

    const sanitizedQuery = query.trim();

    // Moderate the content to comply with OpenAI T&C
    const moderationResponse = await openai.createModeration({
      input: sanitizedQuery,
    });

    const [results] = moderationResponse.data.results;

    if (results.flagged) {
      throw new UserError("Flagged content", {
        flagged: true,
        categories: results.categories,
      });
    }

    const embeddingResponse = await openai.createEmbedding({
      model: "text-embedding-ada-002",
      input: sanitizedQuery.replaceAll("\n", " "),
    });

    if (embeddingResponse.status !== 200) {
      throw new ApplicationError(
        "Failed to create embedding for question",
        embeddingResponse,
      );
    }

    const [{ embedding }] = embeddingResponse.data.data;

    const { error: matchError, data: pageSections } = await supabaseClient.rpc(
      "match_page_sections",
      {
        embedding,
        match_threshold: 0.78,
        match_count: 10,
        min_content_length: 50,
      },
    );

    if (matchError) {
      throw new ApplicationError("Failed to match page sections", matchError);
    }

    const tokenizer = new GPT3Tokenizer({ type: "gpt3" });
    let tokenCount = 0;
    let contextText = "";

    for (const pageSection of pageSections) {
      const content = pageSection.content;
      const encoded = tokenizer.encode(content);
      tokenCount += encoded.text.length;

      if (tokenCount >= 1500) {
        break;
      }

      contextText += `${content.trim()}\n---\n`;
    }

    const prompt = codeBlock`
      ${oneLine`
        You are a very enthusiastic Deno representative who loves
        to help people! Given the following sections from the Deno
        documentation, answer the question using only that information,
        outputted in markdown format. If you are unsure and the answer
        is not explicitly written in the documentation, say
        "Sorry, I don't know how to help with that."
      `}

      Context sections:
      ${contextText}

      Question: """
      ${sanitizedQuery}
      """

      Answer as markdown (including related code snippets if available):
    `;

    const completionOptions: CreateCompletionRequest = {
      model: "text-davinci-003",
      prompt,
      max_tokens: 512,
      temperature: 0,
      stream: false,
    };

    // The Fetch API allows for easier response streaming over the OpenAI client.
    const response = await fetch("https://api.openai.com/v1/completions", {
      headers: {
        Authorization: `Bearer ${OPENAI_KEY}`,
        "Content-Type": "application/json",
      },
      method: "POST",
      body: JSON.stringify(completionOptions),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new ApplicationError("Failed to generate completion", error);
    }

    // deno-lint-ignore no-explicit-any
    const choice = ((await response.json())["choices"] as Array<any>).at(0);

    return new Response(JSON.stringify(choice), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: unknown) {
    if (err instanceof UserError) {
      return Response.json(
        {
          error: err.message,
          data: err.data,
        },
        {
          status: 400,
          headers: corsHeaders,
        },
      );
    } else if (err instanceof ApplicationError) {
      // Print out application errors with their additional data
      console.error(`${err.message}: ${JSON.stringify(err.data)}`);
    } else {
      // Print out unexpected errors as is to help with debugging
      console.error(err);
    }

    // TODO: include more response info in debug environments
    return Response.json(
      {
        error: "There was an error processing your request",
      },
      {
        status: 500,
        headers: corsHeaders,
      },
    );
  }
});
```

Next, let's create a new file, `supabase/functions/import_map.json` and add the
following to it:

```json
{
  "imports": {
    "commmon-tags": "https://esm.sh/common-tags@1.8.2",
    "gpt3-tokenizer": "https://esm.sh/gpt3-tokenizer@1.1.5",
    "openai": "https://esm.sh/openai@3.2.1",
    "preact": "https://esm.sh/preact@10.13.2",
    "preact/": "https://esm.sh/preact@10.13.2/",
    "preact-render-to-string": "https://esm.sh/*preact-render-to-string@5.2.6",
    "@preact/signals": "https://esm.sh/*@preact/signals@1.1.3",
    "@preact/signals-core": "https://esm.sh/*@preact/signals-core@1.3.0",
    "@supabase/supabase-js": "https://esm.sh/@supabase/supabase-js@2.21.0",
    "std/": "https://deno.land/std@0.184.0/",
    "twind": "https://esm.sh/twind@0.16.19",
    "twind/": "https://esm.sh/twind@0.16.19/",
    "xhr": "https://deno.land/x/xhr@0.3.0/mod.ts",
    "github-slugger": "npm:github-slugger@2.0.0",
    "mdast-util-from-markdown": "npm:mdast-util-from-markdown@1.3.0",
    "mdast-util-mdx": "npm:mdast-util-mdx@2.0.1",
    "mdast-util-to-markdown": "npm:mdast-util-to-markdown@1.5.0",
    "mdast-util-to-string": "npm:mdast-util-to-string@3.2.0",
    "micromark-extension-mdxjs": "npm:micromark-extension-mdxjs@1.0.0",
    "unist-builder": "npm:unist-builder@3.0.1",
    "unist-util-filter": "npm:unist-util-filter@4.0.1",
    "types/mdast": "npm:@types/mdast@3.0.11",
    "types/estree": "npm:@types/estree@1.0.0"
  }
}
```

Now, let's ensure that VSCode knows about this import map, by opening
`.vscode/settings.json` and updating it to look like this:

```json
{
  "search.exclude": {
    "**/.fvm": true
  },
  // Remove from file watching
  "files.watcherExclude": {
    "**/.fvm": true
  },
  "separators.enabledSymbols": [
    "Classes",
    "Enums",
    "Functions",
    "Interfaces",
    "Methods",
    "Namespaces",
    "Structs"
  ],
  "deno.enable": true,
  "deno.lint": true,
  "editor.defaultFormatter": "denoland.vscode-deno",
  // ATTENTION
  "deno.enablePaths": [
    "./supabase/functions"
  ],
  "deno.importMap": "./supabase/functions/import_map.json"
  // ---
}
```

Finally, open the `vector_search/index.ts` file and run the VSCode command
`Deno: Cache Dependencies` to install the Deno dependencies locally.

Note: if you get an error when running `Deno: Cache Dependencies`, just reopen
VSCode at the project root so that the `.vscode/settings.json` picks up the
newly created `supabase/functions/import_map.json` file.

```sh
# Open the file vector_search/index.ts
# Then run `Deno: Cache Dependencies` in VSCode
```

To be able to serve this edge function locally, we need to create a
`supabase/.env` file to store the `OPENAI_KEY`.

```sh
touch supabase/.env
```

Create an OpenAI account if you haven't done it yet and get your api key. Paste
your api key into your `.env` file:

```sh
OPENAI_KEY=XXX
```

You don't want to check-in your .env file, so add `.env` to your
`supabase/.gitignore` file.

To run your edge functions locally, run the following in a terminal:

```sh
supabase functions serve --env-file supabase/.env
```

## Step 5: Update UI to call vector_search edge function

The following files were either created or edited (roughly in this order):

- edited: `app/lib/i18n/translations.i18n.yaml`
- created: `app/lib/repositories/search/repository.dart`
- edited: `app/lib/app/builder.dart`
- edited: `app/main/bootstrap.dart`
- edited: `app/test/util/mocked_app.dart`
- edited: `app/test/util/app_builder.dart`
- created: `app/lib/blocs/search/state.dart`
- created: `app/lib/blocs/search/event.dart`
- edited: `app/lib/blocs/base_blocs.dart`
- edited: `app/lib/blocs/redux_remote_devtools.dart`
- created: `app/lib/blocs/search/bloc.dart`
- edited: `app/pubspec.yaml`
- created:
  `app/lib/pages/authenticated/home/widgets/connector/vector_search.dart`
- created: `app/lib/pages/authenticated/home/page.dart`
- created: `app/test/flows/authenticated/vector_search_test.dart`

Note: for the edited files, look for the `// ATTENTION` comments to see what
changed from the base template.

Run the following to update your dependencies because we added flutter_markdown:

```sh
make flutter_get
```

Run the following to rebuild generated files:

```sh
make slang_build
make runner_build
```
