# HD04 — Day 2 afternoon: CalcApp v0.1 part 2, AI code review, ship v0.1, bridge to GSE-One

*AI for Software Engineering (AI4SE), edition 2 — Friday 27 November 2026, 13:15-17:30.*
*Content licensed CC BY 4.0. Slide deck: "Day 2 — Driving a Coding Agent: CalcApp v0.1" (afternoon part).*

Start of the half-day: `~/ai4se/ai4se-kit/tutor update`, then open your tutor window (`~/ai4se/ai4se-kit/tutor`) in a second terminal. This sheet continues hd03 § CalcApp v0.1 part 1 — test first (TDD, the golden rule and the mutant trick are explained there).

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:15 | 75 | CalcApp v0.1 part 2 (re-orientation 5 · practice 50 · debrief 10) |
| 14:30 | 30 | AI-assisted code review |
| 15:00 | 15 | Break |
| 15:15 | 60 | Review today's diff (review 35 · README 80/20 15 · debrief 10) |
| 16:15 | 15 | Ship v0.1 |
| 16:30 | 30 | Bridge to GSE-One · debrief · hands-up quiz |
| 17:00 | 30 | Buffer: catch up, questions, tutor window |

## Learning goals

At the end of this half-day you can:

1. Apply the same test-first loop to every task of your plan, one branch per task, and review the agent's code with a checklist.
2. Explain what AI review catches and misses, why review size matters, and write an effective review prompt.
3. Triage findings HIGH / MEDIUM / LOW and decide for each: fix, defer, or refuse with a written reason.
4. Write a README where the agent writes the WHAT and you write the WHY.
5. Ship a tagged `v0.1` and map today's manual loop onto the GSE-One commands.

## CalcApp v0.1 part 2

### Key ideas

**Re-orientation (5 min) after lunch:** `cd ~/ai4se/calcapp` → `git status` clean, on `mywork`; `npm test` → part 1 tests still green (`q` quits); `npm run dev` → the app renders in the browser; start opencode, read `@docs/plan.md`: which task is next? One check fails and you cannot fix it in 5 minutes? Catch up from the tag `j2-part1` (end of part 1, first features, tests green):

```bash
git clone https://github.com/nicolasguelfi/calcapp-starter ~/ai4se/calcapp-restart
cd ~/ai4se/calcapp-restart && git checkout -b mywork j2-part1 && npm ci
```

Copy back `docs/plan.md` and `AGENTS.md` from `~/ai4se/calcapp`, skip the tasks already done in the tag, continue with the next one. A recovery tag is a safety net, not a failure.

**Same loop, every task:** branch `git switch -c feat/<task-name>` → RED: test only → *you* review → commit `test: …` → GREEN: minimal code, test untouched → commit `feat: …` → mutant check → undo → review the agent's code (checklists below) → merge into `mywork` only when green. Typical order: routing → data → UI; follow your plan's order.

**Task — routing and navigation.** Two pages: `/` → Dashboard (expenses + total), `/add` → Add Expense (the form).

```text
RED:   Write a failing test in tests/App.test.tsx: render `routes` from
       src/App.tsx with createMemoryRouter + RouterProvider; expect links
       "Dashboard" and "Add Expense". A second test starts at "/add"
       (initialEntries) and expects a heading "Add Expense". Test only.
GREEN: Make it pass with react-router (NOT react-router-dom): export `routes`
       from src/App.tsx (Layout with nav Links + Outlet; "/" Dashboard,
       "/add" AddExpense); App keeps createBrowserRouter(routes).
       One file per page in src/pages/. Do not modify the test.
```

*Review checklist:* `react-router` in `package.json`, no `react-router-dom`? navigation with `Link`, not `<a href>` (no full reload)? one file per page in `src/pages/`? test untouched (`git diff -- tests/` shows nothing)? `npm run dev`: click both links, does the back button work? *Trust, but verify* — you will need this habit at 14:30.

**Task — data layer.** `Expense` type in `src/types/expense.ts`, storage in `src/utils/storage.ts`; localStorage is enough for v0.1.

```text
RED:   Write a failing integration test: `routes` in a memory router at "/add",
       fill amount 42.50, category Food, description Lunch (fireEvent),
       click Add, then expect the Dashboard to contain "42.50" and "Food".
       Clear localStorage before each test. Test only.
GREEN: Make it pass: Expense type; getExpenses/saveExpenses in storage.ts
       (localStorage key "calcapp-data"); Dashboard lists the expenses with
       a total; AddExpense saves, then navigates to "/" with useNavigate.
       Do not modify the test.
```

