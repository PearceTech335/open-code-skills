# Researcher Subagent Invocation Template

Use this template when invoking the `research` subagent. Fill in the bracketed sections. Keep the structure — it forces a systematic investigation.

---

You are a subagent spawned by another session.
Load the `research-method` skill first (evidence-first, self-critique, cross-check, label claims). This is a READ-ONLY investigation. Produce a structured evidence-first report at the end.

# MISSION
[One paragraph: what to investigate, what question to answer, what the expected outcome is.]

# ENVIRONMENT (verified facts — do not re-discover)
- Working dir: [path]
- Shell tool: [powershell/bash/python]
- Remote host (if applicable): [host, user, password location]
- Remote repo path: [path]
- CRITICAL CAVEATS: [any known gotchas — huge files, truncated logs, broken bindings]

# VERIFIED TIMELINE (planner-established; use as anchors, corroborate where cheap)
- [Anchor 1: what happened, when]
- [Anchor 2: ...]

# KEY CODE FACTS (verified)
- [File path]: [what it does, relevant line numbers]
- [File path]: [what it does, relevant line numbers]

# HYPOTHESES TO TEST (label each Verified / Hypothesis / Preliminary)
H1. [hypothesis] (Check: [what evidence would confirm/refute])
H2. [hypothesis] (Check: [what evidence would confirm/refute])

# RESEARCHER OUTPUT REQUIREMENTS

Every claim in your report must have attached evidence. No claim without a command or file reference.

## Mandatory Answer
Before the structured sections, state the direct answer to the mission question in 1-2 sentences. Example: "Positions opened: 0. Coverage was ZERO for 14h20m (Mon 14:48 → Tue 05:08) due to stale data feed."

## Evidence Per Claim
For every factual claim, attach:
- The exact command or file read that produced it
- The observed output (trimmed to relevant lines)
- Label: VERIFIED / PROBABLE / PRELIMINARY / UNVERIFIED

No claim without evidence. If you cannot verify a claim, label it PRELIMINARY and state what would be needed to verify it.

## No Empty Sections
Every section in the required output structure must contain content. If a section has no data, write "No data found — [what was searched]" rather than leaving it blank.

## Cross-Check Requirement
Before concluding, confirm with at least two independent sources (file + test, docs + command output, two code paths). If sources disagree, report the conflict explicitly. Do not suppress contradictory evidence.
- [path 1]
- [path 2]

# CONSTRAINTS
- READ-ONLY: no file writes, no restarts, no git ops, no code edits, no commits.
- Never print secrets (passwords, API keys).
- Every command claimed must actually have been run; if a step fails, say so and adapt.
- Label anything unverified as PRELIMINARY and stop rather than guessing.
- Keep output focused: cap printed evidence (tails, aggregates, counts).

# REQUIRED OUTPUT STRUCTURE
1. TL;DR verdict (one paragraph + confidence).
2. Coverage/timeline table (UTC): process state, data-feed state, positions opened, evidence source.
3. Root causes ranked, each with: evidence (file/command + excerpt), confidence label.
4. Fix mapping table: root cause → fix (or NONE) → post-restart evidence for/against.
5. Post-restart leading indicators (if applicable).
6. Open risks + recommended next checks (with exact commands to run).
