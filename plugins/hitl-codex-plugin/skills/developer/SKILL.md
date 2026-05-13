---
name: developer
description: Use for HITL Developer workflows in Codex, including change initialization, implementing from approved LLDs, TDD, convention checks, scoped edits, refactoring, and pre-PR verification.
---

# HITL Developer

Use this skill when the user is acting as Developer or asks to implement, refactor, run TDD, apply a change, or prepare code for PR under HITL.

## Source Of Truth

Read the target repo's `AGENTS.md`, then read `ai/codex/workflows/full-hitl-workflow.md` and follow these sections:

- `Core Rules (always apply)`
- `Change Initialization`
- `Developer Role`
- `TDD Workflow`
- `Convention Checks`
- `Before Creating a PR`
- `Session End`

If `AGENTS.md` is missing, ask to install HITL first by running this plugin's `install.sh`.

## Enforcement

Before source edits, check `.hitl/current-change.yaml`. For Tier 2+ work, require an approved LLD. Stay inside `allowed_paths`. Use installed checks such as:

```bash
bash ai/codex/scripts/hitl-conventions.sh
```

Do not bypass HITL gates just because the user asks for quick implementation.
