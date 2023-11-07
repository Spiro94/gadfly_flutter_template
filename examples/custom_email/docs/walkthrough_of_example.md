# Walkthrough of Example

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create custom_email
```

Then open VSCode in that directory:

```sh
code projects/custom_email
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

## Local Development

### Step 1: Update `config.toml` to use an html template for password recovery

reference:
[customizing-email-templates](https://supabase.com/docs/guides/cli/customizing-email-templates)

In the `supabase/config.toml` file, add the following section:

```toml
[auth.email.template.recovery]
subject = "Reset Password"
content_path = "./supabase/templates/recovery.html"
```

We now need to create the file `supabase/templates/recovery.html` and add the
following to it:

```html
<html>
  <body>
    <h2>Custom Reset Password Email</h2>

    <p>Follow this link to reset the password for your user:</p>
    <p><a href="{{ .ConfirmationURL }}">Reset Password</a></p>
  </body>
</html>
```

### Step 2: Confirm the custom email works in local development

Start the flutter application. In VSCode, go to the `Run and Debug` tab and
click play on `development`. Choose `chrome` for the device. This should open up
a web browser with your flutter application.

Create a new user in the signup flow. This automatically signs you in as that
user. Sign yourself out.

Click on the `forgot password` button and type in the email of your new user.

Then go to [localhost:54324](http://localhost:54324) and find the recovery email
in InBucket.

![inbucket1](images/walkthrough_of_example/inbucket1.png?raw=true)

![inbucket2](images/walkthrough_of_example/inbucket2.png?raw=true)

![inbucket3](images/walkthrough_of_example/inbucket3.png?raw=true)

![inbucket4](images/walkthrough_of_example/inbucket4.png?raw=true)

You can see that this email is different than the default email an includes our
customized heading of `Custom Reset Password Email`. We could have customized
this email further, but this is simply a proof of concept.

## In Production

There isn't a straightforward way to promote the custom email from local
development to production. Because of this, we will explicitly call out how to
add a custom email to production in this section.

### Step 1: Update password recovery email template

Sign in to your Supabase project and update the email template for password
recovery.

![email_template](images/walkthrough_of_example/email_template.png?raw=true)

### Step 2: Add a redirect URL

We are going to serve our production flutter app locally at
[localhost:3000](http://localhost:3000), so let's add a redirect URL for
localhost:3000. Note: once we have a hosted website, we will need to change this
URL.

![redirect1](images/walkthrough_of_example/redirect1.png?raw=true)

![redirect2](images/walkthrough_of_example/redirect2.png?raw=true)

![redirect3](images/walkthrough_of_example/redirect3.png?raw=true)

### Step 3: Create a Resend account

In production, we will use SMTP (simple mail transfer protocol) to send custom
emails. We can use [Resend](https://resend.com) for this. Note: we could also
use SendGrid, MailGun, etc.

Sign up for a Resend account.

![create_account](images/walkthrough_of_example/create_account.png?raw=true)

### Step 4: Create a Resend API Key

Create the onboarding API Key. This is a special API Key in that it doesn't
require a verified domain, because it will send an email from
`onboarding@resend.dev`. For the sake of testing out Resend's SMTP, we can use
this email. However, we will eventually need to verify a domain and create an
API Key with that domain.

![api_key1](images/walkthrough_of_example/api_key1.png?raw=true)

![api_key2](images/walkthrough_of_example/api_key2.png?raw=true)

![api_key3](images/walkthrough_of_example/api_key3.png?raw=true)

### Step 5: Connect Supabase to Resend using SMTP

![smtp1](images/walkthrough_of_example/smtp1.png?raw=true)

![smtp2](images/walkthrough_of_example/smtp2.png?raw=true)

### Step 5: Confirm the custom email works in production

Go to `app/lib/main/configuration.dart` and make sure you have added your
**production** Supabase Credentials.

![config](images/walkthrough_of_example/config.png?raw=true)

Start the flutter application. In VSCode, go to the `Run and Debug` tab and
click play on `production`. Choose `chrome` for the device. This should open up
a web browser with your flutter application.

**Note**: Make sure you have completely gone through the "Checklist before first
run" document. In particular, make sure you have _turned off_ `Confirm Email` in
the email auth provider.

Create a new user, but make sure the email is the **same** as the email address
you used when signing up for Resend. This will automatically sign you in. Sign
out.

**Note** Because we are using Resend's Onboarding API Key, we can only send an
email to the email address we used to sign up for Resend. Note: once we verify a
domain and create a new API Key, we will be able to send emails to other email
addresses, but for now, this is our limitation with the Onboarding API Key.

Click on the `forgot password` button and type in the email of your new user.
You should then receive an email address.
