# Xaquima

A robust, multi-agent software development framework designed to operate across diverse coding domains. It acts as a "hackamore" (xaquima) for AI agents—providing bitless, structural guidance to autonomous workflows without micromanaging the execution.

It integrates directly with Linear, uses Git worktrees for parallel execution, and strictly separates ephemeral task instructions (`.agent/prd/`) from living system documentation (`.agent/specs/`).

## Architecture
- **`.xaquima/` (This Repository):** The logic. Contains immutable system prompts, routing configs, and scripts. Installed as a Git submodule.
- **`.agent/` (Host Project Directory):** The context. Contains the stateful data for the specific repository (`config.md`, `prd/`, `specs/`).

See the internal prompt files for specific agent rules and permissions.
