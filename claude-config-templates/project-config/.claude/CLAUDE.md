# Todo App Project

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  PROJECT CLAUDE.MD - Team-shared project memory                              ║
║  ────────────────────────────────────────────────────────────────────────────║
║  LOCATION: .claude/CLAUDE.md (or CLAUDE.md in project root)                  ║
║                                                                              ║
║  This file is CHECKED INTO GIT and shared with your team.                    ║
║  Claude reads this at the start of every session in this project.            ║
║                                                                              ║
║  USE THIS FOR:                                                               ║
║  • Project architecture overview                                             ║
║  • Coding standards everyone should follow                                   ║
║  • Common commands and workflows                                             ║
║  • File organization explanations                                            ║
║                                                                              ║
║  DON'T PUT HERE:                                                             ║
║  • Personal preferences (use ~/.claude/CLAUDE.md)                            ║
║  • Secrets or API keys (use .env files)                                      ║
║  • Local-only notes (use .claude/CLAUDE.local.md)                            ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

## Project Overview

<!--
  TIP: Start with a high-level description.
  Claude uses this to understand what kind of project it's working on.
-->

A full-stack todo application built with:
- **Frontend**: React + TypeScript + Tailwind CSS
- **Backend**: Node.js + Express + TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Testing**: Vitest (unit), Playwright (E2E)

## Architecture

<!--
  TIP: Describe the codebase structure.
  This helps Claude navigate and make appropriate suggestions.
-->

```
src/
├── client/                 # React frontend
│   ├── components/         # Reusable UI components
│   ├── pages/              # Route-level components
│   ├── hooks/              # Custom React hooks
│   ├── stores/             # Zustand state stores
│   └── types/              # Frontend TypeScript types
│
├── server/                 # Express backend
│   ├── routes/             # API route handlers
│   ├── services/           # Business logic layer
│   ├── middleware/         # Express middleware
│   └── utils/              # Server utilities
│
├── shared/                 # Shared between client/server
│   └── types/              # Shared TypeScript interfaces
│
└── prisma/
    ├── schema.prisma       # Database schema
    └── migrations/         # Database migrations
```

## Key Files

<!--
  TIP: Point Claude to important files.
  Use @file syntax to include their content when relevant.
-->

- Database schema: @prisma/schema.prisma
- API routes: @src/server/routes/index.ts
- Main types: @src/shared/types/todo.ts

## Coding Standards

<!--
  TIP: Be specific about patterns Claude should follow.
  These override personal preferences in ~/.claude/CLAUDE.md
-->

### TypeScript
- Strict mode enabled; never use `any` type
- Use interfaces for objects, types for unions/primitives
- Export types from `shared/types/` for cross-boundary use

### React Patterns
- Functional components only (no classes)
- Use Zustand for global state, React Query for server state
- Prefer composition over prop drilling

### API Design
- RESTful endpoints: `GET /api/todos`, `POST /api/todos`, etc.
- Always return JSON with `{ data, error }` shape
- Use Zod for request validation

### Database
- All schema changes go through Prisma migrations
- Use transactions for multi-step operations
- Soft delete (set `deletedAt`) instead of hard delete

## Common Commands

<!--
  TIP: Claude references these when helping with tasks.
  Include commands your team uses regularly.
-->

| Task | Command |
|------|---------|
| Start dev server | `pnpm dev` |
| Run all tests | `pnpm test` |
| Run E2E tests | `pnpm test:e2e` |
| Type check | `pnpm typecheck` |
| Lint & fix | `pnpm lint:fix` |
| Database migrate | `pnpm prisma migrate dev` |
| Generate Prisma client | `pnpm prisma generate` |

## Development Workflow

<!--
  TIP: Document your team's process.
  Claude can remind developers of these steps.
-->

1. Create a feature branch: `git checkout -b feat/description`
2. Make changes with tests
3. Run `pnpm verify` (runs lint, typecheck, test)
4. Create PR with conventional commit message

## API Endpoints

<!--
  TIP: Document your API surface.
  Claude uses this when implementing new features.
-->

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/todos` | List all todos (supports `?status=` filter) |
| POST | `/api/todos` | Create a new todo |
| GET | `/api/todos/:id` | Get a specific todo |
| PATCH | `/api/todos/:id` | Update a todo |
| DELETE | `/api/todos/:id` | Soft-delete a todo |

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  INTERACTIVE USE CASE: Adding a Priority Field                               ║
║  ────────────────────────────────────────────────────────────────────────────║
║  Imagine you ask Claude: "Add a priority field to todo items"                ║
║                                                                              ║
║  HOW CLAUDE USES THIS FILE:                                                  ║
║                                                                              ║
║  1. ARCHITECTURE: Claude knows to update:                                    ║
║     • prisma/schema.prisma (database)                                        ║
║     • src/shared/types/todo.ts (TypeScript types)                            ║
║     • src/server/routes/ (API)                                               ║
║     • src/client/components/ (UI)                                            ║
║                                                                              ║
║  2. CODING STANDARDS: Claude will:                                           ║
║     • Use an interface for the Priority type                                 ║
║     • Create a Prisma migration (not raw SQL)                                ║
║     • Add Zod validation for the new field                                   ║
║                                                                              ║
║  3. COMMON COMMANDS: Claude will suggest running:                            ║
║     • pnpm prisma migrate dev (after schema change)                          ║
║     • pnpm typecheck (to verify types)                                       ║
║     • pnpm test (to ensure nothing broke)                                    ║
║                                                                              ║
║  TRY IT: Copy this config, then ask Claude to add the priority field!        ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->
