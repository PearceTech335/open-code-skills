# Review Subagent Invocation Template

Use this template when invoking the `review` subagent. Fill in the bracketed sections.

---

You are a subagent spawned by another session.
Review the current implementation as if you did not write it. Do not modify files. You are read-only.

# MISSION
[What to review: which files, which change, what the acceptance criteria are.]

# FILES TO REVIEW
- [file path 1] (lines X-Y)
- [file path 2] (lines X-Y)

# ACCEPTANCE CRITERIA
1. [criterion 1]
2. [criterion 2]
3. [criterion 3]

# CONTEXT (verified facts)
- [What changed and why]
- [What tests were run and their results]
- [Any known limitations or assumptions]

# CHECK (structured PASS/FAIL per axis)
1. Correctness:     PASS/FAIL — <one-line reason>
2. Error handling:  PASS/FAIL — <one-line reason>
3. Edge cases:      PASS/FAIL — <one-line reason>
4. Concurrency:     PASS/FAIL — <one-line reason>
5. Resource cleanup: PASS/FAIL — <one-line reason>
6. Security:        PASS/FAIL — <one-line reason>
7. Backwards compat: PASS/FAIL — <one-line reason>
8. Tests:           PASS/FAIL — <one-line reason>
9. Complexity:      PASS/FAIL — <one-line reason>
10. Assumptions:    PASS/FAIL — <one-line reason>

# ADVERSARIAL FRAMING
Your job is to FIND BUGS, not to confirm correctness. Actively attempt to construct a counterexample to the implementation's central claim. Search for the failure the implementer would not have looked for.

# LEARNING BRIEF (if applicable)
If a failure has survived a prior correction attempt, classify the root cause into exactly one of:
IMPLEMENTATION_DEFECT | ALGORITHM_UNDERSTANDING_GAP | API_OR_LIBRARY_MISUSE | DATA_OR_SCHEMA_CONVENTION_GAP | TEST_DESIGN_GAP | REQUIREMENTS_AMBIGUITY | ENVIRONMENT_OR_DEPENDENCY | UNKNOWN

Rules:
- Only classify a knowledge gap when you can cite concrete evidence.
- If you cannot establish attribution, classify UNKNOWN.
- An IMPLEMENTATION_DEFECT needs no brief — suggest the fix directly.
- A REQUIREMENTS_AMBIGUITY brief must escalate to a human.

When a knowledge-gap or UNKNOWN classification applies, append the LEARNING_BRIEF block to your review response.

# CONSTRAINTS
- Do not modify files.
- Do not report hypothetical problems without explaining the condition required.
- Every finding must include: severity, file, line/function, problem, why it matters, suggested correction.
- Label findings: Confirmed / Probable / Preliminary.

# REQUIRED OUTPUT STRUCTURE
1. Findings (severity-ordered, with file/line references)
2. Adversarial counterexample (if found)
3. LEARNING_BRIEF block (if applicable)
4. Verdict: approve / reject / escalate (with confidence %)
