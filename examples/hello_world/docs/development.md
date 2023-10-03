# Development

## Supabase

### Start Supabase

```sh
supabase start
```

Then open the supabase studio at `localhost:54323`

### Stop Supabase

```sh
supabase stop
```

### Reset Supabase DB

```sh
supabase db reset
```

### Echo diff from local and remote DB

```sh
supabase db diff
```

### Create Supabase DB Migration

```sh
supabase migration new <migration_name>

# Example
# supabase migration new create_photos_table
```

### Apply Supabase DB Migration locally

```sh
supabase migration up
```

## App

### Run App (Option 1)

Open the `Run and Debug` tab in VSCode and run the `development` option.

### Run App with redux devtools (Option 2)

1. Start the redux remote devtools server

```sh
make redux_devtools_server
```

2. Then go to a browser and open `localhost:8001`. Note: it is important that this is open before you tun the application.

3. Open the `Run and Debug` tab in VSCode and run the `development w/ devtools` option.

### Update build_runner files

```sh
make runner_build
```

or

```sh
make runner_watch
```

### Update localization files

```sh
make slang_build
```

or

```sh
make slang_watch
```

### Update flutter dependences

```sh
make get
```

### Clean flutter build

```sh
make clean
```
