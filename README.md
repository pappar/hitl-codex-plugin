# HITL Codex Plugin

Codex plugin for the HITL AI-Driven Development workflow.

This repo is a small Codex marketplace containing one plugin:

```text
plugins/hitl-codex-plugin
```

The plugin installs HITL project instructions, Codex lifecycle hooks, git hooks, convention checks, role skills, templates, and optional Graphify support.

The target product repo receives only lightweight pointers and wrappers. The plugin payload stays in the Codex plugin folder.

## Install

**Step 1 — Add this repo as a Codex marketplace:**

```bash
codex plugin marketplace add /path/to/hitl-codex-plugin
```

**Step 2 — Install the plugin:**

```bash
codex plugin add hitl-codex-plugin@hitl-codex
```

**Step 3 — Install HITL into a target git repo:**

```bash
bash /path/to/hitl-codex-plugin/plugins/hitl-codex-plugin/install.sh /path/to/target-repo
```

This writes a small `AGENTS.md` (with a managed block that upgrades automatically), Codex hook config, git-hook wrappers, a convention-check wrapper, `.mcp.json`, and `.graphifyignore` into the target repo. The plugin's workflow, scripts, templates, and rule bundles stay in the plugin folder.

## Upgrade

```bash
# 1 — Pull the latest plugin code
cd /path/to/hitl-codex-plugin
git pull

# 2 — Reinstall the plugin in Codex
codex plugin add hitl-codex-plugin@hitl-codex

# 3 — Re-run install.sh in the target repo
#     Updates AGENTS.md managed block, hooks.json, and git-hook wrappers.
#     Any project-specific content you added outside the managed block is preserved.
cd /path/to/target-repo
bash /path/to/hitl-codex-plugin/plugins/hitl-codex-plugin/install.sh .

# 4 — Verify
bash ai/codex/hook-scripts/test-hooks.sh   # should show: 14 passed, 0 failed
```

Note: `codex plugin marketplace upgrade` only works for Git-sourced marketplaces, not local paths. For local development, use `codex plugin add` to reinstall.

## Start

Open Codex in the target repo and start a workflow:

```bash
codex "I am the PM. Start the HITL pm/design-feature workflow."
```

or:

```bash
codex "Initialize HITL context for GH-42: add user notifications"
```

## Further Reading

Full methodology, playbooks, role guides, and adoption guidance live in the main HITL platform repo:

https://github.com/Prasad-Apparaju/hitl-dev-platform
