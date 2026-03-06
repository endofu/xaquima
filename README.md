# Xaquima Agentic Framework

A multi-agent software development framework designed to operate across diverse coding harnesses. It integrates with Linear for task management, uses Git worktrees for parallel execution, and strictly separates ephemeral task instructions from living system documentation.

This framework is harness-agnostic and designed to run as a Git submodule inside host projects using tools like **Claude Code**, **Gemini CLI**, or **OpenCode**.

*Xaquima* is a bitless bridle. Instead of forcing a metal bit into the horse's mouth (hardcoding strict, brittle paths), a xaquima (hackamore) uses pressure points to guide the horse naturally. The framework provides the "pressure" (prompts, rules, and boundaries) to guide the AI agents (the "harness") to do the heavy lifting safely and quickly.

---

## 1. Architecture: Framework vs. Project

This system strictly separates the **Logic** (the agents and rules) from the **Context** (the specific project being worked on).

### `.xaquima/` (This Repository)
Added to host projects as a Git submodule. Contains:
- `prompts/` — Shared agent prompts (the "brains" of each role)
- `agents/` — Harness-specific agent wrappers (`claude/`, `gemini/`, `opencode/`)
- `scripts/` — Automation scripts (init, worktree, PM daemon)
- `templates/` — Project scaffolding templates (config, PRD)

### `.agent/` (Host Project Directory)
Contains the stateful data for the specific repository:
- `.agent/config.md` — Project manifest (Linear workspace, tech stack, test commands). **All agents read this first.**
- `.agent/prd/` — Ephemeral Product Requirements Documents for active tasks.
- `.agent/specs/` — Permanent, living architectural documentation of the project.

---

## 2. The Agent Roster

The framework employs five specialized agents, each with strict boundaries and tool permissions.

| Agent | Role | Can Write | Cannot Touch |
|:---|:---|:---|:---|
| **PM** | Orchestrator — monitors Linear, manages tags, delegates to subagents | Linear tags/comments | Code, tests, docs |
| **Planner** | Architect — reads tasks/specs, writes PRDs | `.agent/prd/` | Code, tests, specs |
| **QA** | Tester — reads PRDs, writes failing tests (TDD) | Test files | Application code |
| **Coder** | Builder — implements code to pass tests, has anti-loop safeguards | Application code | Test files |
| **Integrator** | Archivist — updates `.agent/specs/`, deletes PRDs | `.agent/specs/` | Application code |

Each agent's full instructions are in `prompts/`. Harness-specific wrappers with tool permissions are in `agents/`.

---

## 3. The State Machine (Linear Integration)

Agents poll the host project's Linear board and react based on a **State + Tag** matrix. Agents only interact with tasks possessing the `agent` tag.

| Linear State | Tags Present | Framework Action | Human Action |
|:---|:---|:---|:---|
| **Plan** | `agent` | PM adds `wip`, delegates to **Planner** | None |
| **Plan** | `agent`, `review` | None (waiting) | Review PRD. Move to `Implement`. |
| **Implement** | `agent` | PM adds `wip`, creates worktree, delegates **QA** → then **Coder** | None |
| **Implement** | `agent`, `review` | None (waiting) | Review code. Move to `Integrate`. |
| **Integrate** | `agent` | PM adds `wip`, delegates to **Integrator** | None |
| **Integrate** | `agent`, `review` | None (waiting) | Final review. Move to `Done`. |

### Tag Lifecycle
- **`agent`** — Marks a task for agent processing. Applied by human.
- **`wip`** — Applied by PM immediately before delegating. Prevents re-processing. Removed by PM when subagent returns.
- **`review`** — Applied by PM after successful subagent run. Signals human review needed.

> If a task fails human review, remove the `review` tag and leave comments. The PM will automatically pick it back up.

### Crash Recovery
On each polling cycle, the PM scans for tasks stuck with `wip` (no activity for 30+ minutes) and clears the tag for re-processing.

---

## 4. Git Worktree Workflow

Implementation work happens in isolated git worktrees. Each task gets its own working directory and branch:

```
.worktrees/xq/<LINEAR-ID>/    ← isolated checkout
xq/<LINEAR-ID>                ← feature branch
```

