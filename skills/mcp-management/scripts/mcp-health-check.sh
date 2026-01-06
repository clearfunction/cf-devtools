#!/bin/bash
# MCP Server Health Check
# Usage: ./mcp-health-check.sh

set -e

echo "=== MCP Server Diagnostics ==="

echo -e "\n1. Node/npm versions:"
node --version 2>/dev/null || echo "  Node.js not found"
npm --version 2>/dev/null || echo "  npm not found"
npx --version 2>/dev/null || echo "  npx not found"

echo -e "\n2. Python version:"
python3 --version 2>/dev/null || echo "  Python3 not found"

echo -e "\n3. Configured servers:"
claude mcp list 2>/dev/null || echo "  Claude CLI not available or no servers configured"

echo -e "\n4. Environment variables (redacted):"
env | grep -E "(GITHUB|POSTGRES|MONGO|OPENAI|ANTHROPIC|LINEAR|SLACK)" | sed 's/=.*/=***/' || echo "  None found"

echo -e "\n5. Recent MCP logs (if available):"
if [ -f ~/Library/Logs/Claude/mcp.log ]; then
	echo "  Last 10 lines of mcp.log:"
	tail -10 ~/Library/Logs/Claude/mcp.log
else
	echo "  No Claude Desktop logs found at ~/Library/Logs/Claude/mcp.log"
fi

echo -e "\n6. Config file validation:"
for config in ~/.claude/settings.json ~/.claude.json; do
	if [ -f "$config" ]; then
		echo "  Checking $config..."
		if jq empty "$config" 2>/dev/null; then
			echo "    Valid JSON"
			if jq -e '.mcpServers' "$config" >/dev/null 2>&1; then
				echo "    MCP servers configured: $(jq '.mcpServers | keys | length' "$config")"
			fi
		else
			echo "    INVALID JSON - syntax error"
		fi
	fi
done

echo -e "\n=== Diagnostics Complete ==="
