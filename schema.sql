-- Hugcode shared workboard. Run in Supabase SQL Editor as project owner.
create table if not exists public.workboard_state (
  id integer primary key default 1 check (id = 1),
  tasks jsonb not null default '[]'::jsonb,
  options jsonb not null default '{"assignees":[],"assigners":[],"modules":[]}'::jsonb,
  statuses jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id)
);

alter table public.workboard_state enable row level security;

-- Authenticated project members may read and update the shared board.
-- Restrict membership more tightly with an organization membership table if needed.
drop policy if exists "Authenticated users can read workboard" on public.workboard_state;
create policy "Authenticated users can read workboard"
  on public.workboard_state for select to authenticated using (true);
drop policy if exists "Authenticated users can insert workboard" on public.workboard_state;
create policy "Authenticated users can insert workboard"
  on public.workboard_state for insert to authenticated with check (true);
drop policy if exists "Authenticated users can update workboard" on public.workboard_state;
create policy "Authenticated users can update workboard"
  on public.workboard_state for update to authenticated using (true) with check (true);

grant select, insert, update on public.workboard_state to authenticated;

-- Enable Realtime for cross-user updates. Ignore the error if the table is already published.
alter publication supabase_realtime add table public.workboard_state;
