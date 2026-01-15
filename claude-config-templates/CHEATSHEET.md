# Claude Code Configuration Cheatsheet

> Quick reference for agents, skills, hooks, and configuration

---

## File Locations at a Glance

```
HOME DIRECTORY (~/)
└── .claude/
    ├── CLAUDE.md              # Personal preferences (all projects)
    ├── settings.json          # Global permissions
    ├── skills/
    │   └── *.md               # Personal slash commands
    └── agents/
        └── *.md               # Personal subagents

PROJECT DIRECTORY
├── CLAUDE.md                  # Team project docs (alternative)
├── .mcp.json                  # Team MCP servers
└── .claude/
    ├── CLAUDE.md              # Team project docs
    ├── CLAUDE.local.md        # Your personal notes (gitignored)
    ├── settings.json          # Team permissions/hooks
    ├── settings.local.json    # Your overrides (gitignored)
    ├── rules/
    │   └── *.md               # Coding standards
    ├── skills/
    │   └── *.md               # Project slash commands
    ├── agents/
    │   └── *.md               # Project subagents
    └── hooks/
        └── *.sh               # Hook scripts
```

---

## Skill Template

```markdown
---
name: my-skill
description: What it does. Use proactively when [trigger phrases].
aliases: [alias1, alias2]
tools: [Read, Bash, Write]
---

# Skill Instructions

When invoked:
1. Do this
2. Then that
3. Return result
```

**Trigger**: `/my-skill` or mentioned trigger phrases

---

## Agent Template

```markdown
---
name: my-agent
description: What it does. Use proactively for [scenarios].
model: sonnet
tools: [Read, Glob, Grep]
disallowedTools: [Write, Edit]
permissionMode: default
---

# Agent Instructions

You are a specialist that...
```

**Trigger**: Claude spawns via `Task` tool when needed

---

## Settings.json Structure

```json
{
  "permissions": {
    "allow": ["Read", "Glob"],
    "allowBash": ["Bash(git *)"],
    "deny": ["Bash(rm -rf *)"]
  },
  "env": {
    "MY_VAR": "value"
  },
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "Stop": [...]
  }
}
```

---

## Hook Events

| Event | When | Can Block? |
|-------|------|------------|
| `PreToolUse` | Before tool runs | Yes (exit 2) |
| `PostToolUse` | After tool completes | No |
| `UserPromptSubmit` | User sends message | Yes |
| `Stop` | Claude finishes | No |
| `SessionStart` | Session begins | No |
| `SessionEnd` | Session ends | No |

---

## Hook Script Template

```bash
#!/bin/bash
# Exit codes:
#   0 = Allow (stdout in verbose mode)
#   2 = BLOCK (stderr shown to Claude)
#   1 = Non-blocking error

FILE=$(echo "$CLAUDE_TOOL_INPUT" | grep -oP '"file_path"\s*:\s*"\K[^"]+')

if [[ "$FILE" == *.env ]]; then
    echo "Cannot modify .env files" >&2
    exit 2  # Block
fi

exit 0  # Allow
```

---

## CLAUDE.md Best Practices

```markdown
# Project Name

## Overview
Brief description of the project.

## Architecture
- Component A: does X
- Component B: does Y

## Coding Standards
- Use TypeScript strict mode
- Prefer functional components

## Common Commands
| Task | Command |
|------|---------|
| Test | `pnpm test` |
| Build | `pnpm build` |

## File Organization
src/
├── components/
├── services/
└── types/
```

---

## Priority Order (Highest → Lowest)

1. **Enterprise** - `/etc/claude-code/` (IT-managed)
2. **Project Local** - `.claude/settings.local.json`
3. **Project** - `.claude/settings.json`
4. **User** - `~/.claude/settings.json`

---

## Quick Commands

```bash
# Initialize project CLAUDE.md
claude /init

# Manage agents
claude /agents

# Manage hooks
claude /hooks

# List MCP servers
claude mcp list

# Add MCP server
claude mcp add --scope project my-server https://example.com/mcp

# View loaded memory
claude /memory

# View config
claude /config
```

---

## What Goes Where?

| Content | File | Commit? |
|---------|------|---------|
| Personal code style | `~/.claude/CLAUDE.md` | N/A |
| Project architecture | `.claude/CLAUDE.md` | Yes |
| Your WIP notes | `.claude/CLAUDE.local.md` | No |
| Team permissions | `.claude/settings.json` | Yes |
| Your overrides | `.claude/settings.local.json` | No |
| Universal skills | `~/.claude/skills/*.md` | N/A |
| Project skills | `.claude/skills/*.md` | Yes |

---

## Debugging Tips

1. **Skill not loading?**
   - Check YAML frontmatter has `---` delimiters
   - Verify file is in `skills/` directory
   - Check for syntax errors in YAML

2. **Hook not running?**
   - Make script executable: `chmod +x script.sh`
   - Check matcher regex matches tool name
   - Use absolute paths or `$CLAUDE_PROJECT_DIR`

3. **Agent not found?**
   - Verify name in frontmatter matches
   - Check file is in `agents/` directory
   - Restart Claude session

4. **Settings not applying?**
   - Check for JSON syntax errors
   - Verify file location
   - Remember: local overrides project
