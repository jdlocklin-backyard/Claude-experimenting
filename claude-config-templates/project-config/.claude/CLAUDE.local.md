# My Local Notes

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  LOCAL PROJECT MEMORY - .claude/CLAUDE.local.md                              ║
║  ────────────────────────────────────────────────────────────────────────────║
║  YOUR personal notes for THIS project.                                       ║
║  This file is GITIGNORED - it stays on your machine only.                    ║
║                                                                              ║
║  USE THIS FOR:                                                               ║
║  • Personal reminders about this project                                     ║
║  • WIP notes and experiments                                                 ║
║  • Local environment quirks                                                  ║
║  • Things you want to remember but not share                                 ║
║                                                                              ║
║  HOW IT WORKS:                                                               ║
║  • Loaded AFTER .claude/CLAUDE.md (higher priority)                          ║
║  • Claude sees both, but your local notes take precedence                    ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

## My Local Environment

<!--
  TIP: Document your specific setup that differs from the team.
-->

- My database runs on port 5433 (not default 5432)
- I use the `debug` branch of the auth library locally
- My editor is Cursor with vim bindings

## Things I'm Working On

<!--
  TIP: Track your personal context across sessions.
-->

- [ ] Refactoring the todo filtering logic
- [ ] Adding keyboard shortcuts to the UI
- [ ] Performance optimization for large lists

## Notes to Self

<!--
  TIP: Reminders that only make sense to you.
-->

- The weird bug in auth is related to session cookies - check browser console
- Don't forget to run migrations after pulling from main
- Ask Sarah about the design system before changing button styles

## Experiments

<!--
  TIP: Track things you're trying out.
-->

### Using Zustand Immer Middleware

I'm testing this in `src/client/stores/todo-store.ts` - might propose to team if it works well.

### New Test Pattern

Trying table-driven tests like Go - see `tests/unit/server/services/todo-service.test.ts`

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  INTERACTIVE EXERCISE                                                        ║
║  ────────────────────────────────────────────────────────────────────────────║
║  1. Copy to .claude/CLAUDE.local.md                                          ║
║  2. Add to .gitignore: .claude/CLAUDE.local.md                               ║
║  3. Add your own personal notes                                              ║
║  4. Start Claude and ask: "What am I working on?"                            ║
║     → Claude reads your local notes and tells you!                           ║
║                                                                              ║
║  EXAMPLE:                                                                    ║
║  You: "What should I remember about the auth bug?"                           ║
║  Claude: "You noted that the weird auth bug is related to session            ║
║           cookies - check the browser console."                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->
