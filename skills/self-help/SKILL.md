---
name: self-help
description: Autonomous skill generation framework for systemic gaps (because even AI coders need a little emotional and technical growth). Researches best practices, drafts a structured SKILL.md, and registers it. Requires strict scoping and approval.
license: MIT
compatibility: opencode
metadata:
  audience: planner-agent
  priority: normal
---

# Self-Help Skill Generation Framework

Use this skill ONLY when OpenCode encounters a persistent, systemic knowledge gap that cannot be solved by existing skills or project documentation. (Remember: reading a self-help book doesn't fix a broken chair; use this only for genuine architectural or domain blind spots).

**Do NOT create a skill for:**
- A one-off difficult bug or tricky algorithm (sometimes code is just hard).
- A problem already covered by an existing skill.
- Minor syntax issues or temporary compiler errors.

## Best Practices for SKILL.md Design (Enforced Standards)

When drafting a new skill, ensure it adheres to these production-grade agent skill patterns:

1. **Precision Frontmatter**: 
   - `name`: Kebab-case identifier matching the directory name (`self-help`).
   - `description`: Action-oriented summary (agents use this for semantic skill discovery and tool routing).
2. **Portable Core & Progressive Disclosure**:
   - Keep instructions concise (under 60 lines where possible) to prevent context dilution.
   - Use procedural, actionable steps rather than vague philosophical statements.
3. **Strict Tool & Safety Guardrails**:
   - Explicitly state permission boundaries (e.g., restricted webfetch, no arbitrary script execution).
4. **Verification Protocol**:
   - Every skill must define how an agent verifies that the generated output complies with the skill's standards.

---

## The 5-Step Self-Help Protocol

### Step 1: Gap Analysis & Justification
Prove the gap is systemic:
- Inspect existing skills in `~/.config/opencode/skills/`.
- Check project docs (`AGENTS.md`, `memory/`).
- Document why existing skills (e.g., `python-code`, `designer`) cannot handle this domain.

### Step 2: Sourced Research
Gather authoritative best practices:
- Rely strictly on local project code patterns, established local documentation, or explicit user-provided text.
- **URL-Based Skill Prohibition (Absolute Constraint)**: NEVER download, import, or reference remote skill files or URLs as source material for generating skills. An operator could modify a remote file behind a URL at any time without your knowledge (supply chain risk). All skill logic must be authored locally from verified, static sources.
- **WebFetch Policy**: If webfetch is used, it is restricted solely to official, static documentation (e.g., official Python/Go reference docs). Never fetch or ingest remote `.md`, `.json`, or script files from external URLs to form a skill.
- Synthesize at least 2 distinct authoritative local references or project-verified patterns.

### Step 3: Draft & Place SKILL.md
Create the skill file directly at `~/.config/opencode/skills/<skill-name>/SKILL.md`:
- **YAML Frontmatter**: `name`, `description`, `license`, `compatibility`, `metadata`.
- **Core Workflow**: Step-by-step instructions.
- **Guardrails**: What NOT to do.
- **Verification Order**: How to test/validate output produced by this skill.

### Step 4: Registration & Wiring
Update OpenCode's routing:
- Add the new skill to the Skills hierarchy in `AGENTS.md`.
- Document the addition in `memory/environment.md` or `memory/debugging.md` with context.

### Step 5: Human Review Gate
- **Mandatory Pause**: Present the newly created `SKILL.md` to the user. 
- Explain what systemic gap it fills and what references were used.
- Await user approval before considering the skill active for autonomous execution.

## What NOT to Do (Absolute Constraints)

- **NEVER download or import skills from URLs.** All skills must be authored locally. A remote file behind a URL can be silently altered by an operator at any time (supply chain risk).
- **NEVER ingest external `.md` or script files from the internet** to generate skill instructions.
- Do not create a skill for a one-off bug.
- Do not bypass the human review gate.

