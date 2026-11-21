# OpenCode Skills & Agent Framework

A version-controlled global configuration for [OpenCode](https://opencode.ai) — the AI coding agent — plus a copy/paste project scaffold. It turns long autonomous coding runs on **small locally hosted models** into a disciplined, auditable process.

> *Because even AI coding agents need a little emotional and technical growth.*

---

## What this is

This repo is an OpenCode setup aimed at improving agentic code generation:

- **`AGENTS.md`** — the global base document. Every project loads it. It contains the engineering standards: workflow, verification, principles, behaviour rules, the skill hierarchy, testing protocol, documentation style (ASD-STE100-inspired).
- **`skills/`** — on-demand skills.
- **`agents/` + `commands/`** — specialist agents (`coder`, `research`, `review`, `test`, `architect`, `autopilot-light`, `rigour`) and slash commands.
- **`templates/AGENTS_TEMPLATES/`** — a copy/paste project scaffold. Customize only its header and `MISSION.md`; everything else stays aligned with the global config.
- **`templates/subagent-calls/`** — completion templates for invoking the specialist agents deterministically.

It is designed to be **dropped into** `~/.config/opencode/` and the contents of **`templates/AGENTS_TEMPLATES`** copied into the project root, per project. You must create your own `opencode.json` there (it is gitignored; declare your provider and a `model` that supports tool calls) — without it, nothing runs.

## Who this is for, and what it is aimed at

**Audience:** operators running OpenCode for sustained, long-horizon agentic coding — especially beneficial on **small, self-hosted models** at modest contexts (e.g. via Ollama or LM Studio; the declared `model` must support tool calls), and equally usable with frontier models to produce high quality generated code and projects.

**The aim:** make a small local model behave like a frontier one *procedurally*. Small models do not reliably generate the constraints, verification, and recovery discipline an autonomous coding run needs. This repo supplies that discipline externally:

- **File-first state** — the agent reads `TASKS.md` index + `tasks/<id>.md` detail files and memory files, never a fat prompt.
- **Delegation with verification** — every non-trivial step goes to a specialist (`research` for investigation, `coder` for implementation, `review` for adversarial checks, `test` for execution), and the primary agent verifies their outputs.
- **Quality gates before "done"** — adversarial review (checklist, security, complexity), executed tests, a final quality-gate pass, then the tick.
- **Failure recovery** - root-cause first, bounded recursion, no blind retries, blockers recorded, never silently skipped.

The result, at the cost of per-step subagent latency: long runs stay on-goal, every step's evidence is inspectable, and behaviour is consistent regardless of the executing model.

This is a **starter + personal configuration**, not a finished product. See "Honest status".

## Two operating modes

### Autopilot (default) — Light loop for frontier models

The `autopilot` agent uses a slimmed-down loop suitable for frontier models that can handle most work themselves:

- Bootstrap → light repository discovery → direct implementation or single coder call → optional targeted review/test if needed → acceptance.
- Frontier models internalise much of the research/review/test discipline; forcing the full pipeline on them wastes tokens and time.
- External specialist agents are invoked only when escalation criteria are met (ambiguity, high-risk changes, or operator request).

Use when: You want fast iteration with a frontier model that can handle most work internally.

### @rigour — Subagent Notation (full quality pipeline)

The `@rigour` subagent notation activates the rigorous quality pipeline for every task. Invoke with `@rigour <task goal>` to enforce the 9-stage pipeline: research → decomposition → adversarial review → planning → implementation → review → test → sign-off.

- **Full pipeline mandatory:** Every task goes through all 9 stages — research, decomposition, adversarial review, planning, implementation, review, test, sign-off. No shortcuts.
- **Research first:** Never implement without documented research findings.
- **Adversarial review required:** Every change gets independent critique before acceptance.
- **Test evidence mandatory:** Full verification sequence with observed PASS/FAIL output.
- **Specialist agents invoked explicitly:** `coder`, `research`, `review`, `test` at each stage.
- **Shared state files:** `TASKS.md`, `tasks/`, `CURRENT_STATE.md` shared with autopilot mode.

Use when: You're using a local model, working on production code, security-sensitive changes, or need maximum integrity and evidence. Choose `@rigour` subagent notation for the full quality pipeline.

### Model Routing

`opencode.json` declares an endpoint via `provider` plus a single `model`; **all agents inherit that one configured `model`**. There is no required cloud endpoint and no cloud/local split. The orchestrator runs specialists **sequentially** against the one endpoint — deliberate: no inference-session contention on bandwidth-limited hardware, and the workflow does not depend on any external model. The one supported override is an agent's own `model: <provider/model[#variant]>` frontmatter; there is no `execution_model` key. `opencode.json` is local-only (gitignored). Whatever you declare is what runs — the framework is deliberately agnostic to model choice, size, and vendor, as long as the declared `model` supports tool calls.

## Quick start

**Prerequisites:** [OpenCode](https://opencode.ai) (`npm install -g opencode-ai`), Node.js, and a local OpenAI-compatible provider (Ollama / LM Studio / vLLM) whose `model` supports tool calls.

1. **Clone this repo into your global config:**

    ```bash
    git clone https://github.com/PearceTech335/open-code-skills.git ~/.config/opencode
    cd ~/.config/opencode
    ```

    *Optional: sanity-check the install with `node scripts/verify.js` (config parses; referenced files resolve). It is not required to proceed.*

2. **Scaffold a project for a long run:**

    ```bash
    cp -r ~/.config/opencode/templates/AGENTS_TEMPLATES/* ./my-project
    cd my-project && cp MISSION.md MISSION.md   # fill in the mission brief
    ```

    `MISSION.md` + `TASKS.md` (thin index; add one line per task) is all you edit by hand. Then open the project in OpenCode and switch to the **`autopilot`** agent, or use `@rigour <new goal>` for maximum integrity. Autopilot uses a light loop suitable for frontier models that can handle most work themselves. The `@rigour` subagent notation activates the full multi-stage quality pipeline (research → decomposition → adversarial review → planning → implementation → review → test → sign-off) for every task — use when token usage is acceptable and code quality/integrity is paramount.

## How the two-layer model works

**Global base (this repo) + project complement** are both loaded in every session:

- `AGENTS.md` (this repo) — hard rules you cannot override per project: workflow, verification requirements, principles, STE-inspired documentation, Checkpoint Discipline, the QA order (`review → test → quality-gate`).
- `AGENTS.md` (your project, from the scaffold) — the task machinery: mission, `TASKS.md`/`tasks/<id>.md` workflow, failure budget, Learning Loop, Skill Policy, memory layout. Customize **only** this header and `MISSION.md`; you do not need to fork global rules into it.

## Design principles

- **No fabricated facts.** Every path and line number the agent reports must come from a tool result in that session.
- **No claim without observation.** Tests must run; stories of them mean nothing.
- **Smallest change first.** Preserve behavior and interfaces; never weaken acceptance criteria to make something pass.
- **Everything is instance state.** The framework persists state in files (`memory/`, `tasks/`), so any turn or resume works without the conversation history.
- **The reviewer is not the author.** Adversarial agents check actual diffs (never summaries); no self-approval.

## What's inside

**Core:** `agent-core` (tool discipline + always-on requirements micro-checklist + the per-task skill-loading cap), `self-help`, `auto-memory`, `template-library`, `supervisor`, `long-running-task-research`, `research-method`, `git-practices`, `readme-authoring`, `ste-writing`.

**Design, quality & process:** `readable-code`, `repo-discovery`, `project-index`, `quality-gate`, `designer`, `strategic-engineering`, `test-engineering`, `root-cause-analysis`, `interface-design`, `production-readiness`, `html-js-graphics-3d`, `network-engineer`.

**Language & domain:** `python-code`, `go-code`, `typescript-code`, `bash-skill`, `powershell-skill`, `ansible-code`, `security`, `penetration-tester`, `networking`, `ot-networking`, `packet-analysis`.

**Agents:** `autopilot` (lightweight orchestrator for frontier models), `rigour` (full multi-stage quality pipeline for local models/high-stakes), `coder`, `research`, `review`, `test`, `architect`.

**Commands:** `@rigour` (rigour subagent), `/research`, `/review`, `/improve`, `/investigate`.

**Static checks:** `node scripts/verify.js` (config + path references), `node scripts/validate_skills.js` (skill frontmatter/structure). No other CI exists in this repo.

## Honest status

- **Verified**: config parses; fresh project scaffold passes `verify.js --project`; all skill files pass the frontmatter validator; the framework runs a full task lifecycle in principle (designed + adversarially audited; see git history).
- **Not verified**: a live end-to-end run on a small local model is currently being executed against a real **one shot** 'Build me a game' style project. Using Qwen3-4b-Thinking-2507, when the project run has completed the whole project with and without this framework will be linked for everyone's perusal. The testing is being completed with one model, same prompt, same tasks and mission, only difference is this framework vs clean opencode. Small models remain fallible; the point of this repo is that failure is bounded, visible, traceable, reviewable and fixable, not that it never happens.
- **Not a certification**: ASD-STE100-inspired documentation style is applied as principles; this repo never claims "STE compliant" or "ASD-STE100 certified". Full conformance is an opt-in per project via the official Issue 9 standard from asd-ste100.org.
- **Personal configuration**: `opencode.json`, `plugin/`, `scripts/` are local-only (gitignored) and machine-specific.

## Safety

- WebFetch is restricted by policy to verified documentation; never to agent files, configs, or arbitrary `github.com/anomalyco/` URLs.
- No `curl | bash`. No unverified binaries. No self-approval.
- Hard blockers in autonomous runs: destructive migrations, credential changes, production deployments, security-boundary changes.
- Skills self-generated by the framework land as provisional and need human review (`auto-approve: off` by default in the starter).

---

*Fork it, adapt it, start a run. If your model survives one full `@rigour` cleanly, the experiment worked.*
