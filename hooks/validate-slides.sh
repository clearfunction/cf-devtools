#!/usr/bin/env bash
# Validates Slidev presentation files
# Checks frontmatter, slide separators, and layout names

set -euo pipefail

FILE_PATH="$1"

if [[ ! -f "$FILE_PATH" ]]; then
	echo "validate-slides: file not found: $FILE_PATH" >&2
	exit 1
fi

ERRORS=()
WARNINGS=()

# Check for frontmatter at start of file
if ! head -1 "$FILE_PATH" | grep -q "^---$"; then
	ERRORS+=("Missing YAML frontmatter at start of file (should start with ---)")
fi

# Check for closing frontmatter delimiter
FRONTMATTER_LINES=$(awk '/^---$/{count++; if(count==2) {print NR; exit}}' "$FILE_PATH")
if [[ -z "$FRONTMATTER_LINES" ]]; then
	ERRORS+=("Frontmatter not properly closed (missing second ---)")
fi

# Valid Slidev layouts
VALID_LAYOUTS="cover|default|center|intro|section|statement|quote|fact|full|image|image-left|image-right|iframe|iframe-left|iframe-right|two-cols|two-cols-header|end"

# Check layout declarations
while IFS= read -r line; do
	if [[ "$line" =~ ^layout:\ *(.+)$ ]]; then
		layout="${BASH_REMATCH[1]}"
		# Strip quotes if present
		layout="${layout//\"/}"
		layout="${layout//\'/}"
		layout="${layout// /}"

		if [[ ! "$layout" =~ ^($VALID_LAYOUTS)$ ]]; then
			WARNINGS+=("Unknown layout '$layout' - may be custom or theme-specific")
		fi
	fi
done <"$FILE_PATH"

# Check for common issues
if grep -q "^---$" "$FILE_PATH"; then
	SLIDE_COUNT=$(grep -c "^---$" "$FILE_PATH" || true)
	if [[ "$SLIDE_COUNT" -lt 2 ]]; then
		WARNINGS+=("Only $SLIDE_COUNT slide separator(s) found - presentation may be incomplete")
	fi
fi

# Check for empty slides (--- followed immediately by ---)
if grep -Pzo "---\n---" "$FILE_PATH" >/dev/null 2>&1; then
	WARNINGS+=("Empty slide detected (consecutive --- separators)")
fi

# Output results
if [[ ${#ERRORS[@]} -gt 0 ]]; then
	echo "Slidev validation errors in $(basename "$FILE_PATH"):" >&2
	for err in "${ERRORS[@]}"; do
		echo "  ERROR: $err" >&2
	done
fi

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
	echo "Slidev validation warnings in $(basename "$FILE_PATH"):" >&2
	for warn in "${WARNINGS[@]}"; do
		echo "  WARNING: $warn" >&2
	done
fi

# Exit with error only if there are actual errors (not just warnings)
if [[ ${#ERRORS[@]} -gt 0 ]]; then
	exit 1
fi

exit 0
