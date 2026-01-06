# MCP Troubleshooting

Common issues and debugging patterns for MCP servers.

## Table of Contents

- [Diagnostic Commands](#diagnostic-commands)
- [Common Errors](#common-errors)
- [Platform-Specific Issues](#platform-specific-issues)
- [Debug Mode](#debug-mode)
- [Log Locations](#log-locations)

---

## Diagnostic Commands

### Claude Code

```bash
# List all configured servers
claude mcp list

# Get details for specific server
claude mcp get github

# Check status in session
/mcp

# Test server manually
npx -y @modelcontextprotocol/server-github
```

### Verify Dependencies

```bash
# Check npx available
which npx

# Check node version (16+ required)
node --version

# Check Python version (3.10+ for MCP SDK)
python3 --version

# Verify package exists
npm view @modelcontextprotocol/server-github
```

---

## Common Errors

### "Server not found" / "Connection closed"

**Causes**:

- Command path incorrect
- Package not installed
- Missing `cmd /c` wrapper on Windows

**Fix**:

```bash
# Test the command directly
npx -y @modelcontextprotocol/server-github

# Windows: Use cmd wrapper
claude mcp add --transport stdio server -- cmd /c npx -y @package/server
```

### "Authentication failed"

**Causes**:

- Token expired or revoked
- Wrong environment variable name
- Token lacks required scopes

**Fix**:

```bash
# Check env var is set
echo $GITHUB_PERSONAL_ACCESS_TOKEN

# Verify token works
curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" \
  https://api.github.com/user

# Regenerate token with correct scopes
```

### "Connection timeout"

**Causes**:

- Network/firewall blocking
- Server crashed on startup
- Slow startup (increase timeout)

**Fix**:

```bash
# Increase timeout (milliseconds)
MCP_TIMEOUT=30000 claude

# Check server logs for crash
tail -f ~/Library/Logs/Claude/mcp-server-*.log
```

### "Invalid configuration"

**Causes**:

- JSON syntax error
- Missing required fields
- Wrong transport type

**Fix**:

```bash
# Validate JSON
cat ~/.claude/settings.json | jq .

# Check config location
claude config list
```

### "Tool call failed" / Garbled output

**Causes**:

- Server writing to stdout (stdio transport)
- JSON-RPC message corruption

**Fix** (in server code):

```python
# WRONG
print("Debug message")

# RIGHT
import sys
print("Debug message", file=sys.stderr)
```

### "Max output exceeded"

**Causes**:

- Server returning too much data
- Default limit is 25k tokens

**Fix**:

```bash
# Increase limit
MAX_MCP_OUTPUT_TOKENS=50000 claude
```

---

## Platform-Specific Issues

### macOS

**Issue**: Server works in terminal but not Claude Desktop

**Fix**: Claude Desktop may not inherit shell environment

```json
{
  "mcpServers": {
    "server": {
      "command": "/bin/bash",
      "args": ["-c", "source ~/.zshrc && npx -y @package/server"],
      "env": {}
    }
  }
}
```

### Windows

**Issue**: "Connection closed" with npx

**Fix**: Always use `cmd /c` wrapper

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

### WSL

**Issue**: Path translation between Windows/Linux

**Fix**: Use WSL paths consistently

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    }
  }
}
```

---

## Debug Mode

### Enable MCP Debug Logging

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "...",
        "DEBUG": "mcp:*"
      }
    }
  }
}
```

### Verbose Server Output

```bash
# Python
PYTHONUNBUFFERED=1 uv run server.py 2>&1 | tee server.log

# Node
DEBUG=* npx -y @package/server 2>&1 | tee server.log
```

---

## Log Locations

### Claude Desktop (macOS)

```bash
# General MCP logs
~/Library/Logs/Claude/mcp.log

# Per-server logs
~/Library/Logs/Claude/mcp-server-SERVERNAME.log

# Watch logs
tail -f ~/Library/Logs/Claude/mcp*.log
```

### Claude Desktop (Windows)

```text
%APPDATA%\Claude\logs\mcp.log
```

### Claude Code

```bash
# Check Claude Code logs
claude --debug

# Or enable verbose mode
CLAUDE_DEBUG=1 claude
```
