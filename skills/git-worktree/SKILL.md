# Git Worktree Skill

Reusable knowledge for working with git worktrees in the Xaquima framework.

## Worktree Locations
- Worktrees live at: `.worktrees/xq/<LINEAR-ID>/`
- Branches are named: `xq/<LINEAR-ID>`
- Base branch (default): `develop` (check `.agent/config.md` for overrides)

## Using the Worktree Manager
```bash
# Create a worktree (also creates the branch)
bash .xaquima/scripts/worktree.sh create ENG-123

# Get the path to a worktree
bash .xaquima/scripts/worktree.sh path ENG-123
# Output: .worktrees/xq/ENG-123

# List all active worktrees
bash .xaquima/scripts/worktree.sh list

# Destroy a worktree (preserves the branch)
bash .xaquima/scripts/worktree.sh destroy ENG-123
```

## Working in a Worktree
When an agent is assigned a task with a worktree:
1. The worktree is a full checkout — all git operations work normally
2. Changes are isolated to the feature branch
3. You can run tests, build, and commit from within the worktree
4. The worktree shares `.git/` with the main repo (objects, refs, etc.)

## Committing
Use conventional commit messages:
```bash
git -C .worktrees/xq/ENG-123 add .
git -C .worktrees/xq/ENG-123 commit -m "feat(ENG-123): description of change"
```

## Pushing
```bash
git -C .worktrees/xq/ENG-123 push -u origin xq/ENG-123
```

## Comparing with Base Branch
```bash
git diff develop...xq/ENG-123          # What this branch adds
git log develop..xq/ENG-123 --oneline  # Commits on this branch
```
