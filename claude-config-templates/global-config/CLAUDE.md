# Personal Claude Preferences

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  WHAT IS THIS FILE?                                                          ║
║  ─────────────────                                                           ║
║  This is YOUR personal memory file. Claude loads it at the START of every   ║
║  session, in EVERY project. Think of it as "things Claude should always     ║
║  know about how I work."                                                     ║
║                                                                              ║
║  LOCATION: ~/.claude/CLAUDE.md                                               ║
║                                                                              ║
║  HOW CLAUDE USES IT:                                                         ║
║  • Reads it automatically when starting any session                          ║
║  • Uses it to personalize responses to your preferences                      ║
║  • Combines it with project-specific CLAUDE.md (project takes priority)      ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

## About Me

<!--
  TIP: Tell Claude about your role and experience level.
  This helps Claude calibrate explanations and suggestions.
-->

- I'm a senior full-stack developer
- I prefer concise explanations over verbose ones
- I like to understand the "why" behind suggestions

## My Coding Style

<!--
  TIP: These preferences apply to ALL projects unless overridden.
  Project-specific CLAUDE.md can override these.
-->

- Use 2-space indentation (not tabs)
- Prefer `const` over `let` in JavaScript/TypeScript
- Write self-documenting code; avoid excessive comments
- Use meaningful variable names (no single letters except in loops)

## My Preferred Tools

<!--
  TIP: Tell Claude which tools you're comfortable with.
  Claude will prefer these when offering solutions.
-->

- Package manager: pnpm (prefer over npm/yarn)
- Testing: Vitest for unit tests, Playwright for E2E
- Linting: ESLint + Prettier
- Git: I use conventional commits (feat:, fix:, etc.)

## Communication Preferences

<!--
  TIP: How should Claude communicate with you?
-->

- Skip basic explanations; assume I know the fundamentals
- When suggesting changes, show the diff or code directly
- Ask clarifying questions before making architectural decisions
- Don't add emojis unless I ask for them

## Common Shortcuts I Use

<!--
  TIP: Document commands you run frequently.
  Claude can reference these when helping you.
-->

| Task | Command |
|------|---------|
| Run tests | `pnpm test` |
| Type check | `pnpm typecheck` |
| Format code | `pnpm format` |
| Build | `pnpm build` |

## Things I Often Forget

<!--
  TIP: Claude can remind you about these!
  Add things you frequently overlook.
-->

- Run `pnpm typecheck` before committing
- Update tests when changing function signatures
- Check for console.log statements before PR

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  INTERACTIVE EXERCISE                                                        ║
║  ───────────────────                                                         ║
║  Try this after copying to ~/.claude/CLAUDE.md:                              ║
║                                                                              ║
║  1. Start a new Claude session: `claude`                                     ║
║  2. Ask: "What package manager should I use?"                                ║
║     → Claude should suggest pnpm (from your preferences above)               ║
║                                                                              ║
║  3. Ask: "Write a quick sort function in TypeScript"                         ║
║     → Claude should use 2-space indentation, const, meaningful names         ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->