*Review checklist:* types in `src/types/expense.ts`, no `any`? storage really uses localStorage — not just React state? form inputs controlled (`value` + `onChange`)? after Add, back to `/` with `useNavigate`? refresh the browser: is your expense still there?

**Task — minimal UI (10 min max).** Target: readable and functional, not production-ready. Pure styling has no test: the rule is *the tests stay green*.

```text
Add minimal plain CSS in src/App.css: horizontal nav bar, Dashboard
list (description, category, amount, date) with a total, labelled
form fields with spacing, centred layout with a max-width.
No animations, no CSS library. Keep all tests green.
```

### Exercise — Your next tasks (13:30 → 14:20, 50 min)

**Goal:** deliver your plan's next tasks (routing, data, UI), one branch each, test first.

**Steps:** one task = one branch `feat/<task-name>`; RED → review → commit `test: …`; GREEN → review checklist → commit `feat: …`; merge into `mywork` when green, next task. Your plan's wording is unclear? Use the prompts above.

**Done when:** `npm test` shows 4+ passing tests; the app has two pages; an added expense survives a browser refresh.

**Mid-point (13:55):** routing merged into `mywork`. Not there? Ask now.

**If stuck:** (1) your tutor window; (2) recovery tag `j2-part1`; (3) raise your hand.

**Ahead?** Delete an expense (`onDelete`) — same loop.

**Did not finish?** v0.1 need not be complete to be reviewed: you review what you have. Merge what is green; leave a red branch aside. App broken? Catch up with `j2-part1`, or `j2-v0.1` to review the reference code. Then `npm test` and `npm run dev` must work. Being behind on code must never block the learning: 14:30 is about review.

**Debrief (14:20 → 14:30):** Where did the agent change a test, or do more than you asked? Which review-checklist item caught something real? Compare with your neighbour: same task, same code? Why not?

### Frequent errors

- Data kept in React state only — gone at the first refresh (the most common slip).
- `react-router-dom` imported, or `<a href>` used for navigation (full page reload).
- Merging a branch whose tests are red into `mywork`.
- `npm test` left in watch mode inside an agent prompt: the agent waits forever — ask for `npm run test:run`.

## AI-assisted code review

### Key ideas

Your code works. Is it good? How do you know?

**The speed paradox.** Typing by hand was a natural throttle on bugs; an agent removes it — code comes faster, and so do bugs. AI-co-authored pull requests had **1.7×** more issues per PR (10.83 vs 6.45) on 470 open-source PRs (CodeRabbit, *State of AI vs. Human Code Generation*, 2025). A vendor study on a small sample — but the direction is clear: review matters MORE with AI.

**Review at scale.** **60 million** Copilot code reviews by March 2026 — more than 1 in 5 code reviews on GitHub (GitHub blog, *60 Million Copilot Code Reviews and Counting*, 2026). Someone — or something — must check all generated code. Speed without review is just faster failure.

**Review vs tests** — share of the defects present that each practice removes, data from 13,000+ projects (Capers Jones, *Software Defect Removal Efficiency*, 2011):

| Practice | Minimum | Average |
|---|--:|--:|
| Formal code inspection | 60 % | 85 % |
| Unit testing (automated) | 20 % | 40 % |
| Function testing | 33 % | 40 % |

Not tests OR review: you need both — today you do both.

**How much per review? 200-400 lines** per review — beyond that, defect detection drops — and no more than 60 minutes per session (Cohen, *Best Kept Secrets of Peer Code Review*, SmartBear, 2006). Measure yours: `git diff j2-start --stat`. An agent writes 1,000 lines in a session: review per task, not per day.

**What AI review sees and misses.** *Catches well — breadth:* missing error handling, null/undefined risks, type slips and dead code, hook dependency mistakes, known security anti-patterns. *Misses — depth, that is you:* does it do what the user needs? is this the right place in the design? effects across distant files, subtle authorisation rules, should this code exist at all? **AI = breadth, you = depth.** Neither alone is enough.

**Weak vs effective prompts.** Weak: "Review this code." Effective: the *plan* agent (Shift+Tab — read-only), one file, one concern, the context:

```text
@src/pages/AddExpense.tsx Review edge cases and error handling.
The input comes from a user form: empty, negative, huge amounts?
```

