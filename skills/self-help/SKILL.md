---
name: self-help
description: Autonomous skill generation for systemic gaps — consumes Learning Briefs, performs sourced research with cross-check and adversarial critique, drafts Power-of-10-compliant skills, and enforces a human review gate.
license: MIT
compatibility: opencode
metadata:
  audience: planner-agent
  priority: normal
---

# Self-Help Skill Generation Framework

Use ONLY for persistent, systemic knowledge gaps that existing skills and project docs cannot close. Never for one-off bugs, syntax errors, or anything an existing skill already covers. A skill is durable capability, not a saved debugging session.

## Entry Paths

### A. Proactive Gap
Triggered by repeated roadblocks where existing skills fall short (e.g. `python-code`, `designer` cannot cover the domain).

### B. Review-Triggered (Learning Brief)
When an adversarial review produces a Learning Brief after a failed correction attempt:
1. Read the brief at the given path (`memory/learning/briefs/<task>.md`).
2. Validate the proposed root cause against the actual implementation. Do not accept the diagnosis blindly.
3. If the `review` agent cited no attribution evidence, the brief is UNKNOWN — investigate or escalate.
4. Route per the brief's Recommended Artifact: load existing skill / update existing / project skill / temporary note / escalate. Routing rank (prefer in this order): USE_EXISTING > UPDATE_EXISTING > CREATE_PROJECT > TEMPORARY_NOTE > ESCALATE.

## Research Protocol (Mandatory Before Drafting)

A skill is only as good as its sources. Self-generated recollection is NOT research.

### 1. Source Acquisition
- Use websearch to identify authoritative sources: official documentation, primary references, reference implementations.
- webfetch ONLY official/static documentation sites (e.g. `docs.python.org`, `xgboost.readthedocs.io`). Local project code and verified local docs are always valid sources.
- NEVER fetch `.md`, `.json`, or script files from arbitrary URLs — supply-chain risk.

### 2. Cross-Check
- Verify every important claim against at least 2 independent authoritative sources.
- Label each claim: `Verified` (2+ sources), `Probable` (1 source, consistent), `Preliminary` (single, unverified).
- If sources disagree, record the disagreement — never silently pick one.

### 3. Critique (Adversarial Self-Review)
Before any claim enters the skill:
- Identify claims resting on a single source.
- Separate sourced fact from your own inference.
- Attempt a counterexample to each key claim.
- Where practical, build a minimal reproducible example and RUN it.
- Only claims that survive critique may be drafted into the skill.

A generated explanation is never evidence of its own correctness.

## Drafting — Power-of-10 Schema

Every generated skill MUST follow `templates/skill-template.md`:
- YAML frontmatter: `name`, `description`, `license`, `compatibility`, `metadata`.
- Numbered, procedural, actionable rules.
- Guardrails (what NOT to do).
- Verification protocol (how to test compliance).
- Provenance section (sources + verification labels).
- Under ~60 lines where possible.

## Learning Gate (Before Any Retry)

Clear all five before the skill may guide a retry:
1. **Evidence** — every non-obvious claim cited to a source or observed output.
2. **Relevance** — the skill addresses the demonstrated failure.
3. **Correctness** — the skill's worked example was executed and passed.
4. **Scope** — reusable capability, not a one-bug workaround.
5. **Executable check** — at least one command/test with observed output pasted.

## Registration & Approval

1. Place project skills at `.opencode/skills/<name>/SKILL.md`. Global skills go to `~/.config/opencode/skills/<name>/`.
2. Update the skills hierarchy in `AGENTS.md`.

### Default — Human Review Gate
**MANDATORY PAUSE**: present the skill + its sources to the user. Await approval before activation.

### Autonomous Mode (explicit project opt-in only)
If the project's `AGENTS.md` declares a `Skill Policy` block with `auto-approve: project-skills`, the pause is skipped for PROJECT-scoped skills only, under these conditions:
- The Learning Gate (all five checks) must pass first — no exceptions.
- The skill's Provenance must record `Status: auto-approved-provisional`.
- Log the cycle to `memory/learning/metrics.jsonl` with `auto_approved: true`.
- Respect `max-new-skills-per-run` (default 3); when exceeded, stop and escalate.
- Global promotion still requires human review, always.

Auto-approve exists for unattended testing. Every auto-approved skill is PROVISIONAL until the user reviews it. Never set this policy in global config.

## Absolute Constraints

- **NEVER download or import skills from URLs.** Local authorship only.
- **NEVER ingest external `.md`/`.json`/script files** to form skill logic.
- NEVER generate a skill for an `IMPLEMENTATION_DEFECT` or one-off bug.
- NEVER bypass the human review gate (unless the project's `Skill Policy` declares `auto-approve: project-skills` — and even then only for project skills, never global).
- NEVER auto-approve a global skill.
- NEVER set `auto-approve` outside a project's `AGENTS.md`.
- NEVER enter a claim you cannot cite.

## Two-Phase Split (quality-preserving)

When a knowledge-gap failure triggers self-help (AGENTS.md section 5), split the pipeline:

**Phase A — Research + Draft (planner):**
1. Load self-help and read the Learning Brief.
2. Research: websearch -> cross-check (>=2 sources) -> adversarial critique -> reproducible example.
3. Draft the skill using templates/skill-template.md.
4. Output: draft skill + sources + evidence labels.

**Phase B — Learning Gate (review):**
1. Validate all 5 checks (evidence, relevance, correctness, scope, executable check).
2. Approve or reject with one-line reason per check.
3. If approved -> activate as auto-approved-provisional (per AGENTS.md section 6). If rejected -> return to Phase A with specific feedback.

Quality is preserved: same research depth, same Learning Gate. The split moves heavy reasoning to the planner and verification to the `review` agent.

## Compact Learning Brief (standard format)

Use a compact 4-field variant as the standard format:

`
LEARNING_BRIEF (compact)
task_id: <id>
root_cause: <classification>
evidence: <one-line>
learning_objective: <one sentence>
`

The planner expands it to the full 8-field template if needed. This reduces output token burden while preserving the core signal.
