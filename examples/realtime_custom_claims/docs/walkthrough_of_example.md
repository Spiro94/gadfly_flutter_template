# Walkthrough of Example

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create realtime_custom_claims
```

Then open VSCode in that directory:

```sh
code projects/realtime_custom_claims
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

## Step 1: Add the custom claims functions

The
[supabase-custom-claims](https://github.com/supabase-community/supabase-custom-claims)
repository has a SQL file to install the custom claims functions. Lets create a
migration file and then copy the contents into it.

```sh
supabase migration new custom_claims
```

Then copy the following into `supabase/migrations/xxx_custom_claims.sql`:

```sql
CREATE OR REPLACE FUNCTION is_claims_admin() RETURNS "bool"
  LANGUAGE "plpgsql" 
  AS $$
  BEGIN
    IF session_user = 'authenticator' THEN
      --------------------------------------------
      -- To disallow any authenticated app users
      -- from editing claims, delete the following
      -- block of code and replace it with:
      -- RETURN FALSE;
      --------------------------------------------
      IF extract(epoch from now()) > coalesce((current_setting('request.jwt.claims', true)::jsonb)->>'exp', '0')::numeric THEN
        return false; -- jwt expired
      END IF;
      If current_setting('request.jwt.claims', true)::jsonb->>'role' = 'service_role' THEN
        RETURN true; -- service role users have admin rights
      END IF;
      IF coalesce((current_setting('request.jwt.claims', true)::jsonb)->'app_metadata'->'claims_admin', 'false')::bool THEN
        return true; -- user has claims_admin set to true
      ELSE
        return false; -- user does NOT have claims_admin set to true
      END IF;
      --------------------------------------------
      -- End of block 
      --------------------------------------------
    ELSE -- not a user session, probably being called from a trigger or something
      return true;
    END IF;
  END;
$$;

CREATE OR REPLACE FUNCTION get_my_claims() RETURNS "jsonb"
    LANGUAGE "sql" STABLE
    AS $$
  select 
   coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata', '{}'::jsonb)::jsonb
$$;

CREATE OR REPLACE FUNCTION get_my_claim(claim TEXT) RETURNS "jsonb"
    LANGUAGE "sql" STABLE
    AS $$
  select 
   coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb -> 'app_metadata' -> claim, null)
$$;

CREATE OR REPLACE FUNCTION get_claims(uid uuid) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER SET search_path = public
    AS $$
    DECLARE retval jsonb;
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN '{"error":"access denied"}'::jsonb;
      ELSE
        select raw_app_meta_data from auth.users into retval where id = uid::uuid;
        return retval;
      END IF;
    END;
$$;

CREATE OR REPLACE FUNCTION get_claim(uid uuid, claim text) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER SET search_path = public
    AS $$
    DECLARE retval jsonb;
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN '{"error":"access denied"}'::jsonb;
      ELSE
        select coalesce(raw_app_meta_data->claim, null) from auth.users into retval where id = uid::uuid;
        return retval;
      END IF;
    END;
$$;

CREATE OR REPLACE FUNCTION set_claim(uid uuid, claim text, value jsonb) RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER SET search_path = public
    AS $$
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN 'error: access denied';
      ELSE        
        update auth.users set raw_app_meta_data = 
          raw_app_meta_data || 
            json_build_object(claim, value)::jsonb where id = uid;
        return 'OK';
      END IF;
    END;
$$;

CREATE OR REPLACE FUNCTION delete_claim(uid uuid, claim text) RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER SET search_path = public
    AS $$
    BEGIN
      IF NOT is_claims_admin() THEN
          RETURN 'error: access denied';
      ELSE        
        update auth.users set raw_app_meta_data = 
          raw_app_meta_data - claim where id = uid;
        return 'OK';
      END IF;
    END;
$$;

NOTIFY pgrst, 'reload schema';
```

To update your local Supabase, you need to apply this migration file by running:

```sh
supabase migration up
```

## Step 2: Create custom claim updates table

Regarding custom claims, there is the following drawback:

> One drawback is that claims don't get updated automatically, so if you assign
> a user a new custom claim, they may need to log out and log back in to have
> the new claim available to them. The same goes for deleting or changing a
> claim. So this is not a good tool for storing data that changes frequently.
>
> You can force a refresh of the current session token by calling
> supabase.auth.refreshSession() on the client, but if a claim is changed by a
> server process or by a claims administrator manually, there's no easy way to
> notify the user that their claims have changed. You can provide a "refresh"
> button or a refresh function inside your app to update the claims at any time,
> though.

We are going to get around this drawback by creating a table that has the most
recent timestamp of a custom claim being changed, and we will have our client
listen to it with a realtime connection. If the timestamp changes, then the
client will call `supabase.auth.refreshSession()`.

Run the following command:

```sh
supabase migration new custom_claim_updates_table
```

Then copy the following into the
`supabse/migrations/xxx_custom_claim_updates_table.sql` file:

```sql
-- Create Custom Claim Updates table
create table "public"."custom_claim_updates" (
    "user_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
);

CREATE UNIQUE INDEX custom_claim_updates_pkey ON public.custom_claim_updates USING btree (user_id);
ALTER TABLE public.custom_claim_updates ADD CONSTRAINT custom_claim_updates_pkey PRIMARY KEY USING INDEX custom_claim_updates_pkey;
ALTER TABLE public.custom_claim_updates ADD CONSTRAINT custom_claim_updates_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE NOT VALID;
ALTER TABLE public.custom_claim_updates VALIDATE CONSTRAINT custom_claim_updates_user_id_fkey;

-- Turn RLS on
ALTER TABLE public.custom_claim_updates ENABLE ROW LEVEL SECURITY;

-- Add SELECT policy
CREATE POLICY "Users can read custom claim updates"
ON public.custom_claim_updates
AS permissive
FOR SELECT
TO authenticated
USING (true);

-- Turn on realtime
ALTER publication supabase_realtime ADD TABLE public.custom_claim_updates;
```

To update your local Supabase, you need to apply this migration file by running:

```sh
supabase migration up
```

## Step 3: Add trigger function to create a custom claim on signup

Assuming we have a claim called `app_role` (that can be either `USER` or
`ADMIN`), we can default this to `USER` when a user signs up. To accomplish
this, we will:

- create a function to update our custom_claim_updates table
- create trigger function that sets the app_role to USER on signup (and also
  calls the function to update our custom_claim_updates table)
- create a trigger that calls the trigger function on signup

```sql
-- Create function to insert or update custom_claim_updates table
CREATE OR REPLACE FUNCTION public.upsert_custom_claim_updates(id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$BEGIN

INSERT INTO public.custom_claim_updates(user_id)
VALUES(id) 
ON CONFLICT (user_id) 
DO UPDATE SET updated_at = now();

END;
$$;

-- Create trigger function to add app_role as USER when user signs up
CREATE OR REPLACE FUNCTION public.on_signup_insert_app_role_claim()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$BEGIN
  PERFORM public.set_claim(new.id, 'app_role', '"USER"');
  PERFORM public.upsert_custom_claim_updates(new.id);

  return new;
END;
$$;

-- Trigger the trigger function when a user signs up
CREATE TRIGGER trigger_on_signup_insert_app_role_claim 
AFTER INSERT ON auth.users 
FOR EACH ROW 
EXECUTE FUNCTION on_signup_insert_app_role_claim();
```

To update your local Supabase, you need to apply this migration file by running:

```sh
supabase migration up
```

## Step 4: Update UI to get realtime updates

The following files were either created or edited (roughly in this order):

- edited: `app/lib/i18n/translations.i18n.yaml`
- created: `app/lib/repositories/custom_claims/repository.dart`
- edited: `app/lib/app/builder.dart`
- edited: `app/main/bootstrap.dart`
- edited: `app/test/util/mocked_app.dart`
- edited: `app/test/util/app_builder.dart`
- created: `app/lib/blocs/custom_claims/state.dart`
- created: `app/lib/blocs/custom_claims/event.dart`
- edited: `app/lib/blocs/base_blocs.dart`
- edited: `app/lib/blocs/redux_remote_devtools.dart`
- created: `app/lib/blocs/custom_claims/bloc.dart`
- created:
  `app/lib/pages/authenticated/home/widgets/connector/app_role_text.dart`
- created: `app/lib/pages/authenticated/home/page.dart`
- edited: `app/test/flows/unauthenticated/sign_in_test.dart`
- edited: `app/test/flows/unauthenticated/sign_up_test.dart`
- edited: `app/test/util/warp/to_home.dart`
- edited: `app/test/flows/unauthenticated/forgot_password_test.dart`
- created: `app/test/flows/authenticated/custom_claims_test.dart`

Note: for the edited files, look for the `// ATTENTION` comments to see what
changed from the base template.

Run the following to rebuild generated files:

```sh
make slang_build
make runner_build
```

## Step 5: Test out the custom claim to ensure it is working in real-time

Start the flutter application. In VSCode, go to the Run and Debug tab and click
play on development. Choose chrome for the device. This should open up a web
browser with your flutter application.

Create a new user in the signup flow.

Then go to the local supabase studio at
[localhost:54323](http://localhost:54323). Open the authentication tab and copy
the user's id (which is a uuid).

![auth_user](images/walkthrough_of_example/auth_user.png?raw=true)

Now, go to the SQL Editor and run the following commands:

```sql
SELECT set_claim('your-user-id-here', 'app_role', '"ADMIN"');
SELECT upsert_custom_claim_updates('your-user-id-here');

-- Example:
-- SELECT set_claim('04830312-5e84-41c8-a4fb-0a08f0cc7f0e', 'app_role', '"ADMIN"');
-- SELECT upsert_custom_claim_updates('04830312-5e84-41c8-a4fb-0a08f0cc7f0e');
```

![set_claim](images/walkthrough_of_example/set_claim.png?raw=true)

Your logged in user's role should change from `USER` to `ADMIN`. This means we
have custom claims in our JWT (which can be used for efficient RLS policies) and
we were able to update it in real-time when there was a change to our claims!
