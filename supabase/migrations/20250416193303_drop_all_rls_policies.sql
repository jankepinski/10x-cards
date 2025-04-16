-- Migration: Drop all RLS policies
-- Created: 2025-04-16
-- Description: This migration drops all RLS policies from the database tables
-- Author: Supabase Migration System

-- Drop RLS Policies for flashcards table
drop policy if exists select_own_flashcards on flashcards;
drop policy if exists insert_own_flashcards on flashcards;
drop policy if exists update_own_flashcards on flashcards;
drop policy if exists delete_own_flashcards on flashcards;
drop policy if exists anon_select_flashcards on flashcards;

-- Drop RLS Policies for generations table
drop policy if exists select_own_generations on generations;
drop policy if exists insert_own_generations on generations;
drop policy if exists update_own_generations on generations;
drop policy if exists delete_own_generations on generations;
drop policy if exists anon_select_generations on generations;

-- Drop RLS Policies for generation_logs table
drop policy if exists select_own_generation_logs on generation_logs;
drop policy if exists insert_own_generation_logs on generation_logs;
drop policy if exists update_own_generation_logs on generation_logs;
drop policy if exists delete_own_generation_logs on generation_logs;
drop policy if exists anon_select_generation_logs on generation_logs;

-- Note: This migration only drops RLS policies, not disables RLS on tables
-- If you want to completely disable RLS, uncomment the following:
-- alter table flashcards disable row level security;
-- alter table generations disable row level security;
-- alter table generation_logs disable row level security; 