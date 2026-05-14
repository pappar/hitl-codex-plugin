#!/usr/bin/env bash
# Install HITL enforcement pointers for Codex users.
#
# Usage:
#   bash /path/to/hitl-codex-plugin/install.sh [target-repo-path]
#
# If target-repo-path is omitted, installs into the current directory.

set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$(pwd)}"

echo ""
echo "HITL Codex setup -> $TARGET_DIR"
echo ""

if [[ ! -d "$TARGET_DIR/.git" ]]; then
  echo "ERROR: $TARGET_DIR is not a git repository." >&2
  echo "Run 'git init' in the target directory first." >&2
  exit 1
fi

HOOKS_DIR="$TARGET_DIR/.git/hooks"
PLUGIN_ROOT_ESCAPED="${PLUGIN_ROOT//\\/\\\\}"

write_file() {
  local dest="$1"
  local label="$2"
  mkdir -p "$(dirname "$dest")"
  cat > "$dest"
  echo "✓ Wrote $label"
}

if [[ -f "$TARGET_DIR/AGENTS.md" ]]; then
  echo "AGENTS.md already exists - add the HITL router manually if needed."
else
  write_file "$TARGET_DIR/AGENTS.md" "AGENTS.md" <<EOF
# HITL Codex Instructions

This project uses the HITL (Human-In-The-Loop) AI-Driven Development workflow.

HITL plugin root:

\`\`\`text
$PLUGIN_ROOT_ESCAPED
\`\`\`

Detailed workflow:

\`\`\`text
$PLUGIN_ROOT_ESCAPED/workflows/full-hitl-workflow.md
\`\`\`

Read the detailed workflow file before substantive HITL work. For role-specific requests, read the relevant section first:

- PM: \`PM Role - Requirements and Product Management\`
- Architect: \`Architecture Review\`, \`Greenfield System Design\`, \`Architect Design Journey\`
- Developer: \`Change Initialization\`, \`Developer Role\`, \`TDD Workflow\`, \`Convention Checks\`
- QA: \`QA Review\`, \`Spec Conformance Review\`, \`TDD Workflow\`
- Ops: \`Ops Role - Build, Deploy, Infrastructure\`
- Graphify: \`Knowledge Graph (Graphify)\`

If the human has not stated their role, ask:

\`\`\`text
Which role are you playing this session? PM / Technical Advisor / Architect / Developer / QA / Ops
\`\`\`

Core gates:

1. No source code edits without \`.hitl/current-change.yaml\`.
2. No Tier 2+ implementation without an approved LLD.
3. Do not implement from a GitHub issue alone.
4. Stay inside \`allowed_paths\` from \`.hitl/current-change.yaml\`.
5. Source-of-truth order is GitHub issue / PRD -> approved HLD/LLD -> ADR -> \`docs/system-manifest.yaml\` -> existing code.

If the detailed workflow references bundled templates, Semgrep rules, or utility scripts, use the files under the HITL plugin root above. Do not copy plugin payload into this product repo.

Run convention checks before PR:

\`\`\`bash
bash ai/codex/scripts/hitl-conventions.sh
\`\`\`
EOF
fi

if [[ -f "$TARGET_DIR/.ai/codex/config.toml" ]]; then
  echo ".ai/codex/config.toml already exists - keep codex_hooks = true."
else
  mkdir -p "$TARGET_DIR/.ai/codex"
  cp "$PLUGIN_ROOT/codex/config.toml" "$TARGET_DIR/.ai/codex/config.toml"
  echo "✓ Copied .ai/codex/config.toml"
fi

write_file "$TARGET_DIR/.ai/codex/hooks.json" ".ai/codex/hooks.json" <<EOF
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash '$PLUGIN_ROOT_ESCAPED/hook-scripts/check-hitl-context.sh'"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash '$PLUGIN_ROOT_ESCAPED/hook-scripts/check-domain-boundary.sh'"
          },
          {
            "type": "command",
            "command": "bash '$PLUGIN_ROOT_ESCAPED/hook-scripts/rebuild-graph.sh'"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash '$PLUGIN_ROOT_ESCAPED/hook-scripts/write-session-summary.sh'"
          }
        ]
      }
    ]
  }
}
EOF

write_file "$TARGET_DIR/ai/codex/scripts/hitl-conventions.sh" "ai/codex/scripts/hitl-conventions.sh" <<EOF
#!/usr/bin/env bash
exec bash '$PLUGIN_ROOT_ESCAPED/scripts/hitl-conventions.sh' "\$@"
EOF
chmod +x "$TARGET_DIR/ai/codex/scripts/hitl-conventions.sh"

write_file "$TARGET_DIR/ai/codex/hook-scripts/test-hooks.sh" "ai/codex/hook-scripts/test-hooks.sh" <<EOF
#!/usr/bin/env bash
exec bash '$PLUGIN_ROOT_ESCAPED/hook-scripts/test-hooks.sh' "\$@"
EOF
chmod +x "$TARGET_DIR/ai/codex/hook-scripts/test-hooks.sh"

if [[ ! -f "$TARGET_DIR/.graphifyignore" ]]; then
  cp "$PLUGIN_ROOT/.graphifyignore" "$TARGET_DIR/.graphifyignore"
  echo "✓ Copied .graphifyignore"
else
  echo ".graphifyignore already exists - skipping."
fi

if [[ ! -f "$TARGET_DIR/.mcp.json" ]]; then
  cat > "$TARGET_DIR/.mcp.json" << 'JSON'
{
  "mcpServers": {
    "graphify": {
      "type": "stdio",
      "command": "python3",
      "args": ["-m", "graphify.serve", "graphify-out/graph.json"]
    }
  }
}
JSON
  echo "✓ Created .mcp.json (Graphify MCP server - optional, requires graphifyy[mcp])"
else
  echo ".mcp.json already exists - add the Graphify server manually if needed."
fi

if command -v graphify >/dev/null 2>&1; then
  echo "  Graphify detected. Build the initial graph with:"
  echo "    cd \"$TARGET_DIR\" && graphify . --directed --no-viz"
else
  echo "  Graphify is optional. To enable graph queries:"
  echo "    pip install 'graphifyy[mcp]' && graphify install"
  echo "    graphify . --directed --no-viz"
fi

for hook in pre-commit post-commit; do
  dest="$HOOKS_DIR/$hook"

  if [[ -f "$dest" ]]; then
    cp "$dest" "$dest.hitl-backup"
    echo "  Backed up existing $hook to $hook.hitl-backup"
  fi

  cat > "$dest" <<EOF
#!/usr/bin/env bash
exec bash '$PLUGIN_ROOT_ESCAPED/git-hooks/$hook' "\$@"
EOF
  chmod +x "$dest"
  echo "✓ Installed .git/hooks/$hook wrapper"
done

echo ""
echo "Setup complete. Next steps:"
echo ""
echo "  1. Review AGENTS.md and add project-specific coding standards."
echo "  2. Review .ai/codex/config.toml and keep codex_hooks = true."
echo "  3. Create docs/system-manifest.yaml if your project does not have one."
echo "  4. Start a change:"
echo "     codex 'Initialize HITL context for GH-42: add user notifications'"
echo "  5. Before PR, run:"
echo "     bash ai/codex/scripts/hitl-conventions.sh"
echo ""
echo "Installed only lightweight pointers/wrappers; plugin payload remains at:"
echo "  $PLUGIN_ROOT"
echo ""
