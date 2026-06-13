-- Example: a user-owned `profiles` table with Row Level Security (RLS).
--
-- Every table exposed through the supabase API (anything in the `public`
-- schema) MUST have RLS enabled, otherwise the anon key shipped inside the
-- app can read and write it freely. Use this table as a starting point and
-- copy the policy pattern for any new tables you add.

CREATE TABLE public.profiles (
    id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
    display_name text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Without this line the table is readable/writable by anyone with the anon
-- key. With it, all access is denied until a policy explicitly grants it.
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Owner-only access: a signed-in user can only see and modify their own row.
CREATE POLICY "Users can view their own profile"
    ON public.profiles
    FOR SELECT
    TO authenticated
    USING ((SELECT auth.uid()) = id);

CREATE POLICY "Users can insert their own profile"
    ON public.profiles
    FOR INSERT
    TO authenticated
    WITH CHECK ((SELECT auth.uid()) = id);

CREATE POLICY "Users can update their own profile"
    ON public.profiles
    FOR UPDATE
    TO authenticated
    USING ((SELECT auth.uid()) = id)
    WITH CHECK ((SELECT auth.uid()) = id);

-- No DELETE policy is defined, so deletes are denied. Rows are removed via
-- the ON DELETE CASCADE when the auth user is deleted.
