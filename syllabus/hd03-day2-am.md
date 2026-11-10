# HD03 — Day 2 morning: git first, driving opencode, your plan, first task test-first

*AI for Software Engineering (AI4SE), edition 2 — Friday 27 November 2026, 09:00-12:15.*
*Content licensed CC BY 4.0. Slide deck: "Day 2 — Driving a Coding Agent: CalcApp v0.1".*

Start of the half-day: `~/ai4se/ai4se-kit/tutor update`, then open your tutor window (`~/ai4se/ai4se-kit/tutor`) in a second terminal.

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 09:00 | 15 | Welcome and the artifact chain |
| 09:15 | 35 | Git first (show 12 · try 15 · debrief 5) |
| 09:50 | 55 | Driving opencode (3 short demos, each followed by 5 min of try-it) |
| 10:45 | 15 | Break |
| 11:00 | 30 | Technical planning workshop (frame 5 · practice 20 · debrief 5) |
| 11:30 | 45 | CalcApp v0.1 part 1 — test first (its slides open the afternoon deck) |
| 12:15 | 60 | Lunch |

## Learning goals

At the end of this half-day you can:

1. Use six git commands to review, save, and undo what an agent did, on a branch per task.
2. Give opencode the context a new colleague would need: structure, `AGENTS.md`, `@file`.
3. Use the *plan* agent before the *build* agent, follow its todo list, and add live docs with MCP + Context7.
4. Write and commit `docs/plan.md`: 5-8 atomic, testable tasks.
5. Deliver the first task of your plan test-first: RED, review, GREEN, mutant check.

## Welcome and the artifact chain

### Key ideas

Yesterday: GenAI basics (what an LLM can and cannot do), VibeCoding vs VibeEngineering, opencode as our coding agent, the setup (key, GSE-One, tutor window, GitHub) and FreeSelfApp — a naive prototype, built fast. *Hands up: who would ship it to a customer?*

**Same tools, new discipline.** Yesterday you explored; today you engineer. opencode is still opencode — what changes is how you drive it.

| | Day 1 | Day 2 |
|---|---|---|
| Mindset | Explore, move fast | Plan, then build |
| Output | FreeSelfApp, a prototype | CalcApp v0.1, tested |
| Approach | "Let the AI figure it out" | "Guide the AI with intent" |
| Tests | None, or very few | Test first, every task |
| Safety net | None | Git: commit, branch |
| Plan | In your head | `docs/plan.md`, committed |

**The artifact chain** — each step feeds the next: (1) *git*, a safety net (commit, branch, restore); (2) *opencode*, `AGENTS.md` + the right context; (3) *plan*, `docs/plan.md` with 5-8 atomic tasks; (4) *build*, tests then code, one branch per task; (5) *review*, findings triaged HIGH / MEDIUM / LOW; (6) *deliver*, v0.1 merged and tagged. By 17:00: a tested, reviewed, versioned app.

**Late or lost? Catch up.** Ask in this order: your tutor window → a recovery tag → raise your hand. A recovery tag is a known state of the public CalcApp starter:

| Tag | State |
|---|---|
| `j2-start` | start of the day (09:15) |
| `j2-part1` | end of the morning build (13:15) |
| `j2-v0.1` | v0.1 ready for delivery (16:15) |

```bash
cd ~/ai4se
git clone https://github.com/nicolasguelfi/calcapp-starter calcapp
cd calcapp && git checkout -b mywork <tag> && npm ci
```

Folder `calcapp` already exists? Clone into `~/ai4se/calcapp-restart` instead: your work stays safe. Always clone inside `~/ai4se` so your tutor window can read it.

## Git first

### Key ideas

Coding without version control is a long game with no save button — and git matters **more** with AI tools: the agent edits 10 files in seconds and git shows which; the agent proposes and `git diff` is how you check; experiments are cheap (try on a branch, delete it if it fails). Even opencode's `/undo` relies on git: no repository, no undo.

**Four words.** *Repository*: the folder git tracks; its hidden `.git/` holds the whole history. *Commit*: a snapshot + a message + a link to its parent; commits form your timeline. *Branch*: a parallel timeline — like it? merge it; don't? delete it. *Remote*: a copy on a server such as GitHub, usually called `origin`.

