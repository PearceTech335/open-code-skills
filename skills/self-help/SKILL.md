---
name: self-help
description: Autonomous skill generation for systemic gaps — consumes Learning Briefs, performs sourced research with cross-check and adversarial critique, drafts Power-of-10-compliant skills, and enforces a human review gate.
license: MIT
compatibility: opencode
metadata:
  priority: normal
---

# Self-Help Skill Generation

Load when a knowledge-gap failure triggers the learning loop and autonomous skill generation is needed. This skill researches, drafts, and gates new skills for human approval.

## Scope

Apply to project-specific skill gaps that recur across tasks. Global skills require review; project skills may be auto-approved per §6 Skill Policy.

Do NOT generate skills for one-off bugs or ordinary debugging.

## Two-Phase Pipeline

### Phase A — Research + Draft (planner)

1. Load self-help and read the Learning Brief.
2. Research: websearch → cross-check (≥2 sources) → adversarial critique → reproducible example.
3. Draft the skill using `~/.config/opencode/skills/self-help/templates/skill-template.md` (global template; see §7.5).
4. Output: draft skill + sources + evidence labels.

### Phase B — Learning Gate (review)

1. Validate all 5 checks (evidence, relevance, correctness, scope, executable check).
2. Approve or reject with one-line reason per check.
3. If approved → activate as `auto-approved-provisional` (per §6). If rejected → return to Phase A with specific feedback.

Quality is preserved: same research depth, same Learning Gate. The split just moves heavy reasoning to the planner and verification to the review agent.

## Verification Checks (5 mandatory checks)

- **Evidence:** All factual claims cite ≥2 independent sources.
- **Relevance:** The skill addresses a genuine recurring gap, not a trivial issue.
- **Correctness:** The drafted skill follows opencode conventions and frontmatter format.
- **Scope:** The skill is project-specific or broadly reusable, not overlapping existing skills.
- **Executable check:** The skill can be loaded and invoked without errors.

## Provenance

- Sources: opencode.json instructions[]; skills/self-help/templates/skill-template.md; skills/self-help/templates/learning-brief.md
- Verified claims: 5-check validation pipeline (opencode internal); Learning Brief format compliance (opencode internal)
- Probable claims: auto-approval gate behavior (§6 Skill Policy); skill draft reusability (single primary source)
- Repro example: Learning Brief → Phase A research → Phase B approval → skill activation (observed 2026-11-02)
- Known limitations: skill complexity beyond 3 major components, domain knowledge gaps beyond 2 hours research
- Status: human-approved
- Created from: proactive gap (user request)
- Date: 2026-11-02