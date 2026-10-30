---
name: readable-code
description: Cross-language coding standards for human-readable, maintainable code. Use whenever writing, refactoring, or reviewing code.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: high
---

# Human-Readable Code

## Primary Objective

Write code that a competent engineer can understand, debug, and safely
modify without having to reverse-engineer the author's intent.

Prefer straightforward, explicit code over clever, compressed, or
unnecessarily abstract implementations.

Correctness, security, and maintainability take priority over brevity
and stylistic novelty.

## 1. Make Intent Obvious

- Use descriptive names that explain the purpose of variables,
  functions, classes, modules, and configuration values.
- Prefer `connection_timeout_seconds` over `t`, and
  `is_user_authorized` over `check`.
- Use domain terminology that matches the problem being solved.
- Avoid unexplained abbreviations, cryptic names, and overloaded
  variables whose meanings change throughout a function.
- Make control flow easy to follow from top to bottom.

## 2. Prefer Simple Solutions

- Start with the simplest solution that fully satisfies the requirements.
- Prefer ordinary conditionals, loops, and named intermediate
  variables when they make the logic easier to understand.
- Avoid nested ternaries, dense comprehensions, deeply nested
  callbacks, metaprogramming, and clever one-liners when a
  straightforward alternative is clearer.
- Do not introduce a design pattern, class, interface, factory,
  framework, or helper solely to make the code appear sophisticated.
- Do not create abstractions until they solve a real problem,
  such as duplicated logic, a meaningful boundary, or a complex
  responsibility that needs separation.

## 3. Functions and Modules

- Give each function one clear, cohesive responsibility.
- Keep functions as short as practical, but do not split them
  mechanically to meet an arbitrary line limit.
- Prefer a few cohesive functions over a long function with
  multiple responsibilities.
- Avoid excessive indirection: a reader should be able to follow
  the important execution path without jumping through many files.
- Keep related behaviour together and separate unrelated concerns.
- Prefer existing project conventions over introducing a new
  architectural style.

## 4. Comments and Documentation

- Write comments to explain why a decision was made, not merely
  repeat what the code already says.
- Explain non-obvious algorithms, security decisions, workarounds,
  protocol constraints, and important business rules.
- Document public interfaces, non-obvious parameters, expected
  side effects, error behaviour, and operational assumptions.
- Do not add comments to every line or write redundant docstrings.
- Update documentation when behaviour or configuration changes.
- Never use comments as a substitute for clear code.

## 5. Error Handling

- Handle errors where meaningful action can be taken.
- Preserve useful diagnostic context without swallowing errors
  or repeatedly wrapping the same error without benefit.
- Use explicit error handling rather than obscure fallback behaviour.
- Do not silently substitute defaults when doing so could conceal
  a configuration error, data loss, or security problem.
- Keep the normal success path easy to read.

## 6. Dependencies and Abstractions

- Prefer existing project utilities and established language
  features over custom implementations.
- Add dependencies only when their benefits justify their
  maintenance, security, and deployment costs.
- Never initiate webfetch or external network requests without
  explicit user authorization. WebFetch (`permission.webfetch: allow`)
  is permitted ONLY for verified external research when explicitly asked
  (e.g., "check docs for X"). It is NEVER permitted for agent/skill/config
  files from repositories (e.g., `github.com/anomalyco/opencode/` paths).
- Prefer standard-library solutions when they remain clear
  and appropriate.
- Avoid unnecessary generic frameworks, compatibility layers,
  plugin systems, and configuration options.
- Do not generalise a solution for hypothetical future needs.

## 7. Safe Refactoring

- Preserve existing behaviour and public interfaces unless a
  change is explicitly required.
- Make the smallest coherent change that solves the problem.
- Do not combine unrelated refactoring with feature work.
- Remove dead code introduced by the change, but do not delete
  unrelated code or user changes.
- Add tests for important behaviour and regression risks.

## 8. Final Readability Review

Before finishing, ask:

1. Can a new team member understand the main execution path?
2. Do names explain intent without requiring extra comments?
3. Is there a simpler implementation with the same behaviour?
4. Have I introduced unnecessary abstractions or indirection?
5. Are errors, side effects, and security boundaries obvious?
6. Does the code follow the existing project conventions?
7. Would I be comfortable maintaining this code in six months?

If a simpler and equally safe solution exists, prefer it.

Do not claim that code is verified unless the relevant checks
were actually run. Report any checks that could not be performed.
