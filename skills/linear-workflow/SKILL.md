# Linear Workflow Skill

Reusable knowledge for interacting with Linear in the Xaquima framework.

## Tag Management

### Available Tags (Xaquima Label Group)

The workflow relies on three distinct labels mapped to the `Xaquima` label group in Linear. Because they are in a label group, they act as radio buttons — an issue can only have ONE of these labels at a time. Applying one automatically removes the others.

- `xqm-todo` — Applied by humans. Marks a task for automated processing.
- `xqm-wip` — Applied by PM. Indicates an agent is actively working.
- `xqm-review` — Applied by PM. Indicates work is complete and ready for human review.

### Tag Operations
When updating tags via the Linear MCP tool, you only need to push the new tag since the group ensures mutual exclusivity:
```
# Add wip tag (auto-removes xqm-todo or xqm-review)
save_issue(id: "<ISSUE-ID>", labels: ["xqm-wip"])
```

### Blocking Dependencies
When processing issues labeled `xqm-todo`, you **must** check for dependencies. 
If an issue has incomplete blocking issues (issues in `blocks`), it must be skipped. Ensure you review the `blockedBy` or relation properties to ensure it's not waiting on another incomplete ticket.

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
list_issues(team: "<TEAM-KEY>", label: "xqm-todo", state: "Plan")
```

To filter out already-processing tasks, check that the result does NOT have `xqm-wip` or `xqm-review` labels (which is naturally guaranteed if they are strictly in the `xqm-todo` state due to the label group radio button logic).
Make sure to always skip unblocked items!
