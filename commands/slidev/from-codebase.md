---
description: Analyze a codebase and interactively build a presentation about it
argument-hint: "[path] optional path to analyze (default: current directory)"
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, Task, AskUserQuestion
---

# Generate Presentation from Codebase Analysis

Analyze the codebase and create a tailored technical presentation.

**Target path**: $ARGUMENTS (default: current directory)

## Phase 1: Codebase Discovery

First, explore and understand the project:

1. **Identify project type and stack**:
   - Check for `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, etc.
   - Identify frameworks (React, Next.js, Django, FastAPI, etc.)
   - Note key dependencies and their purposes

2. **Map the architecture**:
   - Directory structure and organization patterns
   - Entry points and main modules
   - API routes/endpoints if applicable
   - Database models/schemas
   - Configuration and environment setup

3. **Find notable patterns**:
   - Design patterns used (MVC, hexagonal, etc.)
   - Testing approach and coverage
   - CI/CD configuration
   - Documentation quality

4. **Identify interesting code**:
   - Core business logic locations
   - Complex algorithms or clever solutions
   - Integration points with external services

## Phase 2: Interactive Discovery

**Ask the user these questions** using AskUserQuestion:

### Question 1: Audience

"Who is the target audience for this presentation?"

- **Options**:
  - New team members (onboarding)
  - Technical leadership (architecture review)
  - External developers (open source/API consumers)
  - Non-technical stakeholders (high-level overview)

### Question 2: Focus Areas

"Which aspects of the codebase should we focus on?" (multi-select)

- **Options**:
  - Architecture & design patterns
  - Key features & functionality
  - API design & endpoints
  - Data models & database schema
  - Testing strategy
  - DevOps & deployment
  - Performance considerations
  - Security measures

### Question 3: Depth Level

"How deep should the technical content go?"

- **Options**:
  - High-level overview (concepts, no code)
  - Moderate depth (key code snippets, diagrams)
  - Deep dive (detailed code walkthrough, internals)

### Question 4: Presentation Length

"How long should this presentation be?"

- **Options**:
  - Lightning talk (5-10 slides, ~10 min)
  - Standard talk (15-20 slides, ~30 min)
  - Deep dive (25-35 slides, ~45-60 min)

### Question 5: Special Requests (optional)

"Any specific components, features, or aspects you want highlighted?"

- Free-form text input

## Phase 3: Generate Presentation

Based on the analysis and user answers, create a `slides.md` file:

1. **Structure the presentation** according to audience and depth:

   **For onboarding**:
   - Project overview and purpose
   - Getting started guide
   - Key directories and files to know
   - Development workflow
   - Where to find help

   **For architecture review**:
   - System context diagram
   - Component architecture
   - Data flow patterns
   - Key design decisions
   - Technical debt and roadmap

   **For API consumers**:
   - API overview and authentication
   - Key endpoints with examples
   - Request/response formats
   - Error handling
   - SDK/client usage

   **For stakeholders**:
   - What the system does
   - Key capabilities
   - Technology choices (simplified)
   - Team structure
   - Metrics and health

2. **Include appropriate visuals**:
   - Mermaid architecture diagrams
   - Code snippets with highlighting
   - Directory tree structures
   - Sequence diagrams for flows

3. **Add presenter notes** with:
   - Key talking points
   - Common questions to anticipate
   - Demo suggestions if applicable

## Phase 4: Review and Refine

1. **Show the generated outline** to the user before writing full content
2. **Ask if any sections should be added, removed, or reordered**
3. **Generate the final `slides.md`** file
4. **Provide next steps**:

   ```bash
   npx slidev slides.md  # Preview the presentation
   ```

## Output Location

Save as `slides.md` in the current directory, or if a project name is clear, save as `{project-name}-presentation/slides.md`.
