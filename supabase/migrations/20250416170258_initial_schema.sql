-- Migration: Initial database schema for 10x-cards flashcard application
-- Created: 2025-04-16
-- Description: This migration creates the core tables, relationships, and security policies for the flashcard generation system
-- Tables: flashcards, generations, generation_logs
-- Author: Supabase Migration System

-- Enable required extensions
create extension if not exists "uuid-ossp";

-- Create custom types
create type flashcard_source as enum ('full-ai', 'edited-ai', 'manual');

-- Table: generations
create table generations (
    id uuid primary key default uuid_generate_v4(),
    prompt text,
    accepted_count integer not null default 0,
    edited_count integer not null default 0,
    total_generated integer not null default 0,
    input_length integer not null,
    input_hash text not null,
    user_id uuid not null references auth.users(id),
    created_at timestamptz not null default current_timestamp,
    updated_at timestamptz not null default current_timestamp,
    constraint generations_input_length_check check (input_length between 1000 and 10000)
);

-- Create index for generations table
create index idx_generations_user_id on generations(user_id);

-- Table: flashcards
create table flashcards (
    id uuid primary key default uuid_generate_v4(),
    front varchar(200) not null,
    back varchar(500) not null,
    generation_id uuid not null references generations(id),
    user_id uuid not null references auth.users(id),
    source flashcard_source,
    created_at timestamptz not null default current_timestamp,
    updated_at timestamptz not null default current_timestamp
);

-- Create indexes for flashcards table
create index idx_flashcards_generation_id on flashcards(generation_id);
create index idx_flashcards_user_id on flashcards(user_id);

-- Table: generation_logs
create table generation_logs (
    id uuid primary key default uuid_generate_v4(),
    generation_id uuid not null references generations(id) on delete cascade,
    input_length integer not null,
    input_hash text not null,
    error_message text,
    model text not null,
    user_id uuid not null references auth.users(id),
    created_at timestamptz not null default current_timestamp
);

-- Create indexes for generation_logs table
create index idx_generation_logs_generation_id on generation_logs(generation_id);
create index idx_generation_logs_user_id on generation_logs(user_id);

-- Create trigger for updating timestamps
create or replace function update_updated_at()
returns trigger as $$
begin
    new.updated_at = current_timestamp;
    return new;
end;
$$ language plpgsql;

-- Create trigger for flashcards table
create trigger update_flashcards_updated_at
before update on flashcards
for each row
execute function update_updated_at();

-- Create trigger for generations table
create trigger update_generations_updated_at
before update on generations
for each row
execute function update_updated_at();

-- Create function to update generation counts
create or replace function update_generation_counts()
returns trigger as $$
declare
    card_source flashcard_source;
begin
    -- Handle different trigger events
    if tg_op = 'INSERT' then
        -- Increment total_generated count
        update generations
        set total_generated = total_generated + 1
        where id = new.generation_id;
        
        -- Update accepted or edited count based on source
        card_source := new.source;
        if card_source = 'full-ai' then
            update generations
            set accepted_count = accepted_count + 1
            where id = new.generation_id;
        elsif card_source = 'edited-ai' then
            update generations
            set edited_count = edited_count + 1
            where id = new.generation_id;
        end if;
        
        return new;
    elsif tg_op = 'UPDATE' then
        -- Handle source changes
        if old.source != new.source then
            -- Decrement old source count
            if old.source = 'full-ai' then
                update generations
                set accepted_count = accepted_count - 1
                where id = new.generation_id;
            elsif old.source = 'edited-ai' then
                update generations
                set edited_count = edited_count - 1
                where id = new.generation_id;
            end if;
            
            -- Increment new source count
            if new.source = 'full-ai' then
                update generations
                set accepted_count = accepted_count + 1
                where id = new.generation_id;
            elsif new.source = 'edited-ai' then
                update generations
                set edited_count = edited_count + 1
                where id = new.generation_id;
            end if;
        end if;
        
        return new;
    elsif tg_op = 'DELETE' then
        -- Decrement total_generated count
        update generations
        set total_generated = total_generated - 1
        where id = old.generation_id;
        
        -- Decrement accepted or edited count based on source
        card_source := old.source;
        if card_source = 'full-ai' then
            update generations
            set accepted_count = accepted_count - 1
            where id = old.generation_id;
        elsif card_source = 'edited-ai' then
            update generations
            set edited_count = edited_count - 1
            where id = old.generation_id;
        end if;
        
        return old;
    end if;
end;
$$ language plpgsql;

-- Create trigger for flashcard counts
create trigger update_flashcards_generation_counts
after insert or update or delete on flashcards
for each row
execute function update_generation_counts();

-- Enable Row Level Security
alter table flashcards enable row level security;
alter table generations enable row level security;
alter table generation_logs enable row level security;

-- RLS Policies for flashcards table
-- Policy for select operations
create policy select_own_flashcards on flashcards
    for select
    to authenticated
    using (user_id = auth.uid());

-- Policy for insert operations
create policy insert_own_flashcards on flashcards
    for insert
    to authenticated
    with check (user_id = auth.uid());

-- Policy for update operations
create policy update_own_flashcards on flashcards
    for update
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());

-- Policy for delete operations
create policy delete_own_flashcards on flashcards
    for delete
    to authenticated
    using (user_id = auth.uid());

-- Anonymous user policies for flashcards - no access
create policy anon_select_flashcards on flashcards
    for select
    to anon
    using (false);

-- RLS Policies for generations table
-- Policy for select operations
create policy select_own_generations on generations
    for select
    to authenticated
    using (user_id = auth.uid());

-- Policy for insert operations
create policy insert_own_generations on generations
    for insert
    to authenticated
    with check (user_id = auth.uid());

-- Policy for update operations
create policy update_own_generations on generations
    for update
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());

-- Policy for delete operations
create policy delete_own_generations on generations
    for delete
    to authenticated
    using (user_id = auth.uid());

-- Anonymous user policies for generations - no access
create policy anon_select_generations on generations
    for select
    to anon
    using (false);

-- RLS Policies for generation_logs table
-- Policy for select operations
create policy select_own_generation_logs on generation_logs
    for select
    to authenticated
    using (user_id = auth.uid());

-- Policy for insert operations
create policy insert_own_generation_logs on generation_logs
    for insert
    to authenticated
    with check (user_id = auth.uid());

-- Policy for update operations
create policy update_own_generation_logs on generation_logs
    for update
    to authenticated
    using (user_id = auth.uid())
    with check (user_id = auth.uid());

-- Policy for delete operations
create policy delete_own_generation_logs on generation_logs
    for delete
    to authenticated
    using (user_id = auth.uid());

-- Anonymous user policies for generation_logs - no access
create policy anon_select_generation_logs on generation_logs
    for select
    to anon
    using (false); 