---
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
description: "TypeScript-specific modular architecture rules: index.ts entry point, template literal LOC exclusion"
---

<MANDATORY_ARCHITECTURE_RULE severity="BLOCKING" priority="HIGHEST">

# TypeScript Modular Architecture — Zero Tolerance Policy

This rule is NON-NEGOTIABLE. Violations BLOCK all further work until resolved.

> General modular rules (SRP, no catch-all files, LOC limit) are defined in `modular-architecture.md` and apply here too.

## Rule: index.ts is an ENTRY POINT, NOT a dumping ground

`index.ts` files MUST ONLY contain:
- Re-exports (`export { ... } from "./module"`)
- Factory function calls that compose modules
- Top-level wiring/registration (hook registration, plugin setup)

`index.ts` MUST NEVER contain:
- Business logic implementation
- Helper/utility functions
- Type definitions beyond simple re-exports
- Multiple unrelated responsibilities mixed together

**If you find mixed logic in index.ts**: Extract each responsibility into its own dedicated file BEFORE making any other changes. This is not optional.

## LOC Counting in TypeScript

Prompt-heavy files (agent definitions, skill definitions) where the bulk of content is template literal prompt text are EXEMPT from the LOC count — but their non-prompt logic must still be < 200 LOC.

**Exclude from LOC count**: lines inside template literals that are prompt/instruction text.

```typescript
// 1  import { foo } from "./foo";          ← COUNT
// 2                                         ← SKIP (blank)
// 3  // Helper for bar                      ← SKIP (comment)
// 4  export function bar(x: number) {       ← COUNT
// 5    const prompt = `                     ← COUNT (declaration)
// 6      You are an assistant.              ← SKIP (prompt text)
// 7      Follow these rules:                ← SKIP (prompt text)
// 8    `;                                   ← COUNT (closing)
// 9    return process(prompt, x);           ← COUNT
// 10 }                                      ← COUNT
```
→ LOC = **5** (lines 1, 4, 5, 8, 9, 10). Not 10.

</MANDATORY_ARCHITECTURE_RULE>
