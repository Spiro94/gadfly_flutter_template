# Testing

## Supabase

### Create Supabase DB Test

```sh
supabase test new <test_name>

# Example
supabase test new new_user_added
```

### Run Supabase DB Tests

To set up the test helpers, run:

```sh
make test_db_init
```

Then to run the tests:

```sh
make test_db
```

## App

### Check coverage

```sh
make coverage_check
```

### Screenshots

```sh
make screenshots_delete
```

```sh
make screenshots_update
```

### Test Gallery

```sh
make gallery
```

Then go to `localhost:8000` to view the test gallery.
