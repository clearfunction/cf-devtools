# CF DevTools - Development Guidelines

## Project Overview

**WHAT:** Claude Code plugin with 2 skills (slidev-presentations, 1password-direnv-secrets) and 8 slash commands.

**WHY:** Production-ready developer workflows for Clear Function's enterprise clients - presentations and secrets management.

**HOW:** Skills in `skills/`, commands in `commands/`. Test locally before committing.

## Quick Commands

```bash
# Install locally for testing
/plugin add /path/to/cf-devtools

# Verify plugin structure
ls -la .claude-plugin/
cat .claude-plugin/plugin.json | jq .

# Test a skill activates (in Claude Code)
"Create a presentation about React hooks"      # Should trigger slidev-presentations
"Set up 1Password with direnv"                 # Should trigger 1password-direnv-secrets

# Test a command works
/slidev:new test topic
/secrets:init

# Validate before commit
find skills -name "SKILL.md" -exec head -10 {} \;  # Check frontmatter
wc -l skills/*/SKILL.md                            # Check line counts (<500)
```

## Skill Authoring Best Practices

When creating or modifying skills in this repository, follow these guidelines based on [Anthropic's official skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).

### The Golden Rule: Progressive Disclosure

**SKILL.md is a table of contents, not the encyclopedia.**

Skills use progressive disclosure - showing just enough information for Claude to decide what to do next, then revealing details as needed. This means:

- SKILL.md provides an overview and navigation
- Detailed content lives in separate reference files
- Claude loads files only when needed, saving context tokens

```text
skill-name/
├── SKILL.md              # Overview + navigation (keep under 500 lines)
├── references/
│   ├── detailed-guide.md # Comprehensive documentation
│   ├── api-reference.md  # API details
│   └── examples.md       # Input/output examples
└── scripts/              # Executable utilities
```

### Size Limits (Official Specification)

| Field             | Limit           | Notes                                                      |
| ----------------- | --------------- | ---------------------------------------------------------- |
| `name`            | 64 characters   | Lowercase, numbers, hyphens only                           |
| `description`     | 1024 characters | Critical for discovery - Claude uses this to choose skills |
| **SKILL.md body** | **500 lines**   | NOT characters - split into reference files if longer      |

### Writing Effective Descriptions

The `description` field determines when your skill activates. Write in **third person** - never "Use when" or "I can help".

**Good:**

```yaml
description: Configures 1Password CLI with direnv for fast secret loading. Activates for: 1Password setup, slow secrets, .env.op files, op:// references.
```

**Bad:**

```yaml
description: Use when you need to set up 1Password  # Second person - causes discovery problems
description: Helps with secrets                      # Too vague
```

### Naming Convention

Use **gerund form** (verb + -ing) for skill names:

- `processing-pdfs`
- `generating-presentations`
- `managing-secrets`

Avoid: `helper`, `utils`, `tools`, `documents`

### SKILL.md Structure Template

```markdown
---
name: your-skill-name
description: Third-person description of what skill does. Activates for: trigger1, trigger2, trigger3. Not for: anti-trigger1.
---

# Skill Title

Brief overview (1-2 sentences).

## When to Use

- Trigger scenario 1
- Trigger scenario 2

## Quick Start

Minimal example to get started.

## Detailed Documentation

- **Feature A**: See [references/feature-a.md](references/feature-a.md)
- **API Reference**: See [references/api.md](references/api.md)
- **Examples**: See [references/examples.md](references/examples.md)
```

### Reference Files Best Practices

1. **One level deep** - All references link directly from SKILL.md (no nested references)
2. **Include table of contents** - For files over 100 lines, add a TOC at the top
3. **Descriptive names** - Use `form-validation-rules.md` not `doc2.md`
4. **Domain separation** - Split by feature/domain so Claude loads only what's needed

### Conciseness Guidelines

**Only add context Claude doesn't already have.** Challenge each section:

- "Does Claude really need this explanation?"
- "Can I assume Claude knows this?"
- "Does this paragraph justify its token cost?"

**Good (50 tokens):**

````markdown
## Extract PDF text
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
````

**Bad (150 tokens):**

```markdown
## Extract PDF text
PDF (Portable Document Format) files are a common file format that contains text, images...
First, you'll need to install it using pip. Then you can use the code below...
```

### Testing Requirements

Before submitting a skill:

- [ ] Test activation with prompts that SHOULD trigger it
- [ ] Test with prompts that should NOT trigger it
- [ ] Test with Claude Haiku (needs more guidance)
- [ ] Test with Claude Sonnet (balanced)
- [ ] Test with Claude Opus (avoid over-explaining)

### Anti-Patterns to Avoid

| Anti-Pattern             | Why It's Bad                             | Fix                                    |
| ------------------------ | ---------------------------------------- | -------------------------------------- |
| Deeply nested references | Claude may partially read files          | Keep references one level deep         |
| Time-sensitive info      | "After August 2025..." becomes wrong     | Use "old patterns" sections            |
| Multiple library options | "Use pypdf or pdfplumber or..." confuses | Provide one default with escape hatch  |
| Windows paths            | `scripts\helper.py` fails on Unix        | Always use forward slashes             |
| Vague descriptions       | "Helps with documents"                   | Be specific: "Extracts text from PDFs" |

## Project-Specific Guidelines

### File Organization

```text
skills/
└── skill-name/
    ├── SKILL.md           # Required: Keep under 500 lines
    ├── references/        # Detailed documentation
    ├── scripts/           # Executable helpers
    └── assets/            # Examples, templates
commands/
└── skill-name/            # Slash commands (optional)
```

### Validation Checklist

Before committing any skill changes:

- [ ] YAML frontmatter is valid
- [ ] `name` matches directory name (lowercase + hyphens)
- [ ] `description` is third person and specific
- [ ] SKILL.md body is under 500 lines
- [ ] Detailed content is in `references/` directory
- [ ] References are one level deep (no nesting)
- [ ] Examples show concrete input/output pairs

## Resources

- [Official Skill Authoring Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Contributing Guide](./docs/contributing.md)
