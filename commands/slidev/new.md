---
description: Create a new Slidev presentation on a topic
argument-hint: "[topic] e.g., 'React hooks' or 'our new API design'"
allowed-tools: Write, Read, Glob, Grep
---

# Create New Slidev Presentation

Create a new Slidev presentation about: **$ARGUMENTS**

## Instructions

1. **Determine the presentation type** based on the topic:
   - Technical deep-dive (conference talk)
   - Tutorial/workshop (hands-on learning)
   - Team update (internal communication)
   - Architecture overview (system design)

2. **Generate a complete `slides.md` file** with:
   - Proper headmatter (theme, title, transitions, mdc enabled)
   - 8-15 slides covering the topic comprehensively
   - Code examples with syntax highlighting where relevant
   - Mermaid diagrams for architecture/flow concepts
   - Progressive reveals (`v-clicks`) for key points
   - Presenter notes for talking points

3. **Use appropriate layouts**:
   - `cover` for title slide
   - `section` for major topic divisions
   - `two-cols` or `two-cols-header` for comparisons
   - `fact` for key statistics or highlights
   - `center` for impactful statements

4. **Save the file** as `slides.md` in the current directory (or a subdirectory if specified)

5. **Provide setup instructions**:

   ```bash
   npm init slidev@latest  # If not installed
   npx slidev              # Start dev server
   ```

Reference the slidev-presentations skill for syntax details.
