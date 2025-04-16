# 10x-Cards

AI-powered flashcard generation application to accelerate your learning.

## Table of Contents
- [Description](#description)
- [Tech Stack](#tech-stack)
- [Getting Started Locally](#getting-started-locally)
- [Available Scripts](#available-scripts)
- [Project Scope](#project-scope)
- [Project Status](#project-status)
- [License](#license)

## Description

10x-Cards is a web application that enables quick and efficient creation of educational flashcards. The system uses artificial intelligence to automatically generate flashcard candidates based on long input text, while also allowing manual flashcard creation. The application integrates with an open-source spaced repetition library to optimize the learning process.

### Key Features
- AI-powered flashcard generation from text input (1,000-10,000 characters)
- Manual flashcard creation
- Review workflow for flashcard candidates (save, reject, or edit)
- User account management (registration, login, password change, account deletion)
- Integration with spaced repetition algorithms
- Comprehensive logging for diagnostics and analysis

## Tech Stack

### Frontend
- **Astro 5** - Fast, efficient pages with minimal JavaScript
- **React 19** - Interactive components where needed
- **TypeScript 5** - Static typing and better IDE support
- **Tailwind 4** - Utility-first CSS framework
- **Shadcn/ui** - Accessible React component library

### Backend
- **Supabase** - Complete backend solution:
  - PostgreSQL database
  - Authentication system
  - Backend-as-a-Service SDK

### AI
- **Openrouter.ai** - Communication with various AI models:
  - Access to models from OpenAI, Anthropic, Google, and others
  - Financial limit controls for API keys

### CI/CD and Hosting
- **GitHub Actions** - CI/CD pipelines
- **DigitalOcean** - Application hosting via Docker

## Getting Started Locally

### Prerequisites
- Node.js v22.14.0 (recommended to use [nvm](https://github.com/nvm-sh/nvm) with the included `.nvmrc`)
- npm (comes with Node.js)

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/jankepinski/10x-cards.git
   cd 10x-cards
   ```

2. Install dependencies
   ```bash
   npm install
   ```

3. Create an environment variables file
   ```bash
   cp .env.example .env
   ```

4. Configure your environment variables in the `.env` file

5. Start the development server
   ```bash
   npm run dev
   ```

6. Open your browser and navigate to `http://localhost:4321`

## Available Scripts

- `npm run dev` - Start the development server
- `npm run build` - Build the application for production
- `npm run preview` - Preview the production build locally
- `npm run astro` - Run Astro CLI commands
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Run ESLint and fix issues
- `npm run format` - Run Prettier to format code

## Project Scope

### Included in MVP
- AI-powered flashcard generation from text input
- Manual flashcard creation
- Flashcard review workflow
- User authentication and account management
- Spaced repetition integration
- Input validation
- Security best practices (authentication, authorization, validation, row-level security)

### Not Included in MVP
- Custom advanced spaced repetition algorithms (e.g., SuperMemo, Anki)
- Multiple file format imports (PDF, DOCX, etc.)
- Flashcard set sharing between users
- Integration with external educational platforms
- Mobile application (web-only in MVP)

## Project Status

This project is currently in early development. The MVP is under active construction.

Success metrics for the project:
- 75% of AI-generated flashcards must be accepted by users
- At least 75% of users utilize the AI flashcard generation feature
- Effective logging of flashcard generation processes and user decisions
- Users experience significant improvement in flashcard creation efficiency compared to traditional manual processes

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). 