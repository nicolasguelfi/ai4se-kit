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

**The artifact chain** — each step feeds the next: (1) *git*, a safety net (commit, branch, restore); (2) *opencode*, `AGENTS.md` + the right context; (3) *plan*, `docs/plan.md` with 5-8 atomic tasks; (4) *build*, tests then code, one branch per task; (5) *review*, a list of problems, ranked HIGH / MEDIUM / LOW; (6) *deliver*, v0.1 merged and tagged. By 17:00: a tested, reviewed, versioned app.

**CalcApp and its starter.** `calcapp-starter` is the course project on GitHub: a minimal React + TypeScript app (Vite, Vitest) that shows « CalcApp » and has one passing test. Everyone clones it once, at 09:15 (Git exercise), into `~/ai4se/calcapp`, and builds CalcApp on it all day. It carries one tag per checkpoint, so anyone can restart from a known state.

**Late or lost? Catch up.** Ask in this order: your tutor window → a recovery tag → raise your hand. A recovery tag is a known state of the public CalcApp starter:

| Tag | State |
|---|---|
| `j2-start` | starter: empty app, 1 test (09:15) |
| `j2-part1` | first task done (13:15) |
| `j2-v0.1` | CalcApp v0.1 shipped (16:15) |

```bash
cd ~/ai4se
git clone https://github.com/nicolasguelfi/calcapp-starter calcapp-restart
TAG=j2-start                  # the tag your half-day sheet names
cd calcapp-restart && git checkout -b mywork "$TAG" && npm ci
```

Your first copy `~/ai4se/calcapp` stays untouched. Always clone inside `~/ai4se` so your tutor window can read it.

**`npm ci` warnings are normal.** `npm warn deprecated …` and « N moderate severity vulnerabilities » come with the starter's dependencies: do **not** run `npm audit fix` during the course (it rewrites `package-lock.json`). « npm warn install-scripts … esbuild … not yet covered by allowScripts » is harmless too: the tests and the build work. Only if an esbuild error appears one day, run:

```bash
npm install-scripts approve esbuild
```

```bash
npm ci
```

## Git first

### Key ideas

Coding without version control is a long game with no save button — and git matters **more** with AI tools: the agent edits 10 files in seconds and git shows which; the agent proposes and `git diff` is how you check; experiments are cheap (try on a branch, delete it if it fails). Even opencode's `/undo` relies on git: no repository, no undo.

**Four words.** *Repository*: the folder git tracks; its hidden `.git/` holds the whole history. *Commit*: a snapshot + a message + a link to its parent; commits form your timeline. *Branch*: a parallel timeline — like it? merge it; don't? delete it. *Remote*: a copy on a server such as GitHub, usually called `origin`.

**Where your changes live — the four areas of git**, from editor to GitHub: the *working directory* (your files on disk) → `git add` → the *staging area* (ready to commit) → `git commit` → the *local repository* (committed history) ⇄ `git push` / `git pull` ⇄ the *remote repository* (GitHub). Photography analogy: scene → pose the subjects → click the shutter → upload to the cloud. `git add` chooses what goes into the next snapshot — `git commit` takes it.

**Seven commands for today:**

```bash
git status                  # what changed? run it all the time
git diff --stat             # how many lines, in which files? as expected?
git diff                    # the exact lines: your review tool
git add src/App.tsx         # stage what you have reviewed (one file, e.g.)
git commit -m "feat: ..."   # snapshot with a message
git log --oneline           # the timeline
git restore src/App.tsx     # throw an unwanted change away (one file, e.g.)
```

After the agent worked: never `git add .` without checking the diff.

