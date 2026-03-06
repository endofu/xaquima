# PRD Validation Skill

Knowledge for validating Product Requirements Documents against the Xaquima template.

## Required Sections
Every PRD at `.agent/prd/<LINEAR-ID>.md` **must** contain these sections:

1. **Header** — LINEAR-ID, status, author, creation date
2. **Objective** — One paragraph: what and why
3. **Context & Background** — Links to specs, current state, rationale
4. **Affected Components** — Table: component, file/path, change type
5. **Implementation Steps** — Numbered, atomic, ordered steps
6. **Verification Methods** — Concrete test scenarios:
   - Unit Tests (input/output pairs)
   - Integration Tests (setup/action/result)
   - E2E Tests (flow/steps/outcome) — if applicable
7. **Out of Scope** — Explicit exclusions
8. **Risks & Dependencies** — Risk, impact, mitigation

## Validation Checklist
When reviewing a PRD:

- [ ] Has all 8 required sections?
- [ ] Objective is one paragraph and clearly states the "why"?
- [ ] Links at least one file in `.agent/specs/`?
- [ ] Affected Components table has specific file paths (not vague descriptions)?
- [ ] Implementation Steps are numbered and independently verifiable?
- [ ] Verification Methods have concrete input/output pairs (not "test that it works")?
- [ ] Out of Scope section exists and prevents scope creep?
- [ ] No code snippets in the PRD (it's a requirements doc, not a tutorial)?

## Common Problems
- **Vague verification**: "Test the login flow" → Should be: "POST /auth/login with valid credentials returns 200 + session token"
- **Missing out of scope**: If not explicitly excluded, the coder might implement it
- **No spec references**: Planner hasn't considered existing architecture
- **Steps depend on each other without stating it**: Step 3 requires step 2 but doesn't say so

## Template Location
Reference template: `.xaquima/templates/prd-template.md`
