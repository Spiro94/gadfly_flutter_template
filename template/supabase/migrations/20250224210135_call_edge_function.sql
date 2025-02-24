-- Helper function to generate hmac
CREATE OR REPLACE FUNCTION public.generate_hmac(secret_key text, message text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    hmac_result bytea;
BEGIN
    hmac_result := extensions.hmac(message::bytea, secret_key::bytea, 'sha256');
    RETURN encode(hmac_result, 'base64');
END;
$function$
;

-- Utility function to call an edge function
CREATE OR REPLACE FUNCTION public.call_edge_function(edge_url text, payload jsonb, tg_relid oid, tg_name name)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    edge_function_secret text;
    supabase_anon_key text;
    request_id bigint;
    signature text;
BEGIN
    -- Get the webhook URL and secret from the vault
    SELECT decrypted_secret INTO edge_function_secret FROM vault.decrypted_secrets WHERE name = 'EDGE_FUNCTION_SECRET' LIMIT 1;
    SELECT decrypted_secret INTO supabase_anon_key FROM vault.decrypted_secrets WHERE name = 'SUPABASE_ANON_KEY' LIMIT 1;

    -- Generate the signature
    signature = generate_hmac(edge_function_secret, payload::text);

    -- Send the webhook request
    SELECT http_post
    INTO request_id
    FROM
        net.http_post(
                edge_url,
                payload,
                '{}',
                jsonb_build_object(
                        'Content-Type', 'application/json',
                        'X-Supabase-Signature', signature,
                        'Authorization', CONCAT('Bearer ', supabase_anon_key)
                ),
                '1000'
        );

    -- Insert the request ID into the Supabase hooks table
    INSERT INTO supabase_functions.hooks
        (hook_table_id, hook_name, request_id)
    VALUES (tg_relid, tg_name, request_id);
END;
$function$
;