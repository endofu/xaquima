---
name: xq-review
description: Review the work done by an agent on a specific task. Shows the PRD, code diff, and test results. Use when a task has the 'review' tag.
disable-model-invocation: true
argument-hint: "<LINEAR-ID>"
---
Review the agent's work on Linear task **$ARGUMENTS**.

## Context
- Project config: @.agent/config.md

## Instructions
1. Read the Linear task $ARGUMENTS — get the title, description, and all comments.
2. Check which status the task is in (`Plan`, `Implement`, `Integrate`).
3. Based on the status, review the relevant artefacts:

### If in `Plan` (reviewing a PRD):
- Read `.agent/prd/$ARGUMENTS.md`
- Check it against the PRD template in `.xaquima/templates/prd-template.md`
- Verify it has: Objective, Context, Implementation Steps, Verification Methods, Out of Scope
- Present a summary with your assessment

### If in `Implement` (reviewing code):
- Show the git diff: `git diff develop...xq/$ARGUMENTS`
- Read `.agent/prd/$ARGUMENTS.md` for the requirements
- Run tests: read the test command from `.agent/config.md` and execute it
- List files changed and lines added/removed
- Present a summary with your assessment

### If in `Integrate` (reviewing docs):
- Show which `.agent/specs/` files were modified (check recent git log)
- Verify the PRD file was deleted
- Present a summary

4. Present your findings and ask the human: **Accept** (move to next status, remove `review` tag) or **Rework** (remove `review` tag, add feedback comment)?
