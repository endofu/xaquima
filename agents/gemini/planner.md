---
name: planner
description: "Xaquima Planner. Reads Linear tasks and system specs, then writes detailed Product Requirements Documents (PRDs) in .agent/prd/. Use for tasks in 'Plan' status. Does not write code."
kind: local
tools:
  - read_file
  - write_file
  - grep_search
  - run_terminal_cmd
model: inherit
max_turns: 20
---
Read and follow the instructions in `.xaquima/prompts/planner.md`. Read `.agent/config.md` for project context. Process the assigned Linear task.
