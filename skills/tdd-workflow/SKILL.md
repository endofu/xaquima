# TDD Workflow Skill

Knowledge for implementing Test-Driven Development in the Xaquima framework.

## The TDD Cycle
1. **QA writes tests** → Tests must FAIL (proving they test non-existent behavior)
2. **Coder implements** → Tests must PASS
3. **Both agents** → Never cross the boundary (QA doesn't write code, Coder doesn't modify tests)

## Writing Good Failing Tests

### Unit Tests
- Test one thing per test case
- Use clear naming: `test_<function>_<scenario>_<expected>`
- Mock external dependencies (DB, APIs, file system)
- Assert specific values, not just "truthy/falsy"

### Integration Tests
- Test component interactions
- Set up and tear down test state explicitly
- Use in-memory databases or test fixtures where possible
- Test both happy path and error paths

### E2E Tests
- Test complete user flows
- Use deterministic test data (seeds, fixtures)
- Don't depend on external services in CI (mock them)
- Test the critical path first

## Test File Organization
Check `.agent/config.md` for project conventions. Common patterns:
```
tests/
  unit/
    <module>/<function>.test.ts
  integration/
    <feature>.integration.test.ts
  e2e/
    <flow>.e2e.test.ts
```

## Anti-Loop Safeguards (Coder)
When implementing code to pass tests:
1. **Baseline**: Record the initial failing test count
2. **After each change**: Run tests, compare to previous count
3. **Regression**: If MORE tests fail → revert immediately
4. **Repetition**: If SAME failures twice → stop and rethink approach
5. **Attempt limit**: After 6 distinct approaches → push and ask for help

## Test Commands
Always read from `.agent/config.md`. Never assume the test framework. Common:
```bash
npm test                    # Node.js
pytest                      # Python
go test ./...               # Go
cargo test                  # Rust
```
