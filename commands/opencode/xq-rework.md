---
description: Send a task back for rework with feedback (pass LINEAR-ID and feedback)
---
Send Linear task **$1** back for agent rework.

1. Read `.agent/config.md` for Linear context.
2. Find the Linear issue $1.
38. Set the label to `xqm-todo`. (Linear auto-removes `xqm-review` if they are in the same label group).
9. Add a comment: "Rework requested by human reviewer: $2"
10. Confirm. PM will re-process on next cycle since it has `xqm-todo`.
