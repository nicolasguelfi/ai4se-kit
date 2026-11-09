# Where to find what in GSE-One (v0.90.0)

GSE-One is the methodology plugin used from day 3. Its full source is cloned on your
machine at tag **v0.90.0** in **`~/ai4se/gensem`** (done by `setup-learner.sh`). It is a
reference: read it, never edit it — your projects use the installed copy, not this clone.

> **Command spelling.** The documents use the Claude Code form `/gse:go`. In **opencode**
> type the dash form: `/gse-go`, `/gse-status`, `/gse-reqs`, … (same activity).

> **Size warning — for learners and for the tutor.** `gse-one-spec.md` is about **271 KB**
> and `gse-one-implementation-design.md` about **197 KB**. **Never read either file
> whole.** Search first (`git grep -n`, see § 7), then read only the section you found (its heading
> down to the next heading of the same level). The activity and principle files are small
> (a few KB to a few tens of KB) and can be read whole when needed.

Course-level material (programme, half-day sheets, glossary, FAQ, recovery) is in
`~/ai4se/ai4se-kit/syllabus/`. Cite GSE-One sections as **§ number + name**, e.g.
"spec § 9 — Guardrails".

---

## 1. Which document for which question

| Question type | Look in | Section |
|---|---|---|
| "What is GSE-One, what can it do?" | `README.md` | Key Features; Your first session |
| "How is it installed for opencode? What files does it write?" | `INSTALL-OPENCODE.md` | § 2 — Install; § 3 — Files written; § 7 — Troubleshooting |
| "Why are guardrails different in opencode 1 / 2?" | `README.md` | OpenCode 1 and 2 guardrails |
| "What does the method say about X?" (concepts, rules) | `gse-one-spec.md` | see § 2 below |
| "How is X implemented (state files, git mechanics, hooks)?" | `gse-one-implementation-design.md` | see § 3 below |
| "What exactly does command `/gse-<name>` do, step by step?" | `gse-one/src/activities/<name>.md` | see § 4 below |
| "What does reviewer / coach / … check?" | `gse-one/src/agents/<name>.md` | see § 5 below |
| "What does principle Pn require?" | `gse-one/src/principles/<name>.md` (short) or spec § 2 — Core Principles (full) | see § 6 below |
| "What does this term mean?" | spec § 16 — Glossary (start with "Essential Concepts") | also `syllabus/glossary.md` |
| "Which command when?" | spec § 3.10 — Commands by Lifecycle Phase; Appendix A — Activity Summary | |
| "What are the files in `.gse/` and `docs/sprints/`?" | spec § 12.1 — Project Layout | |

---

## 2. `gse-one-spec.md` — the methodology specification (≈ 271 KB)

