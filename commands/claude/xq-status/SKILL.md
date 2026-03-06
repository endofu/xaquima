---
name: xq-status
description: Show all active Xaquima tasks with their current status and assigned agents. Use when checking the state of work in progress.
disable-model-invocation: true
argument-hint: "[optional: team-key]"
---
Show the current status of all Xaquima-managed tasks.

## Context
- Project config: @.agent/config.md
- Active worktrees: !`bash .xaquima/scripts/worktree.sh list 2>/dev/null || echo "No worktrees"`
- PM daemon status: !`cat .xaquima/xaquima.pid 2>/dev/null && echo "Running (PID $(cat .xaquima/xaquima.pid))" || echo "Not running"`
- Last PM log entries: !`tail -5 .xaquima/xaquima.log 2>/dev/null || echo "No log file"`

## Instructions
1. Read `.agent/config.md` to get the Linear team key.
2. Query Linear for all issues with the `agent` label.
3. Group them by status (`Plan`, `Implement`, `Integrate`, `Done`).
4. For each task, show:
   - Linear ID and title
   - Current tags (`wip`, `review`, or neither)
   - If `wip`: which agent is likely working (based on status)
   - If a worktree exists for it
5. Display as a clean markdown table.
