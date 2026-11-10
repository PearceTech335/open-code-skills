---
name: test-engineering
description: Test design strategy - unit/integration/contract/property/boundary/failure/regression testing. Tests verify intended behavior, not implementation.
license: MIT
compatibility: opencode
metadata:
  audience: planner-agent, coder, tester
  priority: high
---

# Test Engineering

## Principles
- **Behavior over implementation**: Test what should happen for defined inputs, not current implementation details.
- **Deterministic**: Avoid flaky tests; control time/random/external deps (mocks/fakes).
- **Risk-based**: Prioritize critical paths, boundaries, error cases.
- **Regression prevention**: Add tests for bugs found.
- **Mutation-aware** (optional): For critical logic, verify tests fail when behavior changes.

## Test Types
| Type | Purpose |
|------|---------|
| Unit | Isolated behavior of functions/modules |
| Integration | Components work together |
| Contract | Interface stability between components |
| Boundary | Limits/invalid inputs |
| Failure | Timeouts/errors/partial outages |
| Property-based | Invariants across inputs |
| Regression | Prevent reintroduction |

## Guidelines
- Write tests that would fail if the requirement is not met.
- Prefer black-box tests at public interfaces.
- Keep tests readable and fast.
- Use existing test patterns from the repo.
- The `test` agent executes tests; this skill guides design.

## Guardrails
- Don't test implementation details.
- Avoid over-mocking.
- Keep scope proportional.
- Respect skill cap (counts as additional skill).
