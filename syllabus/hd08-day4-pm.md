# HD08 — Day 4 afternoon: deliver and capitalise; frame your mini-project

*AI for Software Engineering (AI4SE), edition 2 — Friday 4 December 2026, 13:15-17:00.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 4 afternoon.*

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:15 | 75 | CCSET14 — Delivery, maintenance, capitalisation (theory 12, GSE-One 3, E16 60) |
| 14:30 | 15 | Debrief of E16 |
| 14:45 | 15 | Break |
| 15:00 | 90 | CCSET15 — Framing a project (theory 15, GSE-One 5, E17 25, E18 45) |
| 16:30 | 15 | Push both repositories, debrief, hands-up quiz |
| 16:45 | 15 | Buffer |

## Learning goals

At the end of this half-day you can:

1. Choose a merge strategy and justify it; say what a release is (tag, version number, change log).
2. Name the four kinds of maintenance, and run a short retrospective.
3. Close a GSE-One sprint end to end, and pick your work up again after a pause.
4. Frame a mini-project you can finish in a day and a half, and start it in Lightweight mode.

## CCSET14 — Delivery, maintenance, capitalisation

### Key ideas

**Bringing work to main.** Merge commit (every commit kept, plus a merge point: full history, but noisy), squash (the branch becomes one commit: clean main line, details lost), rebase (commits replayed on top of main: linear history, rewritten commits). No right answer: choose, and say why.

**A release** is a tag on the exact commit delivered, a version number MAJOR.MINOR.PATCH (Semantic Versioning: MAJOR breaks what users rely on, MINOR adds, PATCH fixes) and a change log written for the people who use it.

**Delivered is not finished** (ISO/IEC/IEEE 14764): corrective maintenance (fix a defect found in use), adaptive (follow a change of environment), perfective (improve), preventive (fix a weakness before it hurts). Most of a program's life is maintenance: write it for the next reader.

**Learn before the next cycle**: a retrospective (Derby & Larsen, 2006) asks what went well (keep it), what hurt (change it), and one action for the next cycle, with an owner. A lesson that is not written down is lost at the next session.

### How GSE-One solves it (CCSET14, concept only)

*The problem:* delivery is rushed, nobody knows what was shipped, and the lessons vanish with the session.

- `/gse-fix` fixes the findings you keep, test first, each on its branch.
- `/gse-deliver`: the merge strategy is a Gate; a tag, a change log; no delivery over an open HIGH finding or untested requirement without your decision.
- `/gse-compound` captures lessons on three axes: the project, the method, your competencies.
- `/gse-pause` and `/gse-resume` keep the thread between sessions; `/gse-backlog` keeps ideas for later.

### Exercise — Full Cycle and Continuity (13:30 · 60 min)

*CCSET14 · Exercise E16 (P7)*

**Goal:** Close the sprint loop, and know how to pick your work up again.

**Steps:**

1. `/gse-fix` on 2 findings, test first.
2. `/gse-deliver`: choose the merge strategy at the Gate and justify it.
3. `/gse-compound`: read the lessons captured, add your own.
4. `/gse-health`: compare with this morning.
5. Continuity: note an idea with `/gse-backlog`; `/gse-pause`, close opencode, reopen it, `/gse-resume`.

**Done when:** The feature is on `main`; your lesson is in the capitalisation file; `/gse-resume` tells you where you were.

**Mid-point:** 14:00 — the delivery is done.

**If stuck:** Your tutor window → restart from the tag `p7-start` → raise your hand.

