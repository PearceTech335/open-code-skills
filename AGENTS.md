# Engineering Standards

The global base layer every project loads. Project setup and the two-layer model:
see README.md. Global rules that a project cannot override: the Checkpoint
Discipline, the Documentation Style (STE-inspired) section, this Workflow, Security/WebFetch
policy, and the language tool mapping.

## Workflow

For non-trivial tasks:

1. Understand before changing (see repo-discovery skill).
2. Identify relevant architecture and existing patterns.
3. Make the smallest correct change.
4. Verify the change.
5. Review the resulting diff.

Do not invent APIs, config options, or project conventions.

## Architectural Governance

The architect sub-agent is responsible for architectural design, discovery, evaluation
and change management.

agent-core should invoke the Architect when:
- Starting a new project or establishing missing architecture documentation.
- Component responsibilities or dependencies are unclear.
- Introducing major components or changing system boundaries.
- Redesigning database schemas or making significant API changes.
- Refactoring across multiple modules.

Do not invoke the Architect for routine bug fixes, isolated function changes or minor
maintenance.

The Architect must:
- Inspect existing implementation before proposing changes.
- Distinguish verified architecture from proposed or intended design.
- Document significant architectural decisions and their rationale.
- Respect approved architecture and existing project constraints.
- Evaluate the impact of proposed dependencies and design changes.

The Architect does not implement routine features or modify production code without
explicit delegation.

Project-level AGENTS.md files may define additional architectural requirements and
invocation criteria.

## Principles

- Prefer existing project patterns over new abstractions.
- Prefer standard library functionality where adequate.
- Avoid unnecessary dependencies (justify new ones).
- Preserve backwards compatibility unless explicitly changing it.
- No TODOs or placeholder implementations in production code.
- Handle errors explicitly; never silently swallow them.
- Validate external input at boundaries.
- Explicit timeouts for network/subprocess operations.
- Deterministic cleanup (defer / with / using).
- Keep changes narrowly scoped; never touch unrelated files.

## Verification

Proportional to the change. Minimum: syntax → static analysis → targeted tests →
broader build → diff review. Report what was actually verified. Never claim an
unverified test passed.

- Go: go vet ./..., go build ./..., go test ./... ( -race for concurrent code),
  golangci-lint run if configured.
- Python: python -m py_compile, ruff check, mypy if configured, pytest <target>
  then full pytest.

Code repetition check: For generated code, ensure identical lines (e.g., imports,
statements) are not repeated without clear purpose. Consolidate into single line with
comment explaining necessity (e.g., # Reconfigured sys.stdout encoding once for UTF-8).

## Behaviour

If uncertain: do NOT guess. Use structured subagent calls, with this hierarchy when
you cannot stop for an answer mid-run:

- Ambiguous condition / conflicting evidence → load templates/subagent-calls/research.md,
  invoke --agent research with completed template. Synthesize results; do not pick blindly.
- Verification needed / potential failure mode → load templates/subagent-calls/review.md,
  invoke --agent review (PASS/FAIL checklist, negative goal: find bugs, not confirm correctness).
- Unsafe assumption → label PRELIMINARY, stop. Document blocker in RESEARCH.md; ask or
  resolve with evidence before proceeding.
- Missing evidence → investigate; never guess.
- Ambiguous implementation → research the missing piece; take the smallest robust change.
- Unverified but reversible → record as PRELIMINARY with evidence; proceed cautiously.
- Architectural or security uncertainty → invoke --agent architect; do not guess through it.
- Irreversible or security-sensitive → BLOCKED; never improvised, even unattended.

Always: inspect repository (repo-discovery) before changing; test safe assumptions
(single command/file read); protect uncommitted changes (git status, git diff --check);
surface conflicts with architecture rather than inventing fixes.

## Documentation Style (STE-inspired)

Applies to human-facing documentation prose (READMEs, docs/, project AGENTS.md prose,
PR notes, runbooks) — not to code, comments, commit messages, chat, or creative/
marketing text.

Write STE-inspired: short sentences (aim ≤20 words per instruction, ≤25 descriptive),
imperative mood for steps, one instruction per sentence, one topic per paragraph, active
voice (passive only when the actor is unknown), conditions before actions, no omitted
sentence parts, vertical lists, one word = one meaning, no noun clusters over three words.

Do NOT claim "STE compliant" or "ASD-STE100 certified" anywhere — full conformance
needs the official standard (Issue 9, free PDF at asd-ste100.org) and its approved
dictionary, applied with professional review. Say "STE-inspired" instead.

Do NOT inline the standard's dictionary or rule text (copyright; CC BY-NC-ND 4.0).

Full ASD-STE100 conformance is opt-in per project. The global config never claims conformance.

Detail + checklist: skills/ste-writing/SKILL.md (load on doc tasks; counts toward the
2-additional-skill cap).

## Test Agent

The test agent performs QA testing of code changes — dynamic verification by execution,
complementing research (discovery) and review (static adversarial review):

- Invoke when functional correctness needs evidence from running tests, not just code
  inspection: after implementation, before reporting done, or when review flags a failure
  mode that only execution can confirm or refute.
- The agent runs the project's test suite on the current changes (targeted tests first,
  then the broader suite), and reports PASS/FAIL per test with file/line, test name, and
  error output for failures — never claiming a test passed unless it actually ran.
