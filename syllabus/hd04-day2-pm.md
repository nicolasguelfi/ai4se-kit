# HD04 — Day 2 afternoon: CalcApp v0.1 part 2, AI code review, ship v0.1, bridge to GSE-One

*AI for Software Engineering (AI4SE), edition 2 — Friday 27 November 2026, 13:15-17:30.*
*Content licensed CC BY 4.0. Slide deck: "Day 2 — Driving a Coding Agent: CalcApp v0.1" (afternoon part).*

Start of the half-day: `~/ai4se/ai4se-kit/tutor update`, then open your tutor window (`~/ai4se/ai4se-kit/tutor`) in a second terminal. This sheet continues hd03 § CalcApp v0.1 part 1 — test first (TDD, the golden rule and the mutant trick are explained there).

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:15 | 75 | CalcApp v0.1 part 2 (restart 15 · practice 13:30 to 14:20 · debrief 10) |
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

**Re-orientation (13:15) after lunch:**

1. Go to your project and run `cd ~/ai4se/calcapp && git status`. It must say that you are on the branch `mywork` and that there is nothing to commit.
2. Run `npm run test:run`. The tests of Part 1 must still pass.
3. Run `npm run dev` and open the address it prints. The app must show in the browser.
4. Start opencode and ask: "Read @docs/plan.md: which task is marked [next]?"

*Or ask opencode:* "Give me the commands to check that git status is clean on mywork and that the tests pass, then run them, and tell me which task of @docs/plan.md is marked [next]." (`npm run dev` stays in a terminal: it does not stop.) One check fails and you cannot fix it in 5 minutes? Catch up from the tag `j2-part1` (end of part 1, task T1 done, tests green):

```bash
cd ~/ai4se
git clone https://github.com/nicolasguelfi/calcapp-starter calcapp-restart
cd calcapp-restart && git checkout -b mywork j2-part1 && git merge --no-edit origin/main && npm ci
# first quit opencode and stop npm run dev, then:
cd ~/ai4se && test ! -e calcapp-old && mv calcapp calcapp-old && mv calcapp-restart calcapp
```

Afterwards every command of the sheets works as written, and your old work stays in `~/ai4se/calcapp-old`. If `~/ai4se/calcapp-old` already exists (a second restart), the last line stops without moving anything: raise your hand. Copy back `docs/plan.md` and `AGENTS.md` from `~/ai4se/calcapp-old`, commit them, then `cd ~/ai4se/calcapp && opencode`. In your `docs/plan.md`, mark `[done]` the tasks `git log --oneline` already shows, mark the first one left `[next]`, continue with it. A recovery tag is a safety net, not a failure.

**Same loop, every task:**

1. Create the branch named under the task in `docs/plan.md` (the line that starts with `Branch:`), e.g. `git switch -c feat/routing`. Your name may differ: ask opencode "Create the branch of the [next] task in @docs/plan.md."
2. RED: ask for the test only. You read it, then commit it alone (`test: …`).
3. GREEN: ask for the minimal code, without changing the test. Commit it (`feat: …`).
4. REFACTOR: ask to improve the design, same behaviour; the tests must still pass. Commit it (`refactor: …`). Nothing to improve? Skip this step.
5. Mutant check: break the code on purpose; a test must fail. Then undo your change.
6. Review the agent's code with the checklists below.
7. When all the tests pass, merge the branch into `mywork`. In `docs/plan.md`, mark the task `[done]` and the next one `[next]`.

The usual order is routing, then data, then UI — but follow the order of your plan.

**Task — routing and navigation.** Two pages: the Dashboard at `/` (the expenses and their total) and Add Expense at `/add` (the form).

```text
RED:   Write a failing test in tests/App.test.tsx: render `routes` from
       src/App.tsx with createMemoryRouter + RouterProvider; expect links
       "Dashboard" and "Add Expense". A second test starts at "/add"
       (initialEntries) and expects a heading "Add Expense". Test only.
GREEN: Make it pass with react-router (NOT react-router-dom): export `routes`
       from src/App.tsx (Layout with nav Links + Outlet; "/" Dashboard,
       "/add" AddExpense); App keeps createBrowserRouter(routes).
       One file per page in src/pages/. Do not change what the test checks.
```

