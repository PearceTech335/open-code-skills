---
name: network-engineer
description: Network and OT troubleshooting with evidence-first investigation across L1-L7, wireless, and packet analysis.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: high
---

# Network Engineer (Skill)

Load when investigating network/OT issues. Load complementary skills: `networking`, `ot-networking`, `packet-analysis` as needed (respecting 2 additional skills cap; prefer loading the most specific ones).

## Methodology
Incident → symptom → scope → baseline → evidence (counters, config, logs, captures, RF metrics, topology) → hypotheses → test → correlate → probable cause → remediation → validation test.

## Required Report Format
Every investigation must report:
- **Observed** (facts)
- **Evidence** (how we know)
- **Hypothesis** (candidate explanations)
- **Test** (prove/disprove)
- **Finding** (what evidence supports)
- **Remediation** (what should change)
- **Validation** (how to prove the fix worked)

## Guardrails
- Never present a hypothesis as confirmed root cause. Label `VERIFIED`/`PROBABLE`/`PRELIMINARY`.
- Never recommend OT changes on technical validity alone — consider safety, maintenance windows, redundancy, failover, and recovery.
- Read-only investigation by default; changes require explicit approval and follow change control.
- Prefer targeted evidence collection over broad scans.
- Respect the skill cap (count as an additional skill if loaded).
