create policy "Users own their folder c5wwbm_0"
on "storage"."objects"
as permissive
for select
to authenticated
using (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


create policy "Users own their folder c5wwbm_1"
on "storage"."objects"
as permissive
for insert
to authenticated
with check (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


create policy "Users own their folder c5wwbm_2"
on "storage"."objects"
as permissive
for update
to authenticated
using (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


create policy "Users own their folder c5wwbm_3"
on "storage"."objects"
as permissive
for delete
to authenticated
using (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));
