# Spec Management Skill

Knowledge for maintaining the living architecture documentation in `.agent/specs/`.

## Purpose
The specs directory is the **permanent memory** of the project. While PRDs are ephemeral (created for a task, deleted after integration), specs persist and evolve. They serve as:
- Context for the Planner when writing PRDs
- Architecture reference for QA when writing tests
- Background knowledge for the Coder when implementing

## File Structure
Each spec file documents **one component or concept**:
```
.agent/specs/
  auth-flow.md          # Authentication system
  database-schema.md    # Database models and relationships
  api-endpoints.md      # REST API contract
  deployment.md         # CI/CD and deployment process
  error-handling.md     # Error handling patterns
```

## Spec File Template
```markdown
# [Component Name]
> Last Updated: [ISO-DATE] | Related Task: [LINEAR-ID]

## Purpose
What this component does and why it exists.

## Architecture
How it works — data flow, interfaces, key abstractions.

## Key Interfaces
```typescript
// Include actual function signatures or API contracts
```

## Integration Points
- [Link to related spec](./related-spec.md) — how they interact

## Decisions & Rationale
- **Decision**: Why this approach was chosen over alternatives

## Known Limitations
- Things that don't work or are tech debt

## Gotchas
- Non-obvious behavior that trips people up
```

## Cross-Referencing
Always use relative markdown links:
```markdown
See [Auth Flow](./auth-flow.md) for authentication details.
The API endpoints documented in [API Spec](./api-endpoints.md) use these models.
```

## When to Create vs Update
- **Update**: The change modifies an existing component that already has a spec
- **Create**: The change introduces a genuinely new component or concept
- **Don't fragment**: Avoid creating a new file for every small change. One spec per logical component.

## Writing Style
- Write for a developer new to the project
- Be concrete, not abstract ("the auth middleware checks JWT tokens" not "the security layer validates credentials")
- Include actual code signatures when they clarify behavior
- Always include the LINEAR-ID that prompted the update
