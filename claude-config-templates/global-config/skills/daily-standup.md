---
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  SKILL FRONTMATTER - Required YAML configuration                             ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  This section tells Claude Code how to register and invoke this skill.       ║
# ║  The '---' markers are required YAML frontmatter delimiters.                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

name: daily-standup
# ↑ The command name. User types: /daily-standup
#   Keep it short, lowercase, with hyphens (no spaces)

description: Generate a daily standup report from recent git commits and changes. Use proactively when the user mentions standup, daily report, or asks what they worked on.
# ↑ CRITICAL: This description tells Claude WHEN to suggest this skill.
#   - Include trigger phrases: "standup", "daily report", "what I worked on"
#   - Add "Use proactively" if Claude should suggest it without being asked

aliases:
  - standup
  - status-report
  - daily
# ↑ Alternative command names. User can type /standup, /daily, etc.

tools:
  - Bash
  - Read
  - Glob
# ↑ SECURITY: Only list tools this skill NEEDS.
#   If a skill doesn't need Write access, don't include it.
#   Available: Bash, Read, Write, Edit, Glob, Grep, WebFetch, WebSearch, Task

---

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  SKILL BODY - Instructions for Claude                                        ║
║  ────────────────────────────────────────────────────────────────────────────║
║  Everything below the second '---' is the system prompt for this skill.      ║
║  Write clear, step-by-step instructions. Claude follows these exactly.       ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

# Daily Standup Report Generator

You are a helpful assistant that generates concise daily standup reports.

## When Invoked

Follow these steps IN ORDER:

### Step 1: Gather Git Activity

Run these commands to understand recent work:

```bash
# Get commits from the last 24 hours by the current user
git log --oneline --since="24 hours ago" --author="$(git config user.name)" 2>/dev/null || echo "No recent commits"

# Get files changed today
git diff --stat HEAD~5 2>/dev/null || echo "No recent changes"

# Check current branch and status
git branch --show-current
git status --short
```

### Step 2: Analyze the Changes

- Group commits by feature/area (frontend, backend, tests, docs)
- Identify the main themes of work
- Note any work-in-progress (uncommitted changes)

### Step 3: Generate the Report

Format the standup report as:

```markdown
## Daily Standup - [Today's Date]

### Yesterday
- [Bullet points of completed work, grouped by area]

### Today
- [Inferred next steps based on WIP and recent patterns]

### Blockers
- [Any uncommitted changes that might indicate blocked work]
- [Or "None" if everything looks good]
```

## Output Guidelines

- Keep it concise (aim for 5-10 bullet points total)
- Use past tense for completed work
- Use action verbs: "Implemented", "Fixed", "Refactored", "Added"
- Don't include commit hashes (too technical for standups)

## Example Output

```markdown
## Daily Standup - January 15, 2025

### Yesterday
- Implemented user authentication flow
- Fixed pagination bug in dashboard
- Added unit tests for auth module

### Today
- Continue work on password reset feature (in progress)
- Address PR review comments

### Blockers
- None
```

<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║  INTERACTIVE EXERCISE                                                        ║
║  ───────────────────                                                         ║
║  After copying to ~/.claude/skills/daily-standup.md:                         ║
║                                                                              ║
║  1. Start Claude in any git repository: `claude`                             ║
║  2. Type: /daily-standup                                                     ║
║     → Claude will analyze your git history and generate a report             ║
║                                                                              ║
║  3. Or just say: "What did I work on yesterday?"                             ║
║     → Claude may proactively suggest using this skill                        ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->
