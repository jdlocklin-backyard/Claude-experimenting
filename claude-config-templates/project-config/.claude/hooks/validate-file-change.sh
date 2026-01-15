#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  PRE-TOOL HOOK: Validate File Changes                                       ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  This hook runs BEFORE Claude writes or edits a file.                       ║
# ║  It can BLOCK the operation by exiting with code 2.                         ║
# ║                                                                              ║
# ║  LOCATION: .claude/hooks/validate-file-change.sh                            ║
# ║  TRIGGERED BY: PreToolUse hook with matcher "Write|Edit"                    ║
# ║                                                                              ║
# ║  ENVIRONMENT VARIABLES AVAILABLE:                                           ║
# ║  • CLAUDE_TOOL_NAME    - The tool being used (Write, Edit)                  ║
# ║  • CLAUDE_TOOL_INPUT   - JSON with tool parameters                          ║
# ║  • CLAUDE_PROJECT_DIR  - Project root directory                             ║
# ║  • CLAUDE_SESSION_ID   - Current session ID                                 ║
# ║                                                                              ║
# ║  EXIT CODES:                                                                ║
# ║  • 0  - Allow the operation (stdout shown in verbose mode)                  ║
# ║  • 2  - BLOCK the operation (stderr shown to Claude as error)               ║
# ║  • 1+ - Non-blocking error (shown in verbose mode)                          ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Get the file path from tool input
# CLAUDE_TOOL_INPUT is JSON like: {"file_path": "/path/to/file", "content": "..."}
FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | grep -oP '"file_path"\s*:\s*"\K[^"]+' 2>/dev/null)

# If we can't extract the path, allow the operation (fail open)
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# ═══════════════════════════════════════════════════════════════════════════════
# RULE 1: Block changes to critical configuration files
# ═══════════════════════════════════════════════════════════════════════════════
CRITICAL_FILES=(
    ".env"
    ".env.local"
    ".env.production"
    "prisma/migrations"
    "package-lock.json"
    "pnpm-lock.yaml"
    "yarn.lock"
)

for critical in "${CRITICAL_FILES[@]}"; do
    if [[ "$FILE_PATH" == *"$critical"* ]]; then
        echo "BLOCKED: Cannot modify critical file: $FILE_PATH" >&2
        echo "This file requires manual editing for safety." >&2
        exit 2  # Exit code 2 blocks the operation
    fi
done

# ═══════════════════════════════════════════════════════════════════════════════
# RULE 2: Warn (but don't block) test file modifications
# ═══════════════════════════════════════════════════════════════════════════════
if [[ "$FILE_PATH" == *".test.ts"* ]] || [[ "$FILE_PATH" == *".spec.ts"* ]]; then
    echo "INFO: Modifying test file: $FILE_PATH"
    # Exit 0 allows, just logs info
fi

# ═══════════════════════════════════════════════════════════════════════════════
# RULE 3: Ensure TypeScript files are in allowed directories
# ═══════════════════════════════════════════════════════════════════════════════
if [[ "$FILE_PATH" == *.ts ]] || [[ "$FILE_PATH" == *.tsx ]]; then
    if [[ "$FILE_PATH" != *"/src/"* ]] && [[ "$FILE_PATH" != *"/tests/"* ]]; then
        echo "BLOCKED: TypeScript files must be in src/ or tests/" >&2
        echo "Attempted path: $FILE_PATH" >&2
        exit 2
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════════
# RULE 4: Check for potential secrets in content
# ═══════════════════════════════════════════════════════════════════════════════
CONTENT=$(echo "$CLAUDE_TOOL_INPUT" | grep -oP '"content"\s*:\s*"\K[^"]+' 2>/dev/null || echo "")

# Look for potential API keys or secrets
if echo "$CONTENT" | grep -qiE "(api[_-]?key|secret|password|token)\s*[:=]\s*['\"][a-zA-Z0-9]{20,}"; then
    echo "WARNING: Potential secret detected in file content" >&2
    echo "Please ensure no API keys or secrets are hardcoded." >&2
    # Exit 0 to allow but warn - change to exit 2 to block
fi

# ═══════════════════════════════════════════════════════════════════════════════
# All checks passed - allow the operation
# ═══════════════════════════════════════════════════════════════════════════════
echo "Validated: $FILE_PATH"
exit 0

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  INTERACTIVE EXERCISE                                                        ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  1. Make this script executable: chmod +x .claude/hooks/validate-file-change.sh
# ║  2. Start Claude and try: "Create a file at .env with API_KEY=secret"        ║
# ║     → Claude will be BLOCKED by this hook                                    ║
# ║                                                                              ║
# ║  3. Try: "Create a TypeScript file at /tmp/test.ts"                          ║
# ║     → Claude will be BLOCKED (not in src/ or tests/)                         ║
# ║                                                                              ║
# ║  4. Try: "Create a new component at src/client/components/Button.tsx"        ║
# ║     → Claude will be ALLOWED                                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
