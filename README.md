# HITL Codex Plugin

Codex plugin for the HITL AI-Driven Development workflow.

This repo is a Codex marketplace containing one plugin: `plugins/hitl-codex-plugin`.

There are **two separate install steps** with different scopes:

| Step | What it does | Scope |
|---|---|---|
| `codex plugin add` | Installs the plugin into Codex — slash commands, skills, workflow files | Global (Codex manages `~/.codex/plugins/cache/`) |
| `install.sh` | Bootstraps a specific project — `AGENTS.md`, lifecycle hooks, git hooks | Per project (run once per repo) |

You need both for the full HITL enforcement layer. You can use the slash commands (`/apply-change`, `/tdd`, etc.) without running `install.sh`, but the hook enforcement (blocking source edits without a context file, git pre-commit checks) requires it.

## Step 1 — Install the Codex plugin (global, once)

Add this repo as a marketplace and install the plugin:

```bash
codex plugin marketplace add /path/to/hitl-codex-plugin
codex plugin add hitl-codex-plugin@hitl-codex
```

Codex stores the installed plugin under its managed cache:
```text
~/.codex/plugins/cache/hitl-codex/hitl-codex-plugin/<version>/
```

After this step, all 43 HITL slash commands are available in every Codex session:
`/apply-change`, `/architect-design-feature`, `/tdd`, `/ta-approve`, `/pm-design-feature`, etc.

## Step 2 — Bootstrap a project (per repo, optional but recommended)

Run `install.sh` from the **cached plugin**, pointing at the target project:

```bash
PLUGIN_CACHE=~/.codex/plugins/cache/hitl-codex/hitl-codex-plugin
VERSION=$(ls "$PLUGIN_CACHE" | sort -V | tail -1)
bash "$PLUGIN_CACHE/$VERSION/install.sh" /path/to/your-project
```

This writes into the target project:
- `AGENTS.md` — points Codex at the cached workflow file; has a managed block that upgrades automatically
- `.ai/codex/hooks.json` — lifecycle hooks that block source edits before design gates are approved
- `.git/hooks/pre-commit` / `post-commit` — git-level enforcement; chains your original hooks if present
- `ai/codex/scripts/hitl-conventions.sh` — pre-PR convention check wrapper

Do **not** run `install.sh` inside `~/.codex` or the marketplace repo itself. Run it from the cached plugin and point it at your project directory.

## Upgrade

**Re-install the plugin in Codex** to pick up a new version:

```bash
codex plugin marketplace remove hitl-codex
codex plugin marketplace add /path/to/hitl-codex-plugin
codex plugin add hitl-codex-plugin@hitl-codex
```

**Re-bootstrap the project** to update hook configs and the AGENTS.md managed block:

```bash
PLUGIN_CACHE=~/.codex/plugins/cache/hitl-codex/hitl-codex-plugin
VERSION=$(ls "$PLUGIN_CACHE" | sort -V | tail -1)
cd /path/to/your-project
bash "$PLUGIN_CACHE/$VERSION/install.sh" .
bash ai/codex/hook-scripts/test-hooks.sh   # should show: 18 passed, 0 failed
```

Custom content you added below the `<!-- HITL:MANAGED:END -->` marker in `AGENTS.md` is preserved automatically on re-run.

Note: `codex plugin marketplace upgrade` only works for Git-sourced marketplaces, not local paths.

Note: if your repo had a custom `.git/hooks/pre-commit`, the original is preserved as `.git/hooks/pre-commit.hitl-backup` and chained automatically after HITL checks pass.

## Start

Slash commands work immediately after Step 1, in any Codex session:

```bash
/apply-change GH-42
/architect-design-feature
/tdd
/ta-approve
```

Or use natural language:

```bash
codex "I am the PM. Run /pm-design-feature — we want to add user notifications."
```

## Further Reading

Full methodology, playbooks, role guides, and adoption guidance live in the main HITL platform repo:

https://github.com/Prasad-Apparaju/hitl-dev-platform
