# VSCode for the Application

Reminders:

- to open VSCode Tasks, press `CMD+SHIFT+B`
- to open VSCode Command Palette, press `CMD+SHIFT+P`
- to run the application, open up the "Run and Debug" tab

## Analyze (Task)

```sh
[App] Analyze (Once)
```

Run this VSCode Task if:

- you want to know if there are any analysis errors in your dart code
- the configuration file for the lint rules is `app/analysis_options.yaml`

## Build Runner (Task)

```sh
[App] Build Runner (Once)
```

```sh
[App] Build Runner (Watch)
```

Run either of these VSCode Tasks if:

- you need to update code generation files
  - inclusive of auto_route_generator and json_serializable
  - not inclusive of slang

## Dart Fix (Task)

```sh
[App] Dart Fix (Dry Run)
```

```sh
[App] Dart Fix (Apply)
```

Run either of these VSCode Tasks if:

- there are analysis errors in your dart code and you'd like to fix them through the command line
  - dry run option lets you know what the errors are
  - apply option makes the change

## Modify and Copy Redirect URL for Android Emulator (Task)

For local development, Supabase will generate redirect urls that have a two step process:

- they hit the supabase server do perform some action,
- then redirect you do a redirect url back to your application.

For that first part, Supabase provides a url that start with `http://127.0.0.1`; however, that does not play nicely with android emulators. They prefer `http://10.0.2.2`. So we have a helper VSCode task to make this conversion for you and then copy it to your clipboard.

```sh
[App] Modify and Copy Redirect URL for Android Emulator
```

You can then open a browser in your android emulator and select the popup that says `Link you copied`.

## Prebuild (Task)

```sh
[App] Prebuild (Once)
```

Run this VSCode Task if:

- you just cloned this project
- you just pulled down code from the remote main branch
- your app isn't building correctly

## Run development and production (Runner)

In the "Run and Debug" tab, select from:

```sh
development (debug)
```

```sh
production (debug)
```

For the most part, you will only need to run `development (debug)`.

## Slang (Task)

```sh
[App] Slang (Once)
```

```sh
[App] Slang (Watch)
```

Run either of these VSCode Tasks if:

- you want to update the generated code for internationalization
- the source strings live in `app/lib/i18n/translations.i18n.yaml`
- the configuration file for slang is `app/slang.yaml`

## Test Coverage (Task)

```sh
[App] Test Coverage (Serve)
```

Run this VSCode Task if:

- you want to see a visual representation of the flutter application's test coverage.

## Test (Runner)

To run the flow tests, open up the "Run and Debug" tab in VSCode and then run:

```sh
run flow tests
```

## Test Gallery (Task)

```sh
[App] Test Gallery (Serve)
```

Run this VSCode Task if:

- you want to see a visual flow of possible User Journey's in the from of a Test Gallery.
- you are writing flow tests, and you want to see a visual guide of what is on the screen at any given moment during the test.
- the configuration file to serve the test gallery is `app/mkdocs.yml`
- the Test Gallery will be served at [localhost:8001](http://localhost:8001)

```sh
[App] Test Gallery (Clean)
```

Run this VSCode Task if:

- you want to purge leftover screenshot files.
