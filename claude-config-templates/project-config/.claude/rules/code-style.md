# Code Style Rules

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  RULES FILES - .claude/rules/*.md                                            ║
║  ────────────────────────────────────────────────────────────────────────────║
║  Rules are modular instruction files that Claude loads based on context.     ║
║  Unlike CLAUDE.md (always loaded), rules can be:                             ║
║  • General (loaded for all files)                                            ║
║  • Path-specific (loaded only for matching files)                            ║
║                                                                              ║
║  HOW RULES DIFFER FROM CLAUDE.MD:                                            ║
║  • CLAUDE.md: Project overview, architecture, commands                       ║
║  • Rules: Specific coding standards, organized by topic                      ║
║                                                                              ║
║  ORGANIZATION OPTIONS:                                                       ║
║  .claude/rules/                                                              ║
║  ├── code-style.md       ← General (this file)                               ║
║  ├── testing.md          ← General                                           ║
║  ├── frontend/           ← Path-specific folder                              ║
║  │   ├── react.md                                                            ║
║  │   └── styles.md                                                           ║
║  └── backend/            ← Path-specific folder                              ║
║      └── api.md                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

## TypeScript Standards

These rules apply to ALL TypeScript files in the project.

### Type Safety

- **Never use `any`** - Use `unknown` and narrow with type guards
- **Prefer interfaces** for object shapes: `interface Todo { ... }`
- **Use types** for unions and primitives: `type Priority = 'low' | 'medium' | 'high'`
- **Export shared types** from `src/shared/types/`

### Naming Conventions

| Thing | Convention | Example |
|-------|------------|---------|
| Variables | camelCase | `todoItem`, `isCompleted` |
| Functions | camelCase | `getTodos`, `updatePriority` |
| Classes | PascalCase | `TodoService`, `ApiError` |
| Interfaces | PascalCase | `Todo`, `CreateTodoRequest` |
| Types | PascalCase | `Priority`, `TodoStatus` |
| Constants | SCREAMING_SNAKE | `MAX_TODOS`, `DEFAULT_PAGE_SIZE` |
| Files | kebab-case | `todo-list.tsx`, `api-client.ts` |

### Imports

- Group imports in this order:
  1. Node built-ins (`import fs from 'fs'`)
  2. External packages (`import React from 'react'`)
  3. Internal absolute (`import { Todo } from '@/types'`)
  4. Internal relative (`import { Button } from './Button'`)
- Use path aliases: `@/` for `src/`

### Functions

```typescript
// Prefer named function declarations for exports
export function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Use arrow functions for callbacks
const filtered = items.filter((item) => item.active);

// Always type parameters and return values
function processData(input: RawData): ProcessedData {
  // ...
}
```

## Error Handling

- Use custom error classes that extend `Error`
- Always include context in error messages
- Log errors with structured data, not string concatenation

```typescript
// Good
throw new ValidationError('Invalid todo', { field: 'title', value });

// Bad
throw new Error('Invalid todo: ' + title);
```

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  HOW CLAUDE USES THIS RULE FILE                                              ║
║  ────────────────────────────────────────────────────────────────────────────║
║  When you ask Claude to write TypeScript code:                               ║
║                                                                              ║
║  1. Claude reads .claude/CLAUDE.md for project context                       ║
║  2. Claude reads .claude/rules/code-style.md for standards                   ║
║  3. Claude applies these rules automatically                                 ║
║                                                                              ║
║  EXAMPLE:                                                                    ║
║  You: "Create a function to filter completed todos"                          ║
║                                                                              ║
║  Claude applies these rules and writes:                                      ║
║  • Named function (not arrow)                                                ║
║  • Typed parameters and return                                               ║
║  • camelCase function name                                                   ║
║  • Interface for the Todo type                                               ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->