*Review checklist:* Does `package.json` use `react-router`, and not `react-router-dom`? · Do the pages link with `Link` rather than `<a href>`, so the page does not fully reload? · Is there one file per page in `src/pages/`? · Is the test unchanged? Run `git diff HEAD -- tests/`: it must show nothing. · Run `npm run dev`: do both links work, and does the browser's back button work? *Trust, but verify* — you will need this habit at 14:30.

**Task — data layer.** The `Expense` type goes in `src/expense.ts`; saving and loading go in `src/storage.ts`. Keeping the data in the browser (localStorage) is enough for v0.1. The RED test is an *integration test*: several parts tested together (router, pages, storage), unlike the morning's one-component test.

```text
RED:   Write a failing integration test: `routes` in a memory router at "/add",
       fill amount 42.50, category Food, description Lunch (fireEvent),
       click the form's "Add Expense" button, then expect the Dashboard to
       contain "42.50" and "Food".
       Clear localStorage before each test. Test only.
GREEN: Make it pass: Expense type; getExpenses/saveExpenses in storage.ts
       (localStorage key "calcapp-data"); Dashboard lists the expenses with
       a total; AddExpense saves, then navigates to "/" with useNavigate.
       Do not change what the test checks.
```

*Review checklist:* Are the types in `src/expense.ts`, with no `any`? · Does the storage really use localStorage, and not only React state? · Is each form input « controlled »: its value comes from the state and `onChange` updates it? · After Add, does the app go back to `/` with `useNavigate`? · Refresh the browser: is your expense still there?

**Task — minimal UI (10 min max).** Target: readable and functional, not production-ready. Pure styling has no test: the rule is *the tests stay green*.

```text
Add minimal plain CSS in src/App.css: horizontal nav bar, Dashboard
list (description, category, amount, date) with a total, labelled
form fields with spacing, centred layout with a max-width.
No animations, no CSS library. Keep all tests green.
```

### Exercise — Your next tasks (13:30 → 14:20, 50 min)

**Goal:** deliver your plan's next tasks, one branch each, test first.

**Steps:**

1. Create the branch of the task marked `[next]`. Its name is in `docs/plan.md`, on the line that starts with `Branch:` under that task. Example: `git switch -c feat/routing` (your name may differ: use the line below)
   *Or ask opencode:* "Give me the git command to create and switch to the [next] task's branch (Branch: line, @docs/plan.md); run it."
2. Paste the RED prompt. Read the test, then commit it alone, with a message that starts with `test:`
   *Or ask opencode:* "Give me the git commands to commit only the new test as 'test: …', then run them."
3. Paste the GREEN prompt. Go through the review checklist, then commit the code, with a message that starts with `feat:`
   *Or ask opencode:* "Give me the commands to run the tests, then commit the code as 'feat: …' if green; run them."

*Then: improve the code, then add the task to `mywork` and move the plan labels.*

4. Paste the REFACTOR prompt. The tests must still pass. Commit with a message that starts with `refactor:`. Nothing to improve? No commit, go on.
   *Or ask opencode:* "Give me the commands to run the tests, then commit the code as 'refactor: …' if green; run them."
5. When all tests pass, merge the branch into `mywork`. In `docs/plan.md`, change this task's label to `[done]` and the next task's label to `[next]`.
   *Or ask opencode:* "Merge the [next] task's branch into mywork; in docs/plan.md mark it [done], the next one [next]; commit as 'docs: update plan labels'."

Your plan's wording is unclear? Use the ready-made prompts above.

**Done when:** `npm run test:run` shows at least 4 passing tests; the app has two pages; an added expense survives a browser refresh.
*Or ask opencode:* "Give me the command to run the tests and count the passing ones, then run it." (the two pages and the refresh: check them in the browser)

