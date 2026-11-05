---
name: project-index
description: Create, search, maintain and validate a standardised PROJECT_INDEX.md for any software repository. Use during initial repository discovery, architecture exploration, project documentation updates, and when changes affect project structure or component relationships.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: high
---

# Project Index

## Purpose

Maintain a reliable, standardised PROJECT_INDEX.md that provides AI coding agents with an accurate map of how a software project is *structured* — not just what it does. The index is the primary navigation and architecture reference for the repository: where components live, how they depend on each other, how the application runs, and how to validate changes — without repeatedly scanning the entire codebase.

A good index answers "where is everything, and how does it fit together?" A quick-start cheat sheet answers "what does this project do?" This skill produces the former.

## Rules

1. **Inspect before documenting**. Never document functionality, interfaces, or architecture without first inspecting the actual implementation, configuration, or existing documentation.
2. **Never invent**. Do not fabricate files, modules, dependencies, interfaces, or behavior. If information cannot be verified, label it as `UNKNOWN` or omit it.
3. **Use repository-relative paths**. All references to files and directories must use paths relative to the repository root.
4. **Maintain a single authoritative index**. Ensure `PROJECT_INDEX.md` exists at the repository root. If an existing index is found elsewhere, inspect it for authority before creating a new one.
5. **Update incrementally**. Modify only the sections affected by changes. Do not regenerate the entire index for minor updates unless explicitly requested.
6. **Verify all changes**. Before reporting completion, validate that referenced paths exist, descriptions match implementation, and no contradictory information has been introduced.
7. **Integrate with existing discovery**. Use this skill alongside `repo-discovery` and other architectural analysis tools. Do not duplicate detailed documentation already maintained in `README.md`, `docs/`, or `AGENTS.md`.
8. **Separate architecture from operational state**. The index documents stable structure (components, entry points, dependencies). Frequently changing facts — experiment progress, batch counts, run statistics, current incidents — belong in `PROJECT_STATUS.md` or existing tracking docs, never in `PROJECT_INDEX.md`.
9. **No line numbers**. Do not record source line numbers in the index unless they are automatically maintained. Source code moves; component responsibilities are stable.

## Minimum Discovery Requirements

Before generating or materially updating PROJECT_INDEX.md, the agent MUST inspect:

1. Repository root and directory structure (actual tree, not assumed).
2. Dependency manifests and runtime requirements (`requirements.txt`, `pyproject.toml`, `package.json`, `go.mod`, lockfiles).
3. Application entry points and execution commands (scripts, `__main__`, CLI definitions, process managers).
4. All primary application modules.
5. Imports and dependencies between primary modules.
6. Configuration and environment handling (config files, env vars, secrets).
7. Data storage and persistence mechanisms (databases, files, caches — including who writes and who reads each store).
8. Testing infrastructure and validation commands.
9. External services and integrations (APIs, brokers, message queues).
10. Existing technical documentation (`README.md`, `docs/`, `AGENTS.md`, ADRs).

The agent must NOT generate the index based solely on:

- `README.md`
- Existing `AGENTS.md`
- Previous project summaries
- Existing project documentation

These sources may provide context but must be validated against the actual repository.

## Architecture Mapping Requirements

The agent must identify, for the primary components:

- Component responsibilities.
- Direct dependencies (which modules import or invoke which).
- Data producers and consumers (who writes each data store, who reads it).
- Application entry points (entry function, launch command, scheduler, restart behaviour).
- Important execution sequences (startup → steady-state → shutdown).
- External integration boundaries (where the system meets external services).

Every relationship recorded in the index must be labelled by evidence:

- `VERIFIED` — confirmed by direct inspection of source (import, call, file operation).
- `INFERRED` — suggested by naming, docs, or partial tracing but not confirmed.
- `UNKNOWN` — relevant but not yet established; documented as a gap, never filled with a plausible guess.

## Discovery Completeness

Before finalising the index, the agent must report:

- Directories inspected.
- Primary modules inspected.
- Dependency manifests inspected.
- Tests discovered.
- Entry points identified.
- Unresolved architectural questions.

If information cannot be established, document the gap rather than inventing an answer.

## Validation Task (Audit Mode)

To test index quality — or to check an index generated by another agent — run an audit:

> Review `PROJECT_INDEX.md` against the actual repository. Identify missing architectural information, incorrect assumptions, and incomplete component relationships. Produce a report of discrepancies **without modifying the index**.

This distinguishes documentation quality from documentation completeness and should be performed before trusting an index produced by a weaker model.

## Guardrails

- Do NOT: Create multiple competing index files for the same repository.
- Do NOT: Document planned or hypothetical functionality as implemented.
- Do NOT: Copy large blocks of source code into the index; prefer concise descriptions.
- Do NOT: Overwrite unrelated user changes in the index file.
- Do NOT: Skip validation steps when modifying the index.
- Do NOT: Record operational state (progress counts, run statistics) in the index.
- Do NOT: Present `INFERRED` relationships as `VERIFIED`, or leave `UNKNOWN` gaps unfilled by guesses.

## Verification

To confirm output complies with this skill:

1. Check that `PROJECT_INDEX.md` exists at the repository root.
2. Verify that all file paths referenced in the index actually exist.
3. Confirm that every component relationship is labelled `VERIFIED`, `INFERRED`, or `UNKNOWN`.
4. Confirm the Discovery Completeness report lists what was inspected and what remains unresolved.
5. Ensure the "Change Impact Map" reflects current architectural relationships.
6. Confirm no operational-state content has crept into the index (it belongs in `PROJECT_STATUS.md`).
7. Run a targeted search (e.g., using `grep` or `glob`) to confirm a component described in the index can be located in the source tree.

## Provenance

- Sources:
  - `claudate/project-multilevel-index` (GitHub) — Established patterns for multi-level project indexing and self-referential documentation.
  - `pccly/project-indexer` (GitHub) — Harness-agnostic skill for generating `PROJECT_INDEX.md` with one-line descriptions and integration into agent context files.
  - `superclaude_framework` (GitHub) — Comprehensive example of a standardized `PROJECT_INDEX.md` structure.
  - Frontier-model review of a generated index (2026-11-05, scored 6/10) — Source of the Minimum Discovery, Architecture Mapping, and Discovery Completeness requirements; identified missing repository tree, shallow component relationships, absent entry-point/testing/config documentation, no change-impact emphasis, and operational-state contamination.
- Verified claims:
  - `PROJECT_INDEX.md` at the repository root is a common pattern for AI agent navigation. (Verified: 2+ sources)
  - Standardized sections improve consistency across projects. (Probable: Based on observed examples)
  - Incremental updates are more sustainable than full regeneration. (Probable: Common practice in documentation systems)
  - Discovery requirements catch omissions that template sections alone do not. (Probable: Based on the 6/10 review findings)
- Repro example:
  - Command: `ls PROJECT_INDEX.md`
  - Observed result: File exists at repository root.
- Known limitations:
  - This skill focuses on the root-level `PROJECT_INDEX.md`. For very large monorepos, a multi-level approach (e.g., folder-level indexes) may be more appropriate, but that is outside the scope of this skill.
  - The "Change Impact Map" requires manual maintenance and may become stale if not updated during architectural changes.
  - Minimum Discovery adds inspection cost on large repositories; scale depth of module inspection to repository size but never skip manifests, entry points, and testing infrastructure.
- Status: human-approved
- Created from: proactive gap (standardizing project indexing across repositories)
- Updated: 2026-11-05 (frontier-model feedback incorporation)
- Date: 2026-11-04
