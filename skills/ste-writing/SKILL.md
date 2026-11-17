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

> ASD-STE100 is a registered EU trademark of ASD (Brussels). This skill teaches
> the *principles* of the standard for general documentation. It does not
> reproduce the standard, its dictionary, or its rule text, and it confers no
> conformance or certification. For true conformance, obtain the official
> standard (free PDF, see References) and apply it per project.

## Scope (hard limits)

- Apply to human-facing documentation prose: READMEs, `docs/`, project
  `AGENTS.md` prose, PR notes, runbooks, troubleshooting guides.
- Do NOT apply to: code, code comments, commit messages, chat, creative/
  marketing text, or API reference generated from source.
- Do NOT print or claim "STE compliant", "ASD-STE100 certified", or
  "conforms to ASD-STE100". Say "STE-inspired". Plausibility is not
  compliance (per ASD's own AI guidance).
- Do NOT inline the ASD-STE100 dictionary or verbatim rule text (copyright;
  CC BY-NC-ND 4.0 on Issue 9; "All rights are reserved").

## Core principles (Issue 9-compatible, STE-inspired)

1. Short sentences. Aim ≤20 words for an instruction, ≤25 for a descriptive
   sentence (numbers sourced from Issue 8-era public summaries — PROBABLE;
   confirm against the Issue 9 PDF).
2. One instruction per sentence. One topic per paragraph; ≤6 sentences per
   paragraph.
3. Imperative mood for steps ("Run the migration."), not descriptions.
4. Active voice. Passive only when the actor is unknown or irrelevant.
5. Do not omit sentence parts (subject, verb, article) to save space.
6. Conditions before actions: "If the service is stopped, restart it."
7. One word, one meaning. Do not use the same word for two concepts, or two
   words for one concept, in the same document.
8. Vertical lists for anything with more than two items or steps.
9. No multi-word noun clusters longer than three words.
10. No unapproved jargon; prefer a consistent, documented termlist. A
    project's own official name/glossary is the legal route for domain terms
    (STE "technical nouns/verbs") — document them in `PROJECT_INDEX.md` or
    `docs/glossary.md`.

## Verification checklist (docs only)

- [ ] Instructions use the imperative; each contains one action.
- [ ] Sentence-length spot check passes (read 5 random sentences).
- [ ] No passive voice with a known actor.
- [ ] No omitted subjects/verbs/articles.
- [ ] Conditions precede actions.
- [ ] Terminology is consistent (one word, one meaning); domain terms are in
      a documented glossary.
- [ ] Lists are vertical where they enumerate.
- [ ] No claim of STE compliance anywhere in the text.

## True STE (opt-in per project)

Projects that need actual conformance (safety-critical maintenance docs,
regulated industries) must declare it in their own `AGENTS.md`/`MISSION.md`,
obtain the official standard PDF from asd-ste100.org (request form, free),
and apply its 53 rules + approved dictionary with professional review. The
global config never claims this. A checker cannot verify meaning or context —
human judgment is required.

## References

- ASD-STE100, Issue 9 (2025-01-15), international standard — VERIFIED (asd-ste100.org)
- asd-ste100.org/about_STE.html — structure (53 rules, 9 sections; ~900 approved / ~1,200 not-approved words) — VERIFIED
- asd-ste100.org/STE_faq.html — procedural vs descriptive text; "not intended for general-purpose writing" — VERIFIED
- asd-ste100.org/STE_downloads.html — free PDF; copyright; AI guidance ("Plausibility must not be confused with verified compliance") — VERIFIED
- en.wikipedia.org/wiki/Simplified_Technical_English — rule details (20/25 words, 6 sentences/para) — PROBABLE (secondary)

## Rule provenance

Rule numbers and word counts above are from public Issue 8-era summaries
(Wikipedia) corroborated by Issue 9's homepage/about pages; they are
PROBABLE, not line-verified against the Issue 9 PDF. Correct them when the
official PDF has been obtained.
