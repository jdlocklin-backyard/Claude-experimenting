# Claude Code Configuration Templates

> **Interactive learning scaffold for Claude Code agents, skills, and hooks**

This repository contains **best-practice templates** for configuring Claude Code at two levels:

| Folder | Location | Scope | When to Use |
|--------|----------|-------|-------------|
| `global-config/` | `~/.claude/` | All projects | Personal preferences, universal tools |
| `project-config/` | `.claude/` in project root | Single project | Team standards, project-specific workflows |

---

## Quick Start

```bash
# 1. Copy global templates to your home directory
cp -r global-config/* ~/.claude/

# 2. Copy project templates to any project
cp -r project-config/.claude /path/to/your/project/

# 3. Start Claude Code and try the examples!
claude
```

---

## What's Inside

### Global Config (`~/.claude/`)
```
global-config/
├── CLAUDE.md                 # Your personal preferences (applies everywhere)
├── settings.json             # Default permissions and environment
├── skills/
│   └── daily-standup.md      # Example: Generate standup reports
└── agents/
    └── security-scanner.md   # Example: Security-focused code reviewer
```

### Project Config (`.claude/`)
```
project-config/
└── .claude/
    ├── CLAUDE.md             # Project architecture and standards
    ├── settings.json         # Team permissions and hooks
    ├── settings.local.json   # Your personal overrides (gitignored)
    ├── rules/
    │   ├── code-style.md     # Coding standards
    │   └── testing.md        # Testing requirements
    ├── skills/
    │   └── feature-spec.md   # Example: Generate feature specs
    ├── agents/
    │   └── test-runner.md    # Example: Specialized test agent
    └── hooks/
        ├── pre-commit-check.sh
        └── format-on-save.sh
```

---

## Interactive Use Case: Building a Todo App Feature

This scaffold includes a **complete worked example** showing how Claude uses these files when you ask:

> "Add a priority field to the todo items"

**Follow along in each file to see:**
1. How `CLAUDE.md` provides context about the codebase
2. How **skills** automate repetitive workflows
3. How **agents** handle specialized tasks
4. How **hooks** enforce quality gates

---

## Key Concepts

### Skills vs Agents

| Aspect | Skills | Agents |
|--------|--------|--------|
| Triggered by | `/command` or proactively | `Task` tool or proactively |
| Context | Same conversation | Isolated subprocess |
| Best for | Workflows, templates | Complex analysis, parallel work |
| Example | `/feature-spec` | Code reviewer, test runner |

### File Priority (Highest → Lowest)

1. **Enterprise** (`/etc/claude-code/`) - IT policies
2. **Project** (`.claude/settings.json`) - Team standards
3. **Project Local** (`.claude/settings.local.json`) - Your overrides
4. **User** (`~/.claude/settings.json`) - Personal defaults

---

## Next Steps

1. **Read the files** - Each has detailed inline comments
2. **Copy what you need** - Customize for your workflow
3. **Try the examples** - Run `/daily-standup` or ask Claude to review code

Happy coding!
