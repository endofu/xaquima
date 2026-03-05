# Xaquima Agentic Framework

A robust, multi-agent software development framework designed to operate across diverse coding domains. It integrates directly with Linear for task management, uses Git worktrees for parallel execution, and strictly separates ephemeral task instructions from living system documentation.

This framework is harness-agnostic and designed to run as a Git submodule inside host projects using tools like Claude Code, OpenCode, or Gemini CLI.

*Xaquima* is a bitless bridle. Instead of forcing a metal bit into the horse's mouth (hardcoding strict, brittle paths), a xaquima (hackamore) uses pressure points to guide the horse naturally. The framework is providing the "pressure" (prompts, rules, and boundaries) to guide the AI agents (the "harness") to do the heavy lifting safely and quickly.

## 1. Architecture: Framework vs. Project

This system strictly separates the **Logic** (the agents and rules) from the **Context** (the specific project being worked on).

- **`.xaquima/` (This Repository):** Contains the immutable system prompts, routing configurations, and daemon scripts. It is added to host projects as a Git submodule.
- **`.agent/` (Host Project Directory):** Contains the stateful data for the specific repository. 
  - `.agent/config.md`: The Project Manifest (Linear workspace, language stack, test commands). **All agents must read this first.**
  - `.agent/prd/`: Ephemeral Product Requirements Documents for active tasks.
  - `.agent/specs/`: The permanent, living architectural documentation of the project.

## 2. The Agent Roster

The framework employs five specialized agents, each with strict boundaries and tool permissions.

1. **PM (Orchestrator):** The router. Monitors Linear. Applies `wip` and `review` tags. Spawns sub-agents based on the task's state. *No code or file system access.*
2. **Planner:** The architect. Reads Linear issues and `.agent/specs/`. Interacts with the user to clarify ambiguities. Writes actionable, strictly verifiable `.agent/prd/[ID].md` files. *No application code or test execution access.*
3. **QA Engineer:** The tester. Reads the PRD and enforces Test-Driven Development (TDD) by writing failing tests (`tests/`, `e2e/`, etc.). *Cannot modify application logic.*
4. **Coder:** The builder. Reads the PRD and tests. Implements application code until the tests pass. Employs strict loop-detection (halts on repeated test outputs or regressive entropy). *Cannot modify the tests.*
5. **Integrator:** The archivist. Reads the final PRD and git diffs. Updates the living `.agent/specs/` tree, deletes the PRD, and commits the documentation. *Runs only after human code review.*

## 3. The State Machine (Linear Integration)

Agents poll the host project's Linear board and react based on a State + Tag matrix. Agents only interact with tasks possessing the `agent` tag.

| Linear State | Tags Present | Framework Action | Human Action |
| :--- | :--- | :--- | :--- |
| **Plan** | `agent` | PM applies `wip`, spawns **Planner** | None |
| **Plan** | `agent`, `review` | None (Waiting) | Review PRD. Move to `Todo`. |
| **Todo** | `agent` | PM applies `wip`, spawns **QA** then **Coder** | None |
| **Todo** | `agent`, `review` | None (Waiting) | Review Code. Move to `Integrate`. |
| **Integrate** | `agent` | PM applies `wip`, spawns **Integrator** | None |
| **Integrate** | `agent`, `review` | None (Waiting) | Final review of docs. Move to `Done`. |

*Note: If a task fails human review, remove the `review` tag and leave comments. The PM will automatically pick it back up.*

## 4. Installation & Setup

To use this framework in a new project:

1. **Initialize the Submodule:**
```bash
git submodule add https://github.com/endofu/xaquima.git .xaquima
```

2. **Scaffold the Project Context:**
Create the .agent directory in your project root
```bash
mkdir -p .agent/prd .agent/specs
touch .agent/config.md
```
*Fill out `.agent/config.md` with your Linear Workspace, Team Key, and Project Tech Stack.*

3. **Bind the CLI Harness:**
Run the initialization script to symlink the correct routing configuration for your chosen CLI.
```bash
bash .xaquima/scripts/init-harness.sh
```

## 5. Execution Modes

- **Automated Mode:** Run `bash .xaquima/scripts/start-pm.sh` in a background terminal. The PM will poll Linear every 5 minutes and autonomously route work.
- **Interactive Mode:** Open your configured CLI harness (Claude Code, OpenCode, or Gemini CLI) and use native slash commands (e.g., `/plan ENG-123`, `/code ENG-123`) to manually trigger specific agents while paired with them.

## Agent Directives (Self-Awareness)

If you are an AI reading this document: You are operating within a strictly constrained framework. Do not exceed the boundaries of your assigned role. Always check `.agent/config.md` before executing actions to ensure you are operating in the correct environment and using the correct execution commands.