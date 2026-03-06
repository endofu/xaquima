#!/bin/bash
# Xaquima Harness Binder
# Symlinks harness-specific agent files into the correct directories.
# Supports binding multiple harnesses simultaneously.

set -euo pipefail

FRAMEWORK_DIR=".xaquima"

# --- Harness target directories ---
# Each harness reads agent .md files from a specific path
declare -A HARNESS_DIRS
HARNESS_DIRS[claude]=".claude/agents"
HARNESS_DIRS[gemini]=".gemini/agents"
HARNESS_DIRS[opencode]=".opencode/agents"

AGENTS=("pm" "planner" "qa" "coder" "integrator")

bind_harness() {
    local harness="$1"
    local target_dir="${HARNESS_DIRS[$harness]}"
    local source_dir="$FRAMEWORK_DIR/agents/$harness"

    echo ""
    echo "🔗 Binding $harness..."

    if [ ! -d "$source_dir" ]; then
        echo "   ❌ Source directory not found: $source_dir"
        return 1
    fi

    # Create target directory
    mkdir -p "$target_dir"

    local linked=0
    for agent in "${AGENTS[@]}"; do
        local source="$source_dir/$agent.md"
        local target="$target_dir/$agent.md"

        if [ ! -f "$source" ]; then
            echo "   ⚠️  Source not found: $source"
            continue
        fi

        if [ -L "$target" ]; then
            # Already a symlink — check if it points to the right place
            local current_target
            current_target=$(readlink "$target")
            if [[ "$current_target" == *"$source"* ]] || [[ "$current_target" == *"xaquima/agents/$harness/$agent.md"* ]]; then
                echo "   ✅ $agent.md — already linked"
                ((linked++))
                continue
            else
                rm "$target"
            fi
        elif [ -f "$target" ]; then
            echo "   ⚠️  $agent.md — regular file exists, backing up to $target.bak"
            mv "$target" "$target.bak"
        fi

        # Create a relative symlink
        local rel_source
        rel_source=$(python3 -c "import os.path; print(os.path.relpath('$source', '$(dirname "$target")'))" 2>/dev/null) \
            || rel_source="../../$source"
        
        ln -s "$rel_source" "$target"
        echo "   ✅ $agent.md — linked"
        ((linked++))
    done

    # Harness-specific setup
    case "$harness" in
        gemini)
            # Ensure experimental agents are enabled in Gemini settings
            local settings_dir=".gemini"
            local settings_file="$settings_dir/settings.json"
            if [ ! -f "$settings_file" ]; then
                mkdir -p "$settings_dir"
                echo '{ "experimental": { "enableAgents": true } }' > "$settings_file"
                echo "   📝 Created $settings_file with enableAgents: true"
            else
                if ! grep -q "enableAgents" "$settings_file" 2>/dev/null; then
                    echo "   ⚠️  Please add '\"experimental\": { \"enableAgents\": true }' to $settings_file"
                fi
            fi
            ;;
    esac

    echo "   🐎 $harness: $linked/${#AGENTS[@]} agents bound."
}

scaffold_project() {
    echo ""
    echo "📂 Scaffolding project context..."
    mkdir -p .agent/prd .agent/specs
    
    if [ ! -f ".agent/config.md" ]; then
        if [ -f "$FRAMEWORK_DIR/templates/config-template.md" ]; then
            cp "$FRAMEWORK_DIR/templates/config-template.md" ".agent/config.md"
            echo "   ✅ Created .agent/config.md from template"
        else
            touch ".agent/config.md"
            echo "   ✅ Created empty .agent/config.md"
        fi
    else
        echo "   ✅ .agent/config.md already exists"
    fi
    echo "   ✅ .agent/prd/ and .agent/specs/ directories ready"
}

# --- Main ---

echo "🐎 Xaquima Harness Binder"
echo "========================="

# Check we're in a project root with xaquima submodule
if [ ! -d "$FRAMEWORK_DIR" ]; then
    echo "❌ Error: $FRAMEWORK_DIR not found. Run this from your project root."
    exit 1
fi

# Accept harness names as arguments, or prompt interactively
if [ $# -gt 0 ]; then
    SELECTED=("$@")
else
    echo ""
    echo "Select CLI harness(es) to bind (space-separated numbers):"
    echo "  1) Claude Code  → .claude/agents/"
    echo "  2) Gemini CLI   → .gemini/agents/"
    echo "  3) OpenCode     → .opencode/agents/"
    echo "  4) All"
    echo ""
    read -rp "Select: " choices

    SELECTED=()
    for choice in $choices; do
        case "$choice" in
            1) SELECTED+=("claude") ;;
            2) SELECTED+=("gemini") ;;
            3) SELECTED+=("opencode") ;;
            4) SELECTED=("claude" "gemini" "opencode"); break ;;
            *) echo "⚠️  Ignoring invalid choice: $choice" ;;
        esac
    done
fi

if [ ${#SELECTED[@]} -eq 0 ]; then
    echo "❌ No harness selected."
    exit 1
fi

# Scaffold project context
scaffold_project

# Bind each selected harness
for harness in "${SELECTED[@]}"; do
    case "$harness" in
        claude|gemini|opencode)
            bind_harness "$harness"
            ;;
        *)
            echo "⚠️  Unknown harness: $harness (expected: claude, gemini, opencode)"
            ;;
    esac
done

echo ""
echo "🚀 Done! Next steps:"
echo "   1. Fill out .agent/config.md with your project details"
echo "   2. Run your CLI harness — agents are now available"
echo "   3. For automated mode: bash $FRAMEWORK_DIR/scripts/start-pm.sh"
