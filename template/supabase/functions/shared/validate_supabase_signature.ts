import { createHmac, timingSafeEqual } from "crypto.ts";
import { Buffer } from "buffer.mjs";

export function validateSupabaseSignature(headers: Headers, body: string) {
  const headerName = "x-supabase-signature";
  const signature = headers.get(headerName);

  if (!signature) {
    console.warn("Supabase signature: missing in request headers");
    return false;
  }

  const decodedSignature = Buffer.from(signature, "base64");

  const edgeSecret = Deno.env.get("EDGE_FUNCTION_SECRET")!;
  const calculatedSignature = createHmac("sha256", edgeSecret)
    .update(body)
    .digest();

  const hmacMatch = timingSafeEqual(decodedSignature, calculatedSignature);

  if (!hmacMatch) {
    console.warn("Supabase signature: not authenticated");
    return false;
  }

  console.log("Supabase signature: authenticated");
  return true;
}
