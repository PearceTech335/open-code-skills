# PROJECT_INDEX.md

> Evidence labels used throughout: `VERIFIED` (confirmed by source inspection) · `INFERRED` (suggested but not confirmed) · `UNKNOWN` (documented gap — not yet established).
> Operational state (progress counts, run statistics) does not belong here — see `PROJECT_STATUS.md`.

## 1. Project Overview
- **Purpose**: [What the project does and why it exists]
- **Status**: [Active / In Development / Maintenance / Archived]
- **Version**: [Current version or release]
- **Last Updated**: [YYYY-MM-DD]

## 2. Technology Stack
- **Language**: [Primary programming language(s)]
- **Framework**: [Web framework, UI framework, etc.]
- **Database**: [Primary database(s)]
- **Runtime**: [Node.js, Python, Java, etc.]
- **Build Tools**: [Webpack, Vite, Maven, Gradle, etc.]
- **Package Manager**: [npm, yarn, pip, cargo, etc.]

## 3. Project Status (Stable)
- **Implemented**: [List of fully implemented features/modules]
- **In Progress**: [List of features currently being developed]
- **Planned**: [List of features documented but not yet implemented]
- **Known Issues**: [List of known bugs, limitations, or technical debt]
- **Operational State**: → Maintained separately in `PROJECT_STATUS.md` (or existing tracking docs). Do not record progress counts or run statistics here.

## 4. Architecture Overview
- **Pattern**: [MVC, Microservices, Monolithic, etc.]
- **Key Components**: [High-level description of major components]
- **Data Flow**: [Brief description of how data moves through the system]
- **Integration Points**: [External systems, APIs, or services]

## 5. Repository Structure
[Actual discovered tree — not an assumed layout. Annotate major directories with their purpose.]
```
project-root/
├── src/                    # [purpose]
│   ├── pipeline.py         # [responsibility]
│   └── ...
├── tests/                  # [test suites]
├── data/                   # [datasets / persistence]
├── models/                 # [trained artifacts]
├── scripts/                # [build and utility scripts]
├── docs/                   # [documentation]
├── config/                 # [configuration]
└── .venv/                  # [local environment — excluded from indexing]
```
- **Datasets**: [where input data lives]
- **Trained models / artifacts**: [where build outputs are stored]
- **Logs**: [where logs are written]
- **Utilities / support scripts**: [where helper tooling lives]

## 6. Application Entry Points
- **Main Entry**: [Path + entry function, e.g., `src/pipeline.py::main`]
- **Launch Command**: [Exact command(s) to start the application]
- **CLI Entry**: [Path to CLI entry point, if applicable]
- **Server Entry**: [Path to server entry point, if applicable]
- **Test Entry**: [Path to test runner configuration]
- **Processes**: [Are training and execution separate processes? One-shot or daemon?]
- **Scheduling**: [How periodic work is triggered — cron, internal loop, scheduler lib]
- **Error Handling & Restarts**: [What happens on failure; restart/supervision behaviour]

## 7. Component and Module Register
| Component | Location | Responsibility | Depends On | Evidence |
|-----------|----------|----------------|------------|----------|
| [Component Name] | [Path] | [Brief description] | [Modules it imports/invokes] | VERIFIED / INFERRED / UNKNOWN |

## 8. Component Relationships (Deep)
[For each primary component, answer the structural questions an agent needs before modifying interconnected functionality:]
- Does [A] invoke [B] directly, or only share data through [C]?
- Does [A] calculate parameters, or execute decisions?
- Does [X] handle [one concern] or [multiple concerns]?
- **Data stores — producers and consumers**:
  | Store | Written by | Read by | Evidence |
  |-------|-----------|---------|----------|
  | [e.g., live_scores.json] | [components] | [components] | VERIFIED / INFERRED |

## 9. Execution and Data Flow
- **Startup Sequence**: [Ordered description of application startup]
- **Execution Flow**: [How work proceeds after startup — the critical path]
- **Request Handling**: [How requests are processed, if applicable]
- **Data Persistence**: [How data is stored and retrieved — by whom]
- **Error Handling**: [Strategy for handling errors]

