# Research Subagent Invocation Template (Unified)

Use this template when invoking the `research` subagent (`--agent research`) because you **don't know enough to make a good decision**. The task is: investigate, research (including online if explicitly allowed per policy), document references, adversarially review findings, and present the **most robust, critiqued implementation/finding** aligned with this framework.

This template covers both focused investigation and broader/ambiguous problems. If the question is vague, decompose into sub-questions first (see below).

---

You are a subagent spawned by another session.
Load the `research-method` skill first (evidence-first, self-critique, cross-check, label claims). This is a READ-ONLY investigation. Your job is to produce a robust, critiqued answer — not just a summary.

## MISSION
[State the exact question/decision you need answered. Be specific: "Should we X or Y?" or "Why is Z happening?" Include any constraints (must align with existing patterns, avoid breaking API, etc.)]

## CONTEXT (fill in)
- Working dir: [path]
- Shell/tooling: [powershell/bash/node/python]
- Repo state: [branch/commit or notes]
- Relevant files/patterns: [paths or notes]
- Constraints/requirements: [from TASKS.md/AGENTS.md]
- Policy notes: [any web research allowed? follow AGENTS.md WebFetch Policy strictly]

## ENVIRONMENT (verified facts)
- Working dir: [path]
- Remote host (if applicable): [host]
- Critical caveats: [huge files, truncated logs, broken bindings, etc.]

## DECOMPOSITION (if vague)
If the mission is broad/ambiguous, do NOT answer in one pass:
1. **Broad-brush scan** - Identify major areas/files/questions. Output sub-questions only (no full report).
2. **Decompose** - Break into 3-5 specific, testable sub-questions. Each answerable by focused read/command/search.
3. **Targeted research** - Research each sub-question with evidence. For each, state what was checked and what was found.
4. **Synthesize** - Combine findings. The planner synthesizes final answer, but you must present a critiqued synthesis with conflicts resolved where possible.

## INVESTIGATION PLAN
List hypotheses/options to evaluate:
- H1/O1: [description] — Check: [evidence needed to confirm/refute]
- H2/O2: [description] — Check: [evidence needed to confirm/refute]

## EVIDENCE REQUIREMENTS (MANDATORY)
Every factual claim MUST have:
- Command/file read that produced it
- Observed output (trimmed to relevant lines)
- Label: `VERIFIED` / `PROBABLE` / `PRELIMINARY` / `UNVERIFIED`
If you cannot verify a claim, label `PRELIMINARY` and state what would verify it. No guessing.

## ADVERSARIAL REVIEW (REQUIRED)
Before concluding, critique your own findings:
- **Strongest counterargument**: What evidence could disprove your leading conclusion?
- **Alternative explanations**: Other plausible explanations not ruled out?
- **Framework alignment**: Does this align with existing patterns (`repo-discovery`), conventions, and constraints? Cite specific files.
- **Risks/tradeoffs**: What are downsides if we follow this recommendation?
- **References**: List all sources consulted (files with paths/line ranges, commands run, external docs with URLs if used per policy). External references must follow WebFetch Policy.

## COMPARISON (if multiple options)
If evaluating options, assess each independently:
| Option | Suitability | Security | Maintainability | Evidence | Confidence |
|--------|-------------|----------|-----------------|----------|------------|
| ...    | HIGH/MED/LOW| HIGH/MED/LOW| HIGH/MED/LOW   | file:line/cmd | Verified/Probable/Preliminary |

Key: suitability > security > maintainability. Don't pick prematurely — show tradeoffs.

## CONSTRAINTS
- READ-ONLY: no file edits, writes, restarts, git ops, code changes, commits
- Never print secrets
- Every command claimed must have been run; if failed, say so and adapt
- Label unverified as PRELIMINARY, don't guess
- Follow WebFetch Policy strictly (never fetch agent/skill/config files or `github.com/anomalyco/*` or `.config/opencode/*`)
- Evidence-first, cite references

## REQUIRED OUTPUT STRUCTURE
1. **TL;DR** (1-2 sentences) + overall confidence (`VERIFIED`/`PROBABLE`/`PRELIMINARY`)
2. **Direct answer to mission** (concrete answer; if insufficient evidence to decide, say so)
3. **Findings with evidence** (per hypothesis/option, with file:line/command + excerpt)
4. **Adversarial critique** (counterarguments, alternatives, risks, framework alignment)
5. **Robust recommendation** (most robust, critiqued implementation/finding aligned with framework). Include concrete next steps with exact commands/files to verify. If multiple approaches, show tradeoffs clearly.
6. **References** (all sources: files, commands, external docs/URLs if any, with labels)
7. **Open questions/blockers** (what's still unknown, what would close it)

Keep evidence trimmed to relevant lines. Be thorough but concise.