| § | Chapter | One-line summary |
|---|---|---|
| 0 | Getting Started | Prerequisites (terminal, git basics, no language required) and a "first 20 minutes" walkthrough of `/gse:go`. |
| 1 | Overview | Coding agents and plugins (1.1), agile foundations (1.2), what GSE-One is (1.3), design philosophy — seven pillars (1.4), key concepts table (1.5), the 11 agent roles (1.6). |
| 2 | Core Principles | The 16 principles P1-P16 in full: lifecycle, artefacts, human-in-the-loop, planning, traceability (artefact ID prefixes), risk tiers, guardrails, version control, hooks, coaching, agent fallibility, adversarial review. |
| 3 | Activities (Commands) | The 24 commands grouped by purpose (orchestration, onboarding, learning, backlog, discovery, engineering, quality, deployment, capitalization); § 3.2.1 HUG profile dimensions; § 3.10 commands by lifecycle phase. |
| 4 | Collect — Artefact Inventory and External Source Discovery | Inventory of internal/external sources, reusability Gate, `sources.yaml`, provenance; § 4.7 Assess — gap analysis. |
| 5 | Preview | Showing what will be built before building it (static description or scaffold). |
| 6 | Testing Strategy | Test strategy framework, test environments, execution and evidence (TCP- reports), coverage model, § 6.5 test review layering (severity HIGH / MEDIUM / LOW), adaptation to expertise. |
| 7 | Project Health Dashboard | The 0-10 health score over 8 dimensions, risk alerts, trend, git hygiene sub-score. |
| 8 | Complexity Budget | Sprint capacity in points (1 pt ≈ 1 pair-session hour) and how it is visualised. |
| 9 | Guardrails | Purpose, levels Soft / Hard / Emergency, git-specific and test-specific guardrails, calibration by expertise. |
| 10 | Version Control Strategy | Branch model (`gse/sprint-NN/…`), worktrees, merge strategy Gate, commit message convention, § 10.6 safety and recovery (`gse-backup/` tags). |
| 11 | Decision Journal | Why and how decisions (DEC-NNN) are recorded in `.gse/decisions.md`; auto decisions log. |
| 12 | Artefact Storage Conventions | Project layout, artefact metadata, unified backlog (`backlog.yaml`), `status.yaml`, § 12.5 checkpoint format, state loading priority, resilience, dashboard. |
| 13 | Configuration & Customization | `.gse/config.yaml` fields; § 13.2 Lightweight Mode (the Micro / Lightweight / Full matrix); team usage; non-code projects. |
| 14 | Standard Activity Groups (Lifecycle Phases) | LC00-LC03 flow diagram, ceremony by expertise, sprint 1 vs N+1, adopting an existing project, § 14.3 orchestrator decision logic for `/gse:go` (incl. Sprint Freeze and mode choice). |
| 15 | Methodology Audit | `/gse:audit`: detecting drift from the method in a project (AUD- findings). |
| 16 | Glossary | 20 essential concepts, then the full glossary. |
| A | Appendix A — Activity Summary (Quick Reference) | The 24 commands on one screen. |
| B | Appendix B — Cost Assessment Grid for Maintenance Work | How the agent sizes maintenance work in complexity points. |
| C | Appendix C — Maintainer Guide | For people who modify GSE-One itself — not needed in the course. |

Most-used sections in the course: § 1.5 Key Concepts · § 2 P7 Risk-Based Decision
Classification (Auto / Inform / Gate) · § 3 Activities · § 9 Guardrails · § 10.6 Safety
and Recovery · § 12.1 Project Layout · § 13.2 Lightweight Mode · § 14 Lifecycle Phases ·
§ 16 Glossary.

---

## 3. `gse-one-implementation-design.md` — how it is built (≈ 197 KB)

Rarely needed in the course. Main chapters:

