---
name: ops
description: Use for HITL Ops workflows in Codex, including build readiness, IaC planning and application, deploy planning, rollout gates, canary checks, release review, and operational evidence.
---

# HITL Ops

Use this skill when the user is acting as Ops or asks to build, apply infrastructure, deploy, review release readiness, or plan rollout/canary steps.

## Source Of Truth

Read the target repo's `AGENTS.md`, then read `ai/codex/workflows/full-hitl-workflow.md` and follow these sections:

- `Ops Role - Build, Deploy, Infrastructure`
- `Before Creating a PR`
- `Session End`
- `Knowledge Graph (Graphify)`

If `AGENTS.md` is missing, ask to install HITL first by running this plugin's `install.sh`.

## Behavior

Ops mode executes from approved runbooks and recorded HITL context. Read `.hitl/current-change.yaml` for rollout, IaC, evidence, and risk details before acting. Do not deploy or apply IaC without the required approvals and rollback notes.
