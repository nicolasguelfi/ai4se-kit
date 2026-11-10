# AI4SE — Course programme (edition 2)

*"AI for Software Engineering" — six days in three blocks of two days:
Thu 26/11 and Fri 27/11, Thu 03/12 and Fri 04/12, Thu 10/12 and Fri 11/12/2026.*

This page is the map of the whole course: twelve half-days, **HD01** (day 1 morning) to
**HD12** (day 6 afternoon). Each half-day has its own sheet in this folder (`hdNN-….md`)
with explanations, exercise sheets, frequent errors and GSE-One references. Sheets are
published in phases: HD01-HD04 now, HD05-HD08 before day 3, HD09-HD12 before day 5.
Times are indicative: practice may run longer, and each day ends with a buffer.

Related pages: [glossary](glossary.md) · [FAQ](faq.md) · [recovery](recovery.md) ·
[where to find what in GSE-One](gse-guide.md).

---

## Course goal

Learn to **build software with an AI coding agent without giving up engineering
discipline**: you stay the one who decides, the agent does the typing, and the files,
tests and git history prove what was done. Days 1-2 teach the discipline by hand; days 3-4
let a method (GSE-One) drive the same loop; days 5-6 apply everything to a small project
of your own, deployed and demonstrated.

## The six objectives — what you can check at the end of day 6

| When | You will be able to… | Observable as |
|---|---|---|
| Days 1-2 | **Drive a coding agent with discipline** | you give a precise task, read its plan, approve or refuse each action |
| Day 2 | **Plan, build, test and review a small app with an AI agent** | CalcApp v0.1: your plan, your tests, an AI review you triaged |
| Day 2 → | **Use git as your safety net** | commit, branch, compare, go back to a known-good tag |
| Days 3-4 | **Run a structured AI-assisted lifecycle with GSE-One** | requirements → plan → build → review → deliver, on CalcApp |
| Day 4 | **Measure quality instead of trusting the agent's word** | lint, tests and CI give a green/red signal you can check |
| Days 5-6 | **Ship and present a mini-project** | scope, milestones, deployment, gallery demo |

These are abilities, not topics. The concepts (agent loop, plan, permissions, context
files) are the same in every coding agent: what you learn with opencode transfers.

## How the week works

- **Every topic is a cycle** (16 cycles, CCSET01 to CCSET16): theory (the problem, and the
  solutions known in research and in practice) → *how GSE-One solves it* (one slide, concept
  only) → exercise → debrief. Days 1-2 by hand with opencode; GSE-One from day 3 afternoon.
- **Practice right after the theory.** At most 10 minutes of demo, then you do it. Every exercise follows
  the same sheet: *Goal* / *Steps* / **Done when** (something you can see, e.g.
  "`npm run test:run` shows 3 passing tests") / *Mid-point check* / **If stuck** / *Debrief*
  (5-10 min, two questions, compare with your neighbour).
- **Stuck? → your tutor window** (the right-hand terminal). The tutor is an AI assistant
  prepared by the trainer — not the trainer. It runs in its own opencode session, reads
  your course folders (never your secrets), never changes anything, gives the smallest
  next step and tells you when to call the trainer. Order when stuck: **tutor window →
  recovery tag → raise your hand.**
- **Keep the kit fresh.** At the start of every half-day: `~/ai4se/ai4se-kit/tutor update`.
- **Feedback any time** as a GitHub issue on `nicolasguelfi/gensem` with the label
  `ai4se-ed2`. The repository is public: never paste a key, a password, client code or
  personal data.
- **Daily buffer.** The last slot of each day is kept free to catch up, ask, finish.
- **Hands-up quizzes.** A few true/false questions at the end of a day. No grades — they
  show what to revisit. Attendance gives the certificate.
- **No homework.** Everything happens in the room; nothing is required between blocks.

## Tools

