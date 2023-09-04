# Gadfly Flutter Template

This is for personal use, so I don't recommend using it. It is not documented and it is subject to change.

## Setup

### FVM

Install [FVM](https://fvm.app/)

```sh
brew tap leoafarias/fvm

brew install fvm

fvm install 3.12.0
```

Then be sure to close your editor and reopen it. Run the following in a terminal at this projects path.

```sh
fvm flutter version
```

The version should be `3.12.0`

### Supabase

```sh
brew install supabase/tap/supabase
```

## Usage

```sh
./create_app.sh <entire flutter command>

# example:
# ./create_app.sh flutter create my_app
```

Then cd into the `projects/my_app` directory and open the `README.md`.
