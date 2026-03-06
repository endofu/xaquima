---
description: Check Xaquima framework health — daemon, config, worktrees, logs
---
Run a health check on the Xaquima framework.

Context:
- PM PID: !`cat .xaquima/xaquima.pid 2>/dev/null || echo "NO_PID"`
- PM process: !`ps -p $(cat .xaquima/xaquima.pid 2>/dev/null || echo 0) 2>/dev/null || echo "NOT_RUNNING"`
- Last log: !`tail -5 .xaquima/xaquima.log 2>/dev/null || echo "NO_LOG"`
- Worktrees: !`bash .xaquima/scripts/worktree.sh list 2>/dev/null || echo "NONE"`
- Harnesses: !`ls .claude/agents/pm.md .gemini/agents/pm.md .opencode/agents/pm.md 2>/dev/null || echo "NONE"`

Report on: daemon status, harness binding, config validity, active work, docs, issues.