| Tool | Role in the course |
|---|---|
| **opencode 2** | the terminal coding agent used in every exercise (*plan* and *build* agents, Tab switches) |
| **A capped model key** | handed out on paper on day 1; one per learner, with a spending cap; never paste it anywhere |
| **GSE-One v0.90.0** (pinned) | the methodology plugin (days 3-6); commands in opencode are `/gse-go`, `/gse-status`, … |
| **git + GitHub** (`gh`) | safety net from day 2; your work is pushed to GitHub from day 3, every evening |
| **Node.js / npm** | runs CalcApp and its tests (Vitest) |
| **The course kit** | `~/ai4se/ai4se-kit`: tutor window, this syllabus, `check-learner.sh` |

## What you own at the end

Everything lives under **`~/ai4se`** — a plain folder (not a git repository) holding
sibling repositories, none nested in another:

| Folder | What it is |
|---|---|
| `~/ai4se/ai4se-kit` | this kit: tutor, syllabus (CC BY 4.0), scripts (MIT) |
| `~/ai4se/gensem` | GSE-One source at tag v0.90.0: spec, design, activities (read-only reference) |
| `~/ai4se/freeselfapp` | your day-1 vibe-coded prototype |
| `~/ai4se/calcapp` | CalcApp, from the starter to the GSE-One sprints, with its tags (`v0.1`, …) |
| your mini-project | your own project (may live elsewhere: add it with `~/ai4se/ai4se-kit/tutor add <path>`) |
| `.gse/` in each GSE-One project | the method's state: profile, plan, backlog, decisions, checkpoints |

You can keep and reuse all of it after the course; you will only need your own model key.

---

## HD01 — Day 1 morning (Thu 26/11): generative AI, vibe coding, tools

**Timing.** 09:00-12:15 (break 10:35-10:50).

| Time | Session |
|---|---|
| 09:00 | Welcome, round table, level check (show of hands) |
| 09:30 | What you will be able to do; how we work this week |
| 09:45 | Generative AI fundamentals + key notions 1-3 |
| 10:50 | From vibe coding to vibe engineering (acts I-III) |
| 11:35 | Act IV — tools; key notion 4: AI Act and practical rules |

**Goals.** Understand what a coding agent is and is not; know the limits that shape every
later exercise (no memory, cost, mistakes); know the rules about data and permissions.

**Key notions.**
- From LLM to agent: a model predicts text; an agent loops model → tool → result → model.
- The model has no memory: between sessions only files and git remember.
- Model families and your key: what the key gives you; tokens = cost.
- Vibe coding (accept unread AI code) vs vibe engineering (same tools, with discipline).
- Autonomy levels: from autocomplete to autonomous agents; you choose what the agent may do.
- opencode: the course tool — open source, terminal, provider-agnostic; other tools and local LLMs.
- MCP: a standard way to plug external tools and data into an agent.
- AI Act and practical rules: what never goes into a prompt; which permissions to give an agent.

**Activities.** Round table; short demos; show-of-hands level check. No installation yet.

**Artefacts produced.** None on disk — your notes.

**Commands met.** `opencode` (shown in demo only).

**Recovery tag(s).** None.

**Sheet.** [`hd01-day1-am.md`](hd01-day1-am.md) (available).

---

## HD02 — Day 1 afternoon (Thu 26/11): installation, FreeSelfApp

**Timing.** 13:15-17:00 (break 15:15-15:30).

| Time | Session |
|---|---|
| 13:15 | Installation in the room (75 min) |
| 14:30 | FreeSelfApp workshop, part 1 — a naive prototype by prompting only |
| 15:30 | FreeSelfApp workshop, part 2 |
| 16:15 | Debrief: "what I would have done by hand / what the AI did"; hands-up quiz; day 2 preview |
| 16:45 | Buffer: late installations, questions |

**Goals.** A working machine (all checks green); feel vibe coding first-hand, so that
day 2 can show what discipline changes.

**Key notions.**
- Installation order matters: opencode 2 before GSE-One (the installer detects the version).
- The model key is a secret: `opencode auth login` stores it; never in a file, a prompt or an issue.
- The tutor window: a second terminal with its own opencode session, read-only.
- GitHub account + `gh auth login`: needed from day 3 to push your work.
- A commit is a save point you can return to.

**Activities.**
- Installation steps: terminal, Node.js, opencode 2, model key, course kit + tutor,
  GSE-One v0.90.0 in a test folder, GitHub + `gh auth login`, git identity, final check.
