create table events (
 id serial primary key,
 timestamp timestamptz not null,
 type text not null,
 user_id bigint not null,
 language_code text,
 chat_id bigint,
 chat_type text
)