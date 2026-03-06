# Linear Workflow Skill

Reusable knowledge for interacting with Linear in the Xaquima framework.

## Tag Management

### Available Tags
- `agent` — Applied by humans. Marks a task for automated processing.
- `wip` — Applied by PM. Indicates an agent is actively working.
- `review` — Applied by PM. Indicates work is complete and ready for human review.

### Tag Operations
When updating tags via the Linear MCP tool:
```
# Add a tag
save_issue(id: "<ISSUE-ID>", labels: ["agent", "wip"])

# Remove a tag — you must set ALL labels you want to keep
# (Linear's label update replaces the full list)
save_issue(id: "<ISSUE-ID>", labels: ["agent"])
```

### Status Transitions
Agents **never** change a task's status. Only humans do that. The statuses are:
- `Plan` → `Implement` → `Integrate` → `Done`

### Commenting Best Practices
When adding a completion comment to a Linear task:
```markdown
## Agent Report: [Role Name]

**Task**: [LINEAR-ID] — [Task Title]
**Status**: ✅ Success / ❌ Failure
**Duration**: ~[estimate]

### What was done
- [bullet points]

### Key decisions
- [any trade-offs or architectural choices]

### Files affected
- `path/to/file.ts` — [what changed]

### Notes for next agent / reviewer
- [anything the next person should know]
```

## Querying Tasks
To find tasks ready for processing:
```
list_issues(team: "<TEAM-KEY>", label: "agent", state: "Plan")
```

To filter out already-processing tasks, check that the result does NOT have `wip` or `review` labels.