- FreeSelfApp: a small personal web app (ideas: recipe finder, habit tracker, movie
  watchlist — or your own, with made-up data), "no rules, no plan — on purpose".
  *Done when:* it opens in the browser, does one thing you wanted, and `git log` shows 2+ commits.

**Artefacts produced.** `~/ai4se/ai4se-kit`, `~/ai4se/gensem` (v0.90.0),
`~/.config/ai4se/tutor-paths`, `~/ai4se/gse-check` (test install of GSE-One),
`~/ai4se/freeselfapp` with 2+ commits, your debrief notes.

**Commands met.**
`git clone https://github.com/nicolasguelfi/ai4se-kit ~/ai4se/ai4se-kit && sh ~/ai4se/ai4se-kit/setup-learner.sh` ·
`opencode --version` · `opencode auth login` · `opencode auth list` ·
`curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/gensem/v0.90.0/install.sh | GSE_PLATFORM=opencode GSE_VERSION=v0.90.0 sh` ·
`gh auth login` · `git config --global user.name / user.email` ·
`sh ~/ai4se/ai4se-kit/check-learner.sh` · `~/ai4se/ai4se-kit/tutor` · `git init` ·
`git add` · `git commit`.

**Recovery tag(s).** None — FreeSelfApp is free work; if it breaks, start a new folder.
Installation problems → tutor window, then raise your hand.

**Sheet.** [`hd02-day1-pm.md`](hd02-day1-pm.md) (available).

---

## HD03 — Day 2 morning (Fri 27/11): CalcApp, git first, steering opencode, plan

**Timing.** 09:00-12:15 (break 10:45-11:00).

| Time | Session |
|---|---|
| 09:00 | Welcome, day 1 recap, "same tools, different discipline", the artefact chain |
| 09:15 | **Git first** on the CalcApp starter (35 min) |
| 09:50 | **Steering opencode**: 3 short demos, each followed by a try (55 min) |
| 11:00 | **Technical plan workshop** → your `docs/plan.md` |
| 11:30 | **CalcApp v0.1, part 1**: TDD with the AI on the first task of your plan |

**Goals.** Use git as a safety net before letting an agent touch code; give the agent a
readable project and precise context; plan before building; build test-first.

**Key notions.**
- CalcApp: a small budget tracker (React + TypeScript, Vitest), the running example of days 2-4.
- Working tree, staging area, commit; one branch per feature/task; `git restore` to undo.
- AI-readable project structure; `AGENTS.md` = the project's standing instructions for the agent.
- Context and `@file` mentions: give the agent exactly what it needs.
- *plan* agent (reads, proposes) vs *build* agent (edits) — switch with Tab.
- MCP and Context7 in `opencode.json`: up-to-date library docs for the agent.
- Atomic tasks with testable acceptance criteria; the plan is yours, not the agent's.
- TDD with an AI: red (failing test), green (make it pass), mutant test (break the code: does a test catch it?).

**Activities.**
- Git exercise (15 min): clone at `j2-start`, branch `feat/hello`, commit, break a file,
  restore. *Done when:* `git log --oneline` shows your commit on `feat/hello` and `git status` is clean.
- Three tries: write rules in `AGENTS.md`; give context with `@file`; plan then build.
- Plan workshop (30 min): elicit requirements with the *plan* agent, split into 5-8 atomic
  tasks, one marked `[next]`. *Done when:* `docs/plan.md` is committed as "docs: v0.1 plan".
- Build part 1 (45 min): first task of your plan, on its own branch, test first.

**Artefacts produced.** `~/ai4se/calcapp` on branch `mywork`, `AGENTS.md`,
`docs/plan.md`, first `feat/…` branch with tests.

**Commands met.** `git clone` · `git checkout -b mywork j2-start` · `npm ci` ·
`npm run test:run` · `git status` · `git diff` · `git add` · `git commit` · `git switch -c` ·
`git restore` · `git log --oneline` · `git branch` · in opencode: Tab, `@file`, `/init`.

