#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  POST-TOOL HOOK: Format on Save                                              ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  This hook runs AFTER Claude writes or edits a file.                        ║
# ║  It cannot block the operation (already done), only provide feedback.       ║
# ║                                                                              ║
# ║  LOCATION: .claude/hooks/format-on-save.sh                                  ║
# ║  TRIGGERED BY: PostToolUse hook with matcher "Write|Edit"                   ║
# ║                                                                              ║
# ║  USE CASES:                                                                  ║
# ║  • Auto-format code after changes                                           ║
# ║  • Run linters to catch issues immediately                                  ║
# ║  • Update generated files (e.g., API client from OpenAPI spec)              ║
# ║  • Log changes for audit purposes                                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Get the file path from tool input
FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | grep -oP '"file_path"\s*:\s*"\K[^"]+' 2>/dev/null)

# If we can't extract the path, skip formatting
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# ═══════════════════════════════════════════════════════════════════════════════
# FORMAT BASED ON FILE EXTENSION
# ═══════════════════════════════════════════════════════════════════════════════

# Check if the file exists (it should after Write/Edit)
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# Get file extension
EXTENSION="${FILE_PATH##*.}"

case "$EXTENSION" in
    ts|tsx|js|jsx)
        # Format TypeScript/JavaScript with Prettier
        if command -v prettier &> /dev/null; then
            prettier --write "$FILE_PATH" 2>/dev/null
            echo "Formatted with Prettier: $FILE_PATH"
        elif [ -f "node_modules/.bin/prettier" ]; then
            ./node_modules/.bin/prettier --write "$FILE_PATH" 2>/dev/null
            echo "Formatted with Prettier: $FILE_PATH"
        fi
        ;;

    json)
        # Format JSON with Prettier or jq
        if command -v prettier &> /dev/null; then
            prettier --write "$FILE_PATH" 2>/dev/null
            echo "Formatted JSON: $FILE_PATH"
        elif command -v jq &> /dev/null; then
            jq '.' "$FILE_PATH" > "$FILE_PATH.tmp" && mv "$FILE_PATH.tmp" "$FILE_PATH"
            echo "Formatted JSON with jq: $FILE_PATH"
        fi
        ;;

    css|scss|less)
        # Format CSS with Prettier
        if command -v prettier &> /dev/null; then
            prettier --write "$FILE_PATH" 2>/dev/null
            echo "Formatted CSS: $FILE_PATH"
        fi
        ;;

    md)
        # Format Markdown with Prettier (optional)
        # Often we skip markdown to preserve intended formatting
        echo "Skipping Markdown formatting: $FILE_PATH"
        ;;

    py)
        # Format Python with Black or autopep8
        if command -v black &> /dev/null; then
            black "$FILE_PATH" 2>/dev/null
            echo "Formatted with Black: $FILE_PATH"
        elif command -v autopep8 &> /dev/null; then
            autopep8 --in-place "$FILE_PATH" 2>/dev/null
            echo "Formatted with autopep8: $FILE_PATH"
        fi
        ;;

    go)
        # Format Go with gofmt
        if command -v gofmt &> /dev/null; then
            gofmt -w "$FILE_PATH" 2>/dev/null
            echo "Formatted with gofmt: $FILE_PATH"
        fi
        ;;

    rs)
        # Format Rust with rustfmt
        if command -v rustfmt &> /dev/null; then
            rustfmt "$FILE_PATH" 2>/dev/null
            echo "Formatted with rustfmt: $FILE_PATH"
        fi
        ;;

    *)
        echo "No formatter configured for .$EXTENSION files"
        ;;
esac

# ═══════════════════════════════════════════════════════════════════════════════
# OPTIONAL: Run quick lint check
# ═══════════════════════════════════════════════════════════════════════════════

# Uncomment to run ESLint on JS/TS files:
# if [[ "$EXTENSION" == "ts" || "$EXTENSION" == "tsx" || "$EXTENSION" == "js" || "$EXTENSION" == "jsx" ]]; then
#     if [ -f "node_modules/.bin/eslint" ]; then
#         LINT_OUTPUT=$(./node_modules/.bin/eslint "$FILE_PATH" 2>&1)
#         if [ $? -ne 0 ]; then
#             echo "ESLint issues found:"
#             echo "$LINT_OUTPUT"
#         fi
#     fi
# fi

exit 0

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  INTERACTIVE EXERCISE                                                        ║
# ║  ────────────────────────────────────────────────────────────────────────────║
# ║  1. Make executable: chmod +x .claude/hooks/format-on-save.sh               ║
# ║  2. Ensure Prettier is installed: pnpm add -D prettier                      ║
# ║  3. Ask Claude to create an unformatted file:                               ║
# ║     "Create a TypeScript file with a function but use bad spacing"          ║
# ║                                                                              ║
# ║  → After Claude writes the file, this hook formats it automatically!        ║
# ║                                                                              ║
# ║  NOTE: PostToolUse hooks run AFTER the operation, so they can't block.      ║
# ║  They're great for cleanup, formatting, and logging.                        ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
