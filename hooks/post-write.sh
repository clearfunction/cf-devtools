#!/usr/bin/env bash
# Post-write dispatcher for cf-devtools plugin
# Routes files to appropriate validators based on type

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get file path from environment (set by Claude Code)
FILE_PATH="${CLAUDE_FILE_PATH:-}"

if [[ -z "$FILE_PATH" ]]; then
	# No file path provided, nothing to validate
	exit 0
fi

# Check if file exists
if [[ ! -f "$FILE_PATH" ]]; then
	exit 0
fi

# Get file extension and name
FILE_EXT="${FILE_PATH##*.}"
FILE_NAME="$(basename "$FILE_PATH")"

# Route to appropriate validator
case "$FILE_NAME" in
*.env.op)
	# 1Password environment file
	"${SCRIPT_DIR}/validate-env-op.sh" "$FILE_PATH"
	;;
slides.md | *.slides.md)
	# Slidev presentation file
	"${SCRIPT_DIR}/validate-slides.sh" "$FILE_PATH"
	"${SCRIPT_DIR}/format-markdown.sh" "$FILE_PATH"
	;;
*.md)
	# Check if it's a Slidev file by content
	if grep -q "^---$" "$FILE_PATH" && grep -q "^layout:" "$FILE_PATH" 2>/dev/null; then
		"${SCRIPT_DIR}/validate-slides.sh" "$FILE_PATH"
	fi
	"${SCRIPT_DIR}/format-markdown.sh" "$FILE_PATH"
	;;
esac

exit 0