**Where your changes live — the four areas of git**, from editor to GitHub: the *working directory* (your files on disk) → `git add` → the *staging area* (ready to commit) → `git commit` → the *local repository* (committed history) ⇄ `git push` / `git pull` ⇄ the *remote repository* (GitHub). Photography analogy: scene → pose the subjects → click the shutter → upload to the cloud. `git add` chooses what goes into the next snapshot — `git commit` takes it.

**Six commands for today:**

```bash
git status                  # what changed? run it all the time
git diff                    # the exact lines: your review tool
git add <file>              # stage what you have reviewed
git commit -m "feat: ..."   # snapshot with a message
git log --oneline           # the timeline
git restore <file>          # throw an unwanted change away
```

After the agent worked: never `git add .` without reading the diff.

**Pattern 1 — review before stage:** `git status` (which files did the agent touch?) → `git diff` (read every change) → `git add <file>` (only what you approve) → `git diff --staged` (last look) → `git commit` (a message that says what and why). Never skip step 2: the diff is your review.

**Pattern 2 — checkpoint commits** ("save the game before the boss fight"), before a big refactor, an approach you doubt, a multi-file change:

```bash
git add <files> && git commit -m "chore: checkpoint before refactor"
# ... let the agent work ...
git diff          # happy? test and commit.   not happy?
git restore .     # back to the checkpoint (uncommitted work is lost)
```

**Pattern 3 — one branch per task:** `git switch -c feat/<task>` — works? merge it back; doesn't? delete it: nothing is lost.

**Names that tell the story.** Commits: `type(scope): what changed`, e.g. `feat(expenses): reject negative amounts`, `fix(list): round the monthly total`, `test(form): cover the empty category`, with a trailer `Assisted-by: opencode`. Types: feat, fix, test, refactor, docs, chore. Branches: `mywork` (your main line today), `feat/<task>` (one task of your plan), `fix/<bug>`, `experiment/<idea>` (may be thrown away).

### Exercise — Git on CalcApp (15 min)

**Goal:** commit on a branch, break, restore.

**Steps:**

```bash
cd ~/ai4se
git clone https://github.com/nicolasguelfi/calcapp-starter calcapp
cd calcapp && git checkout -b mywork j2-start && npm ci
npm run test:run              # all green?
git switch -c feat/hello
# change one line of README.md, then:
git status && git diff
git add README.md && git commit -m "docs: say hello"
# break a file in src/ on purpose, look at git diff, then:
git restore <that-file> && npm run test:run
```

**Done when:** `git log --oneline` shows your commit on `feat/hello`, and `git status` is clean.

**Mid-point (7 min):** `npm run test:run` is green and `git branch` shows `* feat/hello`.

**If stuck:** (1) your tutor window; (2) re-clone at `j2-start` in a new folder; (3) raise your hand.

**Debrief (5 min):** What did `git diff` show when you broke the file — and after `git restore`? The agent just edited 5 files: which command do you run first, and why? Compare `git log --oneline` with your neighbour: same history?

### Frequent errors

- Git asks who you are: `git config --global user.name "Your Name"`, then `user.email` (hd02 § Installation in the room, step 6).
- `git restore` on a file you never committed: there is nothing to go back to — commit first.
- Working on `main` or `mywork` directly instead of a `feat/…` branch.

### How GSE-One solves it (CCSET04, concept only)

*The problem:* an agent edits many files at once. Without git, a bad change is hard to see and harder to undo.

