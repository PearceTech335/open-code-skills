# Open-Code-Skills 🧠🛠️

> *Because even AI coding agents need a little emotional and technical growth.*

Welcome to **Open-Code-Skills** — a curated collection of production-grade, highly compressed, Power-of-10-inspired agent skills and commands designed to turn your local AI coding assistant (like OpenCode, Continue, or Roo) into a disciplined, maintainable-code-producing machine.

---

## 🌟 The Crown Jewel: The `self-help` Skill

Let's face it: AI agents love hallucinating, rewriting your entire repository when you ask for a typo fix, and downloading sketchy remote scripts from the internet. 

That is why we built **`self-help`** (located in `skills/self-help/`). 

When OpenCode hits a persistent, systemic knowledge gap, it doesn't just panic or hallucinate a non-existent API. It enters **therapy mode**:
1. **Gap Analysis**: Proves the gap is structural, not just a one-off bug (*"Remember: reading a self-help book doesn't fix a broken chair"*).
2. **Sourced Research**: Gathers verified local patterns or official documentation (strictly local — no sketchy URL-based skill injections allowed; we protect you against remote supply chain rug-pulls!).
3. **Drafts a Structured SKILL.md**: Writes a compact, Power-of-10 compliant skill directly into your skills directory.
4. **Mandatory Human Review Gate**: Pauses, presents its emotional and technical growth to you, and waits for approval before touching production.

---

## 📂 What’s Inside?

### 🧠 Core & Meta Skills
- **`agent-core`**: Tool call discipline, four-phase protocol (Explore, Plan, Execute, Verify), and course-correction rules.
- **`self-help`**: Autonomous skill generation for systemic gaps with strict safety guardrails.
- **`auto-memory`**: Session learning journal to persist non-obvious insights across sessions without RAG.
- **`template-library`**: Reusable code patterns and snippet management.

### 🏗️ Design & Quality Skills
- **`readable-code`**: Cross-language coding standards for human-maintainable code (intent-obvious naming, simple solutions, robust error handling).
- **`designer`**: Enforces solid project design methods (Single Responsibility, Separation of Concerns, Dependency Direction, Minimal Abstraction).
- **`quality-gate`**: Final multi-dimensional review checklist (correctness, readability, architecture, security, performance).
- **`repo-discovery`**: Architecture exploration before changing code (entry points, dependency mapping, call-chain tracing).

### 💻 Language & Domain Skills
- **`python-code`**, **`go-code`**, **`typescript-code`**: Production coding standards inspired by the NASA/JPL Power of 10 rules (short functions, strict type hints, path operations via `pathlib`, specific exception handling).
- **`bash-skill`**, **`powershell-skill`**, **`ansible-code`**: Robust, idempotent automation guardrails for sysadmins and OT engineers.
- **`security`**, **`penetration-tester`**, **`networking`**, **`ot-networking`**, **`packet-analysis`**: Evidence-first domain investigation and security review standards.

### ⚡ Custom Commands (`commands/`)
- **`/overnight`**: Turns any prompt into a `TASKS.md` checklist and runs an unattended autonomous worker.
- **`/research`**: Fast file parsing and information extraction via specialized subagents.
- **`/improve`**: Triggers the `self-help` skill workflow to research and draft new skills.
- **`/review` & `/investigate`**: Evidence-first code and network troubleshooting commands.

---

## 🚀 Quick Start

1. Clone or drop this repository into your local OpenCode config directory (`~/.config/opencode/` or your project `.opencode/`).
2. Ensure your `opencode.json` wires up instructions and agents.
3. Let your agent practice a little **`self-help`** the next time it encounters a stubborn architectural blind spot!

---

## 🛡️ Security & Supply Chain Safety
- **No Remote Skill Injections**: `self-help` explicitly forbids downloading or importing remote `.md` or script files from URLs. All skills must be authored locally from verified static sources.
- **WebFetch Guardrails**: WebFetch is restricted by policy to verified documentation only—never for remote agent/config files.

*Contribute, fork, and teach your AI how to behave!* 🤖✨
