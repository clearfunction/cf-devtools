---
description: Convert existing .env file to .env.op format with 1Password references
argument-hint: "[env-file] e.g., '.env' or '.env.local' (default: .env)"
allowed-tools: Read, Write, Glob, Bash, AskUserQuestion
---

# Migrate .env to 1Password References

Convert an existing `.env` file to `.env.op` format, replacing secret values with `op://` references.

## Phase 1: Locate and Read .env File

1. **Find the .env file**:
   - Use `$ARGUMENTS` if provided (e.g., `.env.local`)
   - Default to `.env` in current directory
   - Search for common variants: `.env`, `.env.local`, `.env.development`

2. **Read and parse the file**:
   - Extract all `KEY=value` pairs
   - Identify which values look like secrets vs. static config
   - Preserve comments and structure

## Phase 2: Classify Variables

Categorize each variable:

### Likely Secrets (need op:// references)

Patterns that indicate secrets:

- `*_KEY`, `*_SECRET`, `*_TOKEN`, `*_PASSWORD`
- `*_API_KEY`, `*_ACCESS_KEY`, `*_PRIVATE_KEY`
- `DATABASE_URL`, `REDIS_URL`, `*_CONNECTION_STRING`
- Values that look like tokens (long alphanumeric strings)
- Values containing `://` with credentials

### Likely Static Config (keep as-is)

Patterns that indicate non-secrets:

- `*_HOST`, `*_PORT`, `*_URL` (without credentials)
- `NODE_ENV`, `DEBUG`, `LOG_LEVEL`
- `true`, `false`, numeric values
- `localhost`, `127.0.0.1`

## Phase 3: Gather 1Password Mapping

Use AskUserQuestion to collect:

**Q1: 1Password Account**
"What is your 1Password account domain?"

- Example: `mycompany.1password.com`

**Q2: Default Vault**
"Which vault should store these secrets?"

- Example: `Development`, `Production`, `Shared`

**Q3: Item Name**
"What should the 1Password item be named?"

- Suggest: Project name or `{project}-secrets`
- Example: `myapp-development`

## Phase 4: Generate .env.op

Create `.env.op` with:

1. **Header comment** explaining the file
2. **Secret references** using op:// format
3. **Static values** preserved as-is
4. **Original comments** preserved

### Example Transformation

**Input (.env):**

```bash
# Database
DATABASE_URL=postgres://user:secretpass@localhost:5432/mydb
DB_HOST=localhost
DB_PORT=5432

# API Keys
STRIPE_SECRET_KEY=sk_live_abc123xyz
SENDGRID_API_KEY=SG.xxxxxxxxxxxx

# Config
NODE_ENV=development
DEBUG=true
```

**Output (.env.op):**

```bash
# 1Password Secret References
# Migrated from .env - safe to commit
# Account: mycompany.1password.com
# Vault: Development
# Item: myapp-development

# Database
DATABASE_URL="op://Development/myapp-development/DATABASE_URL"
DB_HOST=localhost
DB_PORT=5432

# API Keys
STRIPE_SECRET_KEY="op://Development/myapp-development/STRIPE_SECRET_KEY"
SENDGRID_API_KEY="op://Development/myapp-development/SENDGRID_API_KEY"

# Config
NODE_ENV=development
DEBUG=true
```

## Phase 5: Create 1Password Item

Provide instructions to create the 1Password item:

```text
Migration complete!

Created: .env.op (with op:// references)

IMPORTANT: You must create the 1Password item with your secrets.

Option A - Manual (via 1Password app):
1. Open 1Password → Select "Development" vault
2. Create new "Secure Note" or "Login" item named "myapp-development"
3. Add these fields with your secret values:
   - DATABASE_URL: postgres://user:secretpass@localhost:5432/mydb
   - STRIPE_SECRET_KEY: sk_live_abc123xyz
   - SENDGRID_API_KEY: SG.xxxxxxxxxxxx

Option B - CLI (faster):
op item create \
  --vault="Development" \
  --category="Secure Note" \
  --title="myapp-development" \
  "DATABASE_URL=postgres://user:secretpass@localhost:5432/mydb" \
  "STRIPE_SECRET_KEY=sk_live_abc123xyz" \
  "SENDGRID_API_KEY=SG.xxxxxxxxxxxx"

After creating the item:
1. Delete your old .env file (it contains secrets!)
2. Run: direnv allow
3. Verify: echo $DATABASE_URL
```

## Phase 6: Safety Checklist

Before finishing, remind user:

```text
Security Checklist:
[ ] 1Password item created with all secrets
[ ] .env.op contains only op:// references (no real secrets)
[ ] Original .env is deleted or moved
[ ] .env is in .gitignore
[ ] direnv allow has been run
[ ] Secrets load correctly (test with: echo $VAR_NAME)

WARNING: Do not commit your original .env file!
If it was previously committed, consider rotating those secrets.
```

## Reference

See the `1password-direnv-secrets` skill for:

- Troubleshooting resolution errors
- The `op run` performance pattern
- What's safe to commit
