---
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  PROJECT-SPECIFIC SKILL                                                      ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  This skill is specific to THIS project and understands its architecture.   ║
# ║  Compare to global skills (in ~/.claude/skills/) which work anywhere.       ║
# ║                                                                              ║
# ║  PROJECT SKILLS ARE GREAT FOR:                                               ║
# ║  • Workflows that use project-specific file patterns                         ║
# ║  • Templates that match your project's coding style                          ║
# ║  • Automations that reference your specific architecture                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

name: feature-spec
description: Generate a feature specification document with implementation checklist. Use proactively when the user describes a new feature they want to add.
aliases:
  - spec
  - plan-feature
tools:
  - Read
  - Write
  - Glob
  - Grep

---

# Feature Specification Generator

You help developers plan new features by generating a structured specification document.

## When to Use This Skill

Use this skill when:
- User says "I want to add..." or "We need a feature for..."
- User describes a new capability they want
- User asks for help planning an implementation

## Process

### Step 1: Understand the Request

Ask clarifying questions if needed:
- What is the core user story?
- What components will be affected?
- Are there any constraints or dependencies?

### Step 2: Analyze the Codebase

Examine the existing codebase to understand:

```bash
# Check existing types
cat src/shared/types/*.ts

# Check existing API routes
ls src/server/routes/

# Check existing components
ls src/client/components/

# Check database schema
cat prisma/schema.prisma
```

### Step 3: Generate the Specification

Create a markdown file with this structure:

```markdown
# Feature: [Feature Name]

## User Story
As a [user type], I want to [action] so that [benefit].

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Design

### Database Changes
- [ ] Add `fieldName` column to `TableName`
- [ ] Create migration

### API Changes
- [ ] `POST /api/resource` - Create
- [ ] `GET /api/resource/:id` - Read

### Frontend Changes
- [ ] Create `ComponentName` component
- [ ] Update `ExistingComponent` to include new feature
- [ ] Add state management for new data

### Type Definitions
```typescript
interface NewFeature {
  // ...
}
```

## Implementation Checklist

1. [ ] Create database migration
2. [ ] Update Prisma schema
3. [ ] Add API routes
4. [ ] Create/update components
5. [ ] Add tests
6. [ ] Update documentation

## Testing Plan
- Unit tests for: [...]
- Integration tests for: [...]
- E2E tests for: [...]

## Estimated Files to Change
- `prisma/schema.prisma`
- `src/shared/types/...`
- `src/server/routes/...`
- `src/client/components/...`
```

### Step 4: Save the Specification

Save to: `docs/features/[feature-name].md`

If the `docs/features/` directory doesn't exist, create it.

## Output Guidelines

- Be specific about file paths and changes
- Reference existing patterns in the codebase
- Include all layers (DB → API → Frontend)
- Make the checklist actionable

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  INTERACTIVE EXAMPLE                                                         ║
║  ────────────────────────────────────────────────────────────────────────────║
║  User: /feature-spec Add priority levels to todo items                       ║
║                                                                              ║
║  Claude will:                                                                ║
║  1. Read prisma/schema.prisma to see current Todo model                      ║
║  2. Read src/shared/types/todo.ts to see current types                       ║
║  3. Generate a complete spec including:                                      ║
║     - Database migration for priority column                                 ║
║     - API updates to accept/return priority                                  ║
║     - UI changes for priority selector                                       ║
║     - Test checklist                                                         ║
║  4. Save to docs/features/todo-priority.md                                   ║
║                                                                              ║
║  TRY IT:                                                                     ║
║  1. Copy this skill to .claude/skills/feature-spec.md                        ║
║  2. Run: claude                                                              ║
║  3. Type: /spec Add tags/labels to todo items                                ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->
