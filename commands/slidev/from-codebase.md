---
description: Analyze a codebase and interactively build a presentation plan and slides
argument-hint: "[path] optional path to analyze (default: current directory)"
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, Task, AskUserQuestion
---

# Generate Presentation from Codebase Analysis

Analyze the codebase, create a detailed presentation plan, then generate slides.

**Target path**: $ARGUMENTS (default: current directory)

## Workflow Overview

```text
Codebase Analysis → Questions → PLAN Document → Review → Slides
```

This command follows the plan-first approach:

1. Analyze the codebase
2. Ask targeted questions
3. Generate a presentation plan (review checkpoint)
4. Generate slides from the approved plan

---

## Phase 1: Codebase Discovery

Explore and understand the project thoroughly:

### 1.1 Identify Project Type and Stack

- Check for `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, `pom.xml`, etc.
- Identify frameworks (React, Next.js, Django, FastAPI, Rails, etc.)
- Note key dependencies and their purposes
- Check for monorepo structure (nx, turborepo, lerna)

### 1.2 Map the Architecture

- Directory structure and organization patterns
- Entry points and main modules
- API routes/endpoints if applicable
- Database models/schemas
- Configuration and environment setup
- Infrastructure as code (Terraform, Pulumi, CloudFormation)

### 1.3 Find Notable Patterns

- Design patterns used (MVC, hexagonal, clean architecture, etc.)
- Testing approach and coverage
- CI/CD configuration (.github/workflows, .gitlab-ci.yml, etc.)
- Documentation quality (README, docs/, wiki)

### 1.4 Identify Interesting Code

- Core business logic locations
- Complex algorithms or clever solutions
- Integration points with external services
- Performance optimizations
- Security implementations

### 1.5 Gather Key Numbers

- Lines of code (approximate)
- Number of files/modules
- Test coverage if available
- Dependencies count
- API endpoint count

---

## Phase 2: Interactive Discovery

**Ask the user these questions** using AskUserQuestion:

### Question Set 1: Presentation Basics

**Q1: Duration**
"How long is this presentation?"

- Lightning talk (5-10 minutes)
- Short talk (15-20 minutes)
- Standard talk (30 minutes)
- Deep dive (45-60 minutes)

**Q2: Audience**
"Who is the target audience?"

- New team members (onboarding)
- Technical leadership (architecture review)
- External developers (open source/API consumers)
- Non-technical stakeholders (high-level overview)
- Mixed audience (varied technical levels)

**Q3: Format**
"What's the presentation format?"

- Lecture/talk (slides + speaking)
- Demo-heavy (live coding/walkthrough)
- Workshop (hands-on exercises)
- Discussion/Q&A heavy

**Q4: Venue**
"What's the occasion?"

- Team meeting (internal, informal)
- Company all-hands (internal, formal)
- Conference talk (external, formal)
- Client presentation (external, demo)
- Training session (educational)

### Question Set 2: Content Focus

**Q5: Focus Areas** (multi-select)
"Which aspects should we focus on?"

- Architecture & design patterns
- Key features & functionality
- API design & endpoints
- Data models & database schema
- Testing strategy
- DevOps & deployment
- Performance considerations
- Security measures

**Q6: Technical Depth**
"How deep should the technical content go?"

- High-level overview (concepts, no code)
- Moderate depth (key code snippets, diagrams)
- Deep dive (detailed code walkthrough, internals)

**Q7: Code Examples**
"How much code should appear in slides?"

- Minimal (concepts only, pseudocode)
- Moderate (key snippets, highlighted lines)
- Heavy (full examples, walkthroughs)

**Q8: Live Demo**
"Will there be live demonstrations?"

- No live demo (slides/screenshots only)
- Brief demo (1-2 quick demos)
- Demo-heavy (significant live portions)

### Question Set 3: Content Strategy

**Q9: Core Message**
"What's the ONE thing you want the audience to remember?"

- Free text input

**Q10: Call to Action**
"What should the audience DO after this presentation?"

- Free text input

**Q11: Special Requests** (optional)
"Any specific components, features, or aspects to highlight?"

- Free text input

---

## Phase 3: Generate Presentation Plan

Based on codebase analysis and user answers, create `{project-name}-presentation-plan.md`:

### Plan Structure

````markdown
# {Project Name} - Presentation Plan

**Duration:** {X} minutes
**Audience:** {description}
**Format:** {format type}
**Venue:** {context}

---

## Core Message

> "{The ONE thing to remember}"

## Call to Action

{What audience should do after}

---

## Codebase Summary

### Technology Stack

| Category | Technology |
|----------|------------|
| Language | {from analysis} |
| Framework | {from analysis} |
| Database | {from analysis} |
| ... | ... |

### Key Statistics

- **{N}** source files
- **{M}** dependencies
- **{P}** API endpoints
- **{Q}%** test coverage

### Architecture Overview

{Brief description of architecture discovered}

---

## Time Allocation

| Section | Time | Focus |
|---------|------|-------|
| 1. Opening Hook | X min | {focus} |
| 2. Project Overview | X min | {focus} |
| 3. {Main Section 1} | X min | {focus} |
| 4. {Main Section 2} | X min | {focus} |
| 5. Demo | X min | {focus} |
| 6. Wrap-up | X min | {focus} |

---

## Section Details

### Section 1: Opening Hook ({X} min)

**Hook Options:**

**Option A - Problem Statement:**
> "{Problem this project solves}"

**Option B - Before/After:**
> "{What was life like before vs after}"

**Context to Establish:**
- {Point 1 from codebase}
- {Point 2 from codebase}

---

### Section 2: Project Overview ({X} min)

**Key Points:**
- {From codebase analysis}
- {From codebase analysis}

**Visuals Needed:**
- [ ] Architecture diagram (Mermaid)
- [ ] Tech stack table
- [ ] Directory structure

---

### Section 3: {Based on Focus Areas} ({X} min)

{Continue for each section based on user's focus area selections}

---

## Diagrams to Create

1. **System Architecture** - Overall system components
   - Type: Mermaid graph TD
   - Include: {components discovered}

2. **Data Flow** - How data moves through system
   - Type: Mermaid sequenceDiagram
   - Include: {key flows}

{Add more based on codebase analysis}

---

## Code Examples to Include

1. **{File: path/to/interesting/code.ts}**
   - Purpose: {what it demonstrates}
   - Lines: {X-Y}
   - Highlight: {key lines}

2. **{File: another/example.py}**
   - Purpose: {what it demonstrates}
   ...

{From codebase analysis - notable code}

---

## Demo Plan

### Option A: {Demo Name}
- What to show: {description}
- Commands:
  ```bash
  {commands from project}
