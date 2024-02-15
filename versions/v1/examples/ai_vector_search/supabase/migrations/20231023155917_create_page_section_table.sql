-- Enable pgvector extension
create extension if not exists vector;

-- Create separate docs schema and grants
create schema if not exists docs;
grant usage on schema docs to postgres, service_role;

-- Create page_section table
create table docs.page_section (
  id bigserial primary key,
  content text,
  token_count int,
  embedding vector(1536) -- size of openai embedding
);
alter table docs.page_section enable row level security;

-- Update table grants
ALTER DEFAULT PRIVILEGES IN SCHEMA docs
GRANT ALL ON TABLES TO postgres, service_role;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON ALL TABLES IN SCHEMA docs 
TO postgres, service_role;

GRANT USAGE, SELECT 
ON ALL SEQUENCES IN SCHEMA docs 
TO postgres, service_role;