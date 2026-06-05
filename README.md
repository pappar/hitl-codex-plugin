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

The plugin is marked `INSTALLED_BY_DEFAULT` — it installs automatically when the marketplace is added. No separate install command is needed.

**Step 2 — Install HITL into a target git repo:**

```bash
bash /path/to/hitl-codex-plugin/plugins/hitl-codex-plugin/install.sh /path/to/target-repo
```

This writes only a small `AGENTS.md`, Codex hook config, git-hook wrappers, a convention-check wrapper, `.mcp.json`, and `.graphifyignore` into the target repo. It does not copy the plugin's workflow, scripts, templates, or rule bundles into the product repo.

## Upgrade

To get the latest version of the plugin after pulling:

```bash
# 1 — Pull the latest plugin code
cd /path/to/hitl-codex-plugin
git pull

# 2 — Tell Codex to re-read the marketplace
codex plugin marketplace upgrade hitl-codex

# 3 — Regenerate the target repo's hook config (picks up new hook matchers etc.)
cd /path/to/target-repo
rm AGENTS.md        # remove so install.sh regenerates it; skip if you've added custom content
bash /path/to/hitl-codex-plugin/plugins/hitl-codex-plugin/install.sh .

# 4 — Verify
bash ai/codex/hook-scripts/test-hooks.sh   # should show: 14 passed, 0 failed
```

If `AGENTS.md` has custom project conventions, back it up before removing:
```bash
cp AGENTS.md AGENTS.md.bak
rm AGENTS.md
bash /path/to/hitl-codex-plugin/plugins/hitl-codex-plugin/install.sh .
cat AGENTS.md.bak >> AGENTS.md && rm AGENTS.md.bak
```

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
