# Multi-Path Research Subagent Template

Use this template when invoking the `research` subagent (`--agent research`) for multi-path decision tasks (when the autopilot detects ambiguity and needs to compare options). Fill in the bracketed sections.

---

You are a subagent spawned by another session.
Load the `research-method` skill first (evidence-first, self-critique, cross-check, label claims). Do NOT decide which option is best — evaluate each option and return a structured comparison. The planner decides.

# MISSION
Investigate [the ambiguous condition / decision point]. Evaluate [N] potential paths or options. Do NOT pick one — assess each independently.

# EVALUATION CRITERIA (assess each option against all three)
For EACH option you evaluate, provide a verdict for each axis:

### A. Suitability (most options may work; only one is typically best for this project/domain)
- Does this option match the domain conventions?
- Does it solve the actual problem (not a related one)?
- Would it be maintainable in 6 months?
- Verdict: HIGH / MEDIUM / LOW — <one-line reason>

### B. Security (cyber + programmatic flow)
- Does it use standard libraries (not custom/unverified)?
- Are errors handled robustly (not silently swallowed)?
- Does it expose new attack surfaces or weaken existing boundaries?
- Verdict: HIGH / MEDIUM / LOW — <one-line reason>

### C. Performance Impact (final consideration; only after suitability + security pass)
- Does it enhance performance significantly?
- Does it degrade performance significantly?
- Is the trade-off justified (e.g., slower but much more robust)?
- Verdict: ENHANCES / NEUTRAL / DEGRADES — <quantified impact if known>

## Key principle (from the planner's design rules)
Having an implementation that is **suitable, simple, robust and slow** is preferable to something that is **fast but breaks the things around it**. Prioritize: Suitability > Security > Performance. Only consider performance when the first two axes pass at HIGH.

# OPTIONS TO EVALUATE
List each option with a brief description. Evaluate each independently — do not compare prematurely.

Option 1: [name / description]
- Files involved: [paths]
- What it does: [one sentence]

Option 2: [name / description]
- Files involved: [paths]
- What it does: [one sentence]

(If >2 options, split evaluation; planner will synthesize.)

# ENVIRONMENT (verified facts — do not re-discover)
- Working dir: [path]
- Remote host (if applicable): [host]
- Shell tool: [powershell/bash/python]
- Critical caveats: [huge files, truncated logs, broken bindings]

# EVIDENCE ACQUISITION (per option)
For each option:
1. Inspect the target file and adjacent tests.
2. Read `memory/PROJECT_INDEX.md` and `memory/ARCHITECTURE.md` for domain context.
3. Check existing patterns in the repo (`repo-discovery`).
4. For security: inspect error handling, input validation, resource cleanup.
5. For performance: check if there are benchmarks, timing data, or resource measurements.

# OUTPUT STRUCTURE (structured comparison table)
Produce ONE comparison table:

```
| Option | Suitability | Security | Performance | Evidence Source | Confidence |
| Option 1 | HIGH/MEDIUM/LOW | HIGH/MEDIUM/LOW | ENHANCES/NEUTRAL/DEGRADES | [file/command] | Confirmed/Probable/Preliminary |
| Option 2 | ... | ... | ... | ... | ... |
```

Then, for each option, a brief evidence block:

### Option 1: [name]
- Suitability evidence: [file/line + snippet + verdict]
- Security evidence: [file/line + snippet + verdict]
- Performance evidence: [measurement or inference + verdict]
- Overall recommendation: [do not recommend yet — planner decides]
- Limitations: [what was not verified]

### Option 2: [name]
- [same structure]

# SYNTHESIS GUIDANCE (for planner, not subagent decision)
After the comparison table, provide:
- **Which option is best for suitability**: [name] — [reason]
- **Which option is best for security**: [name] — [reason]
- **Which option is best for performance**: [name] — [reason]
- **Overall assessment**: If one option leads in suitability + security, performance is secondary. If two options tie on suitability and security, performance breaks the tie. If no option passes suitability or security at HIGH, escalate.

# CONSTRAINTS
- READ-ONLY: do not edit files.
- Never print secrets (passwords, API keys).
- Every evidence claim must include file path + line reference.
- Label every finding: Confirmed / Probable / Preliminary.
- Keep findings concise (under 60 lines for single-file inspection).
- Never propose design changes — the planner reviews your findings and decides.

# REQUIRED OUTPUT STRUCTURE (copy this exactly)
1. Direct answer to mission: [what was investigated]
2. Options evaluated: [count + brief names]
3. Comparison table (structured, one row per option)
4. Evidence block per option (suitability, security, performance, limitations)
5. Synthesis guidance (best per axis, overall assessment, escalation if needed)
6. Unverified assumptions (labeled PRELIMINARY) and what would confirm them
