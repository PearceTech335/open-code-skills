---
name: quality-gate
description: Final review checklist for correctness, readability, security, and verification. Apply after code changes, before reporting done.
license: MIT
compatibility: opencode
metadata:
  priority: high
---

# Quality Gate

Apply this checklist as the final review pass on any code change. This is a reviewer's checklist, not a coding specification — the language skills and `readable-code` define how to write code; this checks whether the result is sound.

## Hard Requirements

These are never negotiable:

1. **No exposed secrets.** No hardcoded keys, tokens, or credentials in code, logs, or error messages.
2. **No unvalidated security-sensitive input.** File paths, network data, and user arguments are validated at trust boundaries.
3. **No silent failure.** Errors are handled at the appropriate boundary — logged with context, translated, or propagated. Never swallowed.
4. **Truthful verification reporting.** Never claim a test passed without running it. Report any checks that could not be performed.
5. **No dead code introduced by the change.** Remove unused variables, imports, or branches that the change created. Do not delete unrelated code.

## Maintainability Review

6. **One clear responsibility per function.** Not a line limit — if a function does one thing with manageable control flow, it is fine. Split when a reader would struggle to hold the logic in their head.
7. **Names explain intent.** A reader can understand variables and functions without tracing every assignment.
8. **No unnecessary abstractions.** No classes, wrappers, helpers, or frameworks introduced without solving a real problem (duplicated logic, meaningful boundary, complex responsibility).
9. **Control flow is easy to follow.** The main execution path is readable top to bottom. No deep nesting that obscures intent.

## Correctness Review

10. **All called functions, commands, and imports exist.** Verified against project definitions, not assumed.
11. **Loops have termination strategies.** Bounded loops, explicit exits, or cancellation handling — whichever fits the context.
12. **Operations with potentially unbounded waits have explicit timeout or cancellation behaviour.** Not every operation needs a timeout — network calls, subprocesses, and lock acquisitions do.
13. **External input is validated at boundaries.** Define what is valid; reject invalid input with an appropriate error.

## Scope Review

14. **The change is the smallest coherent solution.** No unrelated refactoring mixed in.
15. **Existing behaviour and public interfaces are preserved** unless the change explicitly requires otherwise.
16. **The code follows existing project conventions.** No second style introduced.

## When to Invoke

- After generating or modifying any code, in any language.
- Before reporting a task as complete.
- As a final review pass on a diff.