- One branch per task: the agent never works directly on `main`.
- Before a risky operation, a safety tag `gse-backup/…` marks where to go back.
- A guardrail blocks a commit straight on `main`.
- Commit messages follow one convention, so the history tells the story.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § P12 — Version Control Isolation`; `§ 10.1 — Branch Model`; `§ 10.5 — Commit Message Convention` (GSE-One uses its own `gse(<scope>):` prefix); `§ 10.6 — Safety and Recovery`. Glossary: repository, commit, branch, remote, staging area, diff, tag.

## Driving opencode

### Key ideas

Give the agent what a new colleague would need. *You hire a talented junior: no README, no coding standards, no architecture notes — how well will they do? Good code, in the wrong folder, with the wrong conventions.* The agent is only as good as the context you give it.

**Structure = first prompt.** For "Add sign-up with email validation", a flat project (`app.ts`, `helpers.ts`, `stuff.ts`, `test.ts`) makes the agent guess; a structured one (`src/routes/auth.routes.ts`, `src/services/auth.service.ts`, `src/validators/auth.validator.ts`, `tests/services/auth.service.test.ts`, `docs/architecture.md`, `README.md`) shows the pattern: right folder, same names, tests mirrored. Five habits: descriptive folders (`components/`, `pages/`, `utils/`); tests mirror `src/` (same path, `.test` suffix); a README (purpose, stack, commands); a short `docs/architecture.md`; small files, one concern each.

**Project rules = `AGENTS.md`.** Plain Markdown at the project root, read at every start; `/init` drafts one from your project; commit it so everyone has the same rules. Personal rules: `~/.config/opencode/AGENTS.md`; extra files: `instructions` in `opencode.json`. The CalcApp starter already ships one — read it before your first prompt. Excerpt: stack pinned (React 19 + React Router 7, TypeScript 5.9, Vite 7, Vitest 4); layout (`src/App.tsx` = routes, `src/pages/` = one component per route, `tests/` mirrors `src/`, `docs/` = your plan and documentation); rules (TDD: failing test first, never weaken a test; `npm run test:run` and `npm run lint` pass before a commit; one branch per task, never commit directly to main; never commit secrets — `.env*` stays out of git).

**The context window** holds the rules (`AGENTS.md`), your prompt, the files you `@mention` or that it reads, the conversation history and tool results (commands, tests, MCP). All of it is sent to the model **every turn**; the window has a fixed size; too full, early details get lost. `/compact` summarises, `/new` starts clean.

**`@file` — point, don't hope.** `@` is a fuzzy file search; the file joins the conversation. Vague: "Make the home page nicer." Precise: "Read @src/pages/Home.tsx and @tests/App.test.tsx. Add the subtitle "Track your expenses" to Home, test first. Do not touch other files." **What NOT to put in context**: secrets (`.env`, your model key, passwords — never paste, never `@`); generated folders (`node_modules/`, `dist/` stay in `.gitignore`); whole logs (paste the 10 lines that matter); old tasks (one task, one session: `/new`). Less but relevant beats more.

**Plan agent, then build agent (Tab switches; opencode shows which is active).** *plan* thinks: reads, analyses, proposes, can ask you questions, does not edit your files. *build* does: all tools enabled, edits files, runs commands, follows the plan you approved. Workflow: Tab → plan, describe the whole feature and its constraints → review (files, order, tests included?) → push back ("tests first", "split this step") → Tab → build, "implement step 1 only" → `git diff`, tests, commit, then the next step. Plan first when the task touches 2+ files or needs a where/how decision; a typo? just build.

**The todo list.** On multi-step work the agent writes a todo list and ticks items as it goes: see where it is, stop it as soon as it drifts (Esc), check nothing was skipped before you commit. Ticked is not done — **done = tests green + diff reviewed**.

**MCP and Context7.** MCP (Model Context Protocol) is an open standard: each server exposes tools the agent calls when needed (docs, database, browser), declared under `mcp` in `opencode.json`. Every tool takes context space: enable few. Context7 gives live documentation instead of stale memory — the model learned old APIs and React Router 7 moves fast. Add to `opencode.json` at the project root:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp"
    }
  }
}
```

Check with `opencode mcp list`; in a prompt, say `use context7`.

### Exercise — Try it ×3 (5 min each, after a 3-min demo)

**1. Rules.** *Goal:* a rule of yours changes the agent's answer. *Steps:* `git switch mywork`, then `opencode`; ask "Which test command and folders must you use?"; add to `AGENTS.md`: `Amounts are integers in cents.`; `/new`, then "Propose formatAmount. Code only, no file."; `git diff AGENTS.md`, then commit it. *Done when:* the proposal uses cents and `git log` shows your `AGENTS.md` commit. *Mid-point (2 min):* the agent named the test command.

**2. Context.** *Goal:* compare a vague prompt with a precise one. *Steps:* `/new`, "How are tests organised here?" — note the answer; `/new`, "From @package.json and @AGENTS.md: test command, folder, naming?"; `!npm run test:run` (the `!` runs a shell command; its output joins the conversation); "Summarise the test results in two lines." *Done when:* it quotes the test command and folder from the files. *Mid-point (2 min):* the vague answer is noted.

