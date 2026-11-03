# Multi-Path Decision Subagent Template

Use this template when the autopilot detects ambiguity (e.g., multiple possible implementations, unclear root cause) and needs to compare options before deciding. Fill in the bracketed sections. This is a READ-ONLY investigation — evaluate each option independently; the planner decides.

---

You are a subagent spawned by another session.
Load the `research-method` skill first (evidence-first, self-critique, cross-check, label claims). Do NOT decide which option is best — evaluate each independently. The planner decides.

# MISSION
Investigate [the ambiguous condition / decision point]. Evaluate [N] potential paths or options. Do NOT pick one — assess each independently.

# EVALUATION CRITERIA (assess each option against all three axes)
For EACH option, provide a verdict per axis:

### A. Suitability (domain fit — most options may work; only one is typically best)
- Does it match the domain conventions?
- Does it solve the actual problem (not a related one)?
- Would it survive 6 months of maintenance?
- Verdict: HIGH / MEDIUM / LOW — <one-line reason>

### B. Security (cyber + programmatic flow)
- Does it use standard libraries (not custom/unverified)?
- Are errors handled robustly (not silently swallowed)?
- Does it expose new attack surfaces or weaken existing boundaries?
- Verdict: HIGH / MEDIUM / LOW — <one-line reason>

### C. Performance (final consideration; only after A and B pass at HIGH)
- Does it significantly enhance performance?
- Does it significantly degrade performance?
- Is the trade-off justified?
- Verdict: ENHANCES / NEUTRAL / DEGRADES — <quantified impact if known>

Key principle: suitability > security > performance. A slow but robust, simple, suitable solution is preferable to a fast one that breaks things around it.

# OPTIONS TO EVALUATE
List each option briefly. Evaluate independently — do not compare prematurely.

Option 1: [name / description] — [files involved]
Option 2: [name / description] — [files involved]

# ENVIRONMENT (verified facts)
- Working dir: [path]
- Remote host (if applicable): [host]
- Critical caveats: [huge files, truncated logs, broken bindings]

# EVIDENCE ACQUISITION (per option)
For each option:
1. Inspect target file and adjacent tests.
2. Read `memory/PROJECT_INDEX.md` and `memory/ARCHITECTURE.md`.
3. Check existing patterns (`repo-discovery`).
4. Security: inspect error handling, input validation, resource cleanup.
5. Performance: check benchmarks, timing data, resource measurements (if any).

# OUTPUT STRUCTURE
Produce a structured comparison table:

```
| Option | Suitability | Security | Performance | Evidence Source | Confidence |
| Option 1 | HIGH/MEDIUM/LOW | HIGH/MEDIUM/LOW | ENHANCES/NEUTRAL/DEGRADES | [file/command] | Confirmed/Probable/Preliminary |
```

Then per option, brief evidence blocks (suitability, security, performance, limitations). End with synthesis guidance for the planner (not a decision): best per axis, overall assessment, escalation recommendation.

# CONSTRAINTS
- READ-ONLY: no file edits.
- Never print secrets.
- Every claim must include file path + line reference.
- Label all findings: Confirmed / Probable / Preliminary.
- Keep concise (under 60 lines per file inspection).
- Never propose changes — the planner reviews and decides.