**Recovery tag(s).** `j2-start` (start of the day). Restart:
`git clone https://github.com/nicolasguelfi/calcapp-starter calcapp && cd calcapp && git checkout -b mywork <tag> && npm ci`.
If your plan does not work out, the starter has a fallback example: `docs/plan-example.md`.

**Sheet.** [`hd03-day2-am.md`](hd03-day2-am.md) (available).

---

## HD04 — Day 2 afternoon (Fri 27/11): build, AI code review, ship v0.1, bridge to GSE-One

**Timing.** 13:15-17:30 (break 15:00-15:15).

| Time | Session |
|---|---|
| 13:15 | **CalcApp v0.1, part 2**: next tasks of your plan (navigation, data, UI) |
| 14:30 | **AI code review**: what the AI sees and misses, review size, HIGH / MEDIUM / LOW triage |
| 15:15 | **Review of the day's diff**: AI review, triage, chosen fixes, README 80/20 |
| 16:15 | **Ship v0.1**: merge, tag `v0.1` |
| 16:30 | **Bridge to GSE-One**: today's manual loop next to the `/gse-…` commands; debrief; quiz |
| 17:00 | Buffer: catch-up, questions, tutor window |

**Goals.** Finish a working v0.1 by following your own plan; review AI-written code
critically; ship a tagged version; see which GSE-One commands automate the loop you ran by hand.

**Key notions.**
- One branch per task, test first, commit when green.
- Review size: small diffs get real reviews; one task at a time if the diff is long.
- Severity triage HIGH / MEDIUM / LOW — the same scale as GSE-One's review findings.
- At least one argued refusal: you do not apply every finding.
- README 80/20: the 20 % of documentation that answers 80 % of the questions.
- A tag marks a version you can always return to.
- The manual loop plan → tasks → TDD → review → delivery maps to `/gse-plan`,
  `/gse-tests` + `/gse-produce`, `/gse-review`, `/gse-fix`, `/gse-deliver`.

**Activities.**
- Build part 2 (75 min): next tasks of your plan, one branch each, test first.
- Review exercise (60 min): AI review of `git diff j2-start`, triage, fix the chosen
  findings on a `fix/review` branch, update the README.
- Ship (15 min): merge into `mywork`, all tests green, `git tag v0.1`.
- Bridge (30 min): the same loop, driven by GSE-One from day 3; hands-up quiz.

**Artefacts produced.** More `feat/…` branches, `fix/review` branch, updated `README.md`,
tag `v0.1` in `~/ai4se/calcapp`.

**Commands met.** `git diff j2-start` · `git diff j2-start --stat` · `git merge` ·
`git tag v0.1` · `git log --oneline --graph --decorate` · in opencode: `!git diff …`
(run a shell command from the prompt).

**Recovery tag(s).** `j2-part1` (end of the morning build, 13:15) and `j2-v0.1`
(v0.1 ready for delivery, 16:15).

**Sheet.** [`hd04-day2-pm.md`](hd04-day2-pm.md) (available).

---

## HD05 — Day 3 morning (Thu 03/12): software engineering concepts, requirements, qualities, verification

**Timing.** 09:00-12:30 (break 11:00). Lunch 12:30-13:30.

| Time | Session |
|---|---|
| 09:00 | Welcome, `tutor update`, recall of days 1-2; CalcApp pushed to your GitHub |
| 09:15 | **CCSET09 — Software engineering concepts, defining your GenSEM** (60 min): why a method, evidence, risks, the landscape of methods; how GSE-One solves it; the Gate grid and the orientation page |
| 10:15 | **CCSET10 — Requirements elicitation** (45 min) |
| 11:15 | **CCSET11 — Non-functional requirements** (45 min) |
| 12:00 | **CCSET12 — Verification and validation** (30 min) |

**Goals.** Understand why a method matters with a coding agent and what it must define;
elicit and write testable requirements; make qualities measurable; tell verification from
validation and design test cases.

