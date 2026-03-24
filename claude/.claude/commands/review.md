# /project:review

Review the current PR for correctness, style, and potential issues.

!git diff main...HEAD

Carefully review the above diff. Check for:
1. Logic errors or edge cases
2. Violations of code style rules (see rules/code-style.md)
3. Missing tests for new code
4. Security issues (injection, unvalidated input, exposed secrets)
5. Performance concerns

Provide a structured review with: **Summary**, **Issues** (blocking), **Suggestions** (non-blocking).
