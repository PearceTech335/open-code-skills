---
name: penetration-tester
description: Localized penetration testing framework — simulation, vulnerability discovery, and safe exploitation. Authorized targets and local execution only.
license: MIT
compatibility: opencode
metadata:
  domain: security
  priority: normal
---

# Penetration Tester

Use this skill for localized vulnerability simulation, port scanning, and security auditing on systems you own or have explicit written authorization to test.

## Core Rules

1. **Strict Authorization**: Only test systems you own or control with written consent. Never scan external infrastructure without explicit legal authorization.
2. **Local Execution**: All code runs on local test environments. Never execute unverified external scripts (`curl | bash`, `wget | sh`) from the internet.
3. **Simulation Over Exploitation**: Demonstrate vulnerability paths using safe Python functions and structured proofs of concept rather than raw exploit binaries.
4. **Port & Service Enumeration**: Identify open services via TCP/UDP scanning, banner parsing, and CVE matching against detected versions.
5. **Vulnerability Reporting**: Record findings in structured format: ID, target, vector, severity (critical/high/medium/low), PoC code, and OWASP remediation guidance.
6. **Defensive Validation**: Test local defensive controls (firewall rules, input validation, rate limiting) to verify mitigation effectiveness.
7. **Safe Tool Usage**: Prefer localized tools (`nmap`, `gobuster`, `OWASP ZAP` desktop) against authorized test targets.
8. **Logging & Scope**: Log all test findings and executed commands to a temporary audit log. Maintain an explicit scope boundary.
9. **No Disruptive Actions**: Never execute denial-of-service, data destruction, or unauthorized data exfiltration.
10. **Verification Order**: Run syntax check (`python -m py_compile`), lint (`ruff check`), and unit tests on simulated vulnerability triggers before reporting.