**Debrief:** What did the agent keep as a lesson, and what would you have written? Did the health improve since this morning?

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § 10.4 — Merge Strategy (Gate Decision)`; `§ 10.6 — Safety and Recovery`; `§ 3.9 — Capitalization`; `§ 12.3 — Unified Backlog`. Glossary: merge strategy, release, change log, maintenance, retrospective.

## CCSET15 — Framing a project

### Key ideas

**Your mini-project.** Frame a small project of your own and drive it with GSE-One, end to end. "Professional" does not mean big; it means the method: plan before you build (`/gse-plan`), requirements with testable criteria before code (`/gse-reqs`), code and tests on a branch per task (`/gse-produce`), deliver with an integrity check (`/gse-deliver`).

**Small enough to finish**: one user (a real person you can picture), one problem (in one sentence), 2-4 requirements (the smallest product that solves it — a minimum viable product, Ries 2011), what is out of scope written in the backlog, and three milestones: card validated today, plan and requirements at 16:30 on day 5, delivery at 11:30 on day 6.

**The rules.** Judged on the process, not on the size. A first sprint of 8-10 complexity points, in Lightweight mode. One app, no multi-service infrastructure. A deployable technology, or your own Dockerfile. An existing project: one small change, with `/gse-go --adopt`. Private repository allowed: no client code on a public one. Demo on day 6: problem, product, one GSE-One moment, one lesson — 5 to 7 minutes.

**Need inspiration?** Shift planner (scheduling for a small team, flags conflicts) · recipe keeper (ingredient search, shopping list) · inventory tracker (low-stock alerts) · study buddy (flashcards with spaced repetition) · incident logger (severity, resolution time). Sparks, not assignments.

### How GSE-One solves it (CCSET15, concept only)

*The problem:* a full method on a one-day project costs more than it gives; no method lets the scope explode.

- The Lightweight mode keeps the same cycle with fewer steps and Gates: plan → requirements → production → delivery.
- The sprint has a complexity budget: what does not fit goes to the backlog.
- `/gse-go --adopt` brings an existing project under GSE-One without starting again.

### Exercise — Your Project Card (15:20 · 25 min)

*CCSET15 · Exercise E17*

**Goal:** A mini-project you can finish in a day and a half.

**Steps:**

1. Pick a subject: professional or personal. An existing project is allowed if reduced to one small change.
2. Fill one page: the user, the problem, 2 to 4 essential requirements, what is out of scope (backlog).
3. Add the technology (deployable, or with your own Dockerfile) and the 5-7 minute demo you will give.
4. Check it against the mini-project rules on the slide.

**Done when:** The card is written in the project repository (`docs/project.md`).

**If stuck:** Your tutor window → ask your neighbour to read your card → raise your hand.

**Debrief:** The trainer reads each card in one minute: "green" or "reduce".

### Exercise — Start Your Mini-Project in Lightweight Mode (15:45 · 45 min)

*CCSET15 · Exercise E18*

**Goal:** Your mini-project started under GSE-One and validated by the trainer.

**Steps:**

1. Create the project folder, `git init`, and its GitHub repository (private allowed).
2. Install GSE-One in the folder; run `/gse-go` and choose Lightweight mode.
3. Put every extra idea in the backlog, not in the plan.
4. Folder outside `~/ai4se`? Run `~/ai4se/ai4se-kit/tutor add <path>`.
5. Show your card to the trainer: "green" or "reduce".

**Done when:** `/gse-status` shows Lightweight mode, the card is "green", the repository is pushed.

**If stuck:** Your tutor window → raise your hand.

**Debrief:** Push both repositories (CalcApp and your project); hands-up quiz.

### Frequent errors

- A project for "everyone" with ten features → one user, one problem, 2-4 requirements; the rest in the backlog.
- The mini-project folder outside `~/ai4se` → the tutor window cannot read it: `~/ai4se/ai4se-kit/tutor add <path>`.
- Client code pushed to a public repository → create the repository private.

### Links

GSE-One: `§ 3.1 — Orchestration & Session` (`/gse-go`, `--adopt`); `§ 8 — Complexity Budget`. Glossary: mini-project, minimum viable product, Lightweight mode, backlog.

## Hands-up quiz

1. 100 % coverage: are the tests good? — *Not necessarily: coverage says what ran, not what was checked.*
2. The CI is red after your push. What do you do first? — *Read which step failed, fix it on your branch, push again — before anything else.*
3. Squash or merge commit: which keeps every step? — *The merge commit; squash keeps one commit per branch.*
4. A new browser version breaks the app: which kind of maintenance? — *Adaptive maintenance.*
5. Your mini-project in one sentence? — *One user, one problem — if it takes more, reduce.*

Before you leave: push both repositories, then `/gse-pause`.

## References

Derby, Larsen (2006), *Agile Retrospectives*. · ISO/IEC/IEEE 14764:2022, *Software maintenance*. · Preston-Werner (2013), *Semantic Versioning 2.0.0*. · Ries (2011), *The Lean Startup*.
