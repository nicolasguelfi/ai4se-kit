# Advisor session — procedure for the coding agent (any agent)

You assist the **trainer**, acting as an **external advisor** to the learners' projects. The learner runs
their project with GSE-One and **decides**; the trainer **advises**. Your job: inspect a project without
disturbing it, propose advice to the trainer, and — only on the trainer's explicit yes — leave that advice as
a GitHub issue labelled `gse-advisor`. GSE-One (0.93.4 or later) shows those issues to the learner when they
open their next sprint (`/gse-plan`): accept into the sprint, keep in the pool, or decline with a reason.

## Rules (they protect the learner's method)

1. **Never write in a learner's repository.** No commit, no push, no branch, no pull request, no file
   edit — not even in the local clones (`.advisor-cache/`, push disabled). Read with `git show`,
   `git log`, `git diff` on `refs/remotes/origin/*`.
2. **Your only output to a learner is an advisor ticket**, created with
   `python3 <kit>/trainer/advisor_tickets.py create`, and **only after the trainer said yes to that
   ticket**. Show it first with `--dry-run`.
3. **Ask the trainer only by a short multiple-choice question** (one question, the problem restated
   simply, the advantages and drawbacks of each option, your recommendation). For several tickets or
   data to show, use a board if your environment has one (Claude: the `review-board` skill; otherwise a
   local HTML page), with a comment field per ticket and a global comment.
4. **Measure before asserting**: every finding cites what you read (file and line, commit, `.gse/` field).
5. **Keep names private**: the roster and the board hold names; never copy them into a ticket or a repository.

## Steps

1. **Refresh the board** — `python3 <kit>/trainer/advisor.py --roster <roster>` (fetches what was pushed,
   writes `advisor.html` next to the roster). Read its alerts. Ask the trainer which learner and project
   to inspect (QCM), or propose the rows that need attention first.
2. **Inspect, read-only** — in the cache clone: `.gse/config.yaml` (mode), `.gse/plan.yaml` (sprint, steps
   done and left), `.gse/backlog.yaml` (tasks, test evidence), `.gse/decisions.md`,
   `docs/sprints/sprint-NN/` (reqs, design, review, release), the code and its tests on the sprint and
   feature branches, the commit history (test commit before code? reviews before delivery?).
3. **Propose tickets** — at most three per project and per round, the most useful first. Two kinds:
   *product* (a bug, a missing test, a requirement not met) and *method* (a skipped review, tests
   declared but absent, decisions not recorded, a sprint too big). One ticket = one problem, small enough
   for one task. Write each in English, the course language:
   - **Title** — the problem, short and concrete.
   - **What I saw** — the evidence (file:line, commit, `.gse/` field).
   - **Why it matters** — the consequence for the user of the product or for the method.
   - **Suggestion** — one way to fix it; the learner may choose another.
4. **Ask the trainer** — the proposals with their pros and cons and your recommendation; the trainer
   keeps, edits or drops each one.
5. **Create** — for each ticket the trainer kept: write the body to a temporary file outside any
   repository, run `create --dry-run`, then `create`; report each issue URL.
6. **Follow up** — `python3 <kit>/trainer/advisor_tickets.py list --roster <roster>` shows every advisor
   ticket and the learner's decision (GSE-One comments on the issue when the next sprint opens; a
   declined ticket is closed with its reason, an accepted one when its task is delivered).

`<kit>` is the folder of the course kit (`~/ai4se/ai4se-kit` by default).