**Key notions.**
- The centre of gravity moves from writing code to deciding, checking and maintaining it; perceived vs measured productivity.
- A GenSEM defines a lifecycle, artefacts, roles, decision rules, quality gates and learning.
- Elicitation techniques (interview, observation, workshop, questionnaire, scenarios, prototype); user stories (INVEST); Given/When/Then acceptance criteria; ambiguity.
- Non-functional requirements: ISO/IEC 25010:2023 quality model; scale, meter, goal; quality scenarios; trade-offs.
- Verification vs validation; test levels; test pyramid; equivalence classes and boundaries; the oracle problem.
- For each topic, the solution GSE-One chose (concept only): principles, lifecycle, modes Full / Lightweight / Micro, Gates and the 3-question grid.

**Activities.** No exercise this morning: the exercises of these four cycles are this afternoon (HD06) and tomorrow morning (HD07).

**Artefacts produced.** CalcApp repository on GitHub. The printed orientation page ([orientation.md](orientation.md)).

**Commands met.** `gh repo create` · `git push`.

**Sheet.** [`hd05-day3-am.md`](hd05-day3-am.md).

---

## HD06 — Day 3 afternoon (Thu 03/12): first use of GSE-One — discover, plan, requirements and design

**Timing.** 13:30-17:00 (break 15:15).

| Time | Session |
|---|---|
| 13:30 | **E11 — Discover GSE-One on your CalcApp** (60 min): install it in the project, `/gse-go`, profile, **Full** mode at the Gate, `.gse/`, a guardrail refusal |
| 14:30 | **E12 — Plan the sprint with GSE-One** (45 min): collect → assess → plan, validate at the Gate |
| 15:30 | **E13 — Requirements and design** (75 min): `/gse-reqs`, `/gse-design`, `/gse-preview`, traceability |
| 16:45 | Push to GitHub, `/gse-pause`, hands-up quiz |

**Goals.** Use GSE-One on a real project; pass Gates with the grid (at least one change or
refusal per activity); obtain a validated plan, requirements and design, traced together.

**Key notions.**
- `.gse/` holds the project state: profile, status, backlog, plan.
- Gate discipline; guardrails (no commit on `main`).
- Sprint = a cycle sized by a complexity budget; `plan.yaml` as a living plan.
- REQ with Given/When/Then acceptance criteria, functional and non-functional; design decisions; preview; traceability REQ → design → task.

**Artefacts produced.** `.gse/` in CalcApp, `.gse/plan.yaml`, `docs/sprints/sprint-01/reqs.md`,
`design.md`, `preview.md`, decisions in `.gse/decisions.md`.

**Commands met.** `/gse-go` · `/gse-status` · `/gse-plan` · `/gse-reqs` · `/gse-design` ·
`/gse-preview` · `/gse-pause` · `git push`.

**Recovery tag(s).** `p3-start` (CalcApp ready for GSE-One), `p5-start` (CalcApp with an approved plan).

**Sheet.** [`hd06-day3-pm.md`](hd06-day3-pm.md).

---

## HD07 — Day 4 morning (Fri 04/12): tests, production, review; measure quality

**Timing.** 09:00-12:15 (break 10:45).

| Time | Session |
|---|---|
| 09:00 | Welcome, `tutor update`, `/gse-resume`, the quality kit (CI + coverage) from the starter tag `quality-kit` |
| 09:15 | **E14 — Test strategy, production, review** (CCSET12 in practice): your strategy first, then `/gse-tests` → `/gse-produce` (80 min, then 30 min after the break) |
| 11:30 | Debrief: what you fix first, what you refuse |
| 11:45 | **CCSET13 — Measuring quality** (30 min): lint, coverage, CI; exercise E15 |

**Goals.** Let the method drive test strategy, production and review, checked against your
own strategy; read a review report critically; get an objective quality signal instead of
the agent's word.

**Key notions.**
- Test strategy before code, derived from the requirements; test evidence.
- PRODUCE works on a feature branch and runs the tests.
- Review findings RVW-… ranked HIGH / MEDIUM / LOW; at least one reasoned refusal.
- Lint, coverage and its limits, CI on every push; the health of the project.

**Artefacts produced.** Test strategy, tests and code on a feature branch, test reports,
`review.md`, a CI run on GitHub.

