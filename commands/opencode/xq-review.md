---
description: Review agent work on a specific task (pass LINEAR-ID)
---
Review the agent's work on Linear task **$ARGUMENTS**.

1. Read `.agent/config.md` for project context.
2. Fetch the Linear task $ARGUMENTS — get title, description, status, tags, comments.
3. Based on the status:
   - Plan: Read `.agent/prd/$ARGUMENTS.md`, check against `.xaquima/templates/prd-template.md`.
   - Implement: Show `git diff develop...xq/$ARGUMENTS`, run tests from config.
   - Integrate: Show updated `.agent/specs/` files, verify PRD deleted.
4. Present findings. Ask: **Accept** or **Rework**?
