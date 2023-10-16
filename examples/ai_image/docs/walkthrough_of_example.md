# Walkthrough of Example

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create ai_image
```

Then open VSCode in that directory:

```sh
code projects/ai_image
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

## Step 1: Create a bucket to store the user's AI generated profile image

Copy the following into `supabase/seed.sql`:

```sql
INSERT INTO storage.buckets(id, name)
VALUES ('images', 'images')
```

Then run:

```sh
supabase db reset
```

Now lets add row-level security to this bucket.

```sh
supabase migration new rls_image_bucket
```

Then copy the following into the generated file
`supabase/migrations/xxx_rls_image_bucket.sql`:

```sql
CREATE POLICY "User can read their images"
ON storage.objects
AS permissive
FOR SELECT 
TO authenticated 
USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));

CREATE POLICY "User can update their images"
ON storage.objects
AS permissive
FOR UPDATE 
TO authenticated 
USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));

CREATE POLICY "User can create their images"
ON storage.objects
AS permissive
FOR INSERT
TO authenticated 
WITH CHECK(((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));

CREATE POLICY "User can delete their images"
ON storage.objects
AS permissive
FOR DELETE 
TO authenticated 
USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));
```

Then run:

```sh
supabase migration up
```

## Step 2: Create an edge function that generates an AI image

Create an edge function file.

```sh
supabase functions new hugging_face_image_generation
```

Make sure you have Deno installed and open VSCode in the `supabase/functions`
directory:

```sh
code supabase/functions
```

Then open VSCode's command palette and select `Deno: Cache Dependencies`.

Next, replace the contents of `hugging_face_image_generation/index.ts` with:

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { HfInference } from "https://esm.sh/@huggingface/inference@2.3.2";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";

const hf = new HfInference(Deno.env.get("HUGGINGFACE_ACCESS_TOKEN"));

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// Start the server

serve(async (req) => {
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders, status: 200 });
  }

  try {
    const { input } = await req.json();

    // Create a Supabase client with the Auth context of the logged in user.
    const supabaseClient = createClient(
      // Supabase API URL - env var exported by default.
      Deno.env.get("SUPABASE_URL") ?? "",
      // Supabase API ANON KEY - env var exported by default.
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      // Create client with Auth context of the user that called the function.
      // This way your row-level-security (RLS) policies are applied.
      {
        global: {
          headers: { Authorization: req.headers.get("Authorization")! },
        },
      },
    );

    // Now we can get the session or user object

    const {
      data: { user },
    } = await supabaseClient.auth.getUser();

    if (!user) {
      throw Error("Invalid JWT");
    }

    // Generate the image using Hugging Face's API

    const imgDesc = await hf.textToImage({
      inputs: input,
      model: "stabilityai/stable-diffusion-2",
      parameters: {
        negative_prompt: "blurry",
      },
    });

    // Upload the image to Supabase Storage

    const imagePath = `/${user.id}/avatar`;

    const { error } = await supabaseClient.storage
      .from("images")
      .upload(imagePath, imgDesc, {
        upsert: true,
      });

    if (error) throw error;

    return new Response(null, {
      headers: corsHeaders,
      status: 200,
    });
  } catch (error) {
    console.log({ error });

    return new Response(JSON.stringify(error), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});
```

To be able to serve this edge function locally, we need to create a
`supabase/functions/.env` file to store the `HUGGINGFACE_ACCESS_TOKEN`.

```sh
touch supabase/functions/.env
```

Sign up on Hugging Face if you haven't done it yet. Generate a new Access Token
under Settings/Access Token. Paste your access token into your `.env` file:

```sh
HUGGINGFACE_ACCESS_TOKEN=XXX
```

To run your edge functions locally, run the following in a terminal:

```sh
supabase functions serve --env-file supabase/functions/.env
```

## Step 3: Call the edge function from the UI

The following files were either created or edited (roughly in this order):

- edited: `app/lib/i18n/translation.i18n.yaml`
- created: `app/lib/repositories/image_generation/repository.dart`
- created: `app/lib/blocs/image_generation/*`
  - `bloc.dart`
  - `event.dart`
  - `state.dart`
- edited: `app/lib/blocs/base_blocs.dart`
- edited: `app/lib/blocs/redux_remote_devtools.dart`
- edited: `app/lib/app/builder.dart`
- edited: `app/test/util/mocked_app.dart`
- edited: `app/test/util/app_builder.dart`
- edited: `app/lib/main/bootstrap.dart`
- created: `app/lib/pages/authenticated/home/widgets/connector/avatar.dart`
- edited: `app/lib/pages/authenticated/home/page.dart`

Note: for the edited files, look for the `// ATTENTION` comments to see what
changed from the base template.

Then run the following:

```sh
make slang_build
make runner_build
```
