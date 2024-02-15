BEGIN;
CREATE EXTENSION "basejump-supabase_test_helpers" VERSION '0.0.1';

SELECT plan(12);

-- Create two users
SELECT tests.create_supabase_user('john');
SELECT tests.create_supabase_user('jane');



-- Authenticate as John
SELECT tests.authenticate_as('john');

-- John should be able to read his row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('john');$$,
  $$SELECT 1::bigint$$,
  'John should be able to read his row in public.counts table'
);
-- But not Jane's row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('jane');$$,
  $$SELECT 0::bigint$$,
  'John should NOT be able to read the row belonging to Jane'
);

-- John should be able to update his row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('john');$$,
  'John increments his own count'
);
SELECT results_eq(
  $$SELECT c.count FROM public.counts c WHERE user_id = tests.get_supabase_uid('john');$$,
  $$SELECT 1::bigint$$,
  'When John reads his count, it should have incremented'
);
-- But not Jane's row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('jane');$$,
  'John attempts increments the count belonging to Jane'
);
SELECT is_empty(
  $$SELECT c.count FROM public.counts AS c WHERE user_id = tests.get_supabase_uid('jane');$$,
  'When John reads the count belonging to Jane, he should get back NULL'
);


-- Authenticate as Jane
SELECT tests.authenticate_as('jane');

-- Jane should be able to read her row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('jane');$$,
  $$SELECT 1::bigint$$,
  'Jane should be able to read his row in public.counts table'
);
-- But not John's row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('john');$$,
  $$SELECT 0::bigint$$,
  'Jane should NOT be able to read the row belonging to John'
);

-- Jane should be able to update her row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('jane');$$,
  'Jane increments her own count'
);
SELECT results_eq(
  $$SELECT c.count FROM public.counts c WHERE user_id = tests.get_supabase_uid('jane');$$,
  $$SELECT 1::bigint$$,
  'When Jane reads her count, it should have incremented'
);
-- But not Jane's row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('jane');$$,
  'Jane attempts increments the count belonging to John'
);
SELECT is_empty(
  $$SELECT c.count FROM public.counts AS c WHERE user_id = tests.get_supabase_uid('john');$$,
  'When Jane reads the count belonging to John, she should get back NULL'
);

SELECT * FROM finish();
ROLLBACK;
