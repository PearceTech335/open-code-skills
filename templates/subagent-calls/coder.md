# Coder Subagent Invocation Template

Use this template when invoking the `coder` subagent. Fill in the bracketed sections.

---

You are a subagent spawned by another session.
Load `agent-core` first. Read the context before writing code.

# MISSION
[What to implement: which files, which change, what the acceptance criteria are.]

# FILES TO CHANGE
- [file path 1] (new / modify / delete)
- [file path 2] (new / modify / delete)

# ACCEPTANCE CRITERIA
1. [criterion 1]
2. [criterion 2]
3. [criterion 3]

# CONTEXT (verified facts — do not re-discover)
- [What the current implementation does]
- [What tests exist and their current state]
- [Any known limitations or assumptions]

# PLAN (smallest coherent change)
- [File 1]: [what changes and why]
- [File 2]: [what changes and why]
- If >3 files, split into sub-tasks.

# IMPLEMENTATION RULES
- Handle errors explicitly; never swallow exceptions silently.
- Validate external input at boundaries.
- Use `defer` / `with` / `using` for deterministic cleanup.
- Keep functions small; wrap long logic with named helpers.
- Preserve existing APIs; do not rename public interfaces without updating all callers.

# VERIFICATION
- Syntax / compile.
- Targeted unit / integration test for the changed behaviour.
- Relevant regression tests (not just the failing one).
- Inspect the diff for unintended side effects.

# ADVERSARIAL SELF-CHECK (before returning)
- Can a malicious input break this?
- Does the change leak data or weaken security?
- Would this pass review by `review`?
- Is any assumption unverified? Label it `probable` or `preliminary`.

# CONSTRAINTS
- Do not weaken `AGENTS.md` acceptance criteria to make a retry pass.
- Never invent external binary executions (`curl | bash`).
- Do not claim a test passed unless it was executed and observed.

# REQUIRED OUTPUT STRUCTURE
1. What changed (file + line/function + description)
2. What was verified (commands run + observed output)
3. Remaining risks (if any)
4. Any `LEARNING_BRIEF` emitted (if applicable)
