# Building MCP Servers

Guide to creating custom MCP servers in Python and TypeScript.

## Table of Contents

- [Language Selection](#language-selection)
- [Core Concepts](#core-concepts)
- [Python Implementation](#python-implementation)
- [TypeScript Implementation](#typescript-implementation)
- [Testing Your Server](#testing-your-server)
- [Publishing](#publishing)

---

## Language Selection

| Factor                | Python                      | TypeScript         |
|-----------------------|-----------------------------|--------------------|
| **Prototyping speed** | Faster (FastMCP)            | Moderate           |
| **Type safety**       | Optional (type hints)       | Built-in           |
| **Ecosystem**         | Data science, ML, scripting | Web, npm packages  |
| **Deployment**        | Requires Python runtime     | Node.js runtime    |
| **SDK maturity**      | FastMCP is excellent        | Official SDK solid |

**Choose Python when**:

- Rapid prototyping
- Data science/ML integrations
- Existing Python codebase
- Scripting/automation focus

**Choose TypeScript when**:

- Web service integrations
- npm ecosystem access
- Strict type safety required
- Existing Node.js infrastructure

---

## Core Concepts

MCP servers expose three primitives:

| Primitive     | Control          | Purpose                        |
|---------------|------------------|--------------------------------|
| **Tools**     | Model-controlled | Actions the AI decides to take |
| **Resources** | App-controlled   | Context provided to the AI     |
| **Prompts**   | User-controlled  | User-invoked interactions      |

---

## Python Implementation

### Setup

```bash
# Create project
mkdir my-mcp-server && cd my-mcp-server
uv init
uv add mcp
```

### Basic Server (FastMCP)

```python
# server.py
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("my-server")

@mcp.tool()
async def get_weather(city: str) -> str:
    """Get current weather for a city.

    Args:
        city: City name (e.g., "San Francisco")
    """
    # Implementation here
    return f"Weather in {city}: 72F, sunny"

@mcp.tool()
async def search_database(query: str, limit: int = 10) -> str:
    """Search the database.

    Args:
        query: Search query string
        limit: Maximum results to return
    """
    # Implementation here
    return f"Found {limit} results for '{query}'"

@mcp.resource("config://app")
def get_config() -> str:
    """Application configuration."""
    return '{"version": "1.0.0", "env": "production"}'

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

### Critical: Logging for stdio

**NEVER use print() with stdio transport** - it corrupts JSON-RPC.

```python
import logging
import sys

# Configure logging to stderr
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    stream=sys.stderr  # CRITICAL: stderr, not stdout
)

logger = logging.getLogger(__name__)

@mcp.tool()
async def my_tool(param: str) -> str:
    logger.info(f"Processing: {param}")  # Safe
    # print(f"Processing: {param}")       # DANGEROUS - breaks server
    return "result"
```

### Adding Resources

```python
@mcp.resource("file://config.json")
def read_config() -> str:
    """Read configuration file."""
    with open("config.json") as f:
        return f.read()

@mcp.resource("db://users/{user_id}")
def get_user(user_id: str) -> str:
    """Get user by ID."""
    # Dynamic resource with parameter
    return f'{{"id": "{user_id}", "name": "User"}}'
```

### Adding Prompts

```python
@mcp.prompt()
def debug_prompt(error_message: str) -> str:
    """Generate a debugging prompt."""
    return f"""Help me debug this error:

Error: {error_message}

Please:
1. Identify the likely cause
2. Suggest fixes
3. Explain how to prevent it
"""
```

---

## TypeScript Implementation

### Setup

```bash
mkdir my-mcp-server && cd my-mcp-server
npm init -y
npm install @modelcontextprotocol/sdk zod
npm install -D typescript @types/node
```

### Basic Server

```typescript
// src/index.ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "my-server",
  version: "1.0.0",
});

// Register a tool
server.registerTool(
  "get_weather",
  {
    description: "Get current weather for a city",
    inputSchema: {
      city: z.string().describe("City name"),
    },
  },
  async ({ city }) => ({
    content: [{ type: "text", text: `Weather in ${city}: 72F, sunny` }],
  })
);

// Register a resource
server.registerResource(
  "config://app",
  {
    description: "Application configuration",
  },
  async () => ({
    contents: [{
      uri: "config://app",
      mimeType: "application/json",
      text: '{"version": "1.0.0"}'
    }],
  })
);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Server running on stdio");  // stderr is safe
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
```

### Critical: Logging for stdio

```typescript
// NEVER use console.log with stdio transport
console.log("message");   // DANGEROUS - breaks JSON-RPC
console.error("message"); // SAFE - goes to stderr

// Or use a proper logger
import { createLogger } from "./logger.js";
const logger = createLogger("my-server");
logger.info("Safe logging");
```

---

## Testing Your Server

### Manual Testing

```bash
# Python
uv run server.py

# TypeScript
npx ts-node src/index.ts

# Then in another terminal, send JSON-RPC:
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | uv run server.py
```

### MCP Inspector

```bash
npx @modelcontextprotocol/inspector
```

Opens a web UI to interact with your server.

### Integration Test with Claude Desktop

1. Add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "uv",
      "args": ["--directory", "/absolute/path/to/server", "run", "server.py"]
    }
  }
}
```

2. Fully restart Claude Desktop (Cmd+Q on macOS)
3. Check logs: `tail -f ~/Library/Logs/Claude/mcp*.log`

---

## Publishing

### To npm (TypeScript)

```bash
npm publish --access public
```

Users install with:

```bash
claude mcp add --transport stdio my-server -- npx -y @your-org/my-server
```

### To PyPI (Python)

```bash
uv build
uv publish
```

Users install with:

```bash
claude mcp add --transport stdio my-server -- uvx my-server
```

### To Smithery

1. Create account at smithery.ai
2. Submit GitHub repo URL
3. Add installation instructions

### To GitHub MCP Registry

1. Ensure repo has proper MCP server structure
2. Submit via github.com/mcp
