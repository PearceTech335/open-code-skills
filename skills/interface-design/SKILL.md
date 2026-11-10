---
name: interface-design
description: API/data contract design - stable interfaces, validation, errors, versioning, backward compatibility, boundaries.
license: MIT
compatibility: opencode
metadata:
  audience: planner-agent, coder, architect
  priority: high
---

# Interface Design

## Principles
- Design around responsibilities and stable contracts, not implementation convenience
- Prefer explicit contracts over implicit assumptions
- Design for evolution (versioning/backward compatibility)
- Fail fast with clear errors

## Areas
- Function/module interfaces
- API request/response
- Data models/schemas
- Input validation
- Error contracts
- Versioning/compatibility
- Optional vs required, nullability
- State ownership
- Dependencies/direction
- Migrations

## Checklist
- [ ] Clear responsibility and purpose
- [ ] Inputs/outputs/types documented
- [ ] Validation at boundaries
- [ ] Error cases defined
- [ ] Backward compatibility considered
- [ ] Ownership/dependencies explicit
- [ ] Testable without excessive mocking

## Guardrails
- Avoid leaking implementation details
- Don't break existing contracts without migration plan
- Cite existing patterns
- Respect skill cap