```text
@src/utils/storage.ts What happens if localStorage holds corrupt JSON
or is full? Classify each finding HIGH / MEDIUM / LOW.
```

**Triage — HIGH / MEDIUM / LOW** (the same scale as GSE-One's `/gse-review`, day 3):

| Severity | Typical finding | Action |
|---|---|---|
| HIGH | Crash, data loss, security hole | Fix before delivering |
| MEDIUM | Missing error handling, hard to maintain | Fix, or decide explicitly |
| LOW | Naming, style, documentation gap | Note it; fix if cheap |

Not every finding is true: you are the judge, not the agent. **You are the judge** — for each finding: fix, defer, or refuse *with a written reason*:

```text
RVW-1 [HIGH]   storage.ts: corrupt JSON crashes the app → FIX
RVW-2 [MEDIUM] AddExpense: negative amount accepted     → FIX
RVW-3 [LOW]    rename amount → amountEur          → REFUSED
               reason: v0.1 has one currency (docs/plan.md)
```

A written refusal is a decision, not laziness — and someone else can review it.

### How GSE-One solves it (CCSET08, concept only)

*The problem:* AI review is fast but uneven: it misses some problems, invents others, and nobody decides what to do with its findings.

- `/gse-review` numbers each finding (RVW-…) and ranks it HIGH, MEDIUM or LOW: the scale you use today.
- Several specialised reviewers read the same change: code, architecture, security, tests, requirements, devil's advocate.
- `/gse-fix` fixes the findings you keep; you refuse the others with a reason.
- `/gse-deliver` will not merge over an open HIGH finding without your explicit decision.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § 3.7 — Quality` (`/gse-review`, `/gse-fix`; the spec writes commands with a colon, the Claude Code form; in opencode type them with a dash); `§ 6.5 — Test Review Layering` (RVW-NNN ids, HIGH / MEDIUM / LOW); `§ P16 — Adversarial Self-Review and User Pushback`. Glossary: code review, finding, RVW, severity, triage, diff.

## Review today's diff

### Exercise — Review practice (15:15 → 15:50, 35 min)

**Goal:** review everything you changed today, triage it, fix what matters.

**Steps:**

1. `git switch mywork` → `git diff j2-start --stat`.
2. Shift+Tab → *plan* agent (read-only). First put the diff into the conversation (`!` runs a shell command): `!git diff j2-start`. Then:
   ```text
   Review this diff of CalcApp v0.1 against @docs/plan.md. Focus: bugs and
   runtime errors, missing error handling, user input reaching storage
   unvalidated, tests that prove nothing. For each finding: RVW-n,
   HIGH/MEDIUM/LOW, file, why it matters, suggested fix. Edit nothing.
   ```
   Diff too long? One task at a time: `!git diff j2-start -- src/utils/`.
3. Write the triage in `docs/review.md`.
4. `git switch -c fix/review`; Shift+Tab back to the *build* agent and fix 2-3 HIGH/MEDIUM findings, test first:
   ```text
   Fix RVW-1 from docs/review.md. First write a failing test that exposes
   it and run npm run test:run (RED), then fix the code (GREEN).
   Change nothing else.
   ```
   Read the diff: did it touch anything else? `npm test` green → commit `fix: RVW-1 …`; in `docs/review.md`: RVW-1 → fixed.
5. Refuse at least one finding, with a written reason.

**Done when:** `docs/review.md` lists your findings with severities; 2+ are fixed with a test; 1+ is refused with a reason; `npm test` is green on `fix/review`.

**Mid-point (15:35):** triage written. Not yet? Review one task's diff only.

**If stuck:** (1) your tutor window; (2) recovery tag `j2-v0.1`; (3) raise your hand (review the reference code).

### Key ideas — living docs, the 80/20 rule

The agent writes the WHAT (80 %): stack, install and run, scripts, structure, feature list. You write the WHY (20 %): why this design, known limits, trade-offs you accepted. Agent: "saveExpenses stores the list under `calcapp-data`." You: "localStorage on purpose: v0.1 is single-user and offline — no backend until the plan needs one."

### Exercise — README 80/20 (15:50 → 16:05, 15 min)

**Steps:** ask the build agent:

```text
Write README.md for CalcApp: what it does and for whom, tech stack,
install and run, scripts, project structure, features. Use only the
code and @docs/plan.md as sources. Invent nothing.
```

Run every command in it: do they all work? Add a **Why** section: 3 sentences only you could write. Commit on `fix/review`: `docs: README`.

**Done when:** the README works as written and ends with a Why section of your own.

**Debrief (16:05 → 16:15):** Most useful finding? What obvious problem did the AI miss? What did you refuse, and why? Compare with your neighbour: similar code, similar findings? Why not?

### Frequent errors

- Asking the *build* agent to review: it may start editing. Review with *plan*, fix with *build*.
- Accepting every finding: some are false — you are the judge.
- One review of a 1,000-line diff: split per task.
- The fix also "improves" other files: check `git diff` before committing.

## Ship v0.1

### Exercise — Ship v0.1 (16:15 → 16:30, 15 min)

**Goal:** all green work on your main line, tagged `v0.1`.

```bash
git switch mywork
git merge fix/review          # + any finished feat/ branch not merged yet
npm run test:run                # all green? if not, fix before tagging
git tag v0.1
git switch -C main mywork     # main = your v0.1 (it held only the starter)
git log --oneline --graph --decorate -10
```

**Why main:** from tomorrow, the methodology plugin treats `main` as the reference. Git says `main` and `origin/main` have diverged: normal, do not pull (`origin` is the starter); you push to your own repository tomorrow morning.

**Done when:** `git tag` lists `v0.1`, on a commit where the tests are green, and `main` is on that same commit (`git branch -v`).

**If stuck:** (1) your tutor window; (2) tag `j2-v0.1`, then `git tag v0.1` on it; (3) raise your hand.

**v0.1 — what you just built:** two pages with navigation; add an expense — it survives a refresh; 4+ tests, each written *before* its code; a review with triage, fixes and one reasoned refusal; a README with *your* Why; a tag `v0.1`. You drove, the agent typed. That is VibeEngineering.

### Links

GSE-One: `§ 3.6 — Engineering` (`/gse-deliver`: merge, tag, changelog); `§ 10.4 — Merge Strategy (Gate Decision)`. Glossary: merge, tag, main line.

## Bridge to GSE-One

### Key ideas

Today you ran the loop by hand. From day 3, GSE-One drives the same loop:

| Today, by hand | GSE-One (day 3) |
|---|---|
| Plan → tasks in `docs/plan.md` | `/gse-plan` |
| Test first, one branch per task | `/gse-tests` + `/gse-produce` |
| Review, triage HIGH / MEDIUM / LOW | `/gse-review` |
| Fix on a branch, test first | `/gse-fix` |
| Merge + tag `v0.1` | `/gse-deliver` |

Same loop, same severities — and GSE-One will not deliver over an open HIGH without your explicit decision.

**Debrief — the day (10 min):** Which step of the loop did you skip or rush? What did it cost you? Which step would you hand to a tool — and which must stay yours? Compare with your neighbour, then 2-3 answers for the room.

**Next: day 3 (Thursday 3 December 2026).** GSE-One drives the loop you ran by hand today; start with `/gse-go` inside your project; CalcApp continues (recovery tag `p3-start`); your work goes to GitHub, pushed every evening. Keep your laptop as it is: opencode, model key, GSE-One v0.90.0, the course kit.

**Buffer (17:00 → 17:30):** finish the exercise you missed (its sheet is in this syllabus), questions to the trainer, your tutor window for anything about today's steps, feedback as an issue on `nicolasguelfi/gensem` with label `ai4se-ed2` (public — no confidential data). Before leaving: `git status` clean, `git tag` shows `v0.1`, and `git branch -v` shows `main` and `mywork` on the same commit.

### Links

GSE-One: `§ 3.10 — Commands by Lifecycle Phase`; `§ 0.2 — Quickstart — Your First 20 Minutes`; `§ 14.3 — Orchestrator Decision Logic` (`/gse-go`). Glossary: GSE-One, Gate, sprint.

## Hands-up quiz

Yes or no?

1. A brand-new test fails before any code exists. Expected? — **Yes**: RED first is the normal start (hd03 § CalcApp v0.1 part 1 — test first).
2. The agent wrote test + code in one go, all green. Merge without reading? — **No**: golden rule — you review the test between RED and GREEN.
3. You sabotage the code and every test still passes. Are the tests useful? — **No**: they prove nothing — fix the tests (mutant trick).
4. A 1,200-line diff: is one review pass enough? — **No**: 200-400 lines per review — review per task (§ AI-assisted code review).
5. May you refuse a finding of the AI review? — **Yes**: with a written reason (§ AI-assisted code review).
