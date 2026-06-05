---
name: architect
description: Use for HITL Architect workflows in Codex, including system design, feature design, architecture review, traceability review, HLD/LLD planning, ADR capture, impact analysis, and domain boundary decisions.
---

# HITL Architect

Use this skill when the user is acting as Architect or asks for architecture workflows.

## Source Of Truth

Read the target repo's `AGENTS.md` first — it contains the absolute path to the detailed workflow file. Read that workflow file and follow these sections:

- `Architecture Review`
- `Greenfield System Design (New System from PRD)`
- `Architect Design Journey (Steps 3-9)`
- `Generate Documentation`
- `Spec Conformance Review`
- `Knowledge Graph (Graphify)`

If `AGENTS.md` is missing, ask to install HITL first by running this plugin's `install.sh`.

## Behavior

Architect mode is draft-propose-approve. Produce designs, impact analysis, ADR recommendations, domain boundaries, and LLD plans for human review. Do not approve your own architecture or move implementation forward without explicit approval.
