# Prerequisites

## Android Platform tools

```sh
brew install android-platform-tools
```

This is needed so we can use adb.

## Deno

Install [Deno](https://deno.com/).

```sh
brew install deno

# deno --version
# deno 2.0.6 (stable, release, x86_64-apple-darwin)
# v8 12.9.202.13-rusty
# typescript 5.6.2
```

This is used for Supabase Edge Functions.

## Direnv

Install [direnv](https://github.com/direnv/direnv/tree/master).

```sh
brew install direnv

# direnv --version
# 2.35.0
```

This is used to define environment variables for our project.

## FVM

Install [FVM](https://fvm.app/).

```sh
dart pub global activate fvm

# fvm --version
# 3.2.1
```

```sh
# In the root directory
fvm use 3.27.4
```

This is used to ensure that everyone who is coding on the flutter project is using the same flutter version.

## lcov

Install [lcov](https://github.com/linux-test-project/lcov).

```sh
brew intall lcov

# lcov --version
# lcov: LCOV version 2.3-1
```

This is used when creating a test coverage report.

## mkdocs

Install [mkdocs](https://www.mkdocs.org/) and the [material theme](https://github.com/squidfunk/mkdocs-material).

```sh
pip install mkdocs
```

```sh
pip install mkdocs-material
```

## Supabase CLI

Install [supabase cli](https://supabase.com/docs/guides/local-development/cli/getting-started).

```sh
brew install supabase/tap/supabase

# supabase --version
# 2.12.1
```

This is used to run supabase locally.

## VSCode Extensions

- [deno extension](https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno). This is used for Supabase Edge Functions.
- [direnv extension](https://marketplace.visualstudio.com/items?itemName=mkhl.direnv). This is used so VSCode is aware of `.env` environment variables.
- [flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter). This is used for Flutter development.
