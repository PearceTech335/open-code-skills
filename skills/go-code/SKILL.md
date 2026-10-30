---
name: go-code
description: Go production coding — error handling, concurrency, and testing standards
license: MIT
compatibility: opencode
metadata:
  language: go
---

# Go Coding Standards

Strong defaults, not rigid rules. Use engineering judgement where context warrants it.

## Strong Defaults

1. **Wrap errors with `fmt.Errorf("context: %w", err)`.** Use `errors.Is` / `errors.As` for inspection — never compare error strings.

2. **Handle errors at the appropriate boundary.** No silent discards. If you intentionally ignore an error, add a comment explaining why.

3. **Accept `context.Context` as the first argument in every I/O or network function.** Propagate to downstream calls. Check `ctx.Err()` in long loops.

4. **Keep functions cohesive.** One clear responsibility. Thin `main()`, logic in `internal/`. A longer function is fine if it is one linear procedure.

5. **Use table-driven tests for non-trivial functions.** One table, one loop, one `t.Run` per case. Include error cases.

6. **Define interfaces at the point of use** — consumer side, 1–3 methods max. Accept interfaces, return concrete types.

7. **Protect shared state with `sync.Mutex` or `sync.RWMutex`.** Prefer channels over shared memory. Use the simplest concurrency pattern that correctly manages cancellation, errors, and goroutine lifetimes — `errgroup` when you need coordinated cancellation and error propagation, not as a default for every concurrent task.

8. **Never panic in a library.** Panic only in `main()` for unrecoverable startup failures. Return errors instead.

9. **Leave the build clean.** No unused imports, variables, or dead code.

10. **Run `go vet ./...`, `go build ./...`, and `go test ./...` before reporting done.** Add `-race` for concurrent code.

## Verification Order

1. Vet: `go vet ./...`
2. Build: `go build ./...`
3. Test: `go test ./...` (`-race` for concurrent code)
4. Lint: `golangci-lint run` if configured
