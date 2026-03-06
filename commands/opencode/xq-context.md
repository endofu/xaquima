---
description: Show full agent context for a task (pass LINEAR-ID)
---
Dump all context for Linear task **$ARGUMENTS**.

1. Read @.agent/config.md — show the config.
2. Fetch the Linear task $ARGUMENTS — show title, description, status, tags, comments.
3. Check if PRD exists at `.agent/prd/$ARGUMENTS.md`. If yes, show it.
4. Check if worktree exists at `.worktrees/xq/$ARGUMENTS`. If yes, show branch, last commit, status.
5. List relevant `.agent/specs/` files.
6. State which agent would process this task next.
