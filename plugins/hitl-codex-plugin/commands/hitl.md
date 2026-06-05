---
description: Run a HITL AI-Driven Development workflow. Pass a role or action as argument — e.g. /hitl developer, /hitl architect, /hitl apply-change, /hitl ta-approve, /hitl pm, /hitl qa, /hitl ops.
---

# HITL Workflow

## Preflight

1. **Locate workflow file** — Read `AGENTS.md` in the project root. Extract the absolute path listed under `Detailed workflow:`. If `AGENTS.md` is missing, stop:
   > "HITL is not installed in this repo. Run `bash <plugin-root>/install.sh .` to install it."

2. **Check HITL context** (for implementation workflows) — If `$ARGUMENTS` is `developer`, `apply-change`, `tdd`, `check-conventions`, or `generate-docs`, verify `.hitl/current-change.yaml` exists. If not, say so and offer to run the Change Initialization workflow first.

## Route by argument

Read `$ARGUMENTS` and route to the matching section of the workflow file:

| `$ARGUMENTS` | Workflow section to follow |
|---|---|
| *(empty)* | Ask: "Which role are you playing? PM / Technical Advisor / Architect / Developer / QA / Ops" — then route below |
| `pm` | `PM Role — Requirements and Product Management` |
| `architect` or `architect-design-feature` | `Architect Design Journey (Steps 3–9)` |
| `architect-design-system` | `Greenfield System Design (New System from PRD)` |
| `architect-review` | `Architecture Review` |
| `architect-review-code` | `Architect Code Review (Step 19a)` |
| `developer` or `dev` | `Developer Role` |
| `apply-change` | `Change Initialization` |
| `tdd` | `TDD Workflow` |
| `ta-approve` | `TA Gate Approval` |
| `qa` | `QA Review` |
| `ops` or `ops-build` | `Ops Role — Build, Deploy, Infrastructure` |
| `check-conventions` | `Convention Checks` |
| `generate-docs` | `Generate Documentation` |
| `review-lld-adherence` | `Review LLD Adherence` |
| `impact-brief` | `Session End` (downstream impact section) |
| `conclude` | `Team Decision Documentation (conclude)` |
| `install` | Run `bash <plugin-root>/install.sh .` in the current directory |

If the argument does not match any row, say:
> "Unknown HITL action: `$ARGUMENTS`. Try: pm, architect, developer, apply-change, tdd, ta-approve, qa, ops, check-conventions, generate-docs, review-lld-adherence, conclude, install."

## Execute

Once the section is identified:

1. Read the workflow file at the path from `AGENTS.md`.
2. Find the matching section heading.
3. Follow the instructions in that section exactly — including all STOP gates, gate checklist questions, and GitHub issue comment requirements.
4. Do not skip phases or self-approve gates. If a gate requires TA approval, stop and say so explicitly.

## Summary

After completing the workflow section (or reaching a gate stop), output:

```
## HITL — [section name]

**Status:** [completed / stopped at gate / blocked]
**Change:** [change_id from .hitl/current-change.yaml, or "not initialized"]
**Next step:** [what happens next — e.g., TA runs /hitl ta-approve, developer runs /hitl tdd]
```

## Next steps

- If stopped at a design gate → "The TA should run `/hitl ta-approve` to review and advance the gate."
- If `apply-change` complete → "Run `/hitl architect` to begin the design phase, or `/hitl tdd` if design is already approved."
- If `tdd` complete → "Run `/hitl check-conventions` before opening the PR."
- If `check-conventions` passes → "Open the PR. Run `/hitl review-lld-adherence` for a final LLD conformance check."
