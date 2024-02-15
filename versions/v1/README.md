
# Gadfly Flutter Template

**ATTENTION**: To use this older version, open VSCode where the root directory is this directory (i.e. versions/v1). This is necessary so that the `.create_app.sh` script uses the correct `.fvm` directory.

---

This is for personal use, so I don't recommend using it. It is not documented and it is subject to change.

## Setup

### FVM

Install [FVM](https://fvm.app/)

```sh
brew tap leoafarias/fvm

brew install fvm

fvm install 3.13.3
```

Then be sure to close your editor and reopen it. Run the following in a terminal at this projects path.

```sh
fvm flutter version
```

The version should be `3.13.3`.

### Supabase

```sh
brew install supabase/tap/supabase
```

## Usage

```sh
./create_app.sh <entire fvm flutter command>

# example:
# ./create_app.sh fvm flutter create my_app
```

_Note: make sure to use `fvm flutter create my_app` and not simply `flutter create my_app`!_

Then cd into the `projects/my_app` directory and open the `README.md`.
