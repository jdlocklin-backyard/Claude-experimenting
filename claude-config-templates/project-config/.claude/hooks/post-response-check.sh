#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  STOP HOOK: Post-Response Check                                              ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  This hook runs when Claude FINISHES a response.                            ║
# ║  Use it for quick quality checks after Claude completes work.               ║
# ║                                                                              ║
# ║  LOCATION: .claude/hooks/post-response-check.sh                             ║
# ║  TRIGGERED BY: Stop hook event                                              ║
# ║                                                                              ║
# ║  AVAILABLE ENVIRONMENT VARIABLES:                                           ║
# ║  • CLAUDE_PROJECT_DIR  - Project root directory                             ║
# ║  • CLAUDE_SESSION_ID   - Current session ID                                 ║
# ║                                                                              ║
# ║  NOTE: Keep this hook FAST (<10 seconds) to avoid slowing down the UX.      ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Change to project directory
cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK 1: TypeScript type errors (quick check)
# ═══════════════════════════════════════════════════════════════════════════════

# Only run if tsconfig exists
if [ -f "tsconfig.json" ]; then
    # Quick type check (no emit, faster)
    if [ -f "node_modules/.bin/tsc" ]; then
        TYPE_ERRORS=$(./node_modules/.bin/tsc --noEmit 2>&1 | head -20)
        if [ $? -ne 0 ]; then
            echo "⚠️  TypeScript errors detected:"
            echo "$TYPE_ERRORS"
            echo ""
            echo "Run 'pnpm typecheck' for full details."
        fi
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK 2: Look for console.log statements in production code
# ═══════════════════════════════════════════════════════════════════════════════

CONSOLE_LOGS=$(grep -rn "console\.log" src/ --include="*.ts" --include="*.tsx" 2>/dev/null | head -5)
if [ -n "$CONSOLE_LOGS" ]; then
    echo "📝 Console.log statements found (remove before commit):"
    echo "$CONSOLE_LOGS"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK 3: Uncommitted changes summary
# ═══════════════════════════════════════════════════════════════════════════════

if git rev-parse --git-dir > /dev/null 2>&1; then
    CHANGED_FILES=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
    if [ "$CHANGED_FILES" -gt 0 ]; then
        echo "📁 $CHANGED_FILES file(s) changed (uncommitted)"
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK 4: Look for TODO/FIXME comments added
# ═══════════════════════════════════════════════════════════════════════════════

# Only check recently modified files
RECENT_TODOS=$(git diff HEAD --no-color 2>/dev/null | grep -E "^\+" | grep -E "(TODO|FIXME|HACK)" | head -3)
if [ -n "$RECENT_TODOS" ]; then
    echo "📌 New TODO/FIXME comments detected:"
    echo "$RECENT_TODOS"
fi

exit 0

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  INTERACTIVE EXERCISE                                                        ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  1. Make executable: chmod +x .claude/hooks/post-response-check.sh          ║
# ║  2. Ask Claude to add a feature with a console.log                          ║
# ║  3. When Claude finishes, you'll see:                                       ║
# ║     "📝 Console.log statements found..."                                     ║
# ║                                                                              ║
# ║  This helps catch common issues automatically!                              ║
# ║                                                                              ║
# ║  CUSTOMIZATION IDEAS:                                                       ║
# ║  • Run quick unit tests                                                     ║
# ║  • Check bundle size                                                        ║
# ║  • Validate JSON/YAML files                                                 ║
# ║  • Check for security issues (secrets, vulnerable deps)                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
