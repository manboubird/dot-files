create_tables.sql <- [method:file method-mode:append]
  --- CREATE DATABASE IF NOT EXISTS drake_test;
  CREATE TABLE IF NOT EXISTS public.user (
    user_id SERIAL
    , first_name varchar NOT NULL
    , last_name varchar NOT NULL
  );

load_data.sql <- [method:file method-mode:append]
  INSERT INTO public.user (first_name, last_name) VALUES 
    ('Jack', 'Teal')
    , ('Alice', 'Teal')
    ;


select_tbl.sql <- [method:file method-mode:append]
  SELECT * FROM public.user;

select_tbl.2.sql <- [method:file method-mode:append]
  SELECT * FROM public.user WHERE user_id=2;

