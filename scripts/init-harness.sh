#!/bin/bash
# Xaquima Harness Binder
# Symlinks harness-specific agent files into the correct directories.
# Supports binding multiple harnesses simultaneously.

set -euo pipefail

FRAMEWORK_DIR=".xaquima"

# --- Harness target directories ---
# Each harness reads agent .md files from a specific path
declare -A HARNESS_AGENT_DIRS
HARNESS_AGENT_DIRS[claude]=".claude/agents"
HARNESS_AGENT_DIRS[gemini]=".gemini/agents"
HARNESS_AGENT_DIRS[opencode]=".opencode/agents"

# Each harness reads commands from a specific path
declare -A HARNESS_CMD_DIRS
HARNESS_CMD_DIRS[claude]=".claude/skills"   # Claude uses skills as commands
HARNESS_CMD_DIRS[gemini]=".gemini/commands"
HARNESS_CMD_DIRS[opencode]=".opencode/commands"

AGENTS=("pm" "planner" "qa" "coder" "integrator")
COMMANDS=("xq-status" "xq-review" "xq-rework" "xq-spec" "xq-health" "xq-context")

symlink_file() {
    local source="$1"
    local target="$2"
    local label="$3"

    if [ ! -e "$source" ]; then
        echo "   ⚠️  Source not found: $source"
        return 1
    fi

    if [ -L "$target" ]; then
        local current_target
        current_target=$(readlink "$target")
        if [[ "$current_target" == *"xaquima"* ]]; then
            echo "   ✅ $label — already linked"
            return 0
        else
            rm "$target"
        fi
    elif [ -e "$target" ]; then
        echo "   ⚠️  $label — exists, backing up to $target.bak"
        mv "$target" "$target.bak"
    fi

    local rel_source
    rel_source=$(python3 -c "import os.path; print(os.path.relpath('$source', '$(dirname "$target")')" 2>/dev/null) \
        || rel_source=$(realpath --relative-to="$(dirname "$target")" "$source" 2>/dev/null) \
        || rel_source="../../$source"

    mkdir -p "$(dirname "$target")"
    ln -s "$rel_source" "$target"
    echo "   ✅ $label — linked"
    return 0
}

bind_harness() {
    local harness="$1"
    local target_dir="${HARNESS_AGENT_DIRS[$harness]}"
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
        if symlink_file "$source_dir/$agent.md" "$target_dir/$agent.md" "$agent.md"; then
            ((linked++))
        fi
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

bind_commands() {
    local harness="$1"
    local target_dir="${HARNESS_CMD_DIRS[$harness]}"
    local source_dir="$FRAMEWORK_DIR/commands/$harness"

    echo ""
    echo "📎 Binding $harness commands..."

    if [ ! -d "$source_dir" ]; then
        echo "   ⚠️  No commands found for $harness"
        return 0
    fi

    local linked=0
    case "$harness" in
        claude)
            # Claude uses skills format: .claude/skills/<name>/SKILL.md
            for cmd in "${COMMANDS[@]}"; do
                local cmd_source="$source_dir/$cmd/SKILL.md"
                local cmd_target="$target_dir/$cmd/SKILL.md"
                if [ -f "$cmd_source" ]; then
                    if symlink_file "$cmd_source" "$cmd_target" "$cmd"; then
                        ((linked++))
                    fi
                fi
            done
            ;;
        gemini)
            # Gemini uses .toml files: .gemini/commands/<name>.toml
            for cmd in "${COMMANDS[@]}"; do
                local cmd_source="$source_dir/$cmd.toml"
                local cmd_target="$target_dir/$cmd.toml"
                if [ -f "$cmd_source" ]; then
                    if symlink_file "$cmd_source" "$cmd_target" "$cmd.toml"; then
                        ((linked++))
                    fi
                fi
            done
            ;;
        opencode)
            # OpenCode uses .md files: .opencode/commands/<name>.md
            for cmd in "${COMMANDS[@]}"; do
                local cmd_source="$source_dir/$cmd.md"
                local cmd_target="$target_dir/$cmd.md"
                if [ -f "$cmd_source" ]; then
                    if symlink_file "$cmd_source" "$cmd_target" "$cmd.md"; then
                        ((linked++))
                    fi
                fi
            done
            ;;
    esac

    echo "   📎 $harness: $linked commands bound."
}

bind_skills() {
    echo ""
    echo "🧠 Binding shared skills..."

    local skills_source="$FRAMEWORK_DIR/skills"
    local linked=0

    if [ ! -d "$skills_source" ]; then
        echo "   ⚠️  No skills directory found"
        return 0
    fi

    # Skills are only natively supported by Claude Code (.claude/skills/)
    # For other harnesses, agents reference skills via .xaquima/skills/ paths directly
    if [[ " ${SELECTED[*]} " == *" claude "* ]]; then
        for skill_dir in "$skills_source"/*/; do
            if [ -d "$skill_dir" ]; then
                local skill_name
                skill_name=$(basename "$skill_dir")
                local skill_source="$skill_dir/SKILL.md"
                local skill_target=".claude/skills/$skill_name/SKILL.md"
                if [ -f "$skill_source" ]; then
                    if symlink_file "$skill_source" "$skill_target" "$skill_name"; then
                        ((linked++))
                    fi
                fi
            fi
        done
        echo "   🧠 $linked skills bound to .claude/skills/"
    else
        echo "   ℹ️  Skills available at $skills_source (agents reference them directly)"
    fi
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
            bind_commands "$harness"
            ;;
        *)
            echo "⚠️  Unknown harness: $harness (expected: claude, gemini, opencode)"
            ;;
    esac
done

# Bind shared skills
bind_skills

echo ""
echo "🚀 Done! Next steps:"
echo "   1. Fill out .agent/config.md with your project details"
echo "   2. Run your CLI harness — agents are now available"
echo "   3. For automated mode: bash $FRAMEWORK_DIR/scripts/start-pm.sh"
