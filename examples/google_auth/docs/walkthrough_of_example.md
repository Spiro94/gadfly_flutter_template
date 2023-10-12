# Walkthrough of Example

<!-- TOC -->

- [Walkthrough of Example](#walkthrough-of-example)
  - [Step 0: Create a new project to follow along](#step-0-create-a-new-project-to-follow-along)
  - [Step 1: Enable google auth in config.toml](#step-1-enable-google-auth-in-configtoml)
  - [Step 2: Create Google OAuth credentials and copy then into .env file](#step-2-create-google-oauth-credentials-and-copy-then-into-env-file)
  - [Step 3: Update the UI to use google auth](#step-3-update-the-ui-to-use-google-auth)
  - [Step 4: Run the application in a web browser](#step-4-run-the-application-in-a-web-browser)

<!-- /TOC -->

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create google_auth
```

Then open VSCode in that directory:

```sh
code projects/google_auth
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

## Step 1: Enable google auth in `config.toml`

Replace the contents of your `supabase/config.toml` with the following:

```toml
# A string used to distinguish different Supabase projects on the same host. Defaults to the
# working directory name when running `supabase init`.
project_id = "google_auth"

[api]
# Port to use for the API URL.
port = 54321
# Schemas to expose in your API. Tables, views and stored procedures in this schema will get API
# endpoints. public and storage are always included.
schemas = ["public", "storage", "graphql_public"]
# Extra schemas to add to the search_path of every request. public is always included.
extra_search_path = ["public", "extensions"]
# The maximum number of rows returns from a view, table, or stored procedure. Limits payload size
# for accidental or malicious requests.
max_rows = 1000

[db]
# Port to use for the local database URL.
port = 54322
# Port used by db diff command to initialise the shadow database.
shadow_port = 54320
# The database major version to use. This has to be the same as your remote database's. Run `SHOW
# server_version;` on the remote database to check.
major_version = 15

[db.pooler]
enabled = false
port = 54329
pool_mode = "transaction"
default_pool_size = 20
max_client_conn = 100

[studio]
enabled = true
# Port to use for Supabase Studio.
port = 54323
# External URL of the API server that frontend connects to.
api_url = "http://localhost"

# Email testing server. Emails sent with the local dev setup are not actually sent - rather, they
# are monitored, and you can view the emails that would have been sent from the web interface.
[inbucket]
enabled = true
# Port to use for the email testing server web interface.
port = 54324
# Uncomment to expose additional ports for testing user applications that send emails.
# smtp_port = 54325
# pop3_port = 54326

[storage]
# The maximum file size allowed (e.g. "5MB", "500KB").
file_size_limit = "50MiB"

[auth]
# The base URL of your website. Used as an allow-list for redirects and for constructing URLs used
# in emails.
site_url = "http://localhost:3000"
# A list of *exact* URLs that auth providers are permitted to redirect to post authentication.


# ATTENTION 1/2
additional_redirect_urls = ["https://localhost:3000", "http://localhost:54321"]
# ---


# How long tokens are valid for, in seconds. Defaults to 3600 (1 hour), maximum 604,800 (1 week).
jwt_expiry = 3600
# If disabled, the refresh token will never expire.
enable_refresh_token_rotation = true
# Allows refresh tokens to be reused after expiry, up to the specified interval in seconds.
# Requires enable_refresh_token_rotation = true.
refresh_token_reuse_interval = 10
# Allow/disallow new user signups to your project.
enable_signup = true

[auth.email]
# Allow/disallow new user signups via email to your project.
enable_signup = true
# If enabled, a user will be required to confirm any email change on both the old, and new email
# addresses. If disabled, only the new email is required to confirm.
double_confirm_changes = true
# If enabled, users need to confirm their email address before signing in.
enable_confirmations = false

# Uncomment to customize email template
# [auth.email.template.invite]
# subject = "You have been invited"
# content_path = "./supabase/templates/invite.html"

[auth.sms]
# Allow/disallow new user signups via SMS to your project.
enable_signup = true
# If enabled, users need to confirm their phone number before signing in.
enable_confirmations = false

# Configure one of the supported SMS providers: `twilio`, `twilio_verify`, `messagebird`, `textlocal`, `vonage`.
[auth.sms.twilio]
enabled = false
account_sid = ""
message_service_sid = ""
# DO NOT commit your Twilio auth token to git. Use environment variable substitution instead:
auth_token = "env(SUPABASE_AUTH_SMS_TWILIO_AUTH_TOKEN)"

# Use an external OAuth provider. The full list of providers are: `apple`, `azure`, `bitbucket`,
# `discord`, `facebook`, `github`, `gitlab`, `google`, `keycloak`, `linkedin`, `notion`, `twitch`,
# `twitter`, `slack`, `spotify`, `workos`, `zoom`.
[auth.external.apple]
enabled = false
client_id = ""
# DO NOT commit your OAuth provider secret to git. Use environment variable substitution instead:
secret = "env(SUPABASE_AUTH_EXTERNAL_APPLE_SECRET)"
# Overrides the default auth redirectUrl.
redirect_uri = ""
# Overrides the default auth provider URL. Used to support self-hosted gitlab, single-tenant Azure,
# or any other third-party OIDC providers.
url = ""


# ATTENTION 2/2
[auth.external.google]
enabled = true
client_id = "env(SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_ID)"
# DO NOT commit your OAuth provider secret to git. Use environment variable substitution instead:
secret = "env(SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET)"
# Overrides the default auth redirectUrl.
redirect_uri = "http://localhost:54321/auth/v1/callback"
# Overrides the default auth provider URL. Used to support self-hosted gitlab, single-tenant Azure,
# or any other third-party OIDC providers.
url = ""
# ---


[analytics]
enabled = false
port = 54327
vector_port = 54328
# Configure one of the supported backends: `postgres`, `bigquery`
backend = "postgres"
```

## Step 2: Create Google OAuth credentials and copy then into .env file

Go to
[console.cloud.google.com/apis/credentials](https://console.cloud.google.com/apis/credentials)
then do the following:

![google1](images/walkthrough_of_example/google1.png?raw=true)

![google2](images/walkthrough_of_example/google2.png?raw=true)

![google3](images/walkthrough_of_example/google3.png?raw=true)

Create `.gitignore` and `.env` files at the root of this project.

```sh
touch .gitignore
touch .env
```

Copy the following into the `.gitignore`.

```
.env
```

Copy the following into `.env`, but replace the `XXX` with your credentials.

```sh
SUPABASE_AUTH_EXTERNAL_GOOGLE_CLIENT_ID="XXX"
SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET="XXX"
```

## Step 3: Update the UI to use google auth

The following files were either created or edited (roughly in this order):

- edited: `app/lib/i18n/translations.i18n.yaml`
- edited: `app/lib/repositories/auth/repository.dart`
- edited: `app/lib/app/router.dart`
- edited: `app/lib/blocs/sign_in/event.dart`
- edited: `app/lib/blocs/sign_in/bloc.dart`
- created:
  `app/lib/pages/unauthenticated/sign_in/widgets/connector/google_auth_button.dart`
- edited: `app/lib/pages/unauthenticated/sign_in/page.dart`
- created: `app/test/flows/unauthenticated/google_auth_test.dart`

Note: for the edited files, look for the `// ATTENTION` comments to see what
changed from the base template.

Run the following to regenerate the internationalization file:

```sh
make slang_build
```

## Step 4: Run the application in a web browser

Since we added environment variables lets restart our local supabase.

```sh
supabase stop
supabase start
```

Next, lets open our flutter application in a web browser. In VSCode, make sure
the selected device is `Chrome`, then click on the `Run and Debug` tab, select
the `development` option, and finally tap on the play button.

Tap the `Sign in with Google` button. This will take you to a google
authentication screen. Sign in with your gmail account. Note: if you aren't able
to type in your email address, pause the debugger to be able to proceed.
