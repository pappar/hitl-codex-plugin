# HITL Codex Instructions

This project uses the HITL (Human-In-The-Loop) AI-Driven Development workflow.

The detailed workflow lives in:

```text
ai/codex/workflows/full-hitl-workflow.md
```

Read that file before substantive HITL work. For role-specific requests, read the relevant section first:

- PM: `PM Role - Requirements and Product Management`
- Architect: `Architecture Review`, `Greenfield System Design`, `Architect Design Journey`
- Developer: `Change Initialization`, `Developer Role`, `TDD Workflow`, `Convention Checks`
- QA: `QA Review`, `Spec Conformance Review`, `TDD Workflow`
- Ops: `Ops Role - Build, Deploy, Infrastructure`
- Graphify: `Knowledge Graph (Graphify)`

## Session Start

If the human has not stated their role, ask:

```text
Which role are you playing this session? PM / Technical Advisor / Architect / Developer / QA / Ops
```

Do not assume Developer mode by default.

## Core Gates

1. No source code edits without `.hitl/current-change.yaml`.
2. No Tier 2+ implementation without an approved LLD.
3. Do not implement from a GitHub issue alone.
4. Stay inside `allowed_paths` from `.hitl/current-change.yaml`.
5. Source-of-truth order is GitHub issue / PRD -> approved HLD/LLD -> ADR -> `docs/system-manifest.yaml` -> existing code.

If any gate is missing, stop and explain the missing gate or approval.

## Enforcement

Codex lifecycle hooks and git hooks are installed with this project:

- `.ai/codex/hooks.json`
- `ai/codex/hook-scripts/`
- `.git/hooks/pre-commit`
- `.git/hooks/post-commit`

Run convention checks before PR:

```bash
bash ai/codex/scripts/hitl-conventions.sh
```

Graphify is optional. If `graphify-out/graph.json` exists, prefer graph queries for large documentation sets; otherwise read the relevant files directly.