| § | Chapter | What you find there |
|---|---|---|
| 1 | Introduction | Scope of the design document. |
| 2 | Platform Git Capabilities | What each coding agent allows with git. |
| 3 | Architecture Overview | Repository structure, plugin manifests, mono-plugin architecture. |
| 4 | Git-Integrated Skill Designs | Git mechanics of `/gse:plan`, `/gse:produce`, `/gse:review`, `/gse:fix`, `/gse:deliver`, `/gse:pause`, `/gse:resume`, `/gse:status`, `/gse:health`. |
| 5 | Skill Designs | Per-activity design notes (learn, backlog, adopt mode, Lightweight mode, tests, devil's advocate, orchestrator decision logic, deploy, audit…); § 5.16 State Schemas & Design Mechanics (schemas of `.gse/` files, Sprint Freeze mechanics). |
| 6 | Methodology Deployment: Cross-Platform Parity | How the same method is shipped to each agent; § 6.3 opencode: AGENTS.md Embedding. |
| 7 | Hooks Design | The deterministic guardrails (e.g. blocking a commit on `main`). |
| 8 | Non-Git Project Handling | What happens without git. |
| 9 | Marketplace & Distribution | Distribution channels. |
| 10 | Shared Project State (`.gse/`) | The shared state folder; § 10.1 Sprint Plan Lifecycle (`plan.yaml`). |
| 11-14 | Generator Script Design · File Inventory · Implementation Priorities · Open Questions | Maintainer material. |

---

## 4. The 24 activities — `gse-one/src/activities/<name>.md`

In opencode each activity is the command `/gse-<name>`.

| Command | File | What it does |
|---|---|---|
| `/gse-go` | `go.md` | Single entry point: detects project state and proposes/runs the next activity; adopts an existing project; recommends the mode. |
| `/gse-status` | `status.md` | Where am I: sprint, current activity, artefacts, health, branches and worktrees. |
| `/gse-health` | `health.md` | Health dashboard (8 dimensions in Full, 3 in Lightweight). |
| `/gse-pause` | `pause.md` | Commits pending work and saves a checkpoint to resume later. |
| `/gse-resume` | `resume.md` | Reloads the last checkpoint, checks worktrees, tells you where you stopped. |
| `/gse-task` | `task.md` | Ad-hoc task outside the normal flow, on its own branch; `--spike` for a throw-away experiment. |
| `/gse-audit` | `audit.md` | Checks the project for drift from the method (missing evidence, skipped steps). |
| `/gse-hug` | `hug.md` | Builds or updates your user profile (expertise, language, involvement…); initialises git and `.gse/`. |
| `/gse-learn` | `learn.md` | Learning session on a topic (quick, deep, roadmap of competencies). |
| `/gse-backlog` | `backlog.md` | View and manage the unified list of work items (pool vs sprint). |
| `/gse-collect` | `collect.md` | Inventories existing artefacts (this project, other sources). |
| `/gse-assess` | `assess.md` | Gap analysis: what is covered, partial, missing with respect to the goals. |
| `/gse-plan` | `plan.md` | Builds or adjusts the sprint plan (`.gse/plan.yaml`): tasks, budget, sprint branch. |
| `/gse-reqs` | `reqs.md` | Elicits and writes functional and non-functional requirements with acceptance criteria. |
| `/gse-design` | `design.md` | Architecture, components, interfaces, shared state; decisions logged. |
| `/gse-preview` | `preview.md` | Shows what will be built before building it (description or scaffold). |
| `/gse-tests` | `tests.md` | Test strategy, test environment, tests, test campaigns and evidence. |
| `/gse-produce` | `produce.md` | Implements a task on a feature branch in its own worktree, then runs the tests. |
| `/gse-review` | `review.md` | Multi-perspective review of the sprint's branch diff, incl. devil's advocate; findings RVW-NNN. |
| `/gse-fix` | `fix.md` | Fixes review findings on a fix branch, traced to the findings. |
| `/gse-deliver` | `deliver.md` | Merges, tags, writes release notes, cleans branches; closes (freezes) the sprint. |
| `/gse-deploy` | `deploy.md` | Deploys the project to a server (Solo / Instructor / Learner roles). |
| `/gse-compound` | `compound.md` | End-of-sprint capitalization on 3 axes: project, methodology, competencies. |
| `/gse-integrate` | `integrate.md` | Routes what compound captured (project rules, upstream issues, learning notes). |

Each activity file has the same skeleton: frontmatter (`description`), options, prerequisites,
`## Workflow` with numbered steps. Search a step by its title: `git -C ~/ai4se/gensem grep -n "^### Step" -- gse-one/src/activities/NAME.md`.

---

## 5. The agents — `gse-one/src/agents/`

| File | Role |
|---|---|
| `gse-orchestrator.md` | The main identity: runs the lifecycle, the 16 principles, the decision tree behind `/gse-go`. |
| `requirements-analyst.md` | Checks that requirements are complete, testable, traceable (reqs, review). |
| `architect.md` | Evaluates architecture decisions (design, review). |
| `test-strategist.md` | Test coverage, strategy and evidence quality (tests, review). |
| `code-reviewer.md` | Code quality, security, maintainability (review). |
| `security-auditor.md` | Vulnerabilities and risks (design, review). |
| `ux-advocate.md` | User experience and accessibility (preview, review). |
| `devil-advocate.md` | Challenges the agent's own work: hallucinations, unverified claims (review, deliver). |
| `guardrail-enforcer.md` | Reference rules for guardrails (Soft / Hard / Emergency); enforced by hooks, not spawned. |
| `coach.md` | Watches the collaboration on 8 axes (pedagogy, velocity, engagement…) and gives advice. |
| `deploy-operator.md` | Safe, step-by-step deployment (deploy). |
| `gse-orchestrator-lite.md` | Condensed orchestrator for one other agent (Codex) — ignore in the course. |

Reviewer agents write findings as `RVW-NNN` with a `perspective:` and a severity
HIGH / MEDIUM / LOW (CRITICAL only by escalation — spec § 2 P15 — Agent Fallibility).

---

## 6. The 16 principles — `gse-one/src/principles/`

| # | Short title | File |
|---|---|---|
| P1 | Iterative & Incremental | `iterative-incremental.md` |
| P2 | Agile Terminology | `agile-terminology.md` |
| P3 | Artefacts Are Everything | `artefacts-are-everything.md` |
| P4 | Human-in-the-Loop | `human-in-the-loop.md` |
| P5 | Planning at Every Level | `planning-at-every-level.md` |
| P6 | Traceability | `traceability.md` |
| P7 | Risk Classification | `risk-classification.md` |
| P8 | Consequence Visibility | `consequence-visibility.md` |
| P9 | Adaptive Communication | `adaptive-communication.md` |
| P10 | Complexity Budget | `complexity-budget.md` |
| P11 | Guardrails | `guardrails.md` |
| P12 | Version Control | `version-control.md` |
| P13 | Hooks | `hooks.md` |
| P14 | Knowledge Transfer | `knowledge-transfer.md` |
| P15 | Agent Fallibility | `agent-fallibility.md` |
| P16 | Adversarial Review | `adversarial-review.md` |

The spec (§ 2 — Core Principles) uses longer titles, e.g. "P7 — Risk-Based Decision
Classification", "P14 — Knowledge Transfer (Coaching)".

---

## 7. Search recipes (for the tutor and for you)

Every recipe is a **`git grep`** command that works from any folder — in your terminal and in
the tutor window alike (the tutor has no other search tool; `git grep` searches only the
files tracked in the clone). `-n` prints line numbers; `-e A -e B` searches A **or** B;
`-F` searches the text literally; the files to search come after `--`. Replace `NAME` and
`TERM` by the activity name or the word you look for. Find the heading line number first,
then read from that line to the next heading of the same level (the tutor uses its read
tool with that line as offset; in your terminal, open the file at that line).

| Question | Search | Then read |
|---|---|---|
| Table of contents of the spec | `git -C ~/ai4se/gensem grep -n -e "^## " -e "^### " -- gse-one-spec.md` | — |
| Gates, Auto / Inform / Gate | `git -C ~/ai4se/gensem grep -n -e "^### P7" -e "Gate decision" -- gse-one-spec.md` | spec § 2 P7 — Risk-Based Decision Classification; P8 — Consequence Visibility |
| Modes Full / Lightweight / Micro | `git -C ~/ai4se/gensem grep -n -e "^### 13.2" -e "Micro mode" -- gse-one-spec.md` | spec § 13.2 — Lightweight Mode (the comparison matrix) |
| How the mode is chosen | `git -C ~/ai4se/gensem grep -n -e "Complexity assessment" -e "Step 6" -- gse-one-spec.md` | spec § 14.3 — Orchestrator Decision Logic |
| Sprint freeze ("sprint is frozen") | `git -C ~/ai4se/gensem grep -n "Sprint Freeze" -- gse-one-spec.md gse-one/src/activities/task.md gse-one/src/activities/deliver.md` | spec § 14.3, guardrail list "Sprint Freeze (Hard…)" |
| Backup tags, restore after a bad merge | `git -C ~/ai4se/gensem grep -n "gse-backup" -- gse-one-spec.md` | spec § 10.6 — Safety and Recovery |
| Pause / resume, checkpoints | `git -C ~/ai4se/gensem grep -n -e "^### 12.5" -e "checkpoint" -- gse-one-spec.md`; read `gse-one/src/activities/pause.md`, `gse-one/src/activities/resume.md` | spec § 12.5 — Checkpoint Format |
| Deploy | `git -C ~/ai4se/gensem grep -n "^### 3.8" -- gse-one-spec.md`; `git -C ~/ai4se/gensem grep -n -e "^### " -e "Learner" -- gse-one/src/activities/deploy.md` | spec § 3.8 — Deployment; `deploy.md` (Phase/Step structure) |
| Review severities HIGH / MEDIUM / LOW | `git -C ~/ai4se/gensem grep -n -e "^### 6.5" -e "CRITICAL" -- gse-one-spec.md` | spec § 6.5 — Test Review Layering; P15 — Agent Fallibility |
| When is FIX added? | `git -C ~/ai4se/gensem grep -n -F "[FIX]" -- gse-one-spec.md` | spec § 14 — Standard Activity Groups (LC02 row) |
| Delivery blocked by findings or tests | `git -C ~/ai4se/gensem grep -n -e "^### 9.3.1" -e "HIGH findings" -e "open HIGH" -- gse-one-spec.md gse-one/src/activities/deliver.md` | spec § 9.3.1 — Test-Specific Guardrails; `deliver.md` |
| Guardrail levels | `git -C ~/ai4se/gensem grep -n -e "^## 9\." -e "^### 9\." -- gse-one-spec.md` | spec § 9 — Guardrails |
| Commit on `main` blocked | `git -C ~/ai4se/gensem grep -n "Protect main" -- gse-one-spec.md` | spec § 2 P13 — Event-Driven Behaviors (Hooks) |
| Artefact IDs (REQ, DES, TST, RVW, DEC, TASK…) | `git -C ~/ai4se/gensem grep -n "Artefact ID allocation" -- gse-one-spec.md` | spec § 2 P6 — Traceability |
| Decision journal, DEC entries | `git -C ~/ai4se/gensem grep -n "^## 11\." -- gse-one-spec.md` | spec § 11 — Decision Journal |
| Files in `.gse/` and `docs/sprints/` | `git -C ~/ai4se/gensem grep -n "^### 12.1" -- gse-one-spec.md` | spec § 12.1 — Project Layout |
| `status.yaml`, `plan.yaml`, `backlog.yaml` fields | `git -C ~/ai4se/gensem grep -n -e "^### 12.3" -e "^### 12.4" -- gse-one-spec.md`; `git -C ~/ai4se/gensem grep -n "^### 5.16" -- gse-one-implementation-design.md` | spec § 12.3-12.4; design § 5.16 — State Schemas & Design Mechanics |
| Complexity budget, points | `git -C ~/ai4se/gensem grep -n -e "^## 8\." -e "Complexity budget" -- gse-one-spec.md` | spec § 8 — Complexity Budget; § 16 Glossary |
| Health score dimensions | `git -C ~/ai4se/gensem grep -n "^### 7.1" -- gse-one-spec.md` | spec § 7.1 — Health Score |
| HUG profile questions | `git -C ~/ai4se/gensem grep -n "^### 3.2.1" -- gse-one-spec.md` | spec § 3.2.1 — HUG Profile Dimensions |
| Spikes | `git -C ~/ai4se/gensem grep -n -e "--spike" -- gse-one-spec.md gse-one/src/activities/task.md` | spec § 3.1 — Orchestration & Session (`/gse:task`) |
| Lifecycle LC00-LC03 | `git -C ~/ai4se/gensem grep -n "^## 14\." -- gse-one-spec.md` | spec § 14 — Lifecycle Flow diagram |
| Compound axes (Axe 1/2/3) | `git -C ~/ai4se/gensem grep -n "^### 3.9" -- gse-one-spec.md` | spec § 3.9 — Capitalization; `gse-one/src/activities/compound.md` |
| Devil's advocate | `git -C ~/ai4se/gensem grep -n "^### P16" -- gse-one-spec.md` | spec § 2 P16 — Adversarial Self-Review and User Pushback |
| Confidence levels (Verified / High / Moderate / Low) | `git -C ~/ai4se/gensem grep -n "^### P15" -- gse-one-spec.md` | spec § 2 P15 — Agent Fallibility (Self-Awareness) |
| A step of an activity | `git -C ~/ai4se/gensem grep -n -e "^### Step" -e "^#### Step" -- gse-one/src/activities/NAME.md` | that step only |
| A term | `git -C ~/ai4se/gensem grep -n -i "TERM" -- gse-one-spec.md` (add `-m 20` to see only the first 20 hits) | spec § 16 — Glossary first |
| opencode install problems | `git -C ~/ai4se/gensem grep -n -e "^## " -e "^### " -- INSTALL-OPENCODE.md` | § 7 — Troubleshooting |

**Rules for the tutor.** Search with a precise pattern, read at most the one or two
sections found, cite them ("spec § 9.2 — Levels"), and say when the course or the spec
does not cover the question. The clone is pinned to v0.90.0: it describes the version
installed in the learners' projects.
