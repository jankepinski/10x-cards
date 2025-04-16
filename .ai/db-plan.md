# Schemat bazy danych PostgreSQL

## 1. Tabele

### 1.1. Typy niestandardowe

Przed utworzeniem tabel należy stworzyć typ ENUM dla kolumny `source` w tabeli `flashcards`:

```sql
CREATE TYPE flashcard_source AS ENUM ('full-ai', 'edited-ai', 'manual');
```

### 1.2. Tabela `flashcards`

- **id**: UUID, PRIMARY KEY, domyślnie generowany (np. za pomocą `gen_random_uuid()` lub `uuid_generate_v4()` w zależności od rozszerzenia)
- **front**: VARCHAR(200) NOT NULL
  - Ograniczenie: maksymalnie 200 znaków
- **back**: VARCHAR(500) NOT NULL
  - Ograniczenie: maksymalnie 500 znaków
- **generation_id**: UUID NOT NULL, FOREIGN KEY REFERENCES `generations(id)`
- **user_id**: UUID NOT NULL, FOREIGN KEY REFERENCES `auth.users(id)`
- **source**: `flashcard_source`, NULLABLE
  - Wartości: 'full-ai', 'edited-ai', 'manual'
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
- **updated_at**: TIMESTAMPTZ NOT NULL, aktualizowany przez trigger

### 1.3. Tabela `generations`

- **id**: UUID, PRIMARY KEY, domyślnie generowany
- **prompt**: TEXT, NULLABLE
- **accepted_count**: INTEGER NOT NULL DEFAULT 0
- **edited_count**: INTEGER NOT NULL DEFAULT 0
- **total_generated**: INTEGER NOT NULL DEFAULT 0
  - UWAGA: Ta wartość powinna odzwierciedlać liczbę powiązanych fiszek z tabeli `flashcards` (aktualizowaną mechanizmem triggera lub przy zapytaniu agregującym)
- **input_length**: INTEGER NOT NULL
  - Ograniczenie: CHECK (input_length BETWEEN 1000 AND 10000)
- **input_hash**: TEXT NOT NULL
- **user_id**: UUID NOT NULL, FOREIGN KEY REFERENCES `auth.users(id)`
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
- **updated_at**: TIMESTAMPTZ NOT NULL, aktualizowany przez trigger

### 1.4. Tabela `generation_logs`

- **id**: UUID, PRIMARY KEY, domyślnie generowany
- **generation_id**: UUID NOT NULL, FOREIGN KEY REFERENCES `generations(id)` ON DELETE CASCADE
- **input_length**: INTEGER NOT NULL
- **input_hash**: TEXT NOT NULL
- **error_message**: TEXT
- **model**: TEXT NOT NULL
- **user_id**: UUID NOT NULL, FOREIGN KEY REFERENCES `auth.users(id)`
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

## 2. Relacje między tabelami

- Tabela `flashcards` posiada kolumnę `generation_id` jako FOREIGN KEY odnoszący się do `generations(id)`.
- Tabela `generation_logs` posiada kolumnę `generation_id` jako FOREIGN KEY odnoszący się do `generations(id)` z opcją ON DELETE CASCADE (usunięcie generacji powoduje usunięcie podpiętych logów).
- Kolumna `user_id` w tabelach `flashcards`, `generations` oraz `generation_logs` referencjonuje użytkowników w tabeli `auth.users` (Supabase authentication).

## 3. Indeksy

- PRIMARY KEY indeksy na kolumnie `id` w każdej tabeli.
- Indeks na `flashcards(generation_id)` dla przyspieszenia zapytań związanych z generacjami.
- Indeks na `flashcards(user_id)` aby wspierać polityki RLS i filtrowanie danych według użytkownika.
- Indeks na `generations(user_id)`.
- Indeks na `generation_logs(generation_id)` oraz `generation_logs(user_id)`.

## 4. Zasady PostgreSQL (Row Level Security - RLS)

Dla każdej głównej tabeli należy wdrożyć politykę RLS opartą na kolumnie `user_id`, która umożliwia dostęp tylko właścicielom danych. Przykładowe definicje polityk:

```sql
-- Włączenie RLS dla tabeli flashcards
ALTER TABLE flashcards ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_own_flashcards ON flashcards
  USING (user_id = auth.uid());

-- Włączenie RLS dla tabeli generations
ALTER TABLE generations ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_own_generations ON generations
  USING (user_id = auth.uid());

-- Włączenie RLS dla tabeli generation_logs
ALTER TABLE generation_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_own_generation_logs ON generation_logs
  USING (user_id = auth.uid());
```

## 5. Dodatkowe uwagi

- Upewnij się, że rozszerzenie do generowania UUID (np. `uuid-ossp` lub `pgcrypto`) jest aktywowane w bazie danych.
- Kolumny `total_generated`, `accepted_count` i `edited_count` w tabeli `generations` powinny być aktualizowane automatycznie poprzez trigger. Trigger (np. funkcja `update_generation_counts()`) powinien reagować na operacje INSERT, UPDATE i DELETE w tabeli `flashcards`, by odzwierciedlać aktualny stan związanych fiszek danej generacji.
- Wszystkie pola typu data są definiowane jako TIMESTAMPTZ z domyślną wartością CURRENT_TIMESTAMP dla zapewnienia właściwego audytu.
- Projekt wykorzystuje podejście oparte na prostych relacjach 1:N między `generations` a `flashcards` oraz między `generations` a `generation_logs`, co sprzyja skalowalności i wydajności przy korzystaniu z frameworka Supabase i technologii wymienionych w stosie.