**Pattern 1 — review before stage:** `git status` (which files did the agent touch?) → `git diff --stat` (how many lines, in which files? as expected?) → `git diff` (read what is small or risky — today's tasks are small: read all of it) → `git add src/App.tsx` (only what you approve) → `git diff --staged` (last look) → `git commit` (a message that says what and why). You own every change: check its scope, read what matters.

**Pattern 2 — checkpoint commits** ("save the game before the boss fight"), before a big refactor, an approach you doubt, a multi-file change:

```bash
git add -A && git commit -m "chore: checkpoint before refactor"
# ... let the agent work ...
git diff          # happy? test and commit.   not happy?
git restore --staged --worktree .   # back to the checkpoint:
#   every change since is lost (never-added files stay)
```

**Pattern 3 — one branch per task:** `git switch -c feat/add-history` (name it after your task) — works? merge it back; doesn't? delete it: nothing is lost.

**Names that tell the story.** Commits: `type(scope): what changed`, e.g. `feat(expenses): reject negative amounts`, `fix(list): round the monthly total`, `test(form): cover the empty category`, with a trailer `Assisted-by: opencode`. Types: feat, fix, test, refactor, docs, chore. Branches: `mywork` (your main line today), `feat/add-history` (one task of your plan), `fix/rounding` (one bug), `experiment/new-layout` (may be thrown away).

**What you clone: CalcApp at `j2-start`.** A title-only page on route `/`, one green test, `AGENTS.md`, and `docs/plan-example.md` (7 tasks, the fallback plan). React 19 + TypeScript, Vite, Vitest, dependencies locked by `package-lock.json`. Tonight, v0.1: add, list and total expenses.

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
# break a file in src/ on purpose, look at git diff, then (BROKEN = that file):
BROKEN=src/App.tsx
git restore "$BROKEN" && npm run test:run
```

**Done when:** `git log --oneline` shows your commit on `feat/hello`, and `git status` is clean.

**Mid-point (7 min):** `npm run test:run` is green and `git branch` shows `* feat/hello`.

**If stuck:** (1) your tutor window; (2) re-clone at `j2-start` in a new folder; (3) raise your hand.

**Debrief (5 min):** What did `git diff` show when you broke the file — and after `git restore`? The agent just edited 5 files: which command do you run first, and why? Compare `git log --oneline` with your neighbour: same history?

**Too big to read every line?** Size your review to the change:

| The change | What you do | When in the course |
|---|---|---|
| A few lines, one task | read the whole `git diff` | today, the CalcApp tasks |
| Tens of files | scope with `git diff --stat`, tests green, test files untouched, read the risky parts | day 2, tasks with tests (11:30) |
| Hundreds of files | AI review against the plan, triage HIGH / MEDIUM / LOW, read and fix the HIGH ones | day 2, review (14:30) |
| Thousands of files | automatic checks (tests, lint, types), several agents review, you review the plan, the tests and the risky zones | days 3-6, GSE-One |

*Risky parts:* security (authentication, secrets, input reaching storage or queries), data (formats, migrations, deletion), money and business rules, configuration and dependencies (`package.json`, the lock file, CI), any change to the tests. Keep changes small: one task, one branch — then reading stays possible.

### Frequent errors

- Git asks who you are: `git config --global user.name "Your Name"`, then `user.email` (hd02 § Installation in the room, step 6).
- `git restore` on a file you never committed: there is nothing to go back to — commit first.
- Working on `main` or `mywork` directly instead of a `feat/…` branch.
- Worrying about `npm ci` warnings (deprecated, moderate vulnerabilities, install-scripts esbuild): harmless — see above; no `npm audit fix`.

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

**Project rules = `AGENTS.md`.** Plain Markdown at the project root, read at every start, and again when it changes; `/init` drafts one from your project; commit it so everyone has the same rules. Personal rules: `~/.config/opencode/AGENTS.md`; extra files: `instructions` in `opencode.json`. The CalcApp starter already ships one — read it before your first prompt. Excerpt: stack pinned (React 19 + React Router 7, TypeScript 5.9, Vite 7, Vitest 4); layout (`src/App.tsx` = routes, `src/pages/` = one component per route, `tests/` mirrors `src/`, `docs/` = your plan and documentation); rules (TDD: failing test first, never weaken a test; `npm run test:run` and `npm run lint` pass before a commit; one branch per task, never commit directly to main; never commit secrets — `.env*` stays out of git).

**The context window** holds the rules (`AGENTS.md`), your prompt, the files you `@mention` or that it reads, the conversation history and tool results (commands, tests, MCP). All of it is sent to the model **every turn**; the window has a fixed size; too full, early details get lost. `/compact` summarises, `/new` starts clean.

**`@file` — point, don't hope.** `@` is a fuzzy file search; the file joins the conversation. Vague: "Make the home page nicer." Precise: "Read @src/pages/Home.tsx and @tests/App.test.tsx. Add the subtitle "Track your expenses" to Home, test first. Do not touch other files." **What NOT to put in context**: secrets (`.env`, your model key, passwords — never paste, never `@`); generated folders (`node_modules/`, `dist/` stay in `.gitignore`); whole logs (paste the 10 lines that matter); old tasks (one task, one session: `/new`). Less but relevant beats more.

**Plan agent, then build agent (Shift+Tab switches; opencode shows which is active).** *plan* thinks: reads, analyses, proposes, can ask you questions, does not edit your files. *build* does: all tools enabled, edits files, runs commands, follows the plan you approved. Workflow: Shift+Tab → plan, describe the whole feature and its constraints → review (files, order, tests included?) → push back ("tests first", "split this step") → Shift+Tab → build, "implement step 1 only" → `git diff`, tests, commit, then the next step. Plan first when the task touches 2+ files or needs a where/how decision; a typo? just build.

**The todo list.** On multi-step work the agent writes a todo list and ticks items as it goes: see where it is, stop it as soon as it drifts (Esc), check nothing was skipped before you commit. Ticked is not done — **done = tests green + diff reviewed**.

**MCP and Context7.** MCP (Model Context Protocol) is an open standard to plug tools into the agent (docs, database, browser). Each server lists its tools; opencode sends their descriptions to the model, the model **chooses** one, opencode runs it (after your permission settings) and returns the result. Servers are declared under `mcp.servers` in `opencode.json`. Every tool description is sent with every request, used or not: enable few. Context7 gives live documentation instead of stale memory — the model learned old APIs and React Router 7 moves fast. Add it with one command in the project folder (no hand-written JSON):

```bash
opencode mcp add context7 --url https://mcp.context7.com/mcp
```

It writes `opencode.json` at the project root:

```json
{
  "mcp": {
    "servers": {
      "context7": {
        "type": "remote",
        "url": "https://mcp.context7.com/mcp"
      }
    }
  }
}
```

Check: restart opencode, the sidebar shows context7 *Connected*; in a prompt, say `use context7`.

### Exercise — Try it ×3 (5 min each, after a 3-min demo)

**1. Rules.** *Goal:* a rule of yours changes the agent's answer. *Steps:* `git switch mywork`, then `opencode`; ask opencode "How do I run the tests, and where do test files go?"; add to `AGENTS.md`: `Amounts are in euros, 2 decimals: €25.50.`; `/new`, then "Write a formatAmount function that formats an amount of money. Show the code and the result for 25.5. Do not create or change any file."; `git diff AGENTS.md`, then commit it. *Done when:* the proposal shows 25.5 as €25.50 and `git log` shows your `AGENTS.md` commit. *Mid-point (2 min):* the agent named the test command.

**2. Context.** *Goal:* compare a vague prompt with a precise one. *Steps:* `/new`, "How are tests organised here?" — note the answer; `/new`, "How are tests organised here? Answer from @package.json." (`AGENTS.md` is loaded in both runs: only `@package.json` makes the difference); `!npm run test:run` (the `!` runs a shell command; its output joins the conversation); "Summarise the test results in two lines." *Done when:* it quotes the test command and folder from the files. *Mid-point (2 min):* the vague answer is noted.

**3. Plan.** *Goal:* a reviewed plan, no code. *Steps:* no context7 yet? `opencode mcp add context7 --url https://mcp.context7.com/mcp` (*or ask opencode, build agent:* "Give me the command to add the Context7 MCP server (https://mcp.context7.com/mcp) to this project, then run it." — read the server address before you allow it); restart opencode (needed either way: servers load at start) (the sidebar shows context7 *Connected*?); Shift+Tab → plan: "Plan a /budgets page. Use context7 for React Router 7. Tests first."; read the plan and its todo list, push back once; **do not build** — your real plan comes at 11:00. *Done when:* the plan names files and tests, and a Context7 call appears. *Mid-point (2 min):* context7 shows as connected.

**If stuck (all three):** your tutor window, then raise your hand.

**Debrief (5 min):** What changed in the answers once `AGENTS.md` and `@files` were there? What did the plan agent ask you — and what did you push back on? Compare plans with your neighbour: same files? same tests? why not?

**To remember:** structure + `AGENTS.md` = your standing prompt; context is finite (`@` the right files, no secrets, `/new` per task); Shift+Tab: plan first, build second; todo ticked ≠ done; MCP adds tools, Context7 adds live docs.

### Frequent errors

- Asking the *plan* agent to "do it": it cannot edit files — Shift+Tab to *build*.
- Context7 not connected: `opencode mcp add` was run outside the project folder, or opencode was not restarted. A hand-written `"mcp": {"context7": …}` (without `servers`) is the old format: opencode 2 ignores it.

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

**CalcApp — a budget tracker**: track expenses, set budgets, see what is left; React + TypeScript in the browser, built test-first. Features: add an expense (amount, category, date); list expenses (filter by month and category); set a monthly budget per category (e.g. 300 EUR for groceries); see what is left (warn when close to or over budget). **v0.1 today**: add an expense with validation; list expenses with a monthly total; two pages and a navigation bar; data kept in the browser (localStorage). Later versions: budgets per category, remaining budget and warnings, your own ideas. **2 minutes, on paper:** 2-3 features you would want as a user — you put them in the elicitation prompt.

**Good requirements** are *testable* (✓ "amount 0 or negative → a validation error is shown"; ✗ "the app handles expenses well"), *small* (30-45 min of work with the agent), *independent* (buildable in any order, as far as possible). **Atomic tasks**: one thing, verifiable, ordered; test first, code second in every task. Example — two stories, each with its tasks and their check:

- **Story 1** — "As a user, I want to record an expense and still find it tomorrow." *Accepted when:* an amount of 0 or less is refused; after closing the browser, the expense is still there.
  1. Check the expense data — *Check:* a test refuses an amount of 0 or less.
  2. Save it in the browser — *Check:* a test saves an expense and reads it back.
- **Story 2** — "As a user, I want to see this month's expenses and their total." *Accepted when:* the list shows my expenses and the right monthly total.
  3. Show the list and the total — *Check:* 2 expenses → both listed, with their sum.
  4. Two pages and a menu — *Check:* a test goes from the Add page to the list.

Each *Check* is a test: written first (RED), then the code (GREEN). Tasks 1-2 are T1-T2 of the `docs/plan.md` example.

**The `docs/plan.md` format** — 5-8 tasks, each with acceptance criteria. `[next]` Treat exactly one · `[todo]` Later · `[done]` Merged (into `mywork`). The label after each title gives the task's state; the brackets are just a label we chose, easy to spot for you and the agent:

```markdown
# CalcApp v0.1 - plan

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

1. `git switch mywork`, `opencode`, Shift+Tab → plan.
2. Paste the elicitation prompt (replace the two example ideas with yours, from paper), answer its questions:
   ```text
   I'm building CalcApp v0.1, a personal budget tracker.
   v0.1: add an expense (amount, category, date), list expenses with a
   monthly total, two pages with navigation, data kept in the browser
   after closing it (localStorage, no server).
   My extra ideas: a monthly budget limit, CSV export.
   Ask me 3 clarifying questions first. Then propose 4-6 user stories:
   title, "As a user, I want...", testable acceptance criteria.
   ```
   *User story* = one need seen by the user: "As a user, I want …" + acceptance criteria (how we check it is done).
   Read critically. Ask back: errors? fixed or free categories? currency?
3. "Split the user stories into 5-8 atomic development tasks, test first, each with its acceptance criteria."
4. Push back at least once: too big? not testable?
5. Shift+Tab → build: "Write the development tasks from this conversation to docs/plan.md. Use @docs/plan-example.md only for its format, not for its tasks."
   Why « only for its format »: `docs/plan-example.md` is a complete fallback plan with its own 7 development tasks; told « use its format », an agent may copy those tasks instead of the ones agreed with you.
6. Open `docs/plan.md` and correct it: T1 is the only task marked `[next]`.
7. `git add docs/plan.md`, then `git diff --staged`.
   *Or ask opencode:* "Give me the git commands to stage docs/plan.md and show what will be committed, then run them."
8. `git commit -m "docs: v0.1 plan"`.
   *Or ask opencode:* "Give me the git command to commit docs/plan.md as 'docs: v0.1 plan', then run it."

*Or ask opencode* needs the **build** agent here: plan may not write `docs/plan.md`.

**Done when:** `git log --oneline` on `mywork` shows "docs: v0.1 plan"; `docs/plan.md` has 5-8 development tasks, only T1 marked `[next]`.
*Or ask opencode:* "Give me the git commands to show the last commits on mywork, and check that docs/plan.md has 5-8 development tasks, only T1 marked [next]. Then run them and show me the result."

**Check:** is anything missing for the app to work end to end (wiring, entry point, assembly of the parts)? If so, add that development task.

**Mid-point (11:15):** your user stories have testable acceptance criteria; you are splitting them.

**If stuck:** (1) your tutor window; (2) start from `docs/plan-example.md` (copy it to `docs/plan.md`, adapt it); (3) raise your hand.
*Or ask opencode:* "Give me the command to copy docs/plan-example.md to docs/plan.md. Then run it."

**Debrief (5 min):** What did the plan agent ask or propose that you had not thought of? Which user story did you split, or which development task did you rewrite — and why? Compare with your neighbour: different plans are normal — are both testable?

### Frequent errors

- `git diff` shows nothing for the new plan: git diff ignores untracked files — `git add` first, then `git diff --staged`. *Or ask opencode:* "Give me the git commands to stage docs/plan.md and show what will be committed. Then run them and show me the result."
- Plan saved but nothing to commit? The plan agent saves under `~/.opencode/plan/`, never in the project: Shift+Tab → build, then ask it to write `docs/plan.md`.
- Tasks like "build the UI": not testable, not atomic — split until each has one acceptance test.

### How GSE-One solves it (CCSET06, concept only)

*The problem:* a vague request gives a vague result. Without a written plan of small, testable tasks, the agent decides the scope for you.

- `/gse-reqs` starts with a conversation, then writes requirements with testable acceptance criteria (Given / When / Then).
  *Given / When / Then* is the same idea as your « Accepted when », written in three fixed parts: **Given** = the starting situation (what is already true before the action); **When** = the one action the user does; **Then** = the result we can observe and check. One acceptance criterion = one concrete scenario (from BDD); each scenario becomes one acceptance test. CalcApp task 1: « Given the Add page is open and no expense is saved, When I enter an amount of 0 and click Add, Then an error message is shown and the list stays empty. » Valid case: « Given the Add page is open, When I enter 25.50 in Food and click Add, Then the list shows one expense of 25.50. »
- `/gse-plan` turns them into a sprint of tasks, each sized in complexity points, within a budget.
- The plan is a Gate: nothing is built before you validate it.
- Ideas that do not fit go to the backlog, not into the code.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `§ 3.5 — Discovery & Planning` (`/gse-plan`); `§ 3.6 — Engineering` (`/gse-reqs`: user stories with testable acceptance criteria); `§ P5 — Planning at Every Level`. Glossary: user story, acceptance criterion, atomic task.

## CalcApp v0.1 part 1 — test first

### Key ideas

You have a plan; now build it, one task at a time. **Why start with tests?** The number-one risk with a coding agent is *losing control*: code arrives fast, but does it work? Clicking through the app is not a proof; a test answers in milliseconds, yes or no. **You** set the specification (the test); the **agent** writes the implementation. Tests = control; no tests = hope.

**TDD in one picture** — the cycle, one line per step; every arrow = `npm run test:run`:

| Step | Action | Who | Test result |
|---|---|---|---|
| RED | Write a test for the expected behaviour | Agent writes, you review | ✗ fails on the expected value |
| GREEN | Write the minimal code that passes | Agent writes, test untouched | ✓ passes |
| REFACTOR | Improve the design, same behaviour | You decide, agent applies | ✓ still passes |

1. **Where:** tests live in `tests/` (named `*.test.ts(x)`); Vitest runs them — already installed in CalcApp (`devDependencies` in `package.json`), the agent does not add one; `npm run test:run` (= `vitest run`) runs them once → ✓ / ✗ per test, with the expected and the received value.
2. **Fail for the right reason:** an empty shell first, so the test fails on the value, not on a missing file.
3. **Refactor = change the structure, not the behaviour:** remove duplication, extract a function, rename. *Refactoring* (Fowler): "a change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior".

A failing test *before* the code is the expected start, not a problem.

**Why an empty shell.** With « do not write the code » alone, red only says « cannot find module ». With an empty shell — the function or component exists and returns nothing, e.g. `export default function ExpenseItem() { return null }` — the test runs and fails on the expected value: red proves the test checks the behaviour.

Live demo (≤ 10 min, build agent): (1) the test + an empty shell of the component → read the test; (2) `npm run test:run` → RED on the expected value, not a missing file; (3) ask for the minimal code — do not touch the test; (4) `npm run test:run` → GREEN; (5) REFACTOR: "Move the euro formatting into a named function formatAmount and call it from ExpenseItem. The screen must not change. Do not touch the test. Run npm run test:run." → still GREEN — before: `<span>€{amount.toFixed(2)}</span>`; after: `` function formatAmount(amount: number) { return `€${amount.toFixed(2)}`; } `` … `<span>{formatAmount(amount)}</span>`; nothing removed, the screen still shows €25.50 (if the agent already wrote such a function, nothing to refactor is a valid result); (6) break the code on purpose → a test must fail; (7) three commits: the test alone — the feature code — the refactoring (`test: ExpenseItem shows label and amount`, `feat: add ExpenseItem`, `refactor: extract formatAmount`). Why separate commits: the history shows the test existed (and failed) before the code, and the refactoring stays apart from the feature; the prefix is the type of change (Conventional Commits, this morning). Demo feature: ExpenseItem shows "Lunch" and "€25.50". Here the failing test comes from the task's acceptance criteria: this is *acceptance-test-driven development* (ATDD) at the scale of one task. Textbook TDD (Beck) goes further: many tiny steps driven by unit tests, and a refactor step after each green.

**The golden rule:** RED — you + agent: the agent drafts the test, *you review it: it is your spec*; GREEN — agent: minimal code, the test is not touched; REFACTOR — improve the design — same behaviour, tests stay green; you decide, the agent applies. **Never let the agent write the test and the code without your review in between** — otherwise the test mirrors what the agent meant to write and proves nothing.

**The mutant test trick.** After GREEN, sabotage your own code and run the tests. One fails → the test is real, undo the sabotage. None fails → the test proves nothing, fix the test. Example: `amount.toFixed(2)` → `amount.toFixed(0)` turns "€25.50" into "€26": the test must go red. Ten seconds of sabotage saves hours of false confidence.

**Testing rules in `AGENTS.md`** (check them before coding; missing? add, then commit `docs: testing rules`): write the test BEFORE the implementation (an empty shell next to the test is fine: red then fails on the expected value, not on a missing file); Vitest + React Testing Library, tests in `tests/`; use `fireEvent` from `@testing-library/react`; import from `react-router` (NOT `react-router-dom`); never install Jest, never skip, weaken or delete a test; run tests with `npm run test:run` (never watch mode).

**Two prompts per task** (build agent). 1 · RED — test + empty shell:

```text
@docs/plan.md Build only the task marked [next].
Write a failing test for its Accept: line, in tests/, plus an
empty shell of the code (exists, does nothing yet): the test must
fail on its expected value, not on a missing file.
Do NOT write the implementation. Run npm run test:run, show the failure.
```

then, once you have reviewed the test:

```text
Implement the minimal code that makes the new test in tests/ pass.
Do not modify the test file. Run npm run test:run.
```

In prompts, ask for `npm run test:run`: `npm test` watches forever and the agent would wait.

### Exercise — Task 1 of YOUR plan (11:45 → 12:10, 25 min)

**Goal:** deliver the first task of `docs/plan.md`, test first, on its own branch.

**Steps:**

1. T1's `Branch:` line, e.g. `git switch -c feat/expense-type`
   *Or ask opencode:* "Give me the git command to create and switch to T1's branch (Branch: line, @docs/plan.md); run it."
2. RED prompt → **read the test** → commit `test: …`
   *Or ask opencode:* "Give me the git commands to commit only the new test as 'test: …', then run them."
3. GREEN prompt → `npm test` green → commit `feat: …`
   *Or ask opencode:* "Give me the commands to run the tests, then commit the code as 'feat: …' if green; run them."
4. Mutant check, then undo the sabotage.
5. `git switch mywork` → `git merge feat/expense-type` (the same name as in step 1). `mywork` is your main line since this morning: every finished task is merged into it.
   *Or ask opencode:* "Give me the git commands to go back to mywork and merge T1's branch into it, then run them."
6. In `docs/plan.md`: T1 `[done]`, T2 `[next]` → commit `docs: T1 done`. After lunch the agent is asked which task is `[next]`: if T1 stays `[next]`, it answers T1.
   *Or ask opencode:* "In docs/plan.md, mark T1 [done] and T2 [next], then commit it as 'docs: T1 done'."

**Done when:** `npm test` shows your new test passing, and `git log --oneline` shows `test:` before `feat:` — two commits, e.g. `test: expense with amount 0 is rejected`, then `feat: add expense validation`: the history shows the test existed (and failed) before the code.
*Or ask opencode:* "Give me the commands to run the tests and show the last commits, then run them."

**Mid-point (12:00):** your RED test is committed. Not yet? Ask now.

**Plan unclear or empty?** Use the fallback prompts (canonical first features). *A — ExpenseItem:*

```text
Write a failing Vitest test in tests/components/ExpenseItem.test.tsx.
ExpenseItem receives an `expense` prop (id, amount, description,
category, date, createdAt) and an `onDelete` handler. It must show
the description and the amount in euros: "Lunch" and "€25.50"
for 25.50. Create only an empty ExpenseItem shell (default export
returning null). Do NOT implement it. Run npm run test:run.
```

GREEN: "Implement the minimal ExpenseItem (default export) that passes tests/components/ExpenseItem.test.tsx. Do not modify the test." *B — ExpenseForm:*

```text
Write a failing Vitest test in tests/components/ExpenseForm.test.tsx.
Render ExpenseForm, fill the labelled inputs amount (4.50),
description (Coffee), category (Food), date (2026-03-01), click
"Add Expense", and assert onSubmit was called with that data,
amount as a number. Use getByLabelText / getByRole.
Create only an empty ExpenseForm shell (default export returning null).
Do NOT implement it. Run npm run test:run.
```

Review: correct import paths? accessible queries? the behaviour *you* want? GREEN: "Implement the minimal ExpenseForm (default export) that passes tests/components/ExpenseForm.test.tsx. Do not modify the test." Mutant: remove the `parseFloat` on the amount.

**If stuck:** (1) your tutor window; (2) recovery tag `j2-start`; (3) raise your hand. **Lost 15+ minutes? Rescue** — don't fight a broken setup. Only to catch up: a second copy in a new folder; your first copy (`~/ai4se/calcapp`) stays untouched.

```bash
cd ~/ai4se
git clone https://github.com/nicolasguelfi/calcapp-starter calcapp-restart
cd calcapp-restart && git checkout -b mywork j2-start && npm ci
```

Copy back `docs/plan.md` and `AGENTS.md` from `~/ai4se/calcapp`, commit them, restart at step 1. Your old work stays in `~/ai4se/calcapp`; from now on, run opencode in `calcapp-restart`.

**Ahead?** Task 2 of your plan, same loop.

**Debrief (12:10 → 12:15):** Did the agent respect "test only"? If not, what did you do? Did your mutant check reveal a test that proved nothing? Show each other your `git log --oneline`.

Before lunch: `git status` must say "nothing to commit". *Or ask opencode:* "Give me the git commands to check that everything is committed and to commit what is left as 'wip: before lunch', then run them."

### Frequent errors

- The agent writes test and code in one go: refuse, `git restore` the code, ask for the test only.
- The agent "fixes" the failing test instead of the code: `git diff HEAD -- tests/` must be empty after GREEN (before the feat: commit).
- `npm test` stays open in watch mode: press `q` to quit, or use `npm run test:run`.
- Importing from `react-router-dom`: the starter uses `react-router` 7.

### How GSE-One solves it (CCSET07, concept only)

*The problem:* an agent can write code that looks right, and tests that prove nothing.

- `/gse-tests` sets a test strategy from the requirements before any code: which levels, which cases, one acceptance (validation) test per Given/When/Then criterion.
- `/gse-produce` builds each code task on its own branch the way you did today: first the acceptance test, run and seen failing, committed; then the code until it passes. The test results are kept as evidence.
- Delivery is blocked while a requirement's tests have not been run and passed.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `§ 3.6 — Engineering` (`/gse-tests`, `/gse-produce`); `§ 9.3.1 — Test-Specific Guardrails`. Glossary: TDD, ATDD, RED/GREEN/REFACTOR, mutant test, spec, Vitest. Continues in hd04 § CalcApp v0.1 part 2.

## Hands-up quiz (morning part)

The day-2 quiz is asked at 16:30 (hd04 § Hands-up quiz). Three of its questions test this morning — yes or no?

1. A brand-new test fails before any code exists. Expected? — **Yes**: RED first is the normal start.
2. The agent wrote test + code in one go, all green. Merge without reading? — **No**: golden rule, you review the test between RED and GREEN.
3. You sabotage the code and every test still passes. Are the tests useful? — **No**: they prove nothing — fix the tests.
