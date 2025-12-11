---
description: Generate Slidev slides from an approved presentation plan
argument-hint: "[plan-file] path to the presentation plan markdown file"
allowed-tools: Read, Write, Glob, Grep
---

# Generate Slides from Presentation Plan

Generate a complete Slidev `slides.md` from the plan: **$ARGUMENTS**

## Prerequisites

- A presentation plan file created by `/slidev:plan` or manually
- Plan should be reviewed and approved by the user

## Phase 1: Parse the Plan

Read the plan file and extract:

1. **Metadata**
   - Title
   - Duration
   - Audience
   - Format

2. **Time Allocation**
   - Section breakdown
   - Time per section

3. **Section Content**
   - Key points
   - Visuals needed
   - Code examples
   - Diagrams

4. **Presenter Notes**
   - Talking points
   - Q&A preparation

## Phase 2: Map Plan to Slides

### Time-to-Slides Ratio

Use these guidelines for slide count:

| Duration  | Approximate Slides |
| --------- | ------------------ |
| 5-10 min  | 5-10 slides        |
| 15-20 min | 12-18 slides       |
| 30 min    | 20-25 slides       |
| 45-60 min | 30-45 slides       |

### Section Mapping

For each section in the plan:

1. **Opening Hook** → `cover` layout with compelling title
2. **Context/Problem** → `center` or `default` with key points
3. **Main Content** → Mix of layouts based on content type:
   - Comparisons → `two-cols` or `two-cols-header`
   - Statistics → `fact` layout
   - Architecture → `default` with Mermaid diagram
   - Code → `default` with highlighted code blocks
4. **Section Dividers** → `section` layout
5. **Wrap-up** → `center` for takeaways, `end` for closing

## Phase 3: Generate slides.md

### Headmatter

```yaml
---
theme: default
title: {from plan}
info: |
  {summary from plan}
  Duration: {duration}
  Audience: {audience}
author: {if specified}
transition: slide-left
mdc: true
download: true
exportFilename: {topic-slug}
---
```

### Slide Generation Rules

1. **Use presenter notes** - Convert plan's "Talking Points" to HTML comments:

   ```markdown
   <!--
   - Key point to mention
   - Remember to demo X
   -->
   ```

2. **Create diagrams** - Generate Mermaid code for each diagram in the plan:
   - Architecture diagrams → `graph TD` or `graph LR`
   - Sequences → `sequenceDiagram`
   - Timelines → `gantt`

3. **Add code examples** - Follow the plan's guidance on:
   - Which code to include
   - Lines to highlight
   - Progressive reveal (`{1|2|3|all}`)

4. **Use v-clicks strategically** - For bullet points that should be revealed progressively

5. **Match layouts to content**:
   - Hook options from plan → Choose the best one for `cover`
   - Comparisons → `two-cols-header`
   - Key stats → `fact` layout
   - Quotes → `quote` layout

### Slide Structure Template

````markdown
---
layout: cover
background: {optional}
---

# {Title from Plan}

{Subtitle - audience/context}

---

# {Section from Plan}

<v-clicks>

- {Key point 1}
- {Key point 2}
- {Key point 3}

</v-clicks>

<!--
{Presenter notes from plan}
-->

---
layout: two-cols-header
---

# {Comparison Title}

::left::

### {Left Header}

- Point 1
- Point 2

::right::

### {Right Header}

- Point 1
- Point 2

---

# {Code Example Title}

```{language} {highlight}
{code from plan}
````

<!--
{Explain what this code demonstrates}
-->

---

## layout: section

## {Section Divider}

---

## layout: fact

## {Key Statistic}

{Context for the number}

---

## layout: end

## Thank You

{Call to action from plan}

<!--
Resources:
- {links from plan}
-->