**Commands met.** `/gse-resume` · `/gse-tests` · `/gse-produce` · `/gse-review` ·
`/gse-health` · `npm run lint` · `npm run test:coverage`.

**Recovery tag(s).** `p6-start`.

**Sheet.** [`hd07-day4-am.md`](hd07-day4-am.md).

---

## HD08 — Day 4 afternoon (Fri 04/12): deliver and capitalise; frame your mini-project

**Timing.** 13:15-17:00 (break 14:45).

| Time | Session |
|---|---|
| 13:15 | **CCSET14 — Delivery, maintenance, capitalisation**: theory, then **E16 — Full cycle and continuity** (fix, deliver, compound, health, pause/resume) |
| 14:30 | Debrief |
| 15:00 | **CCSET15 — Framing a project**: theory, then **E17 — Your project card** |
| 15:45 | **E18 — Start your mini-project** in **Lightweight** mode; the trainer validates each card ("green" or "reduce") |
| 16:30 | Push both repositories, debrief, hands-up quiz |
| 16:45 | Buffer |

**Goals.** Deliver a GSE-One sprint end to end; capitalise what you learned; frame a small
project that you can finish and demo in a day and a half.

**Key notions.**
- Delivery: merge strategy (a Gate), tag, changelog; no delivery over an open HIGH without your decision.
- Backup tags `gse-backup/…`; pause and resume; the backlog for later ideas.
- Capitalisation: project learnings, methodology feedback, competencies.
- Mini-project = one user, one problem, 2-4 requirements, a first sprint of 8-10 points; one page: scope, milestones, demo.
- Lightweight mode: plan → requirements → production → delivery.

**Artefacts produced.** Delivered sprint on CalcApp (tag, release notes, capitalisation),
mini-project repository with `.gse/` and its project card (`docs/project.md`).

**Commands met.** `/gse-fix` · `/gse-deliver` · `/gse-compound` · `/gse-health` ·
`/gse-backlog` · `/gse-pause` · `/gse-resume` · `/gse-learn` · `/gse-go` ·
`~/ai4se/ai4se-kit/tutor add <path>` (if the mini-project is outside `~/ai4se`).

**Recovery tag(s).** CalcApp: `p7-start`. Mini-project: `gse-backup/…` tags and `/gse-pause`
checkpoints (see [recovery](recovery.md)).

**Sheet.** [`hd08-day4-pm.md`](hd08-day4-pm.md).

---

## HD09 — Day 5 morning (Thu 10/12): mini-project sprint; deployment waves

*Provisional — refined before the day.*

**Timing.** 09:00-12:15.

| Time | Session |
|---|---|
| 09:00 | Welcome, `tutor update`, `/gse-resume` on the mini-project |
| 09:15 | How deployment works: container (Dockerfile), server, your application id |
| 09:45 | **Mini-project sprint**: plan and requirements |
| 09:45 → | **Deployment waves** of 5 learners, in parallel with the sprint |

**Goals.** Make steady progress on your own project with the method; deploy CalcApp
(or your mini-project) once, guided, to understand the path from code to a live URL.

**Key notions.**
- A Dockerfile describes how to build and run the app in a container (the CalcApp starter ships a tested one).
- Deployment is done in waves of 5 to avoid overloading the server; the trainer guides each wave.
- Credentials never go into the repository, a prompt or an issue.
- Requirements first: no production without at least one requirement with acceptance criteria.

**Activities.**
- Sprint: `/gse-plan`, `/gse-reqs` on the mini-project; commit and push.
- Deployment: when your wave is called, follow the deployment sheet with the trainer.

**Artefacts produced.** Mini-project plan and `reqs.md`; a deployed application.

**Commands met.** `/gse-resume` · `/gse-plan` · `/gse-reqs` · `/gse-status` · deployment commands given on the sheet.

**Recovery tag(s).** CalcApp deployable tag announced on the day; mini-project: `gse-backup/…` and checkpoints.

**Sheet.** [`hd09-day5-am.md`](hd09-day5-am.md) (coming with phase 3).

---

## HD10 — Day 5 afternoon (Thu 10/12): mini-project sprint; milestone at 16:30

