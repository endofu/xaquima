---
name: xq-health
description: Check the health of the Xaquima framework — daemon status, stale tasks, worktree state, and configuration validity.
disable-model-invocation: true
---
Run a health check on the Xaquima framework.

## Dynamic Context
- PM daemon PID file: !`cat .xaquima/xaquima.pid 2>/dev/null || echo "NO_PID_FILE"`
- PM daemon process: !`ps -p $(cat .xaquima/xaquima.pid 2>/dev/null || echo 0) -o pid,etime,command 2>/dev/null || echo "NOT_RUNNING"`
- Last 10 log entries: !`tail -10 .xaquima/xaquima.log 2>/dev/null || echo "NO_LOG_FILE"`
- Active worktrees: !`bash .xaquima/scripts/worktree.sh list 2>/dev/null || echo "SCRIPT_ERROR"`
- Config file exists: !`test -f .agent/config.md && echo "YES" || echo "NO"`
- PRD files: !`ls .agent/prd/ 2>/dev/null || echo "EMPTY"`
- Spec files: !`ls .agent/specs/ 2>/dev/null || echo "EMPTY"`
- Harness symlinks: !`ls -la .claude/agents/pm.md .gemini/agents/pm.md .opencode/agents/pm.md 2>/dev/null || echo "NO_HARNESS_BOUND"`

## Instructions
Present a health report covering:

1. **PM Daemon**: Running/stopped, PID, uptime, last activity
2. **Harness Binding**: Which harnesses are set up
3. **Configuration**: Is `.agent/config.md` present and populated?
4. **Active Work**: Any worktrees? Any WIP tasks stuck?
5. **Documentation**: How many spec files exist?
6. **Issues**: Flag any problems found (stale PIDs, missing files, etc.)

Format as a clean status dashboard.
