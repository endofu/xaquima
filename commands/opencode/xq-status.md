---
description: Show all active Xaquima tasks with their current status and agents
agent: pm
---
Show the current status of all Xaquima-managed tasks.

Context:
- Active worktrees: !`bash .xaquima/scripts/worktree.sh list 2>/dev/null || echo "No worktrees"`
- PM daemon: !`cat .xaquima/xaquima.pid 2>/dev/null && echo "Running" || echo "Not running"`

1. Read `.agent/config.md` to get the Linear team key.
2. Query Linear for all issues with the `agent` label.
3. Group by status (Plan, Implement, Integrate, Done).
4. Show: Linear ID, title, tags (wip/review), active agent, worktree status.
5. Display as a clean markdown table.
