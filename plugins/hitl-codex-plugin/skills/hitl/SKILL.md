---
name: hitl
description: Use when the user wants to install, configure, or follow the HITL AI-Driven Development workflow with Codex, including HITL change initialization, approval gates, scoped implementation, lifecycle hooks, or convention checks.
---

# HITL Codex

Use this skill for HITL AI-Driven Development work in Codex. This plugin is self-contained: it installs project instructions, Codex lifecycle hooks, git hooks, convention checks, document templates, and optional Graphify support into a target repository.

## Enforcement Model

Skills are guidance, not enforcement. HITL enforcement comes from the files installed into the target repo:

1. `AGENTS.md` provides the full workflow brain and trigger phrases.
   `AGENTS.md` contains the absolute path to the detailed workflow file under the plugin root. Read `AGENTS.md` to get that path before starting any HITL work.
2. `.ai/codex/hooks.json` blocks or warns during Codex lifecycle events.
3. `.git/hooks/pre-commit` and `.git/hooks/post-commit` catch bypasses outside Codex.
4. `ai/codex/scripts/hitl-conventions.sh` provides PR gate checks.
5. `.mcp.json` and `.graphifyignore` enable optional Graphify context retrieval.

## Install In A Project

Before installing, verify the target directory is a git repository. Then run:

```bash
bash <plugin-root>/install.sh <target-repo-path>
```

After installation, tell the user to review:

- `AGENTS.md`
- `.ai/codex/config.toml`
- `.ai/codex/hooks.json`
- `ai/codex/scripts/hitl-conventions.sh`
- `.mcp.json` if they want Graphify

Do not treat this skill as the safety layer. The installed hooks and git hooks are the safety layer.

## Work Under HITL

When operating inside a project that has HITL installed:

1. Read the project `AGENTS.md` before substantive HITL work.
2. If editing source code, check `.hitl/current-change.yaml` first.
3. For Tier 2+ implementation, require an approved LLD before source edits.
4. Stay inside `allowed_paths` from `.hitl/current-change.yaml`.
5. Prefer the platform's installed scripts for checks, especially `bash ai/codex/scripts/hitl-conventions.sh`.

If a requested action conflicts with the project HITL gates, stop and explain the missing gate or approval instead of bypassing it.
