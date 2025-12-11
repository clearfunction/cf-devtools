#!/usr/bin/env bash
# Validates 1Password .env.op files
# Checks that values use op:// reference format

set -euo pipefail

FILE_PATH="$1"

if [[ ! -f "$FILE_PATH" ]]; then
	echo "validate-env-op: file not found: $FILE_PATH" >&2
	exit 1
fi

ERRORS=()
WARNINGS=()
LINE_NUM=0

while IFS= read -r line || [[ -n "$line" ]]; do
	LINE_NUM=$((LINE_NUM + 1))

	# Skip empty lines and comments
	[[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

	# Check for valid KEY=VALUE format
	if [[ ! "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
		WARNINGS+=("Line $LINE_NUM: Invalid format - should be KEY=VALUE")
		continue
	fi

	# Extract value (everything after first =)
	KEY="${line%%=*}"
	VALUE="${line#*=}"

	# Remove surrounding quotes if present
	VALUE="${VALUE#\"}"
	VALUE="${VALUE%\"}"
	VALUE="${VALUE#\'}"
	VALUE="${VALUE%\'}"

	# Check if value is an op:// reference
	if [[ "$VALUE" =~ ^op:// ]]; then
		# Validate op:// format: op://vault/item/field
		if [[ ! "$VALUE" =~ ^op://[^/]+/[^/]+/[^/]+$ ]]; then
			ERRORS+=("Line $LINE_NUM: Invalid op:// format for $KEY - should be op://vault/item/field")
		fi
	elif [[ -n "$VALUE" ]]; then
		# Non-empty value that's not an op:// reference
		# This is allowed but worth noting (static values like ports)
		WARNINGS+=("Line $LINE_NUM: $KEY has static value (not an op:// reference)")
	fi

done <"$FILE_PATH"

# Output results
if [[ ${#ERRORS[@]} -gt 0 ]]; then
	echo "1Password .env.op validation errors in $(basename "$FILE_PATH"):" >&2
	for err in "${ERRORS[@]}"; do
		echo "  ERROR: $err" >&2
	done
fi

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
	echo "1Password .env.op validation notes in $(basename "$FILE_PATH"):" >&2
	for warn in "${WARNINGS[@]}"; do
		echo "  NOTE: $warn" >&2
	done
fi

# Exit with error only if there are actual errors
if [[ ${#ERRORS[@]} -gt 0 ]]; then
	exit 1
fi

exit 0