**Mid-point (13:55):** your routing task is merged into `mywork`. Not yet? Ask now.

**If stuck:** (1) your tutor window; (2) recovery tag `j2-part1`; (3) raise your hand.

**Finished early?** Add one more task — delete an expense (the `onDelete` handler) — with the same steps.

**Did not finish?** v0.1 need not be complete to be reviewed: you review what you have. Merge the branches whose tests pass; leave aside a branch whose tests fail (*or ask opencode:* "Give me the git commands to merge into mywork only my task branches whose tests pass, then run them."). Your app is broken? Restart from the tag `j2-part1` (catch-up above), or from `j2-v0.1` to review the reference code. Then `npm run test:run` and `npm run dev` must both work (*or ask opencode:* "Give me the command to run the tests, then run it."). Being behind on code must never block the learning: 14:30 is about review.

**Debrief (14:20 → 14:30):** Where did the agent change a test, or do more than you asked? Which review-checklist item caught something real? Which test did you want to change, and was it the requirement or the code? Compare with your neighbour: same task, same code? Why not?

### Frequent errors

- Data kept in React state only — gone at the first refresh (the most common slip).
- `react-router-dom` imported, or `<a href>` used for navigation (full page reload).
- Merging a branch whose tests are red into `mywork`.
- `npm test` left in watch mode inside an agent prompt: the agent waits forever — ask for `npm run test:run`.

## AI-assisted code review

### Key ideas

Your code works. Is it good? How do you know?

**The speed paradox.** Typing by hand was a natural throttle on bugs; an agent removes it — code comes faster, and so do bugs. AI-co-authored pull requests (a pull request = a proposed change submitted for review before it is merged) had **1.7×** more issues per PR (10.83 vs 6.45) on 470 open-source PRs (CodeRabbit, *State of AI vs. Human Code Generation*, 2025). A vendor study on a small sample — but the direction is clear: review matters MORE with AI.

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

**Weak vs effective prompts.** Weak: "Review this code." Effective: use the *plan* agent (Shift+Tab; it cannot edit files). Name one file, one concern and the context:

```text
@src/pages/AddExpense.tsx Review edge cases and error handling.
The input comes from a user form: empty, negative, huge amounts?
```

