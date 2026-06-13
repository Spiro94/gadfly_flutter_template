# Gadfly Flutter Template

This is for personal use, so I don't recommend using it. It is not documented and it is subject to change.

## What's included

- **Auth flows** — sign-in, sign-up, forgot password, and reset password with BLoC state management and full integration tests
- **Auth error i18n** — localized error messages for all auth failure cases
- **Supabase** — typed auth abstraction, RLS policies example migration, and local dev config
- **Android release signing** — `key.properties`-based keystore wiring in `build.gradle`
- **Sentry** — PII scrubbed from events; deep-link URLs sanitized before logging
- **Startup validation** — app fails fast if `AppConfiguration` still contains `CHANGE_ME` placeholders
- **Theme tokens** — spacing, radius, icon-size, and color extensions
- **Mixpanel** — route observer and effect provider with a fake for tests

## Setup

### FVM

Install [FVM](https://fvm.app/)

```sh
brew tap leoafarias/fvm

brew install fvm
# fvm --version
# 4.0.5

fvm install 3.44.2
```

Then be sure to close your editor and reopen it. Run the following in a terminal at this projects path.

```sh
fvm flutter version
```

The version should be `3.44.2`.

### Supabase

```sh
brew install supabase/tap/supabase

# supabase --version
# 2.101.0
```

## Usage

To create a project based on this template, run the following VSCode Task:

- Open tasks: `CMD+SHIFT+B`
- Select `[GFT] Create app from template`
- Enter your application name (e.g. my_app)
- Enter you company name (e.g. mycompanyname)
