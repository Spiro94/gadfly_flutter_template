import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import Stripe from 'https://esm.sh/stripe@13.9.0?target=deno';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.0';

// We need to define this environment variable in a .env file
const stripe = Stripe(Deno.env.get('STRIPE_KEY')!, {
  httpClient: Stripe.createFetchHttpClient(),
});

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // Step 1: Check if we have a user's JWT

    // Create a Supabase client with the Auth context of the logged in user.
    const supabaseClient = createClient(
      // Supabase API URL - env var exported by default.
      Deno.env.get('SUPABASE_URL') ?? '',
      // Supabase API ANON KEY - env var exported by default.
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      // Create client with Auth context of the user that called the function.
      // This way your row-level-security (RLS) policies are applied.
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    );
    // Now we can get the session or user object
    const {
      data: { user },
    } = await supabaseClient.auth.getUser();

    if (!user) {
      throw Error('Invalid JWT');
    }

    // Step 2: Create a stripe account

    const customer = await stripe.customers.create({
      email: user.email,
      metadata: {
        supabase_id: user.id,
      },
    });

    // Step 3: Update the profile's table with the user's stripe id

    const { error: updateError } = await supabase
      .from('profiles')
      .update({
        stripe_id: customer.id,
      })
      .match({ id: user.id });

    if (updateError) {
      throw Error('Could not update profiles table with stripe id');
    }

    return new Response(JSON.stringify({ stripe_id: customer.id }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    });
  } catch (error) {
    console.log({ error });
    return new Response(JSON.stringify(error), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});
