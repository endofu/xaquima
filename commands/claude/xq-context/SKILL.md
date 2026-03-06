---
name: xq-context
description: Dump all the context an agent would receive for a specific Linear task. Use to debug or preview what an agent will work with.
disable-model-invocation: true
argument-hint: "<LINEAR-ID>"
---
Show the full context that an agent would receive for Linear task **$ARGUMENTS**.

## Instructions
1. Read `.agent/config.md` — show the full config.
2. Fetch the Linear task $ARGUMENTS — show title, description, status, tags, all comments.
3. Check if a PRD exists at `.agent/prd/$ARGUMENTS.md`. If yes, show it.
4. Check if a worktree exists at `.worktrees/xq/$ARGUMENTS`. If yes, show:
   - Branch name
   - Last commit
   - Modified files (`git status`)
5. List relevant `.agent/specs/` files (based on any component references in the task or PRD).
6. Based on the task's current Linear status, state which agent would process it next and what that agent's instructions say.

Present everything organized as a clear context dump.
