---
name: git-practices
description: Git workflow and project maintenance best practices — topic branches, commit hygiene, pull-request flow, history safety, branch protection, SemVer releases, and human-readable changelogs.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: normal
---

# Git Practices & Project Maintenance

Load when making commits, structuring branches, releasing versions, or maintaining a repository. Covers workflow rules with cited sources and observed behavior.

## Rules

1. **One topic branch per change.** Short descriptive names (`add-token-timeout`, or contributor-namespaced like `sc/ruby_client`); separate unrelated changes into separate branches so each merges and reverts independently. Never commit to the default branch directly once protection is on.
2. **Isolated, complete commits.** Each commit is one revertable unit (a variable rename and its tests go in separate commits); message states what changed and why. If the repo uses Conventional Commits: `<type>[scope]: <description>` — feat→MINOR, fix→PATCH, `BREAKING CHANGE`/`!`→MAJOR.
3. **Integrate via pull request.** PR body summarizes the change and the problem it solves, links related issues (keyword links auto-close); use draft PRs for early feedback; answer review comments with new commits; merge only when required checks pass.
4. **Delete topic branches after merge.** History lives on in the main branch and the PR (verified: commits survive `git branch -d`). Long-lived branches (release/maintenance lines) are the deliberate exception — document them.
5. **Never rewrite published history.** Golden rule: do not rebase commits that exist outside your repository or that people may have based work on. Verified: rebase rewrites SHAs. Rebase your own unpushed topic branches for linear history; integrate into shared branches by merge, not force-push.
6. **Protect the default branch.** Require PR reviews and status checks; GitHub defaults already block force pushes and deletion; consider dismissing stale approvals when new commits are pushed.
7. **Release with SemVer and tags.** MAJOR = incompatible API change, MINOR = backward-compatible feature, PATCH = backward-compatible fix; never modify a released version (re-release instead); tag releases with annotated (`git tag -a -m`) or signed (`-s`) tags; use `git describe` for build names.
8. **Keep a human changelog.** Curated notable changes — not a git-log dump: an Unreleased section, entries grouped Added/Fixed/Changed/Removed, newest first, ISO dates, an entry for every version. `git shortlog --no-merges <main> --not <tag>` is raw input, not final text.
9. **Repository presentation** (README, license, community files): load `readme-authoring`.

## Guardrails

- Do NOT: rebase or force-push commits others may have based work on.
- Do NOT: bundle unrelated changes into one branch or PR.
- Do NOT: edit, move, or retag a released version.
- Do NOT: paste raw `git log` output into CHANGELOG.
- Do NOT: delete unmerged branches (`git branch -d` only; review `git branch --merged` first).

## Verification

1. Pre-push: `git log --oneline --graph --decorate main..HEAD` — one concern per commit, descriptive messages.
2. Pre-delete: `git branch --merged main` shows the topic branch before removing it; PR checks are green.
3. Pre-release: `git log <last-tag>..HEAD --oneline` matches the SemVer bump, and CHANGELOG has a dated section for the new version.
4. Repo settings: default branch requires PR reviews + status checks; force-push and deletion blocked.

## Provenance

- Sources: git-scm.com Pro Git 2e §5.3 "Maintaining a Project" and §3.6 "Rebasing"; guides.github.com "GitHub flow"; docs.github.com "About protected branches"; semver.org 2.0.0; keepachangelog.com 1.1.0; conventionalcommits.org 1.0.0 (all fetched 2026-11-02)
- Verified claims: golden-rule mechanism (rebase SHA rewrite, observed); merged-branch deletion retains history (observed); annotated vs lightweight tag metadata (observed); topic-branch + PR flow (2 independent sources); branch protection defaults (primary docs); SemVer/Conventional Commits/Changelog structures (primary specs)
- Probable claims: commit-isolation revertability rationale (single source); rebase-for-linear-history preference (single source)
- Repro example: git 2.55.0 — E1 SHA f7babec→a6cf99e after rebase; E3 topic commits survive `git branch -d`; E2 `objecttype=tag` vs `commit`, `git describe --tags` → v1.0.0 (observed 2026-11-02)
- Known limitations: CI design, issue triage, dependency automation, fork/sync workflows, non-GitHub hosting, and signing-key setup are not covered
- Status: human-approved
- Created from: proactive gap (user request)
- Date: 2026-11-02
