# MCP Server Configurations

Specific configuration examples for popular MCP servers.

## Table of Contents

- [Token Budget Reference](#token-budget-reference)
- [Always-Enable Servers](#always-enable-servers)
- [Development Servers](#development-servers)
- [Database Servers](#database-servers)
- [Web & Browser Servers](#web--browser-servers)
- [Cloud Provider Servers](#cloud-provider-servers)
- [Productivity Servers](#productivity-servers)

---

## Token Budget Reference

| Server             | Tokens | Recommendation               |
|--------------------|--------|------------------------------|
| Context7           | ~500   | Always enable                |
| Filesystem         | ~2k    | Enable per-project           |
| Playwright         | ~10k   | E2E testing sessions         |
| PostgreSQL/MongoDB | ~5-10k | Data exploration             |
| GitHub             | ~40k   | Complex repo operations only |

---

## Always-Enable Servers

### Context7 (Documentation Lookup)

Low token cost, high value. Provides up-to-date library documentation.

**Claude Code:**

```bash
claude mcp add --transport stdio context7 -- npx -y @upstash/context7-mcp
```

**Claude Desktop:**

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

**Capabilities**: Library docs lookup, API references, code examples

---

## Development Servers

### GitHub

**Token usage**: ~40k (use sparingly for complex operations)

**Claude Code:**

```bash
# Remote (recommended)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Local with PAT
claude mcp add --transport stdio github \
  --env GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxx \
  -- npx -y @modelcontextprotocol/server-github
```

**Claude Desktop:**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxx"
      }
    }
  }
}
```

**Capabilities**: Repo operations, issues, PRs, file operations, branch management

**Token creation**: <https://github.com/settings/tokens> (repo scope minimum)

### Filesystem

**Claude Code:**

```bash
claude mcp add --transport stdio filesystem \
  -- npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/dir
```

**Claude Desktop:**

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/you/projects"]
    }
  }
}
```

**Security**: Only grant access to specific directories, never root.

---

## Database Servers

### PostgreSQL

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@host:5432/db"
      }
    }
  }
}
```

**Capabilities**: Query execution, schema introspection, table management

**Security**: Use read-only credentials for exploration.

### MongoDB

```json
{
  "mcpServers": {
    "mongodb": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-mongodb"],
      "env": {
        "MONGODB_URI": "mongodb://user:pass@host:27017/db"
      }
    }
  }
}
```

**Capabilities**: Document queries, collection management, aggregation pipelines

### SQLite

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "/path/to/database.db"]
    }
  }
}
```

---

## Web & Browser Servers

### Playwright

**Token usage**: ~10k

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-playwright"]
    }
  }
}
```

**Capabilities**: Browser automation, navigation, screenshots, element interaction

**Note**: If browser not installed, call `mcp__playwright__browser_install` first.

### Firecrawl (Web Scraping)

```json
{
  "mcpServers": {
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "fc-xxx"
      }
    }
  }
}
```

**Capabilities**: Web scraping, content extraction, site crawling

### Fetch (Simple HTTP)

```json
{
  "mcpServers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

**Capabilities**: HTTP requests, API calls (simpler than Firecrawl)

---

## Cloud Provider Servers

### AWS

```json
{
  "mcpServers": {
    "aws": {
      "command": "npx",
      "args": ["-y", "@aws/mcp-server"],
      "env": {
        "AWS_ACCESS_KEY_ID": "xxx",
        "AWS_SECRET_ACCESS_KEY": "xxx",
        "AWS_REGION": "us-east-1"
      }
    }
  }
}
```

**Alternative**: Use AWS CLI credentials from `~/.aws/credentials`

### Azure

```json
{
  "mcpServers": {
    "azure": {
      "command": "npx",
      "args": ["-y", "@azure/mcp-server"],
      "env": {
        "AZURE_SUBSCRIPTION_ID": "xxx",
        "AZURE_TENANT_ID": "xxx",
        "AZURE_CLIENT_ID": "xxx",
        "AZURE_CLIENT_SECRET": "xxx"
      }
    }
  }
}
```

**Capabilities**: Resource management, deployments, configuration

---

## Productivity Servers

### Slack

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-xxx"
      }
    }
  }
}
```

### Notion

**Claude Code (remote):**

```bash
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

### Linear

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@linear/mcp-server"],
      "env": {
        "LINEAR_API_KEY": "lin_api_xxx"
      }
    }
  }
}
```

---

## Environment Variable Patterns

### In .mcp.json (project-scoped)

```json
{
  "mcpServers": {
    "api": {
      "type": "http",
      "url": "${API_URL:-https://default.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

Supported syntax:

- `${VAR}` - Variable value (fails if unset)
- `${VAR:-default}` - Use default if unset

### Windows Notes

On native Windows (not WSL), wrap npx with `cmd /c`:

```json
{
  "mcpServers": {
    "server": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@package/server"]
    }
  }
}
```
