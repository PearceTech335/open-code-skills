---
description: Rigorous multi-stage orchestration for maximum integrity (research → decomposition → adversarial review → planning → implementation → review → test → sign-off). Use for local models or high-stakes work where code quality is paramount. Shares same agents and templates as autopilot, but forces full quality pipeline every step.
agent: rigour
---

This command activates the rigorous multi-stage orchestration path for maximum integrity. It uses the `rigour` agent which enforces the full quality pipeline (research → decomposition → adversarial review → planning → implementation → review → test → sign-off) for every task.

## Rigour Loop (mandatory for this command)

1. **Task + Project Research**
   - Research the specific task details
   - Research how it fits into overall program/project (read PROJECT_INDEX, architecture, mission, related tasks)
   - Document findings + evidence in `tasks/<id>.md`

2. **Decomposition**
   - Break the task into researched subtasks
   - Create detail files for each subtask if needed

3. **Adversarial Review of Research**
   - Independent critique of research findings and proposed approach
   - Identify gaps, risks, and assumptions

4. **Implementation Planning**
   - Detailed plan including any required updates to PROJECT_INDEX.md, README, architecture notes
   - Document changes in `memory/ARCHITECTURE-CHANGES.md` if applicable

5. **Coder (Implementation)**
   - Implement according to approved plan and research
   - Use single coder call per change unless complexity demands escalation

6. **Review**
   - Adversarial review of the actual diff (10-axis + Power-of-10 + security)
   - Checklist: syntax, static analysis, targeted tests, broader build, diff review

7. **Test**
   - Full verification sequence with observed evidence
   - Report PASS/FAIL per test with file/line and error output for failures

8. **Sign-off / Quality Gate**
   - Final acceptance criteria check + documentation updates
   - Tick task only after all criteria met and evidence documented

9. **Proceed to Next Task (or Subtask)**
   - Move to next unchecked item in `TASKS.md` or next subtask

## When to use rigour vs autopilot

| Use autopilot | Use rigour |
|---|---|
| Frontier models that can handle most work themselves | Local models where token usage is acceptable and code quality is paramount |
| Fast iteration, low-latency needs | High-stakes work (production code, security-sensitive changes) |
| "Just do the work competently" philosophy | Maximum integrity, evidence, and adversarial process |

## Notes

- This command still uses `agent: autopilot` as the orchestrator — no separate agent needed.
- Mode flags are injected into the orchestration loop via system prompt modifications.
- The same specialist agents (`coder`, `research`, `review`, `test`) are reused.
- State files (`TASKS.md`, `tasks/`, `CURRENT_STATE.md`) are shared between modes.

## Example usage

```
/rigour Build the user authentication system
```

This will run the full rigour loop for that task, creating subtasks as needed and proceeding through all stages before moving to the next item.
