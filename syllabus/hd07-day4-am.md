# HD07 — Day 4 morning: tests, production, review; measuring quality

*AI for Software Engineering (AI4SE), edition 2 — Friday 4 December 2026, 09:00-12:15.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 4 morning.*

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 09:00 | 15 | Welcome: `tutor update`, `/gse-resume`, the quality kit |
| 09:15 | 120 | E14 — Test strategy, production, review (recall 10, exercise 80 + 30 around the break) — cycle CCSET12 in practice |
| 10:45 | 15 | Break |
| 11:30 | 15 | Debrief of the review triage |
| 11:45 | 30 | CCSET13 — Measuring quality (theory 10, GSE-One 3, E15 12, debrief 5) |

## Learning goals

At the end of this half-day you can:

1. Write a short test strategy yourself, then compare it with the one GSE-One proposes, and keep or refuse its points.
2. Read a review report critically: agree with the triage, fix first what matters, refuse with a reason.
3. Read four quality signals (lint, tests, coverage, build) on your machine and in continuous integration.
4. Say what coverage does not tell you.

## Welcome: the quality kit

### Key ideas

Bring the quality kit of the starter into your CalcApp first, so that every push of the morning runs lint, tests with coverage and the build on GitHub:

```bash
git fetch origin --tags
git checkout quality-kit -- .github/workflows/ci.yml
npm install -D @vitest/coverage-v8@4.0.18
npm pkg set scripts.test:coverage="vitest run --coverage"
git add .github package.json package-lock.json
git commit -m "ci: lint, tests with coverage, build" && git push mine --all
```

`origin` is the course starter you cloned on day 2; `mine` is your own repository (day 3).

## CCSET12 in practice — your strategy, then GSE-One

### Key ideas

Yesterday's cycle CCSET12 (hd05): verification and validation, test levels, test cases from equivalence classes and boundaries, the oracle problem. This morning you apply it before the agent does: five lines of strategy on paper, then `/gse-tests` (strategy derived from the requirements), `/gse-produce` (code and tests on a feature branch, tests run, evidence kept), `/gse-review` (several reviewers, findings RVW-… ranked HIGH / MEDIUM / LOW). As on day 2, you are the judge: at least one reasoned refusal.

### Exercise — Test Strategy, Production, Review (09:25 · 80 min + 11:00 · 30 min)

*CCSET12 · Exercise E14 (P6)*

**Goal:** The next feature, tested according to your strategy, then reviewed.

**Steps:**

1. On paper, 5 lines: your test strategy for the next requirement — which levels, which edge cases.
2. `/gse-tests`: compare with your strategy; accept or refuse at least one point.
3. `/gse-produce`: the tests run; how many pass?
4. Part 2 (11:00): `/gse-review`; read the 3 most severe findings in `review.md`.
5. Do you agree with the triage? Refuse at least one finding, with a written reason.

**Done when:** The feature is produced, its tests are green, `review.md` exists, and your triage is noted with at least one reasoned refusal.

**Mid-point:** 10:05 — your test strategy is validated.

**If stuck:** Your tutor window → restart from the tag `p6-start` → raise your hand.

**Debrief:** What did the review find that you missed by hand on day 2? What do you fix first, what do you refuse?

### Frequent errors

- Skipping the paper strategy → you can no longer tell what the agent added or forgot.
- Accepting every finding → some are false; refuse with one sentence of reason.
- Red tests left "for later" → the delivery will be blocked: fix now, on the branch.

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § 6.1 — Test Strategy Framework`; `§ 6.3 — Test Execution and Evidence`; `§ 6.5 — Test Review Layering`; `§ 3.7 — Quality` (`/gse-review`). Glossary: test strategy, test evidence, finding, triage.

## CCSET13 — Measuring quality

### Key ideas

**Signals, not opinions.** "All done, tests pass" from the agent is a claim; a green signal is a fact. Four signals on CalcApp: lint (`npm run lint`: rule breaks, suspicious code, without running it), tests (`npm run test:run`: the behaviour you specified still holds), coverage (`npm run test:coverage`: which lines the tests executed), build (`npm run build`: the app compiles and packages).

**Coverage is not quality** (Inozemtseva & Holmes, 2014). Coverage counts the lines a test executed, not what it checked: a test with no assertion gives 100 % and proves nothing; files no test loads may not even appear in the table; low coverage is a warning, high coverage is not a proof. Better check: break the code — does a test fail? (the mutant trick of day 2).

**Continuous integration** (Fowler, 2006): the same checks, on a clean machine, at every push — install, lint, tests with coverage, build, green or red. Red means: stop and fix before anything else is merged.

### How GSE-One solves it (CCSET13, concept only)

*The problem:* the agent says "done"; nothing says how healthy the project is.

- `/gse-health` scores the project on up to 8 dimensions: tests passing, review findings, git hygiene, requirements coverage, traceability…
- In Lightweight mode it keeps 3 of them: tests, review findings, git hygiene.
- Tests leave evidence; the review reads the results of your tools, not the agent's word.

### Exercise — Measure Your CalcApp (11:58 · 12 min)

*CCSET13 · Exercise E15*

**Goal:** Three measures of the quality of your code (the quality kit was added at 09:00).

**Steps:**

1. `npm run lint`: how many problems?
2. `npm run test:coverage`: which percentage? Which source files are missing from the table, and why?
3. On GitHub, tab Actions: open the last CI run of your repository. Which steps ran? Green or red?
4. `/gse-health`: compare with your three numbers.

**Done when:** The three numbers and the CI colour are written in the tracking sheet.

**If stuck:** No CI run? The kit is not pushed: `git push mine --all`. Then your tutor window → raise your hand.

**Debrief:** What does coverage not tell you? Hint: a file no test loads is not even listed.

### Links

GSE-One: `§ 7 — Project Health Dashboard`; `§ 6.4 — Coverage Model`. Glossary: lint, coverage, continuous integration, health score.

## References

Fowler (2006), *Continuous Integration*, martinfowler.com. · Inozemtseva, Holmes (2014), *Coverage Is Not Strongly Correlated with Test Suite Effectiveness*, ICSE.
