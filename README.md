# Gadfly Flutter Template

This is for personal use, so I don't recommend using it. It is not documented and it is subject to change.

## Previous versions

- [v0.1.0](https://github.com/gadfly361/gadfly_flutter_template/tree/v0.1.0), which includes [examples](https://github.com/gadfly361/gadfly_flutter_template/tree/v0.1.0/examples)

## Setup

### FVM

Install [FVM](https://fvm.app/)

```sh
brew tap leoafarias/fvm

brew install fvm

fvm install 3.19.0
```

Then be sure to close your editor and reopen it. Run the following in a terminal at this projects path.

```sh
fvm flutter version
```

The version should be `3.19.0`.

### Supabase

```sh
brew install supabase/tap/supabase

# supabase --version
# 1.142.2
```

## Usage

```sh
./create_app.sh <entire fvm flutter command>

# example:
# ./create_app.sh fvm flutter create my_app
```

_Note: make sure to use `fvm flutter create my_app` and not simply `flutter create my_app`!_

_Note: There is a bug in the `supabase init` command where the `--with-vscode-settings` flag is broken. Your `create_app.sh` will eventually stop and you will see `Generate VS Code settings for Deno? [y/N]`. Be sure to answer `N` because `y` doesn't work._

Then cd into the `projects/my_app` directory and open the `README.md`.
