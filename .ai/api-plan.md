# REST API Plan

## 1. Resources

- **Flashcards** - Maps to `flashcards` table
- **Generations** - Maps to `generations` table
- **Generation Logs** - Maps to `generation_logs` table
- **Users** - Maps to Supabase `auth.users` table

## 2. Endpoints

### Generations

#### Create generation

- **Method:** POST
- **Path:** `/api/generations`
- **Description:** Creates a new generation by submitting text and optional prompt to AI, returns flashcard proposals
- **Request Body:**
  ```json
  {
    "input_text": "string (1000-10000 characters)",
    "prompt": "string (optional)"
  }
  ```
- **Response:**
  ```json
  {
    "id": "uuid",
    "prompt": "string",
    "accepted_count": 0,
    "edited_count": 0,
    "total_generated": 10,
    "input_length": 1500,
    "user_id": "uuid",
    "created_at": "timestamp",
    "flashcards": [
      {
        "id": "uuid",
        "front": "string",
        "back": "string",
        "generation_id": "uuid",
        "source": null
      }
    ]
  }
  ```
- **Success:** 201 Created
- **Errors:**
  - 400 Bad Request - Input text length invalid or other validation errors
  - 401 Unauthorized - User not authenticated
  - 500 Internal Server Error - AI generation failed

#### Get all generations

- **Method:** GET
- **Path:** `/api/generations`
- **Description:** Returns a list of all generations created by the authenticated user
- **Query Parameters:**
  - `page` (integer, default: 1) - For pagination
  - `limit` (integer, default: 10) - Number of results per page
  - `sort_by` (string, optional) - Field to sort by
  - `sort_dir` (string, optional) - Sort direction (asc/desc)
- **Response:**
  ```json
  {
    "generations": [
      {
        "id": "uuid",
        "prompt": "string",
        "accepted_count": 5,
        "edited_count": 2,
        "total_generated": 10,
        "input_length": 1500,
        "created_at": "timestamp"
      }
    ],
    "pagination": {
      "total": 25,
      "pages": 3,
      "current_page": 1,
      "limit": 10
    }
  }
  ```
- **Success:** 200 OK
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 400 Bad Request - Invalid query parameters

#### Get generation

- **Method:** GET
- **Path:** `/api/generations/{id}`
- **Description:** Returns details of a specific generation with flashcard proposals made with this generation
- **Response:**
  ```json
  {
    "id": "uuid",
    "prompt": "string",
    "accepted_count": 5,
    "edited_count": 2,
    "total_generated": 10,
    "input_length": 1500,
    "input_hash": "string",
    "user_id": "uuid",
    "created_at": "timestamp",
    "updated_at": "timestamp",
    "flashcards": [
      {
        "id": "uuid",
        "front": "string",
        "back": "string",
        "generation_id": "uuid",
        "source": "string",
        "created_at": "timestamp",
        "updated_at": "timestamp"
      }
    ]
  }
  ```
- **Success:** 200 OK
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 403 Forbidden - User doesn't own this generation
  - 404 Not Found - Generation not found

#### Get flashcards for generation

- **Method:** GET
- **Path:** `/api/generations/{id}/flashcards`
- **Description:** Returns all flashcards associated with a specific generation
- **Query Parameters:**
  - `status` (string, optional) - Filter by status (accepted, rejected, pending)
- **Response:**
  ```json
  {
    "flashcards": [
      {
        "id": "uuid",
        "front": "string",
        "back": "string",
        "generation_id": "uuid",
        "source": "full-ai",
        "created_at": "timestamp",
        "updated_at": "timestamp"
      }
    ]
  }
  ```
- **Success:** 200 OK
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 403 Forbidden - User doesn't own this generation
  - 404 Not Found - Generation not found

### Flashcards

#### Create flashcard

- **Method:** POST
- **Path:** `/api/flashcards`
- **Description:** Creates a new standalone flashcard manually
- **Request Body:**
  ```json
  {
    "front": "string (max 200 chars)",
    "back": "string (max 500 chars)"
  }
  ```
- **Response:**
  ```json
  {
    "id": "uuid",
    "front": "string",
    "back": "string",
    "generation_id": null,
    "source": "manual",
    "created_at": "timestamp",
    "updated_at": "timestamp"
  }
  ```
- **Success:** 201 Created
- **Errors:**
  - 400 Bad Request - Validation failed
  - 401 Unauthorized - User not authenticated

#### Get all flashcards

- **Method:** GET
- **Path:** `/api/flashcards`
- **Description:** Returns all flashcards for the authenticated user
- **Query Parameters:**
  - `page` (integer, default: 1) - For pagination
  - `limit` (integer, default: 20) - Number of results per page
  - `source` (string, optional) - Filter by source (full-ai, edited-ai, manual)
  - `generation_id` (uuid, optional) - Filter by generation
