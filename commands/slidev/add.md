---
description: Add a new slide with a specific layout to an existing presentation
argument-hint: "[layout] e.g., 'two-cols', 'fact', 'section', 'code-comparison'"
allowed-tools: Read, Edit, Write
---

# Add Slide to Presentation

Add a new slide with layout: **$ARGUMENTS**

## Instructions

1. **Read the existing `slides.md`** file to understand:
   - Current theme and style
   - Content flow and structure
   - Where the new slide should be inserted

2. **Ask the user** (if not specified):
   - What content should this slide contain?
   - Where should it be inserted (after which slide)?

3. **Generate the slide** based on the requested layout:

   **Available layouts**:

   | Layout | Use Case |
   |--------|----------|
   | `cover` | Title/opening slide |
   | `center` | Centered statement |
   | `section` | Section divider |
   | `two-cols` | Side-by-side content |
   | `two-cols-header` | Header + two columns |
   | `image-right` | Image with content |
   | `fact` | Highlight a statistic |
   | `quote` | Quotation |
   | `end` | Closing slide |

   **Special templates**:

   | Template | Description |
   |----------|-------------|
   | `code-comparison` | Before/after code with two-cols |
   | `pros-cons` | Two-column pros and cons list |
   | `timeline` | Mermaid Gantt chart |
   | `architecture` | Mermaid flowchart |

4. **Insert the slide** at the appropriate location in `slides.md`

5. **Confirm the addition** and show a preview of the slide markdown
