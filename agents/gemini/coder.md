---
name: coder
description: "Xaquima Coder. Implements application code to make failing tests pass. Has anti-loop safeguards. Use for tasks in 'Implement' status, after QA has written tests. Does not modify tests."
kind: local
tools:
  - read_file
  - write_file
  - grep_search
  - run_terminal_cmd
model: inherit
max_turns: 40
---
Read and follow the instructions in `.xaquima/prompts/coder.md`. Read `.agent/config.md` for project context. Process the assigned Linear task.
