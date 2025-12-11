---
name: 1password-direnv-secrets
description: Use when setting up 1Password CLI with direnv for automatic secret loading, or when secrets load slowly (>2 seconds) - provides the fast op-run pattern instead of slow multiple op-read calls
---

# 1Password + direnv Secret Management

Load secrets automatically from 1Password when entering a directory, using the fast single-invocation pattern.

## Core Pattern

**Use `op run --env-file` NOT multiple `op read` calls.**

| Approach           | CLI Invocations    | Load Time  |
| ------------------ | ------------------ | ---------- |
| Multiple `op read` | N (one per secret) | ~5 seconds |
| Single `op run`    | 1                  | ~1 second  |

## File Structure

```text
project/
  .env.op    # Template with op:// references (SAFE TO COMMIT)
  .envrc     # direnv config (gitignored)
  .gitignore # Excludes .envrc
```

## Implementation

### 1. Create `.env.op` (commit this)

```bash
# .env.op - Secret references only, no actual secrets
AWS_ACCESS_KEY_ID="op://VaultName/ItemName/AWS Access Key ID"
AWS_SECRET_ACCESS_KEY="op://VaultName/ItemName/AWS Secret Access Key"
DB_HOST="op://VaultName/ItemName/Database Host"
DB_PASSWORD="op://VaultName/ItemName/Database Password"
```

### 2. Create `.envrc` (gitignored)

```bash
# .envrc - The magic one-liner
direnv_load op run \
  --env-file=.env.op \
  --no-masking \
  --account=yourcompany.1password.com \
  -- direnv dump
```

### 3. Update `.gitignore`

```gitignore
.envrc
.direnv/
```

### 4. Enable

```bash
direnv allow
```

## What's Safe to Commit?

| File                       | Contains                   | Safe to Commit? |
| -------------------------- | -------------------------- | --------------- |
| `.env.op`                  | `op://` references only    | **Yes**         |
| `.envrc`                   | Account name, direnv logic | No (gitignored) |
| `.env` with actual secrets | Real credentials           | **Never**       |

**Key insight**: `op://vault/item/field` references are NOT secrets - they're just pointers. Safe to commit.

## Adding New Secrets

1. Add field in 1Password item
2. Add reference to `.env.op`:

   ```bash
   NEW_VAR="op://VaultName/ItemName/New Field"
   ```

3. Re-enter directory: `cd .. && cd -`

## Common Mistakes

| Mistake                            | Fix                                   |
| ---------------------------------- | ------------------------------------- |
| Multiple `op read` calls           | Use `op run --env-file` pattern       |
| Putting op:// refs in `.envrc`     | Use separate `.env.op` template       |
| Thinking op:// refs are secrets    | They're safe references, commit them  |
| Creating `.envrc.example` template | Use `.env.op` as the template instead |

## Troubleshooting

```bash
# Verify 1Password CLI
op --version

# Sign in
op signin --account=yourcompany.1password.com

# Test single reference
op read "op://VaultName/ItemName/FieldName" --account=yourcompany.1password.com

# Allow direnv
direnv allow

# Force reload
direnv reload
```

## References

- [1Password: Load secrets into environment](https://developer.1password.com/docs/cli/secrets-environment-variables/)
- [1Password: Secret reference syntax](https://developer.1password.com/docs/cli/secret-references/)
- [direnv stdlib: direnv_load](https://direnv.net/man/direnv-stdlib.1.html)
