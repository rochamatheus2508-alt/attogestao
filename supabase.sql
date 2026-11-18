-- Atto Gestão: tabela única com os registros de cada usuário
create table if not exists public.registros (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  id text not null,
  col text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.registros enable row level security;

create policy "dono lê"     on public.registros for select using (auth.uid() = user_id);
create policy "dono insere" on public.registros for insert with check (auth.uid() = user_id);
create policy "dono altera" on public.registros for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dono apaga"  on public.registros for delete using (auth.uid() = user_id);

-- sincronização em tempo real entre aparelhos
alter publication supabase_realtime add table public.registros;
