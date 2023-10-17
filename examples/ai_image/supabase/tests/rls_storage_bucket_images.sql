BEGIN;

SELECT plan(2);


SELECT has_table('storage', 'buckets', 'Should have storage.buckets table');
SELECT policies_are('storage', 'objects', ARRAY[
  'User can create their images',
  'User can delete their images',
  'User can read their images',
  'User can update their images'
]);


SELECT * FROM finish();
ROLLBACK;
