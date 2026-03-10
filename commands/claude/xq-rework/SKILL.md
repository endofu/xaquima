---
name: xq-rework
description: Send a reviewed task back for rework by replacing the 'xqm-review' tag with 'xqm-todo' and adding feedback as a comment. Use after reviewing and deciding the work needs changes.
disable-model-invocation: true
argument-hint: "<LINEAR-ID> <feedback>"
---
Send Linear task **$1** back for agent rework.

## Instructions
1. Read `.agent/config.md` for Linear context.
2. Find the Linear issue $1.
3. Change the label from `xqm-review` to `xqm-todo`. (Linear auto-removes the old label if they are in the same label group).
4. Add a comment on the issue with the following feedback:

---
**Rework requested by human reviewer:**

$2

---

5. Confirm the action was taken.

The PM agent will automatically pick up this task on its next polling cycle since it now has the `xqm-todo` tag.
