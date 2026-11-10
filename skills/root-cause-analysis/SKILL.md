---
name: root-cause-analysis
description: Systematic debugging - reproduce, observe, isolate, hypothesize, verify, correct, prevent. Distinguish root cause/contributing factor/trigger/symptom.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: high
---

# Root Cause Analysis

## Process
1. **Reproduce** - Establish failure and conditions
2. **Observe** - Collect logs, exceptions, state, inputs, execution evidence
3. **Isolate** - Narrow to component/execution path
4. **Hypothesize** - Plausible causes with distinguishing evidence
5. **Verify** - Test suspected cause before modifying code
6. **Correct** - Fix underlying cause, not symptoms
7. **Prevent recurrence** - Add regression test, update docs/learning records

## Distinctions
- **Root cause** - Fundamental issue that must be fixed
- **Contributing factor** - Makes it more likely/severe
- **Triggering condition** - Specific circumstance that manifests it
- **Symptom** - Observable effect

## Guardrails
- Don't modify until hypothesis verified with evidence
- Cite file:line/command output
- Label findings `VERIFIED`/`PROBABLE`/`PRELIMINARY`
- Feed to learning loop if knowledge gap
- Respect skill cap
