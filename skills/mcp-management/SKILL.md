---
name: mcp-management
description: >
  Manages MCP (Model Context Protocol) servers for Claude Code and Claude Desktop.
  Activates for: finding MCP servers, MCP registries, MCP server setup,
  MCP configuration, MCP troubleshooting, MCP security, building MCP servers,
  MCP transport selection, claude mcp commands, mcp.json files, mcpServers
  configuration, tool poisoning prevention, MCP debugging, Smithery, Glama,
  GitHub MCP registry, which MCP server should I use.
  NOT for: general Claude Code settings (use claude-code-mastery),
  OAuth/authentication unrelated to MCP, generic API integrations without MCP.
---

# MCP Management

Comprehensive guide for finding, configuring, securing, and building MCP servers
for Claude Code and Claude Desktop.

## Quick Navigation

- **Find Servers**: See [Discovering MCP Servers](#discovering-mcp-servers)
- **Configure Servers**: See [references/server-configs.md](references/server-configs.md)
- **Build Custom Servers**: See [references/building-servers.md](references/building-servers.md)
- **Security**: See [references/security-essentials.md](references/security-essentials.md)
- **Troubleshooting**: See [references/troubleshooting.md](references/troubleshooting.md)
- **Enterprise**: See [references/enterprise-config.md](references/enterprise-config.md)

## Platform Differences

| Aspect            | Claude Code                  | Claude Desktop                                                    |
|-------------------|------------------------------|-------------------------------------------------------------------|
| Config location   | `~/.claude/settings.json`    | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| CLI management    | `claude mcp add/list/remove` | Manual JSON editing                                               |
| Scopes            | local/project/user           | Single config                                                     |
| Hot reload        | Supported                    | Requires full restart (Cmd+Q)                                     |
| Can act as server | Yes (`claude mcp serve`)     | No                                                                |

## Discovering MCP Servers

### Primary Registries

| Registry                                                           | Servers   | Best For                                 |
|--------------------------------------------------------------------|-----------|------------------------------------------|
| [Official MCP Registry](https://registry.modelcontextprotocol.io/) | Canonical | Verified, authoritative source           |
| [GitHub MCP Registry](https://github.com/mcp)                      | Curated   | GitHub-native, one-click VS Code install |
| [Smithery.ai](https://smithery.ai/)                                | 4,600+    | Usage metrics, edge deployment           |
| [Glama.ai](https://glama.ai/mcp/servers)                           | 10,000+   | Hosted option, no local setup            |
| [PulseMCP](https://www.pulsemcp.com/servers)                       | 7,500+    | Daily updates, streaming focus           |

### Specialized Directories

| Registry                                                                      | Focus                                |
|-------------------------------------------------------------------------------|--------------------------------------|
| [Cursor Directory](https://cursor.directory/mcp)                              | Cursor IDE optimized (1,800+)        |
| [Mastra](https://mastra.ai/mcp-registry-registry)                             | Meta-aggregator across registries    |
| [MCP.so](https://mcp.so/)                                                     | Quality-verified listings            |
| [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)        | Community curated GitHub list        |
| [HiMCP.ai](https://himcp.ai/)                                                 | Uptime & performance metrics         |
| [MCPdb.org](https://mcpdb.org/)                                               | Regional filtering, tech docs        |
| [MCPMarket.com](https://mcpmarket.com/)                                       | Commercial/enterprise with pricing   |
| [Portkey.ai](https://portkey.ai/mcp-servers)                                  | Enterprise security/compliance       |
| [MCPServers.org](https://mcpservers.org/)                                     | User reviews, troubleshooting guides |
| [Cline.bot](https://cline.bot/mcp-marketplace)                                | Cline AI one-click integration       |
| [APITracker.io](https://apitracker.io/mcp-servers)                            | API version tracking                 |
| [AIXploria](https://www.aixploria.com/en/list-best-mcp-servers-directory-ai/) | Editorial reviews, use-case guides   |

### Evaluation Criteria

When selecting an MCP server:

1. **Maintenance**: Recent commits? Active issues?
2. **Security**: Reviewed code? Known vulnerabilities?
3. **Token cost**: How many tokens does it consume?
4. **Transport**: HTTP (remote) vs stdio (local)?
5. **Trust**: Official vs community vs unknown author?

## Pre-Installation Workflow

**CRITICAL**: Before installing ANY MCP server, follow this workflow:

### 1. Fetch and Read the README

Always retrieve the server's README.md from GitHub or the registry:

```bash
# View README directly
gh repo view owner/repo-name

# Or fetch raw README
curl -s https://raw.githubusercontent.com/owner/repo/main/README.md
```

**Look for**:

- Required environment variables
- Prerequisites (Node 18+, Python 3.10+, API keys)
- Configuration options and defaults
- Usage examples and limitations
- Security considerations

### 2. Check for Deprecations

| Deprecated                            | Use Instead                              |
|---------------------------------------|------------------------------------------|
| SSE transport                         | HTTP or stdio (June 2025 spec)           |
| `@modelcontextprotocol/server-github` | `@github/github-mcp-server` (April 2025) |
| OAuth 2.0 for HTTP                    | OAuth 2.1 required (March 2025 spec)     |

### 3. Verify Prerequisites

```bash
# Check Node version (18+ typically required)
node --version

# Check Python version (3.10+ for MCP SDK)
python3 --version

# Check if package exists
npm view @package/server-name
```

### 4. Review Security Implications

Before proceeding, confirm:

- [ ] What filesystem paths can it access?
- [ ] What network requests can it make?
- [ ] What environment variables does it read?
- [ ] Is the source code available and reviewed?

### 5. Install Following README Instructions

Only after completing steps 1-4, install using the README's recommended method.

## Transport Types

| Transport | Use When                    | Example                                                                          |
|-----------|-----------------------------|----------------------------------------------------------------------------------|
| **HTTP**  | Cloud services, remote APIs | `claude mcp add --transport http notion https://mcp.notion.com/mcp`              |
| **stdio** | Local tools, system access  | `claude mcp add --transport stdio fs -- npx -y @anthropic/mcp-server-filesystem` |
| **SSE**   | Legacy (prefer HTTP)        | Deprecated for new implementations                                               |

## Quick Setup Examples

### Claude Code (CLI)

```bash
# Add remote server
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Add local server
claude mcp add --transport stdio postgres -- npx -y @modelcontextprotocol/server-postgres

# List servers
claude mcp list

# Remove server
claude mcp remove github
```

### Claude Desktop (JSON)

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

## MCP vs CLI Decision

| Use MCP When                     | Use CLI When              |
|----------------------------------|---------------------------|
| Rich context needed in responses | Simple one-off operations |
| Complex queries across resources | Quick lookups             |
| Ongoing session work             | Infrequent access         |
| Want tool integration            | Prefer direct control     |

**Token budget matters**: GitHub MCP ~40k tokens. Context7 ~500 tokens. Enable sparingly.

## Security Essentials

**Critical risks** (2025 research: 43% of servers have command injection flaws):

1. **Prompt injection**: Malicious content in fetched data manipulates Claude
2. **Tool poisoning**: Malicious tool descriptions trick model into unsafe actions
3. **Credential exposure**: API keys in version control or logs

**Mitigations**:

- Only install from trusted registries
- Review server code before installing unknown servers
- Use scoped tokens with minimal permissions
- Never commit credentials to version control
- Enable project-scope servers only after review

See [references/security-essentials.md](references/security-essentials.md) for detailed patterns.

## Building MCP Servers

### Language Selection

| Choose         | When                                                             |
|----------------|------------------------------------------------------------------|
| **Python**     | Rapid prototyping, data science tools, existing Python ecosystem |
| **TypeScript** | Web integrations, npm ecosystem, type safety preference          |

### Python Quick Start (FastMCP)

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("my-server")

@mcp.tool()
async def my_tool(param: str) -> str:
    """Tool description for Claude."""
    return f"Result: {param}"

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

### TypeScript Quick Start

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({ name: "my-server", version: "1.0.0" });

server.registerTool("my_tool", {
  description: "Tool description for Claude",
  inputSchema: { param: z.string() }
}, async ({ param }) => ({
  content: [{ type: "text", text: `Result: ${param}` }]
}));

const transport = new StdioServerTransport();
await server.connect(transport);
```

**Critical**: For stdio transport, NEVER write to stdout (corrupts JSON-RPC). Use stderr or logging libraries.

See [references/building-servers.md](references/building-servers.md) for complete patterns.
