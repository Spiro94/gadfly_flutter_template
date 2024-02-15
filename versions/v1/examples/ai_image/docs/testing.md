# Testing

## Supabase

### Create Supabase DB Test

```sh
supabase test new <test_name>

# Example
supabase test new new_user_added
```

### Run Supabase DB Tests

```sh
supabase test db
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
