# Development Setup

Our tech stack is Flutter on the front-end and Supabase on the back-end. To
setup your computer for development, follow these steps.

## Flutter version management

Install [FVM](https://fvm.app/)

```sh
brew tap leoafarias/fvm

brew install fvm

fvm install 3.19.0
```

## Redux remote devtools

Get [pyenv](https://github.com/pyenv/pyenv), then set your shell to use python
2.7.28 to install redux's
[remotedev-server](https://www.npmjs.com/package/remotedev-server).

```sh
brew install pyenv
```

```sh
pyenv init
# make sure to follow the instructions
```

```sh
pyenv install 2.7.18
```

```sh
pyenv shell 2.7.18

npm install -g remotedev-server
```

## Mkdocs

Install mkdocs.

```sh
brew install mkdocs
```

Install mkdocs theme.

```sh
pip install mkdocs-material
```

## Supabase

Get Supabase:

```sh
brew install supabase/tap/supabase
```

## PostgresQL

Get `psql`

```sh
brew install postgresql@15
```

Then add the following to your `~/.zshrc` file:

```sh
# postgres
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
```

## PgAdmin

Get `PgAdmin`

```sh
brew install --cask pgadmin4
```
