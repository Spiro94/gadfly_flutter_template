CREATE POLICY "User can read their images"
ON storage.objects
AS permissive
FOR SELECT 
TO authenticated 
USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));

CREATE POLICY "User can update their images"
ON storage.objects
AS permissive
FOR UPDATE 
TO authenticated 
USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));

CREATE POLICY "User can create their images"
ON storage.objects
AS permissive
FOR INSERT
TO authenticated 
WITH CHECK(((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));

CREATE POLICY "User can delete their images"
ON storage.objects
AS permissive
FOR DELETE 
TO authenticated 
USING (((bucket_id = 'images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));