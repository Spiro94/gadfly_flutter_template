-- Create Custom Claim Updates table
create table "public"."custom_claim_updates" (
    "user_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
);

CREATE UNIQUE INDEX custom_claim_updates_pkey ON public.custom_claim_updates USING btree (user_id);
ALTER TABLE public.custom_claim_updates ADD CONSTRAINT custom_claim_updates_pkey PRIMARY KEY USING INDEX custom_claim_updates_pkey;
ALTER TABLE public.custom_claim_updates ADD CONSTRAINT custom_claim_updates_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE NOT VALID;
ALTER TABLE public.custom_claim_updates VALIDATE CONSTRAINT custom_claim_updates_user_id_fkey;

-- Turn RLS on
ALTER TABLE public.custom_claim_updates ENABLE ROW LEVEL SECURITY;

-- Add SELECT policy
CREATE POLICY "Users can read custom claim updates"
ON public.custom_claim_updates
AS permissive
FOR SELECT
TO authenticated
USING (true);

-- Turn on realtime
ALTER publication supabase_realtime ADD TABLE public.custom_claim_updates;