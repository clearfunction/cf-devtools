---
description: Export a Slidev presentation to PDF, PNG, or PPTX
argument-hint: "[format] pdf (default), png, or pptx"
allowed-tools: Bash, Read, Glob
---

# Export Slidev Presentation

Export the current Slidev presentation to: **$ARGUMENTS** (default: PDF)

## Instructions

1. **Verify slides.md exists** in the current directory or find the presentation file

2. **Check dependencies**:

   ```bash
   # playwright-chromium is required for export
   npm list playwright-chromium || npm install -D playwright-chromium
   ```

3. **Run the appropriate export command**:

   **PDF (default)**:

   ```bash
   npx slidev export
   ```

   **PNG (one image per slide)**:

   ```bash
   npx slidev export --format png
   ```

   **PPTX (PowerPoint)**:

   ```bash
   npx slidev export --format pptx
   ```

4. **Additional options** (use if requested):
   - `--dark` - Export in dark mode
   - `--with-clicks` - Separate page for each click animation
   - `--output filename` - Custom output filename

5. **Report the output location** to the user (typically `./slides-export.pdf` or similar)
