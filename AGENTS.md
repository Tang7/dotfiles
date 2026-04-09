# General Agent Efficiency Rules
# Works with: Cursor, GitHub Copilot, Claude Code, and any AGENTS.md-aware tool

---

## 1. Agent Behavior Defaults

- Think step by step before writing any code. State the plan first, then execute.
- When the task is ambiguous, ask one clarifying question before proceeding.
  Do not ask multiple questions at once.
- Prefer editing existing code over rewriting it. Preserve surrounding context.
- Never silently skip a subtask. If something is blocked, say why and stop.
- Do not invent API names, file paths, or library functions. If unsure, say so.
- Do not add unrequested features. Implement exactly what was asked.
- Do not remove existing comments, logging, or tests unless explicitly told to.

---

## 2. Before Writing Any Code

Always do these steps first:

1. Read the relevant existing files before touching them.
2. Search for similar patterns already in the codebase and follow them.
3. Identify the narrowest possible change that solves the problem.
4. Check if a test already exists that covers the area being changed.

Rule: search first, then edit. Never write from scratch what already exists nearby.

---

## 3. Code Quality Standards

- Every function must have a single, clear responsibility.
- Function and variable names must make the intent obvious without a comment.
- Avoid deep nesting. Use early returns / guard clauses instead.
- Do not duplicate logic. If a pattern appears twice, extract it.
- Never suppress errors silently (empty catch blocks, unchecked return values).
- Remove all debug code, temporary prints, and TODO stubs before finishing.
- All new public interfaces must have a doc comment explaining purpose and
  parameters.

---

## 4. How to Write a Good Prompt for This Agent

Include these elements for best results:

  WHAT:   What the task is (specific, not vague)
  WHERE:  Which file(s) or function(s) are involved
  WHY:    The reason or constraint driving the change
  HOW:    Any patterns, examples, or conventions to follow
  DONE:   What "done" looks like (test passes, output format, etc.)

Good example:
  "In src/host/pusch_pipeline.cpp, add a null-check for the config pointer
   at the top of run(), following the same pattern used in pdsch_pipeline.cpp.
   Done when the existing unit test suite still passes."

Bad example:
  "Fix the bug in the pipeline."

---

## 5. Task Decomposition Rules

For any task that touches more than 3 files or takes more than ~10 minutes:

- Break it into numbered subtasks before starting.
- Complete and verify each subtask before moving to the next.
- State which subtask you are working on at the start of each step.
- After each subtask, summarize what changed and what comes next.

Do not attempt to complete a large task in a single pass without a stated plan.

---

## 6. Session and Context Management

- Start a new session for each distinct task. Do not carry unrelated context
  between tasks — it degrades output quality.
- When context is approaching its limit, summarize progress and key decisions
  into a handoff note before starting a fresh session.
- Reference specific file paths and line numbers rather than vague descriptions.
  Example: "See src/common/cuda_utils.h:42" not "the utility file."
- If a file is large, specify which section is relevant instead of loading
  the whole file.

---

## 7. Verification Steps (Run After Every Change)

The agent must verify its own output before declaring done:

1. Does the code compile / parse without errors?
2. Do existing tests still pass?
3. Does the change introduce any new linter warnings?
4. Is the diff minimal — only the lines that needed to change?
5. Does the output match the stated "done" condition from the prompt?

If verification fails, fix the issue before reporting completion.
Do not report "done" and leave broken code for the user to discover.

---

## 8. When the Agent Makes a Mistake

- Acknowledge the mistake directly. Do not silently rewrite and pretend
  it did not happen.
- Explain what went wrong in one sentence.
- State the corrected approach before applying it.
- If the same mistake has happened before in this project, note it here
  under "Known Pitfalls" so the rule can be updated.

---

## 9. Commit and Change Discipline

- Every commit must address exactly one logical change.
- Commit message format: Conventional Commits
    feat: add HARQ process timeout guard in pusch_pipeline
    fix: correct LLR buffer offset in ldpc_decode_kernel
    refactor: extract common stream setup into cuda_stream_utils
    test: add BER validation for MCS27 PDSCH path
    docs: update kernel header for ofdm_ifft to match new buffer layout
- Never bundle unrelated fixes into the same commit.
- Do not commit commented-out code.

---

## 10. File and Context Access Discipline

Files the agent should NEVER read or modify:
  - .env, .env.*, secrets.*, credentials.*
  - Any file containing passwords, API keys, or certificates
  - Build artifacts and generated files (build/, dist/, __pycache__/)

Use .cursorignore / .copilotignore to exclude:
  build/
  dist/
  *.o
  *.a
  *.so
  __pycache__/
  .cache/
  test_vectors/*.bin   (large binary reference files)

---

## 11. Rules Maintenance

- Rules are living documentation. Update them when the agent makes
  a repeated mistake — the fix goes into the rule, not just the code.
- When a new pattern is established in the codebase, document it here
  so future sessions follow it automatically.
- Keep each rule short and actionable. A rule that requires interpretation
  is not a good rule — rewrite it until it is unambiguous.
- Add a "Known Pitfalls" section below when a class of mistake has
  been observed more than once.

---

## 12. Known Pitfalls (populate as project grows)

Add entries here in this format:

  [Date] [Area] — What went wrong and what the correct behavior is.

  Example:
  [2025-04] [CUDA kernels] — Agent added cudaDeviceSynchronize inside
  the slot processing loop. This is forbidden on the critical path.
  Synchronize only at slot boundaries. See rules section 5G rules §5.
