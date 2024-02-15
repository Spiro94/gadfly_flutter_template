-- Create message table
CREATE TABLE public.messages (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    user_id uuid NOT NULL,
    message text NOT NULL
);

CREATE UNIQUE INDEX messages_pkey ON public.messages USING btree (id);
ALTER TABLE public.messages ADD CONSTRAINT "messages_pkey" PRIMARY KEY USING INDEX "messages_pkey";
ALTER TABLE public.messages ADD CONSTRAINT  "messages_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) NOT valid;
ALTER TABLE public.messages validate CONSTRAINT "messages_user_id_fkey";

-- Turn RLS on
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Add INSERT policy
CREATE POLICY "Users can create messages"
ON public.messages
AS permissive
FOR INSERT 
TO authenticated
WITH CHECK (true);

-- Add SELECT policy
CREATE POLICY "Users can read messages"
ON public.messages
AS permissive
FOR SELECT
TO authenticated
USING (true);

-- Turn on realtime
ALTER publication supabase_realtime ADD TABLE public.messages;