*Provisional — refined before the day.*

**Timing.** 13:15-17:00.

| Time | Session |
|---|---|
| 13:15 | Mini-project sprint continues; remaining deployment waves |
| 16:30 | **Milestone**: requirements and plan validated with the trainer |
| 16:45 | Push, `/gse-pause`, buffer |

**Goals.** Have a validated plan and requirements and the first tasks produced, so that
day 6 is about finishing, not starting.

**Key notions.**
- Cut scope early: what will not be done by Friday 11:30 goes to the backlog.
- Each task on its own branch, tests run by PRODUCE.
- Lightweight DELIVER still runs a minimal integrity check (HIGH findings block the merge).

**Activities.** `/gse-produce` on the first tasks; milestone review with the trainer at 16:30.

**Artefacts produced.** Validated `reqs.md` and plan; first produced tasks with tests; pushed repository.

**Commands met.** `/gse-produce` · `/gse-status` · `/gse-backlog` · `/gse-pause` · `git push`.

**Recovery tag(s).** `gse-backup/…` tags and checkpoints.

**Sheet.** [`hd10-day5-pm.md`](hd10-day5-pm.md) (coming with phase 3).

---

## HD11 — Day 6 morning (Fri 11/12): finish, deliver, freeze; applied ethics

*Provisional — refined before the day.*

**Timing.** 09:00-12:45.

| Time | Session |
|---|---|
| 09:00 | Welcome, `tutor update`, `/gse-resume` |
| 09:15 | Finish the sprint |
| 11:30 | **First delivery** (`/gse-deliver`) |
| 12:00 | **Freeze** — no new features; hunt for empty stubs |
| 12:15 | **Applied ethics on your own project**: AI Act, licences, security |

**Goals.** Deliver something that really works; check honestly what is real and what is
a placeholder; look at your own project through ethics, law and security.

**Key notions.**
- Freeze: after noon only fixes, no new features.
- Empty stubs: buttons or functions that look done but do nothing (placeholders, `TODO`, `PREVIEW:` markers).
- AI Act risk categories applied to your project; licences of the code and dependencies you used; secrets and data exposure.

**Activities.** Finish and deliver; stub hunt (click every button, read every `TODO`);
a short ethics/licence/security checklist on your own project.

**Artefacts produced.** Delivered and tagged mini-project; your ethics/security checklist notes.

**Commands met.** `/gse-deliver` · `/gse-status` · `/gse-health` · `git tag` · `git push`.

**Recovery tag(s).** The delivery tag of 11:30 is your demo fallback.

**Sheet.** [`hd11-day6-am.md`](hd11-day6-am.md) (coming with phase 3).

---

## HD12 — Day 6 afternoon (Fri 11/12): gallery demos, lessons learned, closing

*Provisional — refined before the day.*

**Timing.** 13:45-17:00.

| Time | Session |
|---|---|
| 13:45 | Prepare your demo (imposed structure) |
| 14:00 | **Gallery, rotation 1** — half of the group presents at their laptop, the other half visits |
| 14:45 | **Gallery, rotation 2** — roles swap |
| 15:30 | Break |
| 15:45 | Lessons learned (group) |
| 16:15 | Your "Monday morning" plan |
| 16:35 | Final questionnaire |
| 16:50 | Certificates, closing |

**Goals.** Show what you built and how; hear what others learned; leave with a concrete
plan for using AI agents with discipline at work.

**Key notions.**
- Demo in 5-7 minutes with an imposed structure: the problem, a live demo, the evidence
  (requirements, tests, review), one lesson.
- Lessons learned: what you would keep, change, drop.
- "Monday morning": the first concrete thing you will do differently at work.

**Activities.** Two gallery rotations; group lessons learned; individual plan; final
questionnaire (the course's main feedback channel, together with the `ai4se-ed2` issues).

**Artefacts produced.** Your demo; your "Monday morning" plan; certificate of attendance.

**Commands met.** None new.

**Recovery tag(s).** Demo from your delivery tag if the latest version misbehaves.

**Sheet.** [`hd12-day6-pm.md`](hd12-day6-pm.md) (coming with phase 3).
