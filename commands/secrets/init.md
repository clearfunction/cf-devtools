---
description: Set up 1Password + direnv for secure secret management in current project
argument-hint: "[account] e.g., 'mycompany.1password.com' (optional)"
allowed-tools: Read, Write, Glob, Bash, AskUserQuestion
---

# Initialize 1Password + direnv Secret Management

Set up secure secret management using 1Password CLI with direnv.

## Phase 1: Check Prerequisites

1. **Verify 1Password CLI is installed**:

   ```bash
   op --version
   ```

   If not installed, inform user:

   ```bash
   brew install --cask 1password-cli
   ```

2. **Verify direnv is installed**:

   ```bash
   direnv --version
   ```

   If not installed, inform user:

   ```bash
   brew install direnv
   echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc  # or ~/.bashrc
   ```

3. **Check if 1Password is signed in**:

   ```bash
   op account list
   ```

   If no accounts, inform user to sign in:

   ```bash
   op signin --account=yourcompany.1password.com
   ```

## Phase 2: Gather Configuration

Use AskUserQuestion to collect:

**Q1: 1Password Account**
"What is your 1Password account domain?"

- Default from $ARGUMENTS if provided
- Example: `mycompany.1password.com`

**Q2: Vault Name**
"Which vault contains your secrets?"

- Default: `Development` or `Private`
- User can specify custom vault

**Q3: Initial Secrets** (optional)
"What environment variables do you need? (comma-separated)"

- Example: `DATABASE_URL, API_KEY, AWS_ACCESS_KEY_ID`
- Can be empty - user can add later

## Phase 3: Create Files

### 1. Create `.env.op`

```bash
# 1Password Secret References
# Safe to commit - contains only op:// pointers, not actual secrets
#
# Format: VAR_NAME="op://Vault/Item/Field"
# Example: DATABASE_URL="op://Development/PostgreSQL/connection-string"

# Add your secret references below:
```

If user provided initial secrets, add placeholder entries:

```bash
DATABASE_URL="op://Vault/Item/Field"  # TODO: Update with actual 1Password path
API_KEY="op://Vault/Item/Field"       # TODO: Update with actual 1Password path
```

### 2. Create `.envrc`

```bash
# Load secrets from 1Password using direnv
# This file is gitignored - contains account-specific configuration

direnv_load op run --env-file=.env.op --no-masking \
  --account=ACCOUNT_DOMAIN -- direnv dump
```

Replace `ACCOUNT_DOMAIN` with the user's account.

### 3. Update `.gitignore`

Check if `.gitignore` exists. If so, append (if not already present):

```text
# 1Password + direnv
.envrc
.direnv/
.env
.env.local
```

If no `.gitignore`, create one with these entries.

## Phase 4: Finalize Setup

1. **Run direnv allow**:

   ```bash
   direnv allow
   ```

2. **Provide usage instructions**:

   ```text
   Setup complete!

   Files created:
   - .env.op     (safe to commit - add your op:// references here)
   - .envrc      (gitignored - loads secrets via 1Password)
   - .gitignore  (updated with direnv entries)

   Next steps:
   1. Edit .env.op to add your secret references:
      DATABASE_URL="op://Development/MyApp/database-url"

   2. Test a secret resolves:
      op read "op://Development/MyApp/database-url"

   3. Reload the environment:
      direnv allow

   4. Verify secrets loaded:
      echo $DATABASE_URL

   To migrate an existing .env file, run:
      /secrets:migrate
   ```

## Reference

See the `1password-direnv-secrets` skill for detailed documentation on:

- The `op run` pattern and why it's faster
- Troubleshooting common issues
- Alternative approaches (`op inject`)
