---
name: typescript-code
description: TypeScript/JavaScript production coding — strict mode, async patterns, error handling, and testing
license: MIT
compatibility: opencode
metadata:
  language: typescript
---

# TypeScript Coding Standards

Strong defaults, not rigid rules. Use engineering judgement where context warrants it.

## Strong Defaults

1. **Enable `strict: true` in tsconfig.** Prefer safe typing. Use `unknown` + type guards over `any`. A type assertion may be justified at a validated boundary where the data has been checked but TypeScript cannot infer the type — isolate and explain it.

2. **Throw `Error` types with context.** Check `err instanceof Error` before accessing `.message`.

3. **Use `async/await` over `.then()` chains.** Flatten nesting. Choose concurrency semantics based on whether partial failure is acceptable: `Promise.all` when all results are required, `Promise.allSettled` when you need to inspect each outcome independently, sequential when operations depend on each other.

4. **Use `AbortController` + `AbortSignal` for cancellable operations.** Pass the signal through `fetch` and event listeners.

5. **Use `node:fs/promises` over callbacks.** Use `node:path` for paths. Use `node:child_process` with `{ stdio: 'pipe', timeout: 30000 }`.

6. **Validate `process.env` access through a config object.** Never assume a value exists.

7. **Test with `describe`/`it` and table-driven patterns (`test.each`).** Mock only at module boundaries. Cover happy path, error paths, and edge cases.

8. **Every async function that can reject must be `await`ed or have `.catch()`.** No unhandled rejections.

9. **Prefer type guards over `as T` assertions.** Use `as const` for literal types. Use `satisfies` where applicable.

10. **Run `npx tsc --noEmit`, lint, and tests before reporting done.** Report what was actually verified.

## Verification Order

1. Typecheck: `npx tsc --noEmit`
2. Lint: `npx eslint .` or `biome check`
3. Test: `npx vitest run` or `npx jest`
4. Build: `npx tsc` or project build script
