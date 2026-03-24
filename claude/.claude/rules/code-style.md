# Code Style Rules

- Functional style preferred; avoid `class` unless modeling stateful entities
- Name files after what they do: `date_formatter.ts`, not `utils.ts`
- No catch-all `utils` / `helpers` / `common` files — each module has one responsibility
- Max 200 LOC per file (excluding blank lines, comments, and prompt text)
- Prefer explicit return types on all exported functions
