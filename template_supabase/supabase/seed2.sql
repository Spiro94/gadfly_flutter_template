SELECT vault.create_secret('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0', 'SUPABASE_ANON_KEY', 'Supabase anon key');
-- CHANGE ME (and make sure it matches in .env file)
SELECT vault.create_secret('XXX', 'EDGE_SECRET', 'Edge secret key');

INSERT INTO storage.buckets(id, name)
VALUES ('recordings', 'recordings');