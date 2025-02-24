# bloc_devtools_extension

This is a flutter devtools extension for flutter_bloc.

To use this extension, it is recommended to use flutter 3.22.0 or greater.

## Build for release

1. Update the version in `extension/devtools/config.yaml`.

2. Rebuild the extension release:

```sh
fvm dart run devtools_extensions build_and_copy --source=. --dest=extension/devtools
```

3. Validate the build:

```sh
fvm dart run devtools_extensions validate --package=.
```

4. Update the version in `extension/devtools/config.yaml`

## Development

Open local version of flutter's devtools that allows for hot-reload:

```sh
fvm dart run devtools_extensions validate --package=.
```

_Note: to reload, type `r` in the terminal._

Then start a flutter application. You will see a print out with a `ws:...`. Copy
that into the local devtools and `Connect`.