- The agent is read-only with respect to source files: it does not modify code. It
  surfaces failures for the implementer (or review for root-cause classification); it does
  not silently swallow or fix them.
- Order of QA: research prepares context → implement → review (static check) → test
  (execution check) → quality-gate (final review).

## Checkpoint Discipline (Critical for Small Models)

Treat the recent-context as ground truth:

- Do NOT re-read files whose contents are already summarized in the checkpoint.
- Do NOT read files that are explicitly marked as "already reviewed" in the checkpoint.
- Only read files that are NOT referenced in the checkpoint or whose content is not fully
  captured.

Checkpoint must preserve:

- Current task/goal with clear acceptance criteria.
- Key file paths and their purpose in the current task.
- Decisions made with reasons (including rejected alternatives).
- Verification commands executed and their observed output.
- Blockers and unresolved issues with severity classification.
- Session state (what was completed, what remains, what's blocked).

Tool Output Management:

- Use offset/limit parameters when reading files (150–200 lines per slice; the
  tool-output cap is 200).
- Grep with line limits (max 100–200 lines) to avoid overwhelming output.
- Never read entire files when only a specific section is needed.
- When using grep, add grep -A 20 -B 5 or similar to get context without bloat.
- The tool-output configuration (max_lines=200, max_bytes=12000) helps prevent ballooning
  but the agent must actively use slicing.

Critical Rule: If the checkpoint already summarizes file content, do NOT read the file
again. This prevents redundant reads that waste context tokens and slow down small models.

## Skills & Memory

Skills are organized in a hierarchy — load the ones relevant to the task. Cap: agent-core
is mandatory and not counted toward the skill cap. Load at most 2 additional skills per
task beyond agent-core. Use subagents/templates/checklists to avoid consuming skill slots.

1. agent-core — how the agent investigates, plans, changes, and verifies. Load on any
   coding task. Includes requirements micro-checklist (always-on) and escalation rules.
2. Understanding/maintainability — readable-code, repo-discovery, project-index. Load
   when writing, refactoring, reviewing code, or when project structure changes.
3. Language and domain skills — python-code, go-code, typescript-code, powershell-skill,
   bash-skill, ansible-code, networking, ot-networking, packet-analysis, security,
   penetration-tester. Load for the specific language or domain (typically 1 additional skill).
4. quality-gate — final review of correctness, readability, security, verification. Load
   before reporting done if not already covered.
5. designer — design/review methodology for components/interfaces (micro/mid-level design).
   Load for component design/interface reviews; not a substitute for architectural governance.
6. architect — subagent (agents/architect.md), invoked via agent-core when architectural
   escalation criteria are met (system boundaries, major deps/schema/cross-module). Not a
   loadable skill slot in the usual sense; use subagent delegation.
7. strategic-engineering — read-only advisor skill for trajectory/debt/systemic issues
   at plan/milestone/recurrent-debt points. Load sparingly (counts toward the 2 additional
   skills cap).
8. long-running-task-research — persistent notes, resumable state, overnight-safe
   verification. Load for multi-stage/research/overnight work.

Supporting skills: template-library, readme-authoring, git-practices, auto-memory,
research-method, self-help, supervisor, test-engineering, root-cause-analysis,
interface-design, production-readiness, network-engineer, ste-writing. Skills load on
demand via the skill tool. Topic memory is wired via opencode.json: instructions[]. For
heavy analysis, prefer subagents (research, review, architect) over loading extra skills.

## Learning Loop

When the review subagent returns a LEARNING_BRIEF block after a failure survived a
correction attempt: do NOT edit code to retry blindly. Write the block to
memory/learning/briefs/<task-id>.md, load self-help, and pass it the Brief path.
self-help researches, drafts a Power-of-10 skill, and (by default) pauses for human
approval. Never generate a skill for a trivial IMPLEMENTATION_DEFECT.

## Language Tool Mapping

| Language | Execution Tool | Skill to Load |
|----------|---------------|---------------|
| Python | shell with python -c "..." or python script.py | python-code |
| Go | shell with go run, go test, go vet | go-code |
| TypeScript/JavaScript | execute (JS runtime) or shell with node/npm | typescript-code |
| Bash | shell with bash script.sh | bash-skill |
| PowerShell | shell with powershell script.ps1 | powershell-skill |

Critical: The execute tool is JavaScript-only. Always use shell for Python/Go/Bash/PowerShell
execution.

## WebFetch Policy

WebFetch (permission.webfetch: allow) is enabled for overnight/research use. Rules:

- Allowed: verified external docs/research when user explicitly asks.
- NEVER allowed: agent files, skills, config files, or repo paths from github.com/anomalyco/
  or any .config/opencode/ URL.