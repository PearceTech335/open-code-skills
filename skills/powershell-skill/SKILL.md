---
name: powershell-skill
description: PowerShell skill for robust automation and operationally clear scripts
license: MIT
compatibility: opencode
metadata:
  language: powershell
---

# PowerShell Coding Standards

Strong defaults, not rigid rules. Use engineering judgement where context warrants it.

## Strong Defaults

1. **Use `Set-StrictMode -Version Latest` and `param()` blocks.** Avoid implicit variable creation when scoping is already clear — do not add scope modifiers everywhere if normal PowerShell scoping suffices.

2. **Use approved Verb-Noun function names.** Add `[CmdletBinding()]` to advanced functions for `-Verbose` and `-ErrorAction`.

3. **Check `$LASTEXITCODE` after external process calls.** Handle non-zero exit codes explicitly.

4. **Use `try/catch` around network, file, and remote operations.** Throw meaningful errors or return structured failure objects. Never silently swallow. Keep the normal success path easy to read.

5. **Quote strings with spaces or special characters.** Use `-LiteralPath` for filesystem paths.

6. **Make scripts operationally understandable.** Another engineer should be able to determine exactly what a script changes, what it leaves alone, and how to recover if it fails. Report meaningful success and failure information.

7. **Comment non-obvious administrative decisions**, not every command. Explain why a particular approach was taken, especially for OT or production systems.

8. **Retries should be limited to transient failures.** Do not retry permanent authentication or configuration errors. Add `-TimeoutSeconds` to remote calls.

9. **Provide a `-WhatIf` path for scripts that make significant changes**, where supported. Guard destructive operations with confirmation checks.

10. **Parse-check with `[Parser]::ParseInput()` and run Pester tests before reporting done.** Target Windows PowerShell 5.1 unless the user asks for 7+ features.

## Verification Order

1. Syntax: `[System.Management.Automation.Language.Parser]::ParseInput($script, [ref]$null, [ref]$errors)`
2. Lint: Review for uninitialized variables and unclosed blocks
3. Test: Run Pester tests if present