**3. Plan.** *Goal:* a reviewed plan, no code. *Steps:* no context7 in `opencode.json`? add it, restart opencode; `opencode mcp list` in a terminal (context7 connected?); Tab → plan: "Plan a /budgets page. Use context7 for React Router 7. Tests first."; read the plan and its todo list, push back once; **do not build** — your real plan comes at 11:00. *Done when:* the plan names files and tests, and a Context7 call appears. *Mid-point (2 min):* context7 shows as connected.

**If stuck (all three):** your tutor window, then raise your hand.

**Debrief (5 min):** What changed in the answers once `AGENTS.md` and `@files` were there? What did the plan agent ask you — and what did you push back on? Compare plans with your neighbour: same files? same tests? why not?

**To remember:** structure + `AGENTS.md` = your standing prompt; context is finite (`@` the right files, no secrets, `/new` per task); Tab: plan first, build second; todo ticked ≠ done; MCP adds tools, Context7 adds live docs.

### Frequent errors

- Editing `AGENTS.md` and expecting the current session to change: start a new one (`/new`).
- Asking the *plan* agent to "do it": it cannot edit files — Tab to *build*.
- Context7 not connected: the JSON is not at the project root, or opencode was not restarted.

### How GSE-One solves it (CCSET05, concept only)

*The problem:* the agent only knows what is in its context. Re-explaining your project at every session wastes time and tokens.

- GSE-One is itself a standing prompt: its orchestrator is an `AGENTS.md` loaded at every session.
- Each activity is a command (`/gse-plan`, `/gse-tests`, …) that loads only what it needs.
- Specialised agents bring one point of view each: architect, code reviewer, security auditor, test strategist…
- The project state lives in files: the context is rebuilt from them, not from the chat.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `§ 1.1 — Coding Agents and Plugin Architecture` (where `AGENTS.md` fits). Glossary: AGENTS.md, context window, `@file`, plan agent, build agent, todo list, MCP, Context7.

## Technical planning workshop

### Key ideas

From a vision to `docs/plan.md`: elicit requirements with the plan agent, split them into atomic, testable tasks, commit the plan that drives your afternoon.

**CalcApp — a budget tracker**: track expenses, set budgets, see what is left; React + TypeScript in the browser, built test-first. Features: add an expense (amount, category, date); list expenses (filter by month and category); set a monthly budget per category (e.g. 300 EUR for groceries); see what is left (warn when close to or over budget). **v0.1 today**: add an expense with validation; list expenses with a monthly total; two pages and a navigation bar; data kept in the browser (localStorage). Later versions: budgets per category, remaining budget and warnings, your own ideas.

**Good requirements** are *testable* (✓ "amount 0 or negative → a validation error is shown"; ✗ "the app handles expenses well"), *small* (30-45 min of work with the agent), *independent* (buildable in any order, as far as possible). **Atomic tasks**: one thing, verifiable, ordered; test first, code second in every task. Example: expense type + test (an amount ≤ 0 is rejected); a saved expense is loaded back from localStorage; the list shows items and the monthly total; routes `/` and `/add` with a navigation bar.

**The `docs/plan.md` format** — 5-8 tasks, each with acceptance criteria, exactly one `[next]`:

```markdown
# CalcApp v0.1 - plan

### How GSE-One solves it (CCSET06, concept only)

*The problem:* a vague request gives a vague result. Without a written plan of small, testable tasks, the agent decides the scope for you.

- `/gse-reqs` starts with a conversation, then writes requirements with testable acceptance criteria (Given / When / Then).
- `/gse-plan` turns them into a sprint of tasks, each sized in complexity points, within a budget.
- The plan is a Gate: nothing is built before you validate it.
- Ideas that do not fit go to the backlog, not into the code.

*Concept only — you use GSE-One from day 3.*

## T1 - Expense type with validation        [next]
Accept: a test rejects amount <= 0; a valid expense passes
Branch: feat/expense-type

## T2 - Save and load expenses (localStorage)   [todo]
Accept: a test saves an expense and loads it back
Branch: feat/expense-storage
```

### Exercise — Your docs/plan.md (20 min)

**Goal:** a committed plan.

**Steps:**

