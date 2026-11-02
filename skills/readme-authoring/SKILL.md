---
name: readme-authoring
description: Write effective README.md files for human understanding and GitHub presentation — audience-first structure, plain-language and accessibility rules, GitHub platform behavior, and a pre-publish verification checklist.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: normal
---

# README Authoring

Load when creating or revising a README.md (repository root, `.github`, `docs/`, or a profile README) for human readers on GitHub. Covers content structure, writing rules, platform behavior, and pre-publish checks.

## Rules

1. **Answer the reader's five questions on the first screen.** What does it do? Why is it useful? How do I get started? Where do I get help? Who maintains it? If contributions are unwanted or the project is not production-ready, say so explicitly.
2. **Draft before you build (new projects), then keep it truthful.** Writing the README first forces you to settle the interface before the code; retroactively written READMEs miss details. Never let the README claim behavior the code does not have.
3. **Stay an introduction, not a manual.** Include only what a newcomer needs to start and contribute; move long-form reference material to a wiki/docs site. Keep well under GitHub's 500 KiB render truncation.
4. **Headings: exactly one `#` title, never skip levels.** Descriptive `##` names double as section anchors and feed GitHub's auto-generated Outline menu.
5. **Plain language.** Second person for instructions, active voice, one idea per paragraph, runnable command examples instead of prose paragraphs; run paragraphs through a readability checker when available.
6. **Descriptive, relative links.** Link text names the destination (never "click here"), stays on one line, and in-repo targets use relative paths so links survive branch switches and clones.
7. **Images carry alt text** — succinct and descriptive ("screenshot of ..." is appropriate for UI captures). Lists use real `-`/`*` markers, never emoji as bullets. Use emoji sparingly — screen readers announce their full names.
8. **Link the companion files:** License, CONTRIBUTING, CODE_OF_CONDUCT, SUPPORT — GitHub surfaces community health files automatically; the README should point to them.
9. **Place it where GitHub surfaces it:** root (default), `.github/`, or `docs/` — precedence `.github` > root > `docs`. A profile README is a root README in a repo named exactly like the username.

## Guardrails

- Do NOT: dump full API/config reference into the README — link out instead.
- Do NOT: leave stale claims (removed features, install steps that no longer work).
- Do NOT: use bare URLs or split link text across lines.
- Do NOT: skip heading levels or use emoji/symbols as list bullets.

## Verification

1. Run `scripts/check-readme.ps1 README.md` — must exit 0 (catches skipped heading levels, missing image alt text, broken local links).
2. Read the first screen cold: it must answer what/why/how without scrolling past detail sections.
3. Grep for staleness: no `TODO`, no feature claims absent from the code, every example command copy-paste runnable.
4. Check the GitHub preview: Outline lists every section, relative links resolve, images render with alt text.

## Provenance

- Sources: docs.github.com "About the repository README file"; tom.preston-werner.com "Readme Driven Development" (2010); opensource.guide "Starting an Open Source Project"; docs.github.com "Setting up your project for healthy contributions"; github.blog "5 tips for making your GitHub profile page accessible" (2023-10-26)
- Verified claims: five-question structure (2 sources); keep-short/deeper-docs-elsewhere (2 sources); companion files (3 sources); platform facts — 500 KiB truncation, location precedence, auto Outline, section anchors, relative/single-line links, profile README (primary official docs)
- Probable claims: README-first workflow (single primary source); accessibility rules — headings/alt text/lists/emoji/plain language (single official source)
- Repro example: `check-readme.ps1 sample-bad.md` → 3 FAILs, exit 1; `check-readme.ps1 sample-good.md` → PASS, exit 0 (observed 2026-11-02)
- Known limitations: repo metadata (description/topics/social preview), badge policy, non-GitHub platforms, and localization are not covered
- Status: human-approved
- Created from: proactive gap (user request)
- Date: 2026-11-02