````

- Duration: {X} min

### Backup Plan

- [ ] Screenshots prepared
- [ ] Recording available
- [ ] Explanation if demo fails

---

## Potential Q&A

Based on the codebase, anticipate these questions:

1. **"Why {technology choice}?"**
   - Answer: {from codebase/README}

2. **"How does {complex feature} work?"**
   - Answer: {from code analysis}

{Generate 3-5 based on codebase}

---

## Presenter Checklist

### Before

- [ ] Review codebase changes since plan created
- [ ] Test all demo commands
- [ ] Prepare backup screenshots
- [ ] Increase font sizes

### During

- [ ] Start with the hook
- [ ] Pause after each section
- [ ] Run demos from clean state

---

## Appendix: Slide Outline

1. Title slide - {project name}
2. {Section 1 slide}
3. {Section 2 slide}
   ...

---

_Plan created: {date}_
_Based on: {codebase path}_
_Ready for slide generation: [ ]_

````

---

## Phase 4: Review Plan with User

1. **Present the plan summary** to the user
2. **Highlight key decisions**:
   - Sections included
   - Diagrams planned
   - Code examples selected
3. **Ask for feedback**:
   "Does this plan capture what you want? Any sections to add, remove, or adjust?"
4. **Iterate** on the plan until approved
5. **Save the final plan**

---

## Phase 5: Generate Slides from Plan

Once the plan is approved:

1. Read the plan document
2. Generate `slides.md` following the plan structure
3. Create all diagrams specified in the plan
4. Include all code examples from the plan
5. Add presenter notes from the plan

### Output Files

```text
{project-name}-presentation/
├── {project-name}-presentation-plan.md  # The plan (presenter reference)
└── slides.md                             # The slides
````

### Final Instructions

```text
Created:
- Plan: {project-name}-presentation-plan.md
- Slides: slides.md ({N} slides)

Preview: npx slidev slides.md

The plan document serves as your presenter notes!
```
