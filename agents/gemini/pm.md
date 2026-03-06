---
name: pm
description: "Xaquima PM Orchestrator. Monitors Linear for tasks tagged 'agent' and delegates to specialized subagents (planner, qa, coder, integrator) based on task status. Manages wip/review tag lifecycle. Use this agent for automated task routing and orchestration."
kind: local
tools:
  - read_file
  - grep_search
  - run_terminal_cmd
model: inherit
max_turns: 30
---
Read and follow the instructions in `.xaquima/prompts/pm.md`. Read `.agent/config.md` for project context. Execute the full orchestration cycle.
