# Walkthrough of Example

<!-- TOC -->

- [Walkthrough of Example](#walkthrough-of-example)
  - [Step 0: Create a new project to follow along](#step-0-create-a-new-project-to-follow-along)
  - [Step 1: Create a profiles table with row-level security](#step-1-create-a-profiles-table-with-row-level-security)
  - [Step 2: Trigger a database function to add the email in the profiles table](#step-2-trigger-a-database-function-to-add-the-email-in-the-profiles-table)
  - [Step 3: Create edge function that creates a stripe account and then adds the stripe_id in the profiles table](#step-3-create-edge-function-that-creates-a-stripe-account-and-then-adds-the-stripe_id-in-the-profiles-table)
  - [Step 4: Call the edge function from the UI](#step-4-call-the-edge-function-from-the-ui)
  - [Step 5: Add flow-based test](#step-5-add-flow-based-test)
  - [Step 6: Add database tests](#step-6-add-database-tests)

<!-- /TOC -->

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create stripe_edge_function
```

Then open VSCode in that directory:

```sh
code projects/stripe_edge_function
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

*Note: Make sure to do everything in `docs/checklist_before_first_run.md`.*

## Step 1: Create a profiles table with row-level security

Open the local SQL editor:

![profiles_table1](images/walkthrough_of_example/profile_table1.png?raw=true)

Then run the following snippet:

```sql
-- Create a profiles table
CREATE TABLE public.profiles (
  -- have an id as the primary key that is a foreigh key to the auth.users(id) column
    id uuid NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    email text NOT NULL,
    stripe_id text
);

-- Enable row level security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Add RLS policy to be able to select data
CREATE POLICY "User can read their own data"
ON public.profiles
AS permissive
FOR SELECT
TO authenticated
USING (id = auth.uid());
```

Create a migration file for this change. Run the following in a terminal at the
root of this example:

```sh
supabase db diff | supabase migration new create_profiles_table
```

## Step 2: Trigger a database function to add the email in the profiles table

Open the local SQL editor, then run the following snippet to create a trigger
function that will insert a new row into our profiles table:

```sql
CREATE OR REPLACE FUNCTION public.on_signup_insert_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$BEGIN
  INSERT INTO public.profiles(id, email)
  VALUES (new.id, new.email);

  return new;
END;$$;
```

Create a trigger on the auth.users table to trigger the function above:

```sql
CREATE TRIGGER trigger_on_signup_insert_profile
AFTER INSERT ON auth.users
FOR EACH ROW 
EXECUTE FUNCTION on_signup_insert_profile();
```

Create a migration file for this change. Run the following in a terminal at the
root of this example. Note: we are changing the default schema to include the
auth scheme because we made a trigger on auth.users table.

```sh
supabase db diff --schema public,auth | supabase migration new on_signup_insert_profile
```

## Step 3: Create edge function that creates a stripe account and then adds the stripe_id in the profiles table

First, lets create a new edge function file. Run the following from the root of
this example:

```sh
supabase functions new create_stripe_account
```

Make sure you have Deno installed and open VSCode in the `supabase/functions`
directory:

```sh
code supabase/functions
```

Then open VSCode's command palette and select `Deno: Cache Dependencies`.

Next, replace the contents of `create_stripe_account/index.ts` with:

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@13.9.0?target=deno";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

// We need to define this environment variable in a .env file
const stripe = Stripe(Deno.env.get("STRIPE_KEY")!, {
  httpClient: Stripe.createFetchHttpClient(),
});

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Step 1: Check if we have a user's JWT

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

    // Step 2: Create a stripe account

    const customer = await stripe.customers.create({
      email: user.email,
      metadata: {
        supabase_id: user.id,
      },
    });

    // Step 3: Update the profile's table with the user's stripe id

    const { error: updateError } = await supabase
      .from("profiles")
      .update({
        stripe_id: customer.id,
      })
      .match({ id: user.id });

    if (updateError) {
      throw Error("Could not update profiles table with stripe id");
    }

    return new Response(JSON.stringify({ stripe_id: customer.id }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
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
`supabase/functions/.env` file to store the `STRIPE_KEY`.

```sh
touch supabase/functions/.env
```

Get your Stripe key by doing the following:

![stripe1](images/walkthrough_of_example/stripe1.png?raw=true)

![stripe2](images/walkthrough_of_example/stripe2.png?raw=true)

And then paste your Stripe secret key into your `.env` file:

```sh
STRIPE_KEY=XXX
```

To run your edge functions locally, run the following in a terminal:

```sh
supabase functions serve --env-file supabase/functions/.env
```

## Step 4: Call the edge function from the UI

The following files were either created or edited (roughly in this order):

- edited: `app/lib/i18n/translation.i18n.yaml`
- created: `app/lib/repositories/payments/repository.dart`
- created: `app/lib/blocs/payments/*`
  - `bloc.dart`
  - `event.dart`
  - `state.dart`
- edited: `app/lib/blocs/base_blocs.dart`
- edited: `app/lib/blocs/redux_remote_devtools.dart`
- edited: `app/lib/app/builder.dart`
- edited: `app/test/util/mocked_app.dart`
- edited: `app/test/util/app_builder.dart`
- edited: `app/lib/main/bootstrap.dart`
- created:
  `app/lib/pages/authenticated/home/widgets/connector/create_stripe_account_button.dart`
- edited: `app/lib/pages/authenticated/home/page.dart`

Note: for the edited files, look for the `// ATTENTION` comments to see what
changed from the base template.

Then run the following:

```sh
make slang_build
make runner_build
```

## Step 5: Add flow-based test

The following files were either created or edited (roughly in this order):

- edited: `app/test/flows/unauthenticated/sign_in_test.dart`
- edited: `app/test/flows/unauthenticated/sign_up_test.dart`
- edited: `app/test/util/warp/to_home.dart`
- edited: `app/test/flows/unauthenticated/forgot_password_test.dart`
- created: `app/test/flows/authenticated/create_stripe_account_test.dart`

Note: for the edited files, look for the `// ATTENTION` comments to see what
changed from the base template.

To update the test screenshots and then view the gallery, run:

```sh
make screenshots_update
make gallery
```

Then go to [localhost:8000](http://localhost:8000).

## Step 6: Add database tests

For our database tests, we want to make use of
[supabase_test_helpers](https://database.dev/basejump/supabase_test_helpers). To
be able to install that, we first need to install
[dbdev](https://database.dev/).

We need to make a new migration file:

```sh
supabase migration new install_dbdev_and_test_helpers
```

And copy the following into it:

```sql
/*---------------------
---- install dbdev ----
----------------------
Requires:
  - pg_tle: https://github.com/aws/pg_tle
  - pgsql-http: https://github.com/pramsey/pgsql-http
*/
create extension if not exists http with schema extensions;
create extension if not exists pg_tle;
select pgtle.uninstall_extension_if_exists('supabase-dbdev');
drop extension if exists "supabase-dbdev";
select
    pgtle.install_extension(
        'supabase-dbdev',
        resp.contents ->> 'version',
        'PostgreSQL package manager',
        resp.contents ->> 'sql'
    )
from http(
    (
        'GET',
        'https://api.database.dev/rest/v1/'
        || 'package_versions?select=sql,version'
        || '&package_name=eq.supabase-dbdev'
        || '&order=version.desc'
        || '&limit=1',
        array[
            (
                'apiKey',
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJp'
                || 'c3MiOiJzdXBhYmFzZSIsInJlZiI6InhtdXB0cHBsZnZpaWZyY'
                || 'ndtbXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODAxMDczNzI'
                || 'sImV4cCI6MTk5NTY4MzM3Mn0.z2CN0mvO2No8wSi46Gw59DFGCTJ'
                || 'rzM0AQKsu_5k134s'
            )::http_header
        ],
        null,
        null
    )
) x,
lateral (
    select
        ((row_to_json(x) -> 'content') #>> '{}')::json -> 0
) resp(contents);
create extension "supabase-dbdev";
select dbdev.install('supabase-dbdev');
drop extension if exists "supabase-dbdev";
create extension "supabase-dbdev";

-- Install supabase_test_helpers
select dbdev.install('basejump-supabase_test_helpers');
```

Then let's run the following to apply the change:

```sh
supabase migration up
```

Now we can write our database test. Let's start by creating a test file.

```sh
supabase test new insert_profile_on_signup
```

Then copy the following into `supabase/tests/insert_profile_signup_test.sql`:

```sql
BEGIN;
CREATE EXTENSION "basejump-supabase_test_helpers" VERSION '0.0.1';

SELECT plan(9);


-- Check public.profiles table
SELECT has_table('public', 'profiles', 'Should have public.profiles table');
SELECT has_column('public', 'profiles', 'id', 'Should have public.profiles.id column');
SELECT has_column('public', 'profiles', 'email', 'Should have public.profiles.email column');
SELECT has_column('public', 'profiles', 'stripe_id', 'Should have public.profiles.stripe_id column');
SELECT col_is_fk('public', 'profiles', 'id', 'public.profiles.id should be a foreign key');

-- Check trigger_on_signup_insert_count
SELECT has_function('public', 'on_signup_insert_profile', 'Should have on_signup_insert_profile function');
SELECT has_trigger('auth', 'users', 'trigger_on_signup_insert_profile', 'Should have trigger_on_signup_insert_profile trigger');


PREPARE john_doe_rows AS SELECT count(*) FROM public.profiles WHERE id = tests.get_supabase_uid('john_doe');

-- John should not exist in the public.profiles table yet
SELECT results_eq(
  'john_doe_rows',
  $$SELECT 0::bigint$$,
  'Should be zero rows for john doe in public.profiles table'
);


-- Create user
SELECT tests.create_supabase_user('john_doe');


-- Check if trigger_on_signup_instert_count ran successfully

SELECT results_eq(
  'john_doe_rows',
  $$SELECT 1::bigint$$,
  'Should be one row for john doe in public.profiles table'
);


SELECT * FROM finish();
ROLLBACK;
```

You can run your database tests by running:

```sh
supabse db test
```
