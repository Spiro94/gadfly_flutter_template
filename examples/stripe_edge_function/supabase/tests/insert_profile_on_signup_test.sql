BEGIN;
CREATE EXTENSION "basejump-supabase_test_helpers" VERSION '0.0.1';

SELECT plan(9);


-- Check public.profiles table
SELECT has_table('public', 'profiles', 'Should have public.profiles table');
SELECT has_column('public', 'profiles', 'id', 'Should have public.profiles.id column');
SELECT has_column('public', 'profiles', 'email', 'Should have public.profiles.email column');
SELECT has_column('public', 'profiles', 'stripe_id', 'Should have public.profiles.stripe_id column');
SELECT col_is_fk('public', 'profiles', 'id', 'public.profiles.id should be a foreign key');

-- Check trigger_on_signup_insert_count
SELECT has_function('public', 'on_signup_insert_profile', 'Should have on_signup_insert_profile function');
SELECT has_trigger('auth', 'users', 'trigger_on_signup_insert_profile', 'Should have trigger_on_signup_insert_profile trigger');


PREPARE john_doe_rows AS SELECT count(*) FROM public.profiles WHERE id = tests.get_supabase_uid('john_doe');

-- John should not exist in the public.profiles table yet
SELECT results_eq(
  'john_doe_rows',
  $$SELECT 0::bigint$$,
  'Should be zero rows for john doe in public.profiles table'
);


-- Create user
SELECT tests.create_supabase_user('john_doe');


-- Check if trigger_on_signup_instert_count ran successfully

SELECT results_eq(
  'john_doe_rows',
  $$SELECT 1::bigint$$,
  'Should be one row for john doe in public.profiles table'
);


SELECT * FROM finish();
ROLLBACK;
