# Clear Function Claude Skills

Production-ready Claude Code skills for presentations, documentation, and developer workflows.

## Installation

### Claude Code (CLI)

```bash
# Add from marketplace
/plugin marketplace add clearfunction/clearfunction-claude-skills

# Install the plugin
/plugin install clearfunction-skills@clearfunction-claude-skills
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/clearfunction/clearfunction-claude-skills.git

# Add as local plugin
/plugin add /path/to/clearfunction-claude-skills
```

## Available Skills

### slidev-presentations

Generate browser-based presentations using [Slidev](https://sli.dev/) - the presentation framework for developers.

**Features:**

- Markdown-based slide generation
- Vue component support
- Code syntax highlighting with live execution
- Presenter mode with notes
- Export to PDF/PNG

**Usage:** Claude automatically activates this skill when you request presentation creation.

```text
Create a technical presentation about Kubernetes architecture for a DevOps team
```

## Recommended Workflow

Follow the **plan-first approach** for quality presentations:

```text
Context → Plan → Review → Slides
```

| Scenario                     | Commands                             | Output        |
| ---------------------------- | ------------------------------------ | ------------- |
| Topic-based presentation     | `/slidev:plan` → `/slidev:from-plan` | Plan + Slides |
| Codebase presentation        | `/slidev:from-codebase`              | Plan + Slides |
| Quick slides (skip planning) | `/slidev:new`                        | Slides only   |

## Slash Commands

### `/slidev:plan [topic]`

Create a detailed presentation plan before generating slides. Asks questions about audience, duration, format, and content focus.

```text
/slidev:plan React hooks deep dive
/slidev:plan our Q4 engineering roadmap
```

**Output:** `{topic}-presentation-plan.md` with:

- Time allocation table
- Section outlines with talking points
- Diagrams and code examples to include
- Demo plan with backup options
- Q&A preparation

### `/slidev:from-plan [plan-file]`

Generate slides from an approved presentation plan.

```text
/slidev:from-plan react-hooks-presentation-plan.md
```

### `/slidev:from-codebase [path]`

**Full workflow** - Analyzes your codebase, asks targeted questions, creates a plan, then generates slides.

```text
/slidev:from-codebase
/slidev:from-codebase ./packages/api
```

Questions asked:

- Duration (lightning to deep dive)
- Audience (peers, leadership, external, onboarding)
- Format (lecture, demo-heavy, workshop)
- Focus areas (architecture, features, API, testing, DevOps)
- Core message and call to action

### `/slidev:new [topic]`

Quick-start a presentation without planning phase (for simple presentations).

```text
/slidev:new React hooks for beginners
/slidev:new our new authentication system
```

### `/slidev:export [format]`

Export presentation to PDF, PNG, or PPTX.

```text
/slidev:export           # PDF (default)
/slidev:export pptx      # PowerPoint
/slidev:export png       # Images
```

### `/slidev:add [layout]`

Add a specific slide type to an existing presentation.

```text
/slidev:add two-cols
/slidev:add architecture
/slidev:add code-comparison
```

## Project Structure

```text
clearfunction-claude-skills/
├── .claude-plugin/
│   ├── plugin.json        # Plugin manifest
│   └── marketplace.json   # Marketplace metadata
├── skills/
│   └── slidev-presentations/
│       ├── SKILL.md       # Skill definition
│       ├── references/    # Syntax documentation
│       └── assets/        # Example presentations
├── commands/
│   └── slidev/            # Slidev slash commands
│       ├── plan.md        # /slidev:plan (create plan)
│       ├── from-plan.md   # /slidev:from-plan (slides from plan)
│       ├── from-codebase.md  # /slidev:from-codebase (full workflow)
│       ├── new.md         # /slidev:new (quick slides)
│       ├── export.md      # /slidev:export
│       └── add.md         # /slidev:add
├── agents/                # Future: Custom agents
└── docs/                  # Documentation
```

## Skill Development

Each skill follows the [Anthropic Skills specification](https://github.com/anthropics/skills):

1. Create a directory under `skills/`
2. Add a `SKILL.md` with YAML frontmatter
3. Include any reference materials in `references/`
4. Test thoroughly before committing

See [docs/contributing.md](docs/contributing.md) for detailed guidelines.

## Roadmap

- [x] slidev-presentations - Browser-based presentations
- [ ] mermaid-diagrams - Architecture and flow diagrams
- [ ] adr-generator - Architecture Decision Records
- [ ] changelog-writer - Conventional changelog generation
- [ ] api-docs - OpenAPI documentation generation

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.

## Contributing

Contributions welcome! Please read [docs/contributing.md](docs/contributing.md) first.

---

Built by [Clear Function](https://clearfunction.com)