## 10. Dependencies and Integrations
- **External Libraries**: [List of key external libraries and their purposes — from manifests]
- **APIs**: [External APIs consumed or provided]
- **Services**: [External services integrated]
- **Authentication**: [Authentication mechanism]

## 11. Configuration and Environment Map
- **Configuration Sources**: [Config files and what they control]
- **Environment Variables**: [Key variables required, including which are secrets]
- **Secrets Handling**: [How credentials are stored/loaded — never record secret values]
- **Model / Artifact Storage**: [Where trained models are loaded from/saved to]
- **External Service Environments**: [e.g., demo vs live endpoints, sandbox vs production]
- **Execution Environments**: [Local/Mac/CI differences, Python or runtime version constraints]
- **Dependency Management**: [How dependencies are installed and pinned]
- **Development Setup**: [Steps to set up development environment]
- **Production Setup**: [Steps to deploy to production]

## 12. Data Models and Storage
- **Database Schema**: [Brief description of database structure]
- **Data Models**: [Key data models or entities]
- **Caching Strategy**: [Caching mechanism, if any]
- **Storage**: [File storage, object storage, etc.]

## 13. Interfaces and APIs
- **REST Endpoints**: [List of REST API endpoints]
- **GraphQL Schema**: [GraphQL schema summary, if applicable]
- **WebSocket**: [WebSocket events or channels]
- **CLI Commands**: [Available CLI commands]

## 14. Testing and Validation
| Test Type | Location | Command | Status |
|-----------|----------|---------|--------|
| Unit tests | [path] | [command] | Verified / To be verified / None found |
| Integration tests | [path] | [command] | Verified / To be verified / None found |
| Compilation check | [e.g., Python sources] | [e.g., `python -m py_compile <file>`] | Verified |
| Full validation | [path] | [command] | Verified / To be verified / None found |

- **Coverage**: [Test coverage information, if available]
- **Safe Validation**: [How to validate changes without triggering side effects — critical for applications with live/external operations]

## 15. Build and Deployment
- **Build Process**: [How the project is built]
- **Deployment Targets**: [Where the project is deployed]
- **CI/CD**: [Continuous integration and deployment pipeline]
- **Release Process**: [How releases are managed]

## 16. Security Architecture
- **Authentication**: [How users are authenticated]
- **Authorization**: [How access is controlled]
- **Input Validation**: [How input is validated]
- **Security Headers**: [Security headers configured]
- **Vulnerability Scanning**: [Tools used for security scanning]

## 17. Documentation Register
- **README.md**: [Main project documentation]
- **CONTRIBUTING.md**: [Contribution guidelines]
- **CHANGELOG.md**: [Version history]
- **docs/**: [Additional documentation]
- **API Documentation**: [API documentation location]
- **ARCHITECTURE.md**: [Target/intended design, if present — note it describes intent, not necessarily implementation]

## 18. Known Issues and Limitations
- **Technical Debt**: [Known technical debt items]
- **Performance Issues**: [Known performance bottlenecks]
- **Compatibility Issues**: [Known compatibility issues]
- **Feature Gaps**: [Missing features or functionality]

## 19. Architectural Decisions
- **ADR-001**: [Architecture Decision Record 1]
- **ADR-002**: [Architecture Decision Record 2]
- **ADR-003**: [Architecture Decision Record 3]

## 20. Change Impact Map
| Changing | Inspect / Likely Regression Areas | Related Tests | Related Docs |
|----------|-----------------------------------|---------------|--------------|
| [Component] | [Components consuming it, tests, docs] | [Tests to update] | [Docs to update] |

## 21. Discovery Completeness Report
[Required before finalising. Records what was actually inspected — not assumed.]
- **Directories inspected**: [list]
- **Primary modules inspected**: [list]
- **Dependency manifests inspected**: [list]
- **Tests discovered**: [locations or "none found"]
- **Entry points identified**: [list]
- **Unresolved architectural questions**: [gaps documented as UNKNOWN — never filled with guesses]
