---
alwaysApply: true
description: "Enforces strict modular code architecture: SRP, no catch-all files, reasonable LOC limit — applies to all languages"
---

<MANDATORY_ARCHITECTURE_RULE severity="BLOCKING" priority="HIGHEST">

# Modular Code Architecture — Zero Tolerance Policy

This rule is NON-NEGOTIABLE. Violations BLOCK all further work until resolved.

## Rule 1: No Catch-All Files — utils / service / helpers are CODE SMELLS

A single `utils`, `helpers`, `service`, or `common` file is a **gravity well** — every unrelated function gets tossed in, and it grows into an untestable, unreviewable blob.

**These file names are BANNED as top-level catch-alls.** Instead:

| Anti-Pattern | Refactor To |
|--------------|-------------|
| `utils` with `formatDate()`, `slugify()`, `retry()` | `date_formatter`, `slugify`, `retry` |
| `service` handling auth + billing + notifications | `auth_service`, `billing_service`, `notification_service` |
| `helpers` with 15 unrelated exports | One file per logical domain |

**Design for reusability from the start.** Each module should be:
- **Independently importable** — no consumer should need to pull in unrelated code
- **Self-contained** — its dependencies are explicit, not buried in a shared grab-bag
- **Nameable by purpose** — the filename alone tells you what it does

If you catch yourself typing `utils`, `helpers`, `service`, or `common`, STOP and name the file after what it actually does.

## Rule 2: Single Responsibility Principle — ABSOLUTE

Every source file MUST have exactly ONE clear, nameable responsibility.

**Self-test**: If you cannot describe the file's purpose in ONE short phrase (e.g., "parses YAML frontmatter", "matches rules against file paths"), the file does too much. Split it.

| Signal | Action |
|--------|--------|
| File has 2+ unrelated exported functions | **SPLIT NOW** — each into its own module |
| File mixes I/O with pure logic | **SPLIT NOW** — separate side effects from computation |
| File has both types and implementation | **SPLIT NOW** — types + implementation |
| You need to scroll to understand the file | **SPLIT NOW** — it's too large |

## Rule 3: Reasonable LOC Limit — CODE SMELL DETECTOR

Any source file exceeding **200 lines of code** (excluding non-logic content — see below) is an **immediate code smell**.

**When you detect a file > 200 LOC**:
1. **STOP** current work
2. **Identify** the multiple responsibilities hiding in the file
3. **Extract** each responsibility into a focused module
4. **Verify** each resulting file is < 200 LOC and has a single purpose
5. **Resume** original work

### How to Count LOC

**Count these** (= actual logic):
- Import / include statements
- Variable / constant declarations
- Function / class / struct / interface / type definitions
- Control flow (`if`, `for`, `while`, `switch`, `try/catch`, `match`, etc.)
- Expressions, assignments, return statements
- Closing braces or `end` keywords that belong to logic blocks

**Exclude these** (= not logic):
- Blank lines
- Comment-only lines (`//`, `/* */`, `#`, `/** */`, `--`, etc.)
- Per-language non-logic content:
  - **Go**: no special exclusions beyond blanks and comments
  - **C++**: content inside raw string literals (`R"(...)"`) used as data/docs
  - **Python**: content inside docstrings (`"""..."""`) used as documentation
  - **TypeScript/JavaScript**: content inside template literals used as prompt/instruction text

**Quick method**: Read the file → subtract blank lines, comment-only lines, and non-logic string content → remaining count = LOC.

When in doubt, **round up** — err on the side of splitting.

## How to Apply

When reading, writing, or editing ANY source file:

1. **Check the file you're touching** — does it violate any rule above?
2. **If YES** — refactor FIRST, then proceed with your task
3. **If creating a new file** — ensure it has exactly one responsibility and stays under 200 LOC
4. **If adding code to an existing file** — verify the addition doesn't push the file past 200 LOC or add a second responsibility. If it does, extract into a new module.

</MANDATORY_ARCHITECTURE_RULE>
