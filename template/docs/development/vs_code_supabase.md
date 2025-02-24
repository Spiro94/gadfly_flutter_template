# VSCode for Supabase

Reminders:

- to open VSCode Tasks, press `CMD+SHIFT+B`
- to open VSCode Command Palette, press `CMD+SHIFT+P`
- to run the application, open up the "Run and Debug" tab

## DB Reset (Task)

```sh
[Supabase] Migration Up
```

Run this VSCode Task if:

- you want to delete and recreate your locally running supabase from migration and seed files

## Deno Cache Dependencies (Command)

```sh
Deno: Cache Dependencies
```

- you developing a Deno Edge Function and you want to download the dependencies for the open typescript file

## Functions New (Task)

```sh
[Supabase] Functions New
```

Run this VSCode Task if:

- you want to create a new Deno Edge Function

## Functions Serve (Task)

```sh
[Supabase] Functions (Serve)
```

Run this VSCode Task if:

- you want to run deno edge functions locally
- reminder: there is a `.env` file at the root of this project. Make sure it has the proper environment variables defined in it.

## Migration New (Task)

```sh
[Supabase] Migration New
```

Run this VSCode Task if:

- you want to create a new migration file

## Migration Up (Task)

```sh
[Supabase] Migration Up
```

Run this VSCode Task if:

- there are new migration files in version control that have not yet been applied to your locally running supabase  

## Start (Task)

```sh
[Supabase] Start
```

Run this VSCode Task if:

- you want to run Supabase locally

## Stop (Task)

```sh
[Supabase] Stop
```

Run this VSCode Task if:

- you want to stop running Supabase locally
