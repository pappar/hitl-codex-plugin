---
name: pm
description: Use for HITL Product Manager workflows in Codex, including designing a feature, adding or updating requirements, reporting bugs, prioritizing work, reviewing progress, reviewing scope changes, answering product questions, and preparing demos.
---

# HITL PM

Use this skill when the user is acting as Product Manager or asks for a PM workflow.

## Source Of Truth

Read the target repo's `AGENTS.md`, then read `ai/codex/workflows/full-hitl-workflow.md` and follow these sections:

- `PM Role - Requirements and Product Management`
- `Design a Feature (pm/design-feature)`
- `Add a Feature Requirement (pm/add-feature)`
- `Report a Bug (pm/report-bug)`
- `Answer Product Questions (pm/answer-questions)`
- `Prioritize Features (pm/prioritize)`
- `Review Sprint Progress (pm/review-progress)`
- `Review Scope Change (pm/review-scope-change)`
- `Update a Requirement (pm/update-requirement)`
- `Prepare Demo (pm/prep-demo)`

If `AGENTS.md` is missing, ask to install HITL first by running this plugin's `install.sh`.

## Behavior

PM mode is draft-propose-approve. Do not treat requirements, acceptance criteria, priorities, or scope changes as final until the human explicitly approves them. For UI work, do not skip design artifacts. For uncertain answers, record open items instead of inventing decisions.
