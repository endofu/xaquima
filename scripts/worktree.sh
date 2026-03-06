#!/bin/bash
# Xaquima Git Worktree Manager
# Usage: worktree.sh <command> <LINEAR-ID>

set -euo pipefail

WORKTREE_BASE=".worktrees/xq"
BRANCH_PREFIX="xq"

# Resolve base branch from .agent/config.md (default: develop)
get_base_branch() {
    if [ -f ".agent/config.md" ]; then
        local branch
        branch=$(grep -A1 "Base Branch" .agent/config.md 2>/dev/null | tail -1 | sed 's/.*`\(.*\)`.*/\1/' | tr -d '[:space:]')
        if [ -n "$branch" ] && [ "$branch" != "---" ]; then
            echo "$branch"
            return
        fi
    fi
    echo "develop"
}

cmd_create() {
    local task_id="$1"
    local worktree_path="$WORKTREE_BASE/$task_id"
    local branch_name="$BRANCH_PREFIX/$task_id"
    local base_branch
    base_branch=$(get_base_branch)

    if [ -d "$worktree_path" ]; then
        echo "⚠️  Worktree already exists: $worktree_path"
        echo "   Branch: $branch_name"
        exit 0
    fi

    echo "🌿 Creating worktree for $task_id..."
    
    # Ensure base branch is up to date
    git fetch origin "$base_branch" 2>/dev/null || true
    
    # Create branch if it doesn't exist
    if git show-ref --verify --quiet "refs/heads/$branch_name" 2>/dev/null; then
        echo "   Branch $branch_name already exists, using it."
        git worktree add "$worktree_path" "$branch_name"
    else
        echo "   Creating new branch $branch_name from $base_branch."
        git worktree add -b "$branch_name" "$worktree_path" "origin/$base_branch" 2>/dev/null \
            || git worktree add -b "$branch_name" "$worktree_path" "$base_branch"
    fi

    echo "✅ Worktree created:"
    echo "   Path:   $worktree_path"
    echo "   Branch: $branch_name"
}

cmd_destroy() {
    local task_id="$1"
    local worktree_path="$WORKTREE_BASE/$task_id"
    local branch_name="$BRANCH_PREFIX/$task_id"

    if [ ! -d "$worktree_path" ]; then
        echo "⚠️  No worktree found at $worktree_path"
        exit 1
    fi

    echo "🗑️  Removing worktree for $task_id..."
    git worktree remove "$worktree_path" --force
    
    echo "✅ Worktree removed: $worktree_path"
    echo "   Branch $branch_name preserved (delete manually if needed)."
}

cmd_list() {
    echo "🌿 Active Xaquima Worktrees:"
    echo ""
    
    if [ ! -d "$WORKTREE_BASE" ]; then
        echo "   (none)"
        exit 0
    fi

    local found=false
    for dir in "$WORKTREE_BASE"/*/; do
        if [ -d "$dir" ]; then
            local task_id
            task_id=$(basename "$dir")
            local branch
            branch=$(git -C "$dir" branch --show-current 2>/dev/null || echo "unknown")
            local last_commit
            last_commit=$(git -C "$dir" log -1 --format="%ar — %s" 2>/dev/null || echo "no commits")
            echo "   📁 $task_id"
            echo "      Branch: $branch"
            echo "      Last:   $last_commit"
            echo ""
            found=true
        fi
    done

    if [ "$found" = false ]; then
        echo "   (none)"
    fi
}

cmd_path() {
    local task_id="$1"
    local worktree_path="$WORKTREE_BASE/$task_id"

    if [ -d "$worktree_path" ]; then
        echo "$worktree_path"
    else
        echo "❌ No worktree found for $task_id" >&2
        exit 1
    fi
}

# --- Main ---

usage() {
    echo "Usage: $(basename "$0") <command> [LINEAR-ID]"
    echo ""
    echo "Commands:"
    echo "  create  <ID>   Create a worktree and branch for a task"
    echo "  destroy <ID>   Remove a worktree (preserves the branch)"
    echo "  list           Show all active worktrees"
    echo "  path    <ID>   Print the worktree path for a task"
    echo ""
    echo "Worktrees are created at: $WORKTREE_BASE/<ID>"
    echo "Branches are named: $BRANCH_PREFIX/<ID>"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

COMMAND="$1"
TASK_ID="${2:-}"

case "$COMMAND" in
    create)
        [ -z "$TASK_ID" ] && { echo "❌ Error: LINEAR-ID required."; exit 1; }
        cmd_create "$TASK_ID"
        ;;
    destroy)
        [ -z "$TASK_ID" ] && { echo "❌ Error: LINEAR-ID required."; exit 1; }
        cmd_destroy "$TASK_ID"
        ;;
    list)
        cmd_list
        ;;
    path)
        [ -z "$TASK_ID" ] && { echo "❌ Error: LINEAR-ID required."; exit 1; }
        cmd_path "$TASK_ID"
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        usage
        exit 1
        ;;
esac