- **Response:**
  ```json
  {
    "flashcards": [
      {
        "id": "uuid",
        "front": "string",
        "back": "string",
        "generation_id": "uuid",
        "source": "string",
        "created_at": "timestamp",
        "updated_at": "timestamp"
      }
    ],
    "pagination": {
      "total": 50,
      "pages": 3,
      "current_page": 1,
      "limit": 20
    }
  }
  ```
- **Success:** 200 OK
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 400 Bad Request - Invalid query parameters

#### Get flashcard

- **Method:** GET
- **Path:** `/api/flashcards/{id}`
- **Description:** Returns a specific flashcard
- **Response:**
  ```json
  {
    "id": "uuid",
    "front": "string",
    "back": "string",
    "generation_id": "uuid",
    "source": "string",
    "created_at": "timestamp",
    "updated_at": "timestamp"
  }
  ```
- **Success:** 200 OK
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 403 Forbidden - User doesn't own this flashcard
  - 404 Not Found - Flashcard not found

#### Update flashcard

- **Method:** PUT
- **Path:** `/api/flashcards/{id}`
- **Description:** Updates a flashcard (edit action) (if source is full-ai or edited-ai, the result source should be edited-ai. If source is manual, then the result source should remain manual)
- **Request Body:**
  ```json
  {
    "front": "string (max 200 chars)",
    "back": "string (max 500 chars)"
  }
  ```
- **Response:**
  ```json
  {
    "id": "uuid",
    "front": "string",
    "back": "string",
    "generation_id": "uuid",
    "source": "edited-ai",
    "created_at": "timestamp",
    "updated_at": "timestamp"
  }
  ```
- **Success:** 200 OK
- **Errors:**
  - 400 Bad Request - Validation failed
  - 401 Unauthorized - User not authenticated
  - 403 Forbidden - User doesn't own this flashcard
  - 404 Not Found - Flashcard not found

#### Delete flashcard

- **Method:** DELETE
- **Path:** `/api/flashcards/{id}`
- **Description:** Deletes a flashcard
- **Response:** No content
- **Success:** 204 No Content
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 403 Forbidden - User doesn't own this flashcard
  - 404 Not Found - Flashcard not found

#### Accept flashcard

- **Method:** POST
- **Path:** `/api/flashcards/{id}/accept`
- **Description:** Marks a flashcard as accepted
- **Response:**
  ```json
  {
    "id": "uuid",
    "front": "string",
    "back": "string",
    "generation_id": "uuid",
    "source": "full-ai",
    "created_at": "timestamp",
    "updated_at": "timestamp"
  }
  ```
- **Success:** 200 OK
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 403 Forbidden - User doesn't own this flashcard
  - 404 Not Found - Flashcard not found

#### Reject flashcard

- **Method:** POST
- **Path:** `/api/flashcards/{id}/reject`
- **Description:** Marks a flashcard as rejected
- **Response:** No content
- **Success:** 204 No Content
- **Errors:**
  - 401 Unauthorized - User not authenticated
  - 403 Forbidden - User doesn't own this flashcard
  - 404 Not Found - Flashcard not found

## 3. Authentication and Authorization

The API will use Supabase authentication with JWT tokens:

- **Authentication**: Supabase's auth system will be used directly from the frontend. JWT tokens will be included in API requests to authenticate users.
- **Authorization**: Row Level Security (RLS) policies defined in the database will ensure users can only access their own data.
- **Implementation Details**:
  - All API requests must include an `Authorization` header with a valid JWT token
  - The backend will validate the token and extract the user_id
  - Database queries will automatically apply RLS policies based on the authenticated user's ID
  - Endpoints will return 401 Unauthorized if no valid token is provided
  - Endpoints will return 403 Forbidden if a user attempts to access resources they don't own

## 4. Validation and Business Logic

### Flashcards

- `front` must be a string with max length of 200 characters
- `back` must be a string with max length of 500 characters
- `source` must be one of: 'full-ai', 'edited-ai', 'manual'

### Generations

- `input_text` must be between 1000 and 10000 characters
- When creating a generation, the text length is validated
- AI generation process is logged automatically
- Counters (`accepted_count`, `edited_count`, `total_generated`) are automatically updated when:
  - A flashcard is accepted (increases `accepted_count`)
  - A flashcard is edited (increases `edited_count`)
  - Flashcards are generated (sets `total_generated`)

### Security Implementations

- Input validation on all endpoints to prevent injection attacks
- Rate limiting for AI generation endpoints to prevent abuse
- Authentication required for all API endpoints
- Row Level Security ensures data isolation between users
