---
name: ste-writing
description: Documentation style reference implementing ASD-STE100-inspired principles (short sentences, one instruction per sentence, active voice). Load when writing READMEs, docs/, or other human-facing documentation. Not code, comments, or commit messages. Never claim STE certification.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: normal
---

# STE-Inspired Writing (ASD-STE100 Principles)

## Scope (hard limits)

Apply to human-facing documentation prose: READMEs, `docs/`, project `AGENTS.md` prose, PR notes, runbooks, troubleshooting guides.

Do NOT apply to: code, code comments, commit messages, chat, creative/marketing text, or API reference generated from source.

## Core principles (Issue 9-compatible, STE-inspired)

1. **Short sentences.** Aim ≤20 words for an instruction, ≤25 for a descriptive sentence (numbers sourced from Issue 8-era public summaries — PROBABLE; confirm against the Issue 9 PDF).
2. **One instruction per sentence.** One topic per paragraph; ≤6 sentences per paragraph.
3. **Imperative mood for steps.** ("Run the migration."), not descriptions.
4. **Active voice.** Passive only when the actor is unknown or irrelevant.
5. **Do not omit sentence parts.** (subject, verb, article) to save space.
6. **Conditions before actions.** "If the service is stopped, restart it."
7. **One word, one meaning.** Do not use the same word for two concepts, or two words for one concept, in the same document.
8. **Vertical lists.** for anything with more than two items or steps.
9. **No multi-word noun clusters** longer than three words.
10. **No unapproved jargon.** prefer a consistent, documented termlist. A project's own official name/glossary is the legal route for domain terms (STE "technical nouns/verbs") — document them in `PROJECT_INDEX.md` or `docs/glossary.md`.

## Verification checklist (docs only)

- [ ] Instructions use the imperative; each contains one action.
- [ ] Sentence-length spot check passes (read 5 random sentences).
- [ ] No passive voice with a known actor.
- [ ] No omitted subjects/verbs/articles.
- [ ] Conditions precede actions.
- [ ] Terminology is consistent (one word, one meaning); domain terms are in a documented glossary.
- [ ] Lists are vertical where they enumerate.
- [ ] No claim of STE compliance anywhere in the text.
