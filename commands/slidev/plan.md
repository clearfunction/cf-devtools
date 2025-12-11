---
description: Create a detailed presentation plan before generating slides
argument-hint: "[topic] e.g., 'React hooks' or 'our authentication system'"
allowed-tools: Read, Write, Glob, Grep, Task, AskUserQuestion
---

# Create Presentation Plan

Create a detailed presentation plan for: **$ARGUMENTS**

This plan document serves as the blueprint for slide generation and presenter notes.

## Phase 1: Gather Context

### Question Set 1: Presentation Basics

Use AskUserQuestion to gather:

**Q1: Duration**
"How long is this presentation?"

- Lightning talk (5-10 minutes)
- Short talk (15-20 minutes)
- Standard talk (30 minutes)
- Deep dive (45-60 minutes)

**Q2: Audience**
"Who is the target audience?"

- Technical peers (same expertise level)
- Mixed technical (varied expertise)
- Leadership/stakeholders (high-level focus)
- New team members (onboarding/educational)
- External/clients (pitch or demo)

**Q3: Format**
"What's the presentation format?"

- Lecture/talk (slides + speaking)
- Demo-heavy (live coding/walkthrough)
- Workshop (hands-on exercises)
- Discussion/Q&A heavy

**Q4: Context**
"What's the venue/occasion?"

- Team meeting (internal, informal)
- Company all-hands (internal, formal)
- Conference talk (external, formal)
- Client presentation (external, sales/demo)
- Training session (educational)

### Question Set 2: Content Strategy

**Q5: Core Message**
"What's the ONE thing you want the audience to remember?"

- Free text input

**Q6: Call to Action**
"What should the audience DO after this presentation?"

- Free text input

**Q7: Key Topics** (multi-select if applicable)
"What topics must be covered?"

- Free text input (list the must-haves)

**Q8: Exclusions**
"Anything to explicitly AVOID or skip?"

- Free text input (optional)

### Question Set 3: Technical Depth

**Q9: Code Examples**
"How much code should appear in slides?"

- Minimal (concepts only, pseudocode)
- Moderate (key snippets, highlighted lines)
- Heavy (full examples, walkthroughs)

**Q10: Live Demo**
"Will there be live demonstrations?"

- No live demo (slides/screenshots only)
- Brief demo (1-2 quick demos)
- Demo-heavy (significant live portions)

## Phase 2: Generate Plan Document

Create a file named `{topic}-presentation-plan.md` with this structure:

```markdown
# {Title} - Presentation Plan

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

## Time Allocation

| Section | Time | Focus |
|---------|------|-------|
| 1. Opening Hook | X min | Grab attention |
| 2. Context/Problem | X min | Why this matters |
| 3. Main Content | X min | Core material |
| 4. Demo/Examples | X min | Show, don't tell |
| 5. Wrap-up | X min | Key takeaways |

---

## Section 1: Opening Hook ({X} min)

### Hook Options

**Option A - Problem Statement:**
> "{A compelling problem statement}"

**Option B - Story:**
> "{A relatable story or scenario}"

**Option C - Statistic:**
> "{A surprising fact or number}"

### Context to Establish
- {Point 1}
- {Point 2}

---

## Section 2: {Section Name} ({X} min)

### Key Points
- {Point 1}
- {Point 2}

### Visuals Needed
- [ ] {Diagram: description}
- [ ] {Code example: description}
- [ ] {Screenshot: description}

### Talking Points
- {Note for presenter}

---

## Section 3: {Continue for each section...}

---

## Demo Plan (if applicable)

### Demo Option A: {Name}
- What to show: {description}
- Commands/steps: {list}
- Fallback if fails: {backup plan}

### Demo Backup Plan
- Screenshots prepared: [ ]
- Recording available: [ ]
- Explanation script: [ ]

---

## Diagrams to Create

1. **{Diagram Name}** - {Purpose}
   - Type: {Mermaid flowchart/sequence/architecture}
   - Key elements: {list}

2. **{Diagram Name}** - {Purpose}
   ...

---

## Code Examples to Include

1. **{Example Name}** ({language})
   - Purpose: {what it demonstrates}
   - Lines to highlight: {which parts}
   - Progressive reveal: {yes/no}

---

## Potential Q&A

### Anticipated Questions

1. **"{Question}?"**
   - Answer: {response}

2. **"{Question}?"**
   - Answer: {response}

---

## Presenter Checklist

### Before Presentation
- [ ] Run through entire presentation
- [ ] Test all demos
- [ ] Prepare backup screenshots
- [ ] Increase font sizes
- [ ] Close unnecessary apps

### During Presentation
- [ ] Start with the hook, not introductions
- [ ] Pause after each major section
- [ ] Make eye contact
- [ ] Speak slower than normal

---

## Appendix: Slide Outline

1. Title slide
2. {Slide 2 title}
3. {Slide 3 title}
...

---

_Plan created: {date}_
_Ready for slide generation: [ ]_
```

## Phase 3: Review and Iterate

1. **Present the plan** to the user
2. **Ask for feedback**: "Does this plan capture what you want? Any sections to add, remove, or adjust?"
3. **Iterate** until the user approves
4. **Mark as ready**: Update the "Ready for slide generation" checkbox

## Output

Save as `{topic-slug}-presentation-plan.md` in the current directory.

Inform the user:

```text
Plan created: {filename}

Review the plan and make any edits. When ready, run:
/slidev:from-plan {filename}
```
