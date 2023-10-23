# Walkthrough of Example

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create realtime_chat
```

Then open VSCode in that directory:

```sh
code projects/realtime_chat
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

## Step 1: Create messages table

Run the following command:

```sh
supabase migration new messages_table
```

Then copy the following into the `supabse/migrations/xxx_messages_table.sql`
file:

```sql
-- Create message table
CREATE TABLE public.messages (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    user_id uuid NOT NULL,
    message text NOT NULL
);

CREATE UNIQUE INDEX messages_pkey ON public.messages USING btree (id);
ALTER TABLE public.messages ADD CONSTRAINT "messages_pkey" PRIMARY KEY USING INDEX "messages_pkey";
ALTER TABLE public.messages ADD CONSTRAINT  "messages_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) NOT valid;
ALTER TABLE public.messages validate CONSTRAINT "messages_user_id_fkey";

-- Turn RLS on
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Add INSERT policy
CREATE POLICY "Users can create messages"
ON public.messages
AS permissive
FOR INSERT 
TO authenticated
WITH CHECK (true);

-- Add SELECT policy
CREATE POLICY "Users can read messages"
ON public.messages
AS permissive
FOR SELECT
TO authenticated
USING (true);

-- Turn on realtime
ALTER publication supabase_realtime ADD TABLE public.messages;
```

## Step 2: Update UI to send messages and get realtime updates

The following files were either created or edited (roughly in this order):

- edited: `app/lib/i18n/translations.i18n.yaml`
- created: `app/lib/repositories/chat/repository.dart`
- edited: `app/lib/app/builder.dart`
- edited: `app/main/bootstrap.dart`
- edited: `app/test/util/mocked_app.dart`
- edited: `app/test/util/app_builder.dart`
- created: `app/lib/blocs/chat/state.dart`
- created: `app/lib/blocs/chat/event.dart`
- edited: `app/lib/blocs/base_blocs.dart`
- edited: `app/lib/blocs/redux_remote_devtools.dart`
- created: `app/lib/blocs/chat/bloc.dart`
- edited: `app/pubspec.yaml`
- created:
  `app/lib/pages/authenticated/home/widgets/connector/send_message_container.dart`
- created:
  `app/lib/pages/authenticated/home/widgets/connector/messages_container.dart`
- created: `app/lib/pages/authenticated/home/page.dart`
- edited: `app/test/flows/unauthenticated/sign_in_test.dart`
- edited: `app/test/flows/unauthenticated/sign_up_test.dart`
- edited: `app/test/util/warp/to_home.dart`
- edited: `app/test/flows/unauthenticated/forgot_password_test.dart`
- created: `app/test/flows/authenticated/chat_test.dart`

Note: for the edited files, look for the `// ATTENTION` comments to see what
changed from the base template.

Run the following to rebuild generated files:

```sh
make slang_build
make runner_build
```
