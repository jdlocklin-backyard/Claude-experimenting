# Testing Rules

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  TESTING STANDARDS                                                           ║
║  ────────────────────────────────────────────────────────────────────────────║
║  This rule file tells Claude how to write tests for this project.            ║
║  Claude will follow these patterns when:                                     ║
║  • You ask it to write tests                                                 ║
║  • You ask it to implement a feature (tests included)                        ║
║  • You ask it to fix a bug (regression test expected)                        ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

## Testing Stack

- **Unit tests**: Vitest
- **E2E tests**: Playwright
- **Coverage**: V8 via Vitest

## File Organization

```
tests/
├── unit/                    # Unit tests (mirror src/ structure)
│   ├── server/
│   │   └── services/
│   │       └── todo-service.test.ts
│   └── client/
│       └── hooks/
│           └── use-todos.test.ts
│
├── integration/             # API integration tests
│   └── api/
│       └── todos.test.ts
│
└── e2e/                     # End-to-end tests
    └── todo-flow.spec.ts
```

## Unit Test Patterns

### Test File Naming
- Mirror the source file: `todo-service.ts` → `todo-service.test.ts`
- Place in corresponding `tests/unit/` subdirectory

### Test Structure

```typescript
// tests/unit/server/services/todo-service.test.ts

import { describe, it, expect, beforeEach, vi } from 'vitest';
import { TodoService } from '@/server/services/todo-service';

describe('TodoService', () => {
  // Group by method or feature
  describe('createTodo', () => {
    // Test the happy path first
    it('creates a todo with valid input', async () => {
      // Arrange
      const input = { title: 'Test todo', priority: 'medium' };

      // Act
      const result = await todoService.createTodo(input);

      // Assert
      expect(result).toMatchObject({
        title: 'Test todo',
        priority: 'medium',
        completed: false,
      });
    });

    // Then edge cases
    it('throws ValidationError for empty title', async () => {
      await expect(todoService.createTodo({ title: '' }))
        .rejects.toThrow(ValidationError);
    });
  });
});
```

### Naming Conventions

Test descriptions should be:
- **Descriptive**: What behavior is being tested
- **Result-focused**: What should happen

```typescript
// Good
it('returns empty array when no todos exist', ...)
it('throws NotFoundError when todo does not exist', ...)
it('filters todos by status when status parameter provided', ...)

// Bad
it('test getTodos', ...)
it('should work', ...)
it('handles error', ...)
```

## Mocking Guidelines

### When to Mock

| Dependency | Mock? | Why |
|------------|-------|-----|
| Database | Yes | Slow, stateful |
| External APIs | Yes | Unreliable, costs money |
| File system | Maybe | Use in-memory for speed |
| Pure functions | No | Fast, deterministic |
| Time/dates | Yes | Non-deterministic |

### Mock Pattern

```typescript
import { vi, beforeEach } from 'vitest';
import { prisma } from '@/server/db';

// Mock the entire module
vi.mock('@/server/db', () => ({
  prisma: {
    todo: {
      findMany: vi.fn(),
      create: vi.fn(),
    },
  },
}));

beforeEach(() => {
  // Reset mocks between tests
  vi.clearAllMocks();
});

it('calls database with correct query', async () => {
  // Arrange
  vi.mocked(prisma.todo.findMany).mockResolvedValue([mockTodo]);

  // Act
  await todoService.getTodos({ status: 'pending' });

  // Assert
  expect(prisma.todo.findMany).toHaveBeenCalledWith({
    where: { status: 'pending', deletedAt: null },
  });
});
```

## E2E Test Patterns

```typescript
// tests/e2e/todo-flow.spec.ts

import { test, expect } from '@playwright/test';

test.describe('Todo Management', () => {
  test('user can create, complete, and delete a todo', async ({ page }) => {
    // Navigate
    await page.goto('/');

    // Create a todo
    await page.fill('[data-testid="todo-input"]', 'Buy groceries');
    await page.click('[data-testid="add-button"]');

    // Verify it appears
    await expect(page.locator('[data-testid="todo-item"]')).toContainText('Buy groceries');

    // Complete it
    await page.click('[data-testid="complete-checkbox"]');
    await expect(page.locator('[data-testid="todo-item"]')).toHaveClass(/completed/);

    // Delete it
    await page.click('[data-testid="delete-button"]');
    await expect(page.locator('[data-testid="todo-item"]')).not.toBeVisible();
  });
});
```

## Test Commands

```bash
# Run all unit tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Run with coverage
pnpm test:coverage

# Run E2E tests
pnpm test:e2e

# Run specific test file
pnpm test todo-service
```

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  INTERACTIVE EXAMPLE                                                         ║
║  ────────────────────────────────────────────────────────────────────────────║
║  When you ask Claude: "Add tests for the priority feature"                   ║
║                                                                              ║
║  Claude will:                                                                ║
║  1. Create tests/unit/server/services/todo-service.test.ts                   ║
║  2. Follow the Arrange/Act/Assert pattern                                    ║
║  3. Use descriptive test names                                               ║
║  4. Mock the database layer                                                  ║
║  5. Test both happy path and error cases                                     ║
║                                                                              ║
║  The test file will look like the examples above!                            ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->
