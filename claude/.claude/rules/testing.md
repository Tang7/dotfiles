# Testing Rules

- Do NOT mock the database — integration tests must hit a real DB
- Unit tests live alongside source files: `foo.ts` → `foo.test.ts`
- Every public function must have at least one test
- Use `describe` blocks to group related cases
- Test names should read as sentences: "returns null when input is empty"
