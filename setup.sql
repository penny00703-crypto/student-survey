-- =========================================================
-- 51Talk 家长问卷 · Supabase 初始化脚本
-- 用法：Supabase 项目 → SQL Editor → 粘贴本文件全部内容 → Run
-- =========================================================

-- 1. 数据表
create table if not exists submissions (
  id bigint generated always as identity primary key,
  submitted_at timestamptz not null default now(),
  lang text default 'ar',
  student_name text not null,
  whatsapp text not null,
  student_id text default '',
  grade text not null,
  english_start text default '',
  english_start_note text default '',
  textbook text default '',
  textbook_image text default '',        -- 封面图在 Storage 里的公开 URL
  current_unit text default '',
  lessons_per_week text default '',
  last_score text default '',
  weakest_part text default '',
  teaching_style text default '',
  expectations text default ''
);

-- 2. 行级安全：匿名用户可插入、可读取、可删除
--    （因为后台按你要求不设密码；任何拿到 anon key 的人技术上都能读数据。
--      问卷属低敏数据，可接受；如以后想加防护，再开 Supabase Auth。）
alter table submissions enable row level security;

create policy "anon insert" on submissions for insert to anon with check (true);
create policy "anon select" on submissions for select to anon using (true);
create policy "anon delete" on submissions for delete to anon using (true);

-- 3. 封面图存储桶（公开可读，匿名可上传/删除）
insert into storage.buckets (id, name, public)
values ('covers', 'covers', true)
on conflict (id) do nothing;

create policy "anon upload covers" on storage.objects
  for insert to anon with check (bucket_id = 'covers');
create policy "public read covers" on storage.objects
  for select to anon using (bucket_id = 'covers');
create policy "anon delete covers" on storage.objects
  for delete to anon using (bucket_id = 'covers');
