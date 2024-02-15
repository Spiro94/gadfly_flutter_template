set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.on_signup_insert_count()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  INSERT INTO public.counts (user_id, count)
  VALUES (new.id, 0);

  return new;
END;$function$
;


CREATE TRIGGER trigger_on_signup_insert_count AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION on_signup_insert_count();