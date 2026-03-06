---
description: "Xaquima PM Orchestrator. Monitors Linear for tasks tagged 'agent' and delegates to specialized subagents (planner, qa, coder, integrator) based on task status. Manages wip/review tag lifecycle."
mode: subagent
tools:
  write: false
  edit: false
  bash: true
---
Read and follow the instructions in `.xaquima/prompts/pm.md`. Read `.agent/config.md` for project context. Execute the full orchestration cycle.
