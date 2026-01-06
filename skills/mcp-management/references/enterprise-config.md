# Enterprise MCP Configuration

Managed policies for organizational MCP server control.

## Table of Contents

- [Deployment Options](#deployment-options)
- [Managed MCP Configuration](#managed-mcp-configuration)
- [Allowlist/Denylist Policies](#allowlistdenylist-policies)
- [Policy Examples](#policy-examples)
- [Deployment via MDM](#deployment-via-mdm)
- [Auditing](#auditing)

---

## Deployment Options

| Approach           | Control Level             | User Flexibility    |
|--------------------|---------------------------|---------------------|
| **Managed config** | Full (fixed servers)      | None                |
| **Allowlist**      | High (approved only)      | Limited to approved |
| **Denylist**       | Moderate (block specific) | High except blocked |
| **None**           | None                      | Full                |

---

## Managed MCP Configuration

Deploy a fixed set of servers users cannot modify.

### System Paths (require admin)

| Platform  | Path                                                       |
|-----------|------------------------------------------------------------|
| macOS     | `/Library/Application Support/ClaudeCode/managed-mcp.json` |
| Linux/WSL | `/etc/claude-code/managed-mcp.json`                        |
| Windows   | `C:\Program Files\ClaudeCode\managed-mcp.json`             |

### Example Configuration

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"],
      "env": {
        "COMPANY_API_URL": "https://internal.company.com"
      }
    },
    "approved-db": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${COMPANY_DB_URL}"
      }
    }
  }
}
```

---

## Allowlist/Denylist Policies

Control which servers users can add within policy constraints.

### Policy Location

Same system paths as managed config, or via MDM deployment.

### Policy Structure

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverCommand": ["npx", "-y", "@approved/package"] },
    { "serverUrl": "https://mcp.company.com/*" }
  ],
  "deniedMcpServers": [
    { "serverName": "dangerous-server" },
    { "serverUrl": "https://*.untrusted.com/*" }
  ]
}
```

### Matching Rules

**Name matching** (`serverName`):

- Matches the server's configured name
- Works for both stdio and HTTP servers

**Command matching** (`serverCommand`):

- Exact array match required (order matters)
- Only applies to stdio servers
- `["npx", "-y", "package"]` does not equal `["npx", "package"]`

**URL matching** (`serverUrl`):

- Wildcard `*` matches any characters
- Only applies to HTTP/SSE servers
- `https://*.company.com/*` matches subdomains

### Behavior

| Allowlist | Denylist  | Result                  |
|-----------|-----------|-------------------------|
| undefined | undefined | All allowed             |
| `[]`      | undefined | All blocked             |
| entries   | undefined | Only matching allowed   |
| undefined | entries   | Matching blocked        |
| entries   | entries   | Denylist wins conflicts |

**Critical**: Denylist takes absolute precedence.

---

## Policy Examples

### Restrictive: Only Approved Servers

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverName": "context7" },
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-postgres"] },
    { "serverUrl": "https://mcp.company.com/*" }
  ]
}
```

### Moderate: Block Known Risks

```json
{
  "deniedMcpServers": [
    { "serverCommand": ["npx", "-y", "malicious-package"] },
    { "serverUrl": "https://*.sketchy-domain.com/*" },
    { "serverName": "known-vulnerable-server" }
  ]
}
```

### Enterprise: Internal Only + Approved External

```json
{
  "allowedMcpServers": [
    { "serverUrl": "https://*.internal.company.com/*" },
    { "serverUrl": "https://api.githubcopilot.com/*" },
    { "serverUrl": "https://mcp.notion.com/*" },
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-*"] }
  ],
  "deniedMcpServers": [
    { "serverUrl": "https://*.external.com/*" }
  ]
}
```

### Complete Lockdown

```json
{
  "allowedMcpServers": []
}
```

Users cannot add any servers; only managed-mcp.json servers available.

---

## Deployment via MDM

### Jamf (macOS)

1. Create configuration profile
2. Add custom settings payload
3. Target: `/Library/Application Support/ClaudeCode/`
4. Deploy `managed-mcp.json`

### Intune (Windows)

1. Create Win32 app or PowerShell script
2. Deploy to `C:\Program Files\ClaudeCode\`
3. Set file permissions (admin write, user read)

### Ansible/Chef/Puppet

```yaml
# Ansible example
- name: Deploy MCP policy
  copy:
    src: managed-mcp.json
    dest: /etc/claude-code/managed-mcp.json
    owner: root
    group: root
    mode: '0644'
```

---

## Auditing

### Monitor MCP Usage

```bash
# Check what servers users have configured
find /Users -name ".claude.json" -exec grep -l "mcpServers" {} \;

# Audit server configurations
claude mcp list --json | jq '.servers[].name'
```

### Log Analysis

```bash
# Find MCP connection events
grep -r "mcp" ~/Library/Logs/Claude/

# Track server additions
grep "mcp add" ~/.claude/command-history
```
