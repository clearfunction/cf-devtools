# CF DevTools

> Production-ready Claude Code skills by [Clear Function](https://clearfunction.com) - 10 years building secure, compliant software for fintech and healthcare.

**200+ solutions delivered | SOC 2 Certified | 5/5 Clutch Rating**

Developer workflows for presentations, secrets management, and documentation - battle-tested in enterprise.

## Installation

### Claude Code (CLI)

```bash
# Add the marketplace
/plugin marketplace add clearfunction/cf-devtools

# Install the plugin
/plugin install cf-devtools@cf-devtools
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/clearfunction/cf-devtools.git

# Add as local plugin
/plugin add /path/to/cf-devtools
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

### 1password-direnv-secrets

Configure 1Password CLI with direnv for fast, secure secret loading in development environments.

**Features:**

- Single `op run` pattern (5x faster than multiple `op read` calls)
- Secure `.env.op` files (safe to commit - contains only `op://` references)
- Automatic secret resolution on directory entry
- Works with any 1Password vault

**Usage:** Claude automatically activates when you need 1Password + direnv setup.

```text
Set up 1Password with direnv for my project's environment variables
```

## Recommended Workflow

Follow the **plan-first approach** for quality presentations:

```text
Context -> Plan -> Review -> Slides
```

| Scenario                     | Commands                              | Output        |
| ---------------------------- | ------------------------------------- | ------------- |
| Topic-based presentation     | `/slidev:plan` -> `/slidev:from-plan` | Plan + Slides |
| Codebase presentation        | `/slidev:from-codebase`               | Plan + Slides |
| Quick slides (skip planning) | `/slidev:new`                         | Slides only   |

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

### `/secrets:init [account]`

Set up 1Password + direnv for secure secret management in your project.

```text
/secrets:init
/secrets:init mycompany.1password.com
```

**Creates:**

- `.env.op` - Secret references (safe to commit)
- `.envrc` - direnv loader (gitignored)
- Updates `.gitignore` with direnv entries

### `/secrets:migrate [env-file]`

Convert an existing `.env` file to `.env.op` format with 1Password references.

```text
/secrets:migrate
/secrets:migrate .env.local
```

**Features:**

- Automatically classifies secrets vs. static config
- Preserves comments and structure
- Generates CLI command to create 1Password item
- Provides security checklist

## Project Structure

```text
cf-devtools/
├── .claude-plugin/
│   ├── plugin.json        # Plugin manifest
│   └── marketplace.json   # Marketplace metadata
├── skills/
│   ├── slidev-presentations/
│   │   ├── SKILL.md       # Skill definition
│   │   ├── references/    # Syntax documentation
│   │   └── assets/        # Example presentations
│   └── 1password-direnv-secrets/
│       └── SKILL.md       # Skill definition
├── commands/
│   ├── slidev/            # Slidev slash commands
│   │   ├── plan.md        # /slidev:plan
│   │   ├── from-plan.md   # /slidev:from-plan
│   │   ├── from-codebase.md  # /slidev:from-codebase
│   │   ├── new.md         # /slidev:new
│   │   ├── export.md      # /slidev:export
│   │   └── add.md         # /slidev:add
│   └── secrets/           # Secrets management commands
│       ├── init.md        # /secrets:init
│       └── migrate.md     # /secrets:migrate
├── agents/                # Custom agents (future)
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
- [x] 1password-direnv-secrets - Fast secret loading
- [ ] mermaid-diagrams - Architecture and flow diagrams
- [ ] adr-generator - Architecture Decision Records
- [ ] changelog-writer - Conventional changelog generation
- [ ] api-docs - OpenAPI documentation generation

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.

## Contributing

Contributions welcome! Please read [docs/contributing.md](docs/contributing.md) first.

---

Built by [Clear Function](https://clearfunction.com) | [AI Strategy & Implementation](https://clearfunction.com) | Memphis, TN
