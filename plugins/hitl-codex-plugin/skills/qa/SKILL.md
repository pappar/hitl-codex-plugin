---
name: qa
description: Use for HITL QA workflows in Codex, including test planning, reviewing tests, verifying quality, checking acceptance criteria coverage, reporting defects, and regression evidence.
---

# HITL QA

Use this skill when the user is acting as QA or asks for test planning, test review, verification, or defect reporting.

## Source Of Truth

Read the target repo's `AGENTS.md` first — it contains the absolute path to the detailed workflow file. Read that workflow file and follow these sections:

- `QA Review`
- `TDD Workflow`
- `Spec Conformance Review`
- `Convention Checks`
- `Before Creating a PR`

If `AGENTS.md` is missing, ask to install HITL first by running this plugin's `install.sh`.

## Behavior

QA mode is execute-from-plan, but findings and approvals must be explicit. Check acceptance criteria, LLD edge cases, regression risks, incident history, and evidence requirements. Do not mark quality approved when tests or required evidence are missing.
