# Dokument wymagań produktu (PRD) - Fiszki AI

## 1. Przegląd produktu

Fiszki AI to aplikacja webowa, która umożliwia szybkie i efektywne tworzenie fiszek edukacyjnych. System wykorzystuje sztuczną inteligencję do automatycznego generowania kandydatów na fiszki na podstawie długiego tekstu wejściowego, a także pozwala na manualne tworzenie fiszek. Aplikacja integruje się z open source'ową biblioteką spaced repetition, co umożliwia optymalizację procesu nauki.

## 2. Problem użytkownika

Użytkownicy często muszą ręcznie tworzyć fiszki edukacyjne, co jest czasochłonne i nieefektywne. Proces ten zniechęca do korzystania z metod nauki opartych na powtórkach (spaced repetition), które są znacznie bardziej efektywne. Brak narzędzi automatyzujących ten proces ogranicza możliwość szybkiego i łatwego przyswajania wiedzy.

## 3. Wymagania funkcjonalne

- Generowanie fiszek przez AI na podstawie przekazanego tekstu wejściowego o długości 1000-10000 znaków oraz opcjonalnego promptu określającego strategię podziału treści. W przypadku braku promptu, stosowana jest domyślna strategia.
- Możliwość manualnego tworzenia fiszek przez użytkownika.
- Workflow przeglądu kandydatów na fiszki z trzema dostępnymi akcjami: zapisz (akceptacja i zapis w bazie danych), odrzuć oraz edytuj (z możliwością późniejszej akceptacji lub odrzucenia po modyfikacji).
- Prosty system kont użytkowników, umożliwiający rejestrację, logowanie, zmianę hasła oraz usunięcie konta.
- Rejestrowanie logów procesu generacji fiszek, w tym błędów AI oraz decyzji użytkownika, w dedykowanej tabeli w bazie danych dla celów diagnostycznych.
- Integracja z open source'ową biblioteką spaced repetition do zarządzania powtórkami.
- Walidacja danych wejściowych, ze szczególnym uwzględnieniem sprawdzenia długości tekstu (1000-10000 znaków).
- Zastosowanie standardowych praktyk bezpieczeństwa, w tym mechanizmów autentykacji, autoryzacji, walidacji oraz row-level security (RLS).

## 4. Granice produktu

- Brak implementacji własnego, zaawansowanego algorytmu powtórek (np. SuperMemo, Anki).
- Brak wsparcia dla importu wielu formatów plików (PDF, DOCX, itp.).
- Brak możliwości współdzielenia zestawów fiszek między użytkownikami.
- Brak integracji z zewnętrznymi platformami edukacyjnymi.
- MVP obejmuje jedynie platformę web, bez wersji mobilnej.

## 5. Historyjki użytkowników

US-001
Tytuł: Wprowadzenie tekstu wejściowego i promptu dla generacji fiszek przez AI
Opis: Jako użytkownik chcę wprowadzić tekst wejściowy o długości 1000-10000 znaków oraz opcjonalny prompt określający strategię podziału treści, aby system mógł na tej podstawie wygenerować kandydatów na fiszki.
Kryteria akceptacji:

- Użytkownik może wprowadzić tekst o wymaganej długości.
- W przypadku braku promptu, system stosuje domyślną strategię podziału treści.
- AI generuje kandydatów na fiszki na podstawie dostarczonych danych.

US-002
Tytuł: Manualne tworzenie fiszek
Opis: Jako użytkownik chcę mieć możliwość ręcznego tworzenia fiszek, aby móc precyzyjnie dostosować treść do swoich potrzeb.
Kryteria akceptacji:

- Użytkownik może ręcznie wprowadzić treść fiszki (pytanie i odpowiedź).
- Fiszki utworzone manualnie są zapisywane w bazie danych.

US-003
Tytuł: Przegląd i zarządzanie kandydatami na fiszki
Opis: Jako użytkownik chcę przeglądać wygenerowane lub utworzone fiszki oraz podejmować na nich działania, takie jak zapisz, odrzuć lub edytuj, aby zoptymalizować proces tworzenia fiszek.
Kryteria akceptacji:

- Użytkownik widzi listę kandydatów na fiszki.
- Dla każdej fiszki dostępne są trzy akcje: zapisz, odrzuć, edytuj.
- Po edycji, użytkownik może ponownie zatwierdzić lub odrzucić zmodyfikowaną fiszkę.

US-004
Tytuł: Zarządzanie kontem użytkownika
Opis: Jako użytkownik chcę móc rejestrować się, logować, zmieniać hasło oraz usuwać konto, aby bezpiecznie korzystać z aplikacji.
Kryteria akceptacji:

- Użytkownik może zarejestrować nowe konto.
- Użytkownik może się zalogować do systemu.
- Użytkownik ma możliwość zmiany hasła oraz usunięcia konta.
- Dane użytkownika są chronione zgodnie z obowiązującymi standardami bezpieczeństwa.

US-005
Tytuł: Logowanie procesu generacji fiszek i rejestrowanie decyzji
Opis: Jako system chcę rejestrować wszystkie procesy generacji fiszek, w tym błędy AI oraz decyzje użytkownika dotyczące akceptacji lub odrzucenia fiszek, aby umożliwić diagnostykę i analizę efektywności systemu.
Kryteria akceptacji:

- System zapisuje logi generacji fiszek w dedykowanej tabeli w bazie danych.
- Logi zawierają informacje o błędach AI, czasie generacji oraz decyzjach użytkownika.

US-006
Tytuł: Bezpieczna autentykacja i autoryzacja
Opis: Jako użytkownik chcę mieć pewność, że proces logowania i autoryzacji jest bezpieczny, aby moje dane były odpowiednio chronione.
Kryteria akceptacji:

- System implementuje mechanizmy bezpiecznej autentykacji i autoryzacji użytkowników.
- Stosowane są standardowe praktyki bezpieczeństwa, w tym walidacja danych i row-level security (RLS).

US-007
Tytuł: Obsługa błędnych danych wejściowych
Opis: Jako użytkownik chcę otrzymać odpowiedni feedback, gdy wprowadzony tekst nie spełnia wymagań (np. jest za krótki lub za długi), aby móc poprawić swoje dane wejściowe.
Kryteria akceptacji:

- System sprawdza długość tekstu wejściowego i wyświetla komunikaty o błędzie, jeśli tekst nie mieści się w zakresie 1000-10000 znaków.
- Użytkownik jest informowany o wymaganiach dotyczących długości tekstu wejściowego.

## 6. Metryki sukcesu

- 75% fiszek generowanych przez AI musi być akceptowanych przez użytkowników.
- Co najmniej 75% użytkowników korzysta z opcji generowania fiszek przez AI.
- System skutecznie rejestruje logi procesu generacji fiszek oraz decyzje użytkowników, umożliwiając diagnostykę.
- Użytkownicy doświadczają wyraźnej poprawy efektywności tworzenia fiszek w porównaniu do tradycyjnego, manualnego procesu.
