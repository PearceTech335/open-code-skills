---
name: security
description: Security review covering input validation, secrets handling, auth, transport safety, and least-privilege. Use for audits and pre-merge reviews.
license: MIT
compatibility: opencode
metadata:
  domain: security
---

# Security

Treat all external input as untrusted. For each trust boundary, identify what input is valid and reject invalid input with an appropriate error — do not add validation everywhere as arbitrary boilerplate.

Never hardcode, log, or expose secrets. Use environment variables or secret managers. Never concatenate user input into SQL, shell commands, file paths, or eval.

Enforce authorization on every protected action. Canonicalize paths before validation. Use constant-time token comparison and proven crypto only.

Operations with potentially unbounded waits need explicit timeout and retry caps. Use deterministic resource cleanup. No new dependencies without justification.

Explain security-sensitive decisions in terms of the threat they address and the assumptions they rely on — this makes the code reviewable and prevents security measures from becoming noise.
