---
name: production-readiness
description: Operational resilience - logging, metrics, timeouts, retries, idempotency, degradation, config validation, health checks.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: high
---

# Production Readiness

## Checklist
- [ ] **Logging**: Structured logs with useful context
- [ ] **Timeouts/Cancellation**: Explicit timeouts, cancellation support
- [ ] **Retries/Backoff**: Idempotent ops, jittered backoff
- [ ] **Idempotency**: Safe to retry
- [ ] **Graceful degradation**: Handle partial failures
- [ ] **Resource management**: Cleanup, limits
- [ ] **Config validation**: Fail fast on bad config
- [ ] **Startup/Shutdown**: Clean lifecycle
- [ ] **Health checks**: Liveness/readiness
- [ ] **Observability**: Metrics/traces where appropriate

## Principles
- Correct but hanging/unguarded code isn't production-ready
- Fail fast with actionable errors
- Make failures observable
- Design for recovery

## Guardrails
- Respect existing patterns
- Don't add heavy deps unnecessarily
- Keep proportional to change
- Respect skill cap
