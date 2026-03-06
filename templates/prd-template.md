# PRD: <LINEAR-ID>

> **Status**: Draft | Review | Approved  
> **Author**: Planner Agent  
> **Created**: <ISO-DATE>  
> **Linear Task**: <LINEAR-ID>

---

## Objective

*One paragraph: What does this task achieve and why is it important?*

---

## Context & Background

*What exists today? Why is this change needed? Link to relevant spec files.*

- Related specs: [Component Name](../../.agent/specs/component-name.md)

---

## Affected Components

| Component | File/Path | Change Type |
|:---|:---|:---|
| *e.g., Auth Middleware* | `src/middleware/auth.ts` | Modify |
| *e.g., User Model* | `src/models/user.ts` | Modify |
| *e.g., Rate Limiter* | `src/middleware/rate-limit.ts` | New |

---

## Implementation Steps

*Numbered, atomic steps. Each step should be independently verifiable. Include the order of operations and dependencies between steps.*

1. **Step one title**: Description of what to do and how.
2. **Step two title**: Description of what to do and how.
3. ...

---

## Verification Methods

### Unit Tests

| Test Case | Input | Expected Output |
|:---|:---|:---|
| *e.g., validates token format* | `"invalid-token"` | `throws AuthError` |
| *e.g., accepts valid JWT* | `validJwt` | `returns { userId: "..." }` |

### Integration Tests

| Test Case | Setup | Action | Expected Result |
|:---|:---|:---|:---|
| *e.g., login flow end-to-end* | *seed test user* | `POST /auth/login` | `200 + valid session` |

### E2E Tests (if applicable)

| Test Flow | Steps | Expected Outcome |
|:---|:---|:---|
| *e.g., user registration* | *1. Open /register, 2. Fill form, 3. Submit* | *Redirect to dashboard, welcome email sent* |

---

## Out of Scope

*Explicitly list what this task does NOT cover. This prevents scope creep by the Coder agent.*

- *e.g., Password reset flow (separate task)*
- *e.g., OAuth integration (future phase)*

---

## Risks & Dependencies

| Risk/Dependency | Impact | Mitigation |
|:---|:---|:---|
| *e.g., Breaking change to API contract* | *Downstream services affected* | *Version the endpoint* |
| *e.g., Requires Redis running* | *Tests won't pass without it* | *Use in-memory mock for unit tests* |
