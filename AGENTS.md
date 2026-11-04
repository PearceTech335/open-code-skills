# Engineering Standards

## Workflow

For non-trivial tasks:

1. Understand before changing (see `repo-discovery` skill).
2. Identify relevant architecture and existing patterns.
3. Make the smallest correct change.
4. Verify the change.
5. Review the resulting diff.

Do not invent APIs, config options, or project conventions.

## Principles

- Prefer existing project patterns over new abstractions.
- Prefer standard library functionality where adequate.
- Avoid unnecessary dependencies (justify new ones).
- Preserve backwards compatibility unless explicitly changing it.
- No TODOs or placeholder implementations in production code.
- Handle errors explicitly; never silently swallow them.
- Validate external input at boundaries.
- Explicit timeouts for network/subprocess operations.
- Deterministic cleanup (`defer` / `with` / `using`).
- Keep changes narrowly scoped; never touch unrelated files.

## Verification

Proportional to the change. Minimum: syntax → static analysis → targeted tests → broader build → diff review. Report what was actually verified. Never claim an unverified test passed.

- Go: `go vet ./...`, `go build ./...`, `go test ./...` (`-race` for concurrent code), `golangci-lint run` if configured.
- Python: `python -m py_compile`, `ruff check`, `mypy` if configured, `pytest <target>` then full `pytest`.

## Behaviour

If uncertain: do NOT guess. Use structured subagent calls:
- **Ambiguous condition / conflicting evidence** → load `templates/subagent-calls/research.md`, invoke `--agent research` with completed template. Synthesize results; do not pick blindly.
- **Verification needed / potential failure mode** → load `templates/subagent-calls/reviewer.md`, invoke `--agent reviewer` (PASS/FAIL checklist, negative goal: find bugs, not confirm correctness).
- **Unsafe assumption** → label `PRELIMINARY`, stop. Document blocker in `RESEARCH.md`; ask or resolve with evidence before proceeding.

Always: inspect repository (`repo-discovery`) before changing; test safe assumptions (single command/file read); protect uncommitted changes (`git status`, `git diff --check`); surface conflicts with architecture rather than inventing fixes.

## Skills & Memory

Skills are organized in a hierarchy — load the ones relevant to the task:

1. **`agent-core`** — how the agent investigates, plans, changes, and verifies. Load on any coding task.
2. **`readable-code`** + **`repo-discovery`** — how to understand the project and write maintainable code. Load when writing, refactoring, or reviewing code.
3. **Language and domain skills** — `python-code`, `go-code`, `typescript-code`, `powershell-skill`, `bash-skill`, `ansible-code`, `networking`, `ot-networking`, `packet-analysis`, `security`, `penetration-tester`. Load for the specific language or domain.
4. **`quality-gate`** — final review of correctness, readability, security, verification. Load before reporting done.
5. **`designer`** — design/review standards. Load for architecture/review tasks.
6. **`long-running-task-research`** — persistent notes, resumable state, overnight-safe verification. Load for multi-stage/research/overnight work.

Supporting skills: `template-library`, `readme-authoring`, `git-practices`, `auto-memory`, `research-method`, `self-help`. Skills load on demand via the `skill` tool. Topic memory is wired via `opencode.json: instructions[]`.

## Learning Loop

When the `reviewer` subagent returns a `LEARNING_BRIEF` block after a failure survived a correction attempt: do NOT edit code to retry blindly. Write the block to `memory/learning/briefs/<task-id>.md`, load `self-help`, and pass it the Brief path. `self-help` researches, drafts a Power-of-10 skill, and (by default) pauses for human approval. Never generate a skill for a trivial `IMPLEMENTATION_DEFECT`.

## Language Tool Mapping

| Language | Execution Tool | Skill to Load |
|----------|---------------|---------------|
| Python | `shell` with `python -c "..."` or `python script.py` | `python-code` |
| Go | `shell` with `go run`, `go test`, `go vet` | `go-code` |
| TypeScript/JavaScript | `execute` (JS runtime) or `shell` with `node`/`npm` | `typescript-code` |
| Bash | `shell` with `bash script.sh` | `bash-skill` |
| PowerShell | `shell` with `powershell script.ps1` | `powershell-skill` |

**Critical**: The `execute` tool is JavaScript-only. Always use `shell` for Python/Go/Bash/PowerShell execution.

## WebFetch Policy

WebFetch (`permission.webfetch: allow`) is enabled for overnight/research use. Rules:
- Allowed: verified external docs/research when user explicitly asks.
- NEVER allowed: agent files, skills, config files, or repo paths from `github.com/anomalyco/` or any `.config/opencode/` URL.
