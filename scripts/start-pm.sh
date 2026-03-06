#!/bin/bash
# Xaquima Autonomous PM Daemon
# Runs the PM agent on a polling loop to process Linear tasks.

set -euo pipefail

POLL_INTERVAL="${POLL_INTERVAL:-300}" # 5 minutes (override via env)
CONFIG_FILE=".agent/config.md"
FRAMEWORK_DIR=".xaquima"
LOG_FILE="$FRAMEWORK_DIR/xaquima.log"
PID_FILE="$FRAMEWORK_DIR/xaquima.pid"

# --- Logging ---

log() {
    local timestamp
    timestamp=$(date +"%Y-%m-%dT%H:%M:%S%z")
    echo "[$timestamp] [PM-DAEMON] $*" | tee -a "$LOG_FILE"
}

# --- Graceful Shutdown ---

cleanup() {
    log "Shutting down PM daemon (PID $$)..."
    rm -f "$PID_FILE"
    exit 0
}
trap cleanup SIGINT SIGTERM

# --- Harness Detection / Selection ---

detect_harness() {
    # Check which harness directories have xaquima agents symlinked
    local found=()
    
    if [ -L ".claude/agents/pm.md" ]; then found+=("claude"); fi
    if [ -L ".gemini/agents/pm.md" ]; then found+=("gemini"); fi
    if [ -L ".opencode/agents/pm.md" ]; then found+=("opencode"); fi
    
    echo "${found[*]:-}"
}

select_harness() {
    local available
    available=$(detect_harness)
    
    if [ -z "$available" ]; then
        echo "❌ No harness bound. Run '$FRAMEWORK_DIR/scripts/init-harness.sh' first."
        exit 1
    fi

    echo ""
    echo "Available harnesses: $available"
    echo ""
    echo "Select harness to use for PM daemon:"
    
    local i=1
    local options=()
    for h in $available; do
        echo "  $i) $h"
        options+=("$h")
        ((i++))
    done
    
    echo ""
    read -rp "Select: " choice
    
    local idx=$((choice - 1))
    if [ $idx -ge 0 ] && [ $idx -lt ${#options[@]} ]; then
        echo "${options[$idx]}"
    else
        echo "❌ Invalid choice."
        exit 1
    fi
}

# --- Build CLI Command ---

build_command() {
    local harness="$1"
    
    case "$harness" in
        claude)
            # Claude Code: invoke the PM agent
            echo "claude --agent pm --print --output-format text -p 'Execute the PM orchestration cycle. Check Linear for tasks with the agent tag and process them according to your state machine rules.'"
            ;;
        gemini)
            # Gemini CLI: invoke using the PM agent
            echo "gemini -a pm 'Execute the PM orchestration cycle. Check Linear for tasks with the agent tag and process them according to your state machine rules.'"
            ;;
        opencode)
            # OpenCode: invoke the PM agent
            echo "opencode agent pm 'Execute the PM orchestration cycle. Check Linear for tasks with the agent tag and process them according to your state machine rules.'"
            ;;
        *)
            echo ""
            ;;
    esac
}

# --- Main ---

echo "🐎 Xaquima PM Daemon"
echo "===================="

# Preflight checks
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: $CONFIG_FILE not found. Run init-harness.sh first."
    exit 1
fi

if [ ! -d "$FRAMEWORK_DIR" ]; then
    echo "❌ Error: $FRAMEWORK_DIR not found. Are you in the project root?"
    exit 1
fi

# Check for existing daemon
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "⚠️  PM daemon already running (PID $OLD_PID)."
        echo "   Kill it with: kill $OLD_PID"
        exit 1
    else
        log "Cleaning up stale PID file (PID $OLD_PID no longer running)."
        rm -f "$PID_FILE"
    fi
fi

# Select harness
HARNESS="${1:-}"
if [ -z "$HARNESS" ]; then
    HARNESS=$(select_harness)
fi

CLI_CMD=$(build_command "$HARNESS")
if [ -z "$CLI_CMD" ]; then
    echo "❌ Unknown harness: $HARNESS"
    exit 1
fi

# Write PID file
echo $$ > "$PID_FILE"

log "Starting PM daemon with harness: $HARNESS"
log "Poll interval: ${POLL_INTERVAL}s"
log "CLI command: $CLI_CMD"
log "PID: $$"
log "Log file: $LOG_FILE"

echo ""
echo "🏃 Daemon running. Press Ctrl+C to stop."
echo "   Harness:  $HARNESS"
echo "   Interval: ${POLL_INTERVAL}s"
echo "   Logs:     $LOG_FILE"
echo ""

while true; do
    log "--- Polling cycle start ---"
    
    # Execute the PM agent
    if eval "$CLI_CMD" >> "$LOG_FILE" 2>&1; then
        log "--- Polling cycle complete (success) ---"
    else
        EXIT_CODE=$?
        log "--- Polling cycle complete (exit code: $EXIT_CODE) ---"
    fi
    
    log "Sleeping ${POLL_INTERVAL}s until next cycle..."
    sleep "$POLL_INTERVAL"
done
