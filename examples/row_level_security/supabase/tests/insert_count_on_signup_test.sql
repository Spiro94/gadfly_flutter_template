BEGIN;
CREATE EXTENSION "basejump-supabase_test_helpers" VERSION '0.0.1';

SELECT plan(8);


-- Check public.counts table
SELECT has_table('public', 'counts', 'Should have public.counts table');
SELECT has_column('public', 'counts', 'user_id', 'Should have public.counts.user_id column');
SELECT has_column('public', 'counts', 'count', 'Should have public.counts.count column');
SELECT col_is_fk('public', 'counts', 'user_id', 'public.counts.user_id should be a foreign key');

-- Check trigger_on_signup_insert_count
SELECT has_function('public', 'on_signup_insert_count', 'Should have on_signup_insert_count function');
SELECT has_trigger('auth', 'users', 'trigger_on_signup_insert_count', 'Should have trigger_on_signup_insert_count trigger');


PREPARE john_doe_rows AS SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('john_doe');

-- John should not exist in the public.counts table yet
SELECT results_eq(
  'john_doe_rows',
  $$SELECT 0::bigint$$,
  'Should be zero rows for john doe in public.counts table'
);


-- Create user
SELECT tests.create_supabase_user('john_doe');


-- Check if trigger_on_signup_instert_count ran successfully

SELECT results_eq(
  'john_doe_rows',
  $$SELECT 1::bigint$$,
  'Should be one row for john doe in public.counts table'
);


SELECT * FROM finish();
ROLLBACK;
