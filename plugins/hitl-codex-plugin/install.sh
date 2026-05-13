#!/usr/bin/env bash
# Install HITL enforcement and workflow files for Codex users.
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

copy_if_missing() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [[ -f "$dest" ]]; then
    echo "$label already exists - review $src and merge manually."
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "✓ Copied $label"
  fi
}

copy_required() {
  local src="$1"
  local dest="$2"
  local label="$3"

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "✓ Copied $label"
}

copy_if_missing "$PLUGIN_ROOT/AGENTS.md" "$TARGET_DIR/AGENTS.md" "AGENTS.md"
copy_required "$PLUGIN_ROOT/workflows/full-hitl-workflow.md" "$TARGET_DIR/ai/codex/workflows/full-hitl-workflow.md" "ai/codex/workflows/full-hitl-workflow.md"
copy_if_missing "$PLUGIN_ROOT/codex/config.toml" "$TARGET_DIR/.ai/codex/config.toml" ".ai/codex/config.toml"
copy_if_missing "$PLUGIN_ROOT/codex/hooks.json" "$TARGET_DIR/.ai/codex/hooks.json" ".ai/codex/hooks.json"

mkdir -p "$TARGET_DIR/ai/codex/hook-scripts"
for script in check-hitl-context.sh check-domain-boundary.sh write-session-summary.sh rebuild-graph.sh test-hooks.sh; do
  copy_required "$PLUGIN_ROOT/hook-scripts/$script" "$TARGET_DIR/ai/codex/hook-scripts/$script" "ai/codex/hook-scripts/$script"
  chmod +x "$TARGET_DIR/ai/codex/hook-scripts/$script"
done

copy_required "$PLUGIN_ROOT/scripts/hitl-conventions.sh" "$TARGET_DIR/ai/codex/scripts/hitl-conventions.sh" "ai/codex/scripts/hitl-conventions.sh"
chmod +x "$TARGET_DIR/ai/codex/scripts/hitl-conventions.sh"

copy_required "$PLUGIN_ROOT/ci/manifest-drift/check_manifest_drift.py" "$TARGET_DIR/ci/manifest-drift/check_manifest_drift.py" "ci/manifest-drift/check_manifest_drift.py"
copy_required "$PLUGIN_ROOT/scripts/fix_mermaid_br_tags.py" "$TARGET_DIR/scripts/fix_mermaid_br_tags.py" "scripts/fix_mermaid_br_tags.py"

mkdir -p "$TARGET_DIR/.semgrep"
cp -R "$PLUGIN_ROOT/.semgrep/." "$TARGET_DIR/.semgrep/"
echo "✓ Copied .semgrep/"

copy_required "$PLUGIN_ROOT/shared/templates/hld-template.md" "$TARGET_DIR/ai/shared/templates/hld-template.md" "ai/shared/templates/hld-template.md"
copy_required "$PLUGIN_ROOT/shared/templates/lld-component-template.md" "$TARGET_DIR/ai/shared/templates/lld-component-template.md" "ai/shared/templates/lld-component-template.md"

if [[ ! -f "$TARGET_DIR/.graphifyignore" ]]; then
  copy_required "$PLUGIN_ROOT/.graphifyignore" "$TARGET_DIR/.graphifyignore" ".graphifyignore"
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
  src="$PLUGIN_ROOT/git-hooks/$hook"
  dest="$HOOKS_DIR/$hook"

  if [[ -f "$dest" ]]; then
    cp "$dest" "$dest.hitl-backup"
    echo "  Backed up existing $hook to $hook.hitl-backup"
  fi

  cp "$src" "$dest"
  chmod +x "$dest"
  echo "✓ Installed .git/hooks/$hook"
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
