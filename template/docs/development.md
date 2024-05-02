# Development

## Run App (Option 1)

Open the `Run and Debug` tab in VSCode and run the `development` option.

## Run App with redux devtools (Option 2)

1. Start the redux remote devtools server

```sh
make redux_devtools_server
```

2. Then go to a browser and open `localhost:8001`. Note: it is important that
   this is open before you tun the application.

3. Open the `Run and Debug` tab in VSCode and run the `development w/ devtools`
   option.

## Update build_runner files

```sh
make runner_build
```

or

```sh
make runner_watch
```

## Update localization files

```sh
make slang_build
```

or

```sh
make slang_watch
```

## Update flutter dependences

```sh
make flutter_get
```

### Clean flutter build

```sh
make flutter_clean
```
