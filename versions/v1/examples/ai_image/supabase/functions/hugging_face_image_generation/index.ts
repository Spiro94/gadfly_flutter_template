import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { HfInference } from 'https://esm.sh/@huggingface/inference@2.3.2';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.7.1';

const hf = new HfInference(Deno.env.get('HUGGINGFACE_ACCESS_TOKEN'));

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

// Start the server

serve(async (req) => {
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders, status: 200 });
  }

  try {
    const { input } = await req.json();

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

    // Generate the image using Hugging Face's API

    const imgDesc = await hf.textToImage({
      inputs: input,
      model: 'stabilityai/stable-diffusion-2',
      parameters: {
        negative_prompt: 'blurry',
      },
    });

    // Upload the image to Supabase Storage

    const imagePath = `/${user.id}/avatar`;

    const { error } = await supabaseClient.storage
      .from('images')
      .upload(imagePath, imgDesc, {
        upsert: true,
      });

    if (error) throw error;

    return new Response(null, {
      headers: corsHeaders,
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
