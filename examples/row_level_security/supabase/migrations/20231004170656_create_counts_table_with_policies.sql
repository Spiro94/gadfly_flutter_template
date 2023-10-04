create table "public"."counts" (
    "user_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "count" bigint not null
);


alter table "public"."counts" enable row level security;

CREATE UNIQUE INDEX counts_pkey ON public.counts USING btree (user_id);

alter table "public"."counts" add constraint "counts_pkey" PRIMARY KEY using index "counts_pkey";

alter table "public"."counts" add constraint "counts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."counts" validate constraint "counts_user_id_fkey";

create policy "Users can read their own data"
on "public"."counts"
as permissive
for select
to authenticated
using ((user_id = auth.uid()));


create policy "Users can update their own data"
on "public"."counts"
as permissive
for update
to authenticated
using ((user_id = auth.uid()))
with check ((user_id = auth.uid()));




