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

**Step 2 — Install the plugin into Codex** (required for skills to load):

```bash
codex plugin add hitl-codex-plugin@hitl-codex
```

Verify installation: `codex plugin list` should show `hitl-codex-plugin` as `installed, enabled`.

**Step 3 — Install HITL into a target git repo:**

```bash
bash /path/to/hitl-codex-plugin/plugins/hitl-codex-plugin/install.sh /path/to/target-repo
```

This writes only a small `AGENTS.md`, Codex hook config, git-hook wrappers, a convention-check wrapper, `.mcp.json`, and `.graphifyignore` into the target repo. It does not copy the plugin's workflow, scripts, templates, or rule bundles into the product repo.

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