Managed by `.xaquima/scripts/worktree.sh`:

```bash
bash .xaquima/scripts/worktree.sh create ENG-123   # Create worktree + branch
bash .xaquima/scripts/worktree.sh list              # Show active worktrees
bash .xaquima/scripts/worktree.sh path ENG-123      # Print worktree path
bash .xaquima/scripts/worktree.sh destroy ENG-123   # Clean up worktree
```

---

## 5. Installation & Setup

### 1. Initialize the Submodule
```bash
git submodule add https://github.com/endofu/xaquima.git .xaquima
```

### 2. Bind the CLI Harness(es)
Run the initialization script to set up your chosen harness(es). This creates the agent symlinks and scaffolds `.agent/`.

```bash
# Interactive mode (prompts for harness selection)
bash .xaquima/scripts/init-harness.sh

# Direct mode (bind specific harnesses)
bash .xaquima/scripts/init-harness.sh claude
bash .xaquima/scripts/init-harness.sh claude gemini  # bind multiple
```

This script:
- Symlinks agent `.md` files to the correct harness directory
- Scaffolds `.agent/prd/`, `.agent/specs/`, and `.agent/config.md`
- For Gemini CLI: enables experimental agents in `settings.json`

### 3. Configure Your Project
Edit `.agent/config.md` with your Linear workspace, tech stack, and test commands.
A template with all fields is at `.xaquima/templates/config-template.md`.

---

## 6. Execution Modes

### Automated Mode
Run the PM daemon in a background terminal. It polls Linear and autonomously routes work.

```bash
# Interactive harness selection
bash .xaquima/scripts/start-pm.sh

# Direct harness selection
bash .xaquima/scripts/start-pm.sh claude

# Custom poll interval (in seconds, default: 300)
POLL_INTERVAL=120 bash .xaquima/scripts/start-pm.sh gemini
```

The daemon writes logs to `.xaquima/xaquima.log` and its PID to `.xaquima/xaquima.pid`.

### Interactive Mode
Open your configured CLI harness and work with agents directly:

- **Claude Code**: Agents are auto-delegated based on context, or invoked explicitly by name.
- **Gemini CLI**: Reference agents by name in your prompts.
- **OpenCode**: Use `@agent-name` to invoke specific agents.

---

## 7. Project Structure

```
your-project/
├── .xaquima/               ← Git submodule (this repo)
│   ├── prompts/            ← Shared agent instructions
│   │   ├── pm.md
│   │   ├── planner.md
│   │   ├── qa.md
│   │   ├── coder.md
│   │   └── integrator.md
│   ├── agents/             ← Harness-specific wrappers
│   │   ├── claude/         ← .claude/agents/ symlink targets
│   │   ├── gemini/         ← .gemini/agents/ symlink targets
│   │   └── opencode/       ← .opencode/agents/ symlink targets
│   ├── scripts/
│   │   ├── init-harness.sh ← Setup script
│   │   ├── start-pm.sh     ← PM daemon
│   │   └── worktree.sh     ← Git worktree manager
│   └── templates/
│       ├── config-template.md
│       └── prd-template.md
├── .agent/                 ← Project-specific context
│   ├── config.md           ← Project manifest
│   ├── prd/                ← Active PRDs
│   └── specs/              ← Living architecture docs
├── .worktrees/xq/          ← Git worktrees (auto-created)
└── .claude/agents/ → .xaquima/agents/claude/  ← Symlinks
```

---

## Linear Setup Requirements

Your Linear team needs the following custom statuses:
- **Plan** — For tasks needing PRDs
- **Implement** — For tasks ready for TDD + coding
- **Integrate** — For tasks needing documentation integration

And the following labels:
- **`agent`** — Marks a task for automated processing
- **`wip`** — (auto-managed) Agent is currently working
- **`review`** — (auto-managed) Ready for human review

---

## Agent Directives (Self-Awareness)

If you are an AI reading this document: You are operating within a strictly constrained framework. Do not exceed the boundaries of your assigned role. Always check `.agent/config.md` before executing actions to ensure you are operating in the correct environment and using the correct execution commands.