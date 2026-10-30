---
name: long-running-task-research
description: Autonomous long-running task research — persistent notes, source-linked evidence, resumable state, design review, and overnight-safe verification.
license: MIT
compatibility: opencode
metadata:
  audience: overnight-agent
  priority: high
---

# Long-Running Task Research

Use this skill for autonomous, unattended, multi-stage, or long-running tasks spanning context compaction, session restarts, or overnight runs.

## Core Rules

1. **State & Constraints**: Read `AGENTS.md`, `TASKS.md`, `PROGRESS.md`, and `memory/*.md` before editing. Identify protected paths. Never copy secrets into notes. Continue reversible work without asking questions.
2. **Persistent Notes**: Maintain `RESEARCH.md`, `INDEX.md`, `subsystem-*.md`, and `PROGRESS.md`. Read large files in ~300-line chunks. Document high-level purpose, boundaries, and verified tests immediately rather than relying on KV cache memory.
3. **Incremental Documentation**: Document findings as you go. Follow call chains far enough to explain behaviour before moving on.
4. **State Separation**: Use `TASKS.md` for checklists, `PROGRESS.md` for execution status, and `RESEARCH.md` for architecture and decisions.
5. **Resumable Retrieval**: At session start, read state files and load only notes relevant to the next action. Source code and test outputs remain authoritative.
6. **Reproducibility**: Record exact commands, configs, and versions. Preserve successful and failed trials. Never claim an unverified test ran.
7. **Safe Refactoring**: Make the smallest reversible change. Preserve public interfaces. Inspect diffs and run verification checks.
8. **Self-Critique**: Every observation requires: Observation (file/line/snippet), Assumption, Limitation, and References. Label findings: `Verified`, `Probable`, or `Preliminary`.
9. **WebFetch Policy**: Allowed ONLY for verified external docs/research when explicitly asked. NEVER permitted for agent/skill/config files or external repos (`github.com/anomalyco/`, etc.). Report failures once; never loop.
10. **Final Review**: Verify separation of concerns, dependency direction, explicit error handling, and test outcomes before declaring complete. Report what changed and where notes were saved.
