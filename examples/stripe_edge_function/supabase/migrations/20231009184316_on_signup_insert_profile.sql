set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.on_signup_insert_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  INSERT INTO public.profiles(id, email)
  VALUES (new.id, new.email);

  return new;
END;$function$
;


CREATE TRIGGER trigger_on_signup_insert_profile AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION on_signup_insert_profile();



