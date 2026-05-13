# HITL Codex Plugin

Codex plugin for the HITL AI-Driven Development workflow.

This repo is a small Codex marketplace containing one plugin:

```text
plugins/hitl-codex-plugin
```

The plugin installs HITL project instructions, Codex lifecycle hooks, git hooks, convention checks, role skills, templates, and optional Graphify support into a target repository.

## Install

Add this repo as a Codex marketplace:

```bash
codex plugin marketplace add /path/to/hitl-codex-plugin
```

Then install HITL into a target git repo:

```bash
bash /path/to/hitl-codex-plugin/plugins/hitl-codex-plugin/install.sh /path/to/target-repo
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
