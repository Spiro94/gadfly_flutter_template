-- Create function to insert or update custom_claim_updates table
CREATE OR REPLACE FUNCTION public.upsert_custom_claim_updates(id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$BEGIN

INSERT INTO public.custom_claim_updates(user_id)
VALUES(id) 
ON CONFLICT (user_id) 
DO UPDATE SET updated_at = now();

END;
$$;

-- Create trigger function to add app_role as USER when user signs up
CREATE OR REPLACE FUNCTION public.on_signup_insert_app_role_claim()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$BEGIN
  PERFORM public.set_claim(new.id, 'app_role', '"USER"');
  PERFORM public.upsert_custom_claim_updates(new.id);

  return new;
END;
$$;

-- Trigger the trigger function when a user signs up
CREATE TRIGGER trigger_on_signup_insert_app_role_claim 
AFTER INSERT ON auth.users 
FOR EACH ROW 
EXECUTE FUNCTION on_signup_insert_app_role_claim();