```text
@src/storage.ts What happens if localStorage holds corrupt JSON
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

1. Go back to your main line and see how much you changed today: `git switch mywork && git diff j2-start --stat`
   *Or ask opencode (build):* "Give me the git commands to go back to mywork and show how much changed since j2-start, then run them."
2. Switch to the *plan* agent (Shift+Tab; it cannot edit files) and paste the review prompt below. First put the diff into the conversation (`!` runs a shell command): `!git diff j2-start`. Then:
   ```text
   Review this diff of CalcApp v0.1 against @docs/plan.md. Focus: bugs and
   runtime errors, missing error handling, user input reaching storage
   unvalidated, tests that prove nothing. For each finding: RVW-n,
   HIGH/MEDIUM/LOW, file, why it matters, suggested fix. Edit nothing.
   ```
   Diff too long? One task at a time: `!git diff j2-start -- src/storage.ts`.
3. Write your decisions in `docs/review.md`: in your editor, or switch to the build agent (Shift+Tab) and ask: "Write the findings above to docs/review.md, one line each: RVW-n, severity, file, problem, then my decision FIX / DEFER / REFUSED and its reason (ask me for them)."
4. Create the branch for the fixes: `git switch -c fix/review`. Then fix 2 or 3 HIGH or MEDIUM findings, each with a test written first.
   *Or ask opencode (build):* "Give me the git command to create and switch to the branch fix/review, then run it."
   Switch back to the build agent (Shift+Tab), on the branch `fix/review`, and paste:
   ```text
   Fix the first finding marked FIX in @docs/review.md (e.g. RVW-1). First
   write a failing test that exposes it and run npm run test:run (RED), then
   fix the code (GREEN).
   Change nothing else.
   ```
   Read the diff: did the agent change anything else? Run `npm run test:run`. When all tests pass, commit with a message like `fix: RVW-1 …`. In `docs/review.md`, mark RVW-1 as fixed.
   Reading the diff stays yours. *Or ask opencode:* "Give me the commands to run the tests, then commit as 'fix: RVW-1 …' if green; run them."
5. Refuse at least one finding, and write the reason in `docs/review.md`.

**Done when:** `docs/review.md` lists your findings with their severity; at least two are fixed, each with a test; at least one is refused, with a reason; and `npm run test:run` passes on the branch `fix/review`.
*Or ask opencode:* "Give me the commands to switch to fix/review and run the tests, then run them."

**Mid-point (15:35):** your triage is written. Not yet? Review the diff of one task only. **Next (15:50):** the README exercise (80/20).

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

Run every command in it: do they all work? Add a **Why** section: 3 sentences only you could write. Commit it on the branch `fix/review`, with the message `docs: README`.

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

**Why main:** from tomorrow, GSE-One treats `main` as the reference. Git says `main` and `origin/main` have diverged: normal, do not pull (`origin` is the starter); you push to your own repository tomorrow morning.

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
| Turn the plan into tasks in `docs/plan.md` | `/gse-plan` |
| Write the acceptance test first, one branch per task | `/gse-produce` (acceptance test first; `/gse-tests` plans the tests in Full mode) |
| Review the code and rank each finding HIGH, MEDIUM or LOW | `/gse-review` |
| Fix each finding on a branch, with a failing test first | `/gse-fix` |
| Merge, then tag `v0.1` | `/gse-deliver` |

Same loop, same severities — and GSE-One will not deliver over an open HIGH without your explicit decision. GSE-One shows you each failing acceptance test before it writes the code: read it, that is your golden rule; say stop to change it (a beginner profile is asked to confirm it).

**Debrief — the day (10 min):** Which step of the loop did you skip or rush? What did it cost you? Which step would you hand to a tool — and which must stay yours? Compare with your neighbour, then 2-3 answers for the room.

**Next: day 3 (Thursday 3 December 2026).** GSE-One drives the loop you ran by hand today; start with `/gse-go` inside your project; CalcApp continues (recovery tag `p3-start`); your work goes to GitHub, pushed before each break and every evening. Keep your laptop as it is: opencode, model key, GSE-One v0.93.5, the course kit.

**Buffer (17:00 → 17:30):** finish the exercise you missed (its sheet is in this syllabus), questions to the trainer, your tutor window for anything about today's steps, feedback as an issue on `nicolasguelfi/gensem` with label `ai4se-ed2` (public — no confidential data). Before leaving: `git status` clean, `git tag` shows `v0.1`, and `git branch -v` shows `main` and `mywork` on the same commit (*or ask opencode:* "Give me the git commands to check that the tree is clean, that the tag v0.1 exists, and that main and mywork are on the same commit, then run them.").

### Links

GSE-One: `§ 3.10 — Commands by Lifecycle Phase`; `§ 0.2 — Quickstart — Your First 20 Minutes`; `§ 14.3 — Orchestrator Decision Logic` (`/gse-go`). Glossary: GSE-One, Gate, sprint.

## Hands-up quiz

Yes or no?

1. A brand-new test fails before any code exists. Expected? — **Yes**: RED first is the normal start (hd03 § CalcApp v0.1 part 1 — test first).
2. The agent wrote test + code in one go, all green. Merge without reading? — **No**: golden rule — you review the test between RED and GREEN.
3. You sabotage the code and every test still passes. Are the tests useful? — **No**: they prove nothing — fix the tests (mutant trick).
4. A 1,200-line diff: is one review pass enough? — **No**: 200-400 lines per review — review per task (§ AI-assisted code review).
5. May you refuse a finding of the AI review? — **Yes**: with a written reason (§ AI-assisted code review).