1. 2 minutes on paper: 2-3 features you would want as a user.
2. `git switch mywork`, `opencode`, Tab → plan. Adapt and paste the elicitation prompt, answer its questions:
   ```text
   I'm building CalcApp v0.1, a personal budget tracker (see @AGENTS.md).
   v0.1: add an expense (amount, category, date), list expenses with a
   monthly total, two pages with navigation, data kept in localStorage.
   My extra ideas: <yours>.
   Ask me 3 clarifying questions first. Then propose 4-6 user stories:
   title, "As a user, I want...", testable acceptance criteria.
   ```
   Read critically. Ask back: errors? fixed or free categories? currency?
3. "Split into 5-8 atomic tasks, tests first, with acceptance criteria." Push back at least once: too big? not testable?
4. Tab → build: "Write docs/plan.md in the slide format."
5. Edit it, mark T1 `[next]`, `git add` it, `git diff --staged`, `git commit -m "docs: v0.1 plan"`.

**Done when:** `git log --oneline` on `mywork` shows "docs: v0.1 plan"; `docs/plan.md` has 5-8 tasks, one `[next]`.

**Mid-point (11:15):** your user stories have testable acceptance criteria; you are splitting them.

**If stuck:** (1) your tutor window; (2) start from `docs/plan-example.md` (copy it to `docs/plan.md`, adapt it); (3) raise your hand.

**Debrief (5 min):** What did the plan agent ask or propose that you had not thought of? Which task did you split or rewrite — and why? Compare with your neighbour: different plans are normal — are both testable?

### Frequent errors

- `git diff` shows nothing for the new plan: git diff ignores untracked files — `git add` first, then `git diff --staged`.
- Tasks like "build the UI": not testable, not atomic — split until each has one acceptance test.

### Links

GSE-One: `§ 3.5 — Discovery & Planning` (`/gse-plan`); `§ 3.6 — Engineering` (`/gse-reqs`: user stories with testable acceptance criteria); `§ P5 — Planning at Every Level`. Glossary: user story, acceptance criterion, atomic task.

## CalcApp v0.1 part 1 — test first

### Key ideas

You have a plan; now build it, one task at a time. **Why start with tests?** The number-one risk with a coding agent is *losing control*: code arrives fast, but does it work? Clicking through the app is not a proof; a test answers in milliseconds, yes or no. **You** set the specification (the test); the **agent** writes the implementation. Tests = control; no tests = hope.

**TDD in one picture:** RED — write a test that fails; GREEN — the minimal code that passes; REFACTOR — clean up, tests stay green. A failing test *before* the code is the expected start, not a problem. Live demo (≤ 10 min, build agent): ask for the test only → read it → `npm test` → RED (the component does not exist) → ask for the minimal code, do not touch the test → GREEN → break the code on purpose, a test must fail → two commits, `test: …` first, then `feat: …`. Demo feature: ExpenseItem shows "Lunch" and "€25.50".

**The golden rule:** RED — you + agent: the agent drafts the test, *you review it: it is your spec*; GREEN — agent: minimal code, the test is not touched; REFACTOR — you decide, tests stay green. **Never let the agent write the test and the code without your review in between** — otherwise the test mirrors what the agent meant to write and proves nothing.

**The mutant test trick.** After GREEN, sabotage your own code and run the tests. One fails → the test is real, undo the sabotage. None fails → the test proves nothing, fix the test. Example: `amount.toFixed(2)` → `amount.toFixed(0)` turns "€25.50" into "€26": the test must go red. Ten seconds of sabotage saves hours of false confidence.

**Testing rules in `AGENTS.md`** (check them before coding; missing? add, then commit `docs: testing rules`): write the test file BEFORE the implementation file; Vitest + React Testing Library, tests in `tests/`; use `fireEvent` from `@testing-library/react`; import from `react-router` (NOT `react-router-dom`); never install Jest, never skip, weaken or delete a test; run tests with `npm run test:run` (never watch mode).

**Two prompts per task** (build agent):

```text
@docs/plan.md Task 1 only. Write the failing test first, in tests/.
Do NOT write the implementation. Run npm run test:run and show the failure.
```

then, once you have reviewed the test:

```text
Implement the minimal code that makes tests/<file>.test.tsx pass.
Do not modify the test file. Run npm run test:run.
```

In prompts, ask for `npm run test:run`: `npm test` watches forever and the agent would wait.

