# OpenCode Skills & Agent Framework

A version-controlled global configuration for [OpenCode](https://opencode.ai) — the AI coding agent — plus a copy/paste project scaffold. It turns long autonomous coding runs on **small locally hosted models** into a disciplined, auditable process.

> *Because even AI coding agents need a little emotional and technical growth.*

---

## What this is

This repo is an OpenCode setup aimed at improving agentic code generation:

- **`AGENTS.md`** — the global base document. Every project loads it. It contains the engineering standards: workflow, verification, principles, behaviour rules, the skill hierarchy, testing protocol, documentation style (ASD-STE100-inspired).
- **`skills/`** — 33 loadable on-demand skills (see below).
- **`agents/` + `commands/`** — specialist agents (`coder`, `research`, `review`, `test`, `architect`, `autopilot`) and slash commands.
- **`templates/AGENTS_TEMPLATES/`** — a copy/paste project scaffold. Customize only its header and `MISSION.md`; everything else stays aligned with the global config.
- **`templates/subagent-calls/`** — completion templates for invoking the specialist agents deterministically.

It is designed to be **dropped into** `~/.config/opencode/` and the contents of **`templates/AGENTS_TEMPLATES`** copied into the project root, per project. You must create your own `opencode.json` there (it is gitignored; declare your provider and a `model` that supports tool calls) — without it, nothing runs.

## Who this is for, and what it is aimed at

**Audience:** operators running OpenCode for sustained, long-horizon agentic coding — especially beneficial on **small, self-hosted models** (Qwen3 4B/9B class at modest contexts, e.g. via Ollama or LM Studio), and equally usable with frontier models to produce high quality generated code and projects.

**The aim:** make a small local model behave like a frontier one *procedurally*. Small models do not reliably generate the constraints, verification, and recovery discipline an autonomous coding run needs. This repo supplies that discipline externally:

- **File-first state** — the agent reads `TASKS.md` index + `tasks/<id>.md` detail files and memory files, never a fat prompt.
- **Delegation with verification** — every non-trivial step goes to a specialist (`research` for investigation, `coder` for implementation, `review` for adversarial checks, `test` for execution), and the primary agent verifies their outputs.
- **Quality gates before "done"** — adversarial review (10 axes + security + complexity), executed tests, a final quality-gate pass, then the tick.
- **Failure recovery** — root-cause first, bounded recursion (max 3 iterations), blockers recorded, never silently skipped.

The result, at the cost of per-step subagent latency: long runs stay on-goal, every step's evidence is inspectable, and behaviour is consistent regardless of the executing model.

This is a **starter + personal configuration**, not a finished product. See "Honest status".

## Layout

```text
~/.config/opencode/      ← copy these files here (global config)
├── AGENTS.md            # global base: engineering standards every project inherits
├── skills/              # 33 on-demand skills
├── agents/              # autopilot · coder · research · review · test · architect
├── commands/            # /overnight /research /review /improve /investigate
├── templates/
│   ├── AGENTS_TEMPLATES/    # project scaffold (copy into a repo root)
│   └── subagent-calls/      # research/review/test/coder/autopilot invocation templates
├── scripts/             # validate_skills.js · verify.js (validators, run with node)
├── opencode.json        # you must supply your own (gitignored, see below)
└── README.md
```

## Quick start

**Prerequisites:** [OpenCode](https://opencode.ai) (`npm install -g opencode-ai`), Node.js, and a local OpenAI-compatible provider (Ollama / LM Studio / vLLM) whose `model` supports tool calls.

1. **Clone this repo into your global config:**

   ```bash
   git clone https://github.com/PearceTech335/open-code-skills.git ~/.config/opencode
   cd ~/.config/opencode
   ```

2. **Scaffold a project for a long run:**

   ```bash
   cp -r ~/.config/opencode/templates/AGENTS_TEMPLATES/* ./my-project
   cd my-project && cp MISSION.md MISSION.md   # fill in the mission brief
   ```

   `MISSION.md` + `TASKS.md` (thin index; add one line per task) is all you edit by hand. Then open the project in OpenCode and switch to the **`autopilot`** agent, or run `/overnight <new goal>`. Autopilot works through the list: repo lookup → research → coder → review → test → fix loop → docs update → tick → next task.

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

## What’s inside

**Core (10):** `agent-core` (tool discipline + always-on requirements micro-checklist + the **2 additional skills per task** cap), `self-help`, `auto-memory`, `template-library`, `supervisor`, `long-running-task-research`, `research-method`, `git-practices`, `readme-authoring`, `ste-writing`.

**Design, quality & process (12):** `readable-code`, `repo-discovery`, `project-index`, `quality-gate`, `designer`, `strategic-engineering`, `test-engineering`, `root-cause-analysis`, `interface-design`, `production-readiness`, `html-js-graphics-3d`, `network-engineer`.

**Language & domain (11):** `python-code`, `go-code`, `typescript-code`, `bash-skill`, `powershell-skill`, `ansible-code`, `security`, `penetration-tester`, `networking`, `ot-networking`, `packet-analysis`.

**Agents:** `autopilot` (engineering orchestrator/QC; Mode A resume list / Mode B new goal merged as milestone), `coder`, `research`, `review`, `test`, `architect`.

**Commands:** `/overnight`, `/research`, `/review`, `/improve`, `/investigate`.

**Static checks:** `node scripts/verify.js` (config + path references), `node scripts/validate_skills.js` (skill frontmatter/structure). No other CI exists in this repo.

## Honest status

- **Verified**: config parses; fresh project scaffold passes `verify.js --project`; all skill files pass the frontmatter validator; the framework runs a full task lifecycle in principle (designed + adversarially audited; see git history).
- **Not verified**: a live end-to-end run on a small local model has not yet been executed against a real repository in this repo. Small models remain fallible; the point of this repo is that failure is bounded and visible, not that it never happens.
- **Not a certification**: ASD-STE100-inspired documentation style is applied as principles; this repo never claims "STE compliant" or "ASD-STE100 certified". Full conformance is an opt-in per project via the official Issue 9 standard from asd-ste100.org.
- **Personal configuration**: `opencode.json`, `plugin/`, `scripts/` are local-only (gitignored) and machine-specific.

## Safety

- WebFetch is restricted by policy to verified documentation; never to agent files, configs, or arbitrary `github.com/anomalyco/` URLs.
- No `curl | bash`. No unverified binaries. No self-approval.
- Hard blockers in autonomous runs: destructive migrations, credential changes, production deployments, security-boundary changes.
- Skills self-generated by the framework land as provisional and need human review (`auto-approve: off` by default in the starter).

---

*Fork it, adapt it, start a run. If your 9B model survives one full `/overnight` cleanly, the experiment worked.*
