#!/usr/bin/env bash
# Auto-formats markdown files with Prettier
# Gracefully skips if Prettier is not installed

set -euo pipefail

FILE_PATH="$1"

if [[ ! -f "$FILE_PATH" ]]; then
	exit 0
fi

# Only format markdown files
if [[ ! "$FILE_PATH" =~ \.md$ ]]; then
	exit 0
fi

# Check if prettier is available
if ! command -v npx &>/dev/null; then
	# No npx available, skip silently
	exit 0
fi

# Check if we're in a directory with prettier configured
# or if prettier is globally available
if npx prettier --version &>/dev/null; then
	# Run prettier on the file
	# Use --write to modify in place
	# Suppress output on success
	if npx prettier --write "$FILE_PATH" >/dev/null 2>&1; then
		echo "Formatted: $(basename "$FILE_PATH")"
	fi
else
	# Prettier not available, skip silently
	exit 0
fi

exit 0