### Exercise — Task 1 of YOUR plan (11:45 → 12:10, 25 min)

**Goal:** deliver the first task of `docs/plan.md`, test first, on its own branch.

**Steps:**

1. `git switch -c feat/<task-1-name>`
2. RED prompt → **read the test** → commit `test: …`
3. GREEN prompt → `npm test` green → commit `feat: …`
4. Mutant check, then undo the sabotage.
5. `git switch mywork` → `git merge feat/<task-1-name>`. `mywork` is your main line since this morning: every finished task is merged into it.

**Done when:** `npm test` shows your new test passing, and `git log --oneline` shows `test:` before `feat:`.

**Mid-point (12:00):** your RED test is committed. Not yet? Ask now.

**Plan unclear or empty?** Use the fallback prompts (canonical first features). *A — ExpenseItem:*

```text
Write a failing Vitest test in tests/components/ExpenseItem.test.tsx.
ExpenseItem receives an `expense` prop (id, amount, description,
category, date, createdAt) and an `onDelete` handler. It must show
the description and the amount in euros: "Lunch" and "€25.50"
for 25.50. Do NOT write the component. Run npm run test:run.
```

GREEN: "Implement the minimal ExpenseItem (default export) that passes tests/components/ExpenseItem.test.tsx. Do not modify the test." *B — ExpenseForm:*

```text
Write a failing Vitest test in tests/components/ExpenseForm.test.tsx.
Render ExpenseForm, fill the labelled inputs amount (4.50),
description (Coffee), category (Food), date (2026-03-01), click
"Add Expense", and assert onSubmit was called with that data,
amount as a number. Use getByLabelText / getByRole.
Do NOT write the component. Run npm run test:run.
```

Review: correct import paths? accessible queries? the behaviour *you* want? GREEN: same prompt as A. Mutant: remove the `parseFloat` on the amount.

**If stuck:** (1) your tutor window; (2) recovery tag `j2-start`; (3) raise your hand. **Lost 15+ minutes? Rescue** — don't fight a broken setup:

```bash
git clone https://github.com/nicolasguelfi/calcapp-starter ~/ai4se/calcapp-restart
cd ~/ai4se/calcapp-restart && git checkout -b mywork j2-start && npm ci
```

Copy back `docs/plan.md` and `AGENTS.md` from `~/ai4se/calcapp`, commit them, restart at step 1. Your old work stays in `~/ai4se/calcapp`; from now on, run opencode in `calcapp-restart`.

**Ahead?** Task 2 of your plan, same loop.

**Debrief (12:10 → 12:15):** Did the agent respect "test only"? If not, what did you do? Did your mutant check reveal a test that proved nothing? Show each other your `git log --oneline`.

Before lunch: `git status` must say "nothing to commit".

### Frequent errors

- The agent writes test and code in one go: refuse, `git restore` the code, ask for the test only.
- The agent "fixes" the failing test instead of the code: `git diff -- tests/` must be empty after GREEN.
- `npm test` stays open in watch mode: press `q` to quit, or use `npm run test:run`.
- Importing from `react-router-dom`: the starter uses `react-router` 7.

### How GSE-One solves it (CCSET07, concept only)

*The problem:* an agent can write code that looks right, and tests that prove nothing.

- `/gse-tests` sets a test strategy from the requirements before any code: which levels, which cases.
- `/gse-produce` builds each task on its own branch and runs the tests; the results are kept as evidence.
- Delivery is blocked while a requirement's tests have not been run and passed.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `§ 3.6 — Engineering` (`/gse-tests`, `/gse-produce`); `§ 9.3.1 — Test-Specific Guardrails`. Glossary: TDD, RED/GREEN/REFACTOR, mutant test, spec, Vitest. Continues in hd04 § CalcApp v0.1 part 2.

## Hands-up quiz (morning part)

The day-2 quiz is asked at 16:30 (hd04 § Hands-up quiz). Three of its questions test this morning — yes or no?

1. A brand-new test fails before any code exists. Expected? — **Yes**: RED first is the normal start.
2. The agent wrote test + code in one go, all green. Merge without reading? — **No**: golden rule, you review the test between RED and GREEN.
3. You sabotage the code and every test still passes. Are the tests useful? — **No**: they prove nothing — fix the tests.
