# HD02 — Day 1 afternoon: setup in the room, FreeSelfApp, debrief

*AI for Software Engineering (AI4SE), edition 2 — Thursday 26 November 2026, 13:15-17:00.*
*Content licensed CC BY 4.0. Slide deck: "Hands-on Setup & First Prototype" (opencode 2 + GSE-One v0.90.1).*

Everything happens in the room: no installation was expected before the course, and there is no homework.

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:15 | 75 | Installation in the room |
| 14:30 | 45 | FreeSelfApp workshop — part 1 |
| 15:15 | 15 | Break |
| 15:30 | 45 | FreeSelfApp workshop — part 2 |
| 16:15 | 30 | Debrief and hands-up quiz |
| 16:45 | 15 | Buffer: late installations, questions |

## Learning goals

At the end of this half-day you can:

1. Open a terminal, run opencode 2 with your course key, and know where your files live (`~/ai4se/`).
2. Open your **tutor window** (a second terminal) and ask it a question about the course.
3. Build a small web app by prompting only, and save working states with git commits.
4. Say, from your own notes, what the AI did that you would have done by hand — and what you did not check.

## Installation in the room

### Key ideas

You install your toolchain one step per slide, nine steps numbered 0 to 8. Each step has its own "Done when": do not go to the next step before it is true. The order matters: opencode must exist before GSE-One is installed, and the course kit before the tutor window can open.

Your work this week lives in one plain folder, **`~/ai4se/`**. It is *not* a git repository: it holds sibling repositories side by side — `ai4se-kit` (the course kit), `gensem` (the GSE-One sources, for reading), `freeselfapp` (this afternoon), `calcapp` (tomorrow). Keep your course projects there: your tutor window can only read the folders listed in its configuration, and by default that list is `~/ai4se`.

The **tutor window** is a second opencode session, opened in the kit folder, separate from your work session. It is an AI prepared by the trainer — not the trainer. It reads the syllabus and your projects, never changes them, never reads secrets (`.env` files, keys, `~/.ssh`, credentials), and tells you when to call the trainer (key or quota problems, a machine still broken after two exchanges, lost work, personal matters).

### Exercise — Installation (75 min)

**Goal:** your toolchain, one step at a time.

**Steps:**

0. **Open a terminal** (~5 min). macOS: Cmd + Space → `Terminal` → Enter. Linux: Ctrl + Alt + T. Windows: the Ubuntu (WSL) app or the course VM — not PowerShell. Type `echo $SHELL`. *Done when* it ends in `bash` or `zsh`.
1. **Install opencode 2** (~10 min).
   ```bash
   curl -fsSL https://opencode.ai/v2/install | bash
   brew install anomalyco/tap/opencode-v2   # macOS, alternative
   npm install -g @opencode/cli             # if you already use Node
   ```
   Open a **new** terminal, then `opencode --version`. *Done when* it prints `2.x.y` (e.g. 2.2.6).
2. **Node.js LTS** (~5 min) — needed tomorrow to run CalcApp (npm). Already ≥ 20? Skip.
   ```bash
   brew install node        # macOS, or:
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh | bash
   # open a NEW terminal, then:
   nvm install --lts         # skip if you used brew
   node --version && npm --version
   ```
   *Done when* node shows v20 or more and npm a version.
3. **Your model key** (~10 min). Run `opencode auth login`, choose the provider written on your key sheet, paste the key when asked. Never put it in a committed file, a prompt, a screenshot or an issue. *Done when* `opencode auth list` shows it.
4. **The course kit** (~5 min).
   ```bash
   git clone https://github.com/nicolasguelfi/ai4se-kit ~/ai4se/ai4se-kit && sh ~/ai4se/ai4se-kit/setup-learner.sh
   ```
   The setup clones GSE-One v0.90.1 into `~/ai4se/gensem` (for reading, not an installation), writes the list of folders your tutor window may read (`~/.config/ai4se/tutor-paths`, `~/ai4se` by default) and sets the default model for the workshops. It never touches your key. *Done when* it ends with no red error line.
5. **GSE-One v0.90.1** (~10 min) — needs opencode 2 (step 1). It installs into a test folder:
   ```bash
   mkdir -p ~/ai4se/gse-check && cd ~/ai4se/gse-check
   curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/gensem/v0.90.1/install.sh \
     | GSE_PLATFORM=opencode GSE_VERSION=v0.90.1 sh
   ```
   *Done when* `cat .gse/registry` prints `.opencode`.
6. **GitHub login and git identity** (~15 min). No account? `github.com/signup` (a personal one is fine).
   ```bash
   brew install gh         # macOS
   sudo apt install gh     # Linux / WSL
   gh auth login           # GitHub.com, HTTPS, browser
   git config --global user.name  "Your Name"
   git config --global user.email "you@example.com"
   git config --global init.defaultBranch main
   ```
   Use the e-mail of your GitHub account. No browser (WSL, VM)? Copy the code and open the link yourself. *Done when* `gh auth status` says "Logged in" and `git config --global --list` shows your name and e-mail.
7. **Check everything** (~10 min).
   ```bash
   cd ~/ai4se/gse-check && sh ~/ai4se/ai4se-kit/check-learner.sh
   ```
   Run it from the folder where GSE-One is installed (step 5). Red line? Redo that step, run the check again. All green? Show your neighbour. *Done when* every line is green.
8. **Open your tutor window** (~5 min). Open a **second terminal** (keep it on the right of your screen) and run:
   ```bash
   ~/ai4se/ai4se-kit/tutor
   ```
   Then ask: `what are we doing this afternoon?` *Done when* it answers with this afternoon's plan.

**Done when:** the check is all green and your tutor window answers you.

**Mid-point (13:50):** step 4 or beyond.

**If stuck — "3 before me":** (1) the slide: reread the step and its "Done when"; (2) your neighbour: two pairs of eyes; (3) your tutor window, once step 8 works; (4) raise your hand for machine, key or lost-work problems. The trainer is alone for about 20 people: the first three solve most problems.

### Frequent errors

| You see… | Do this |
|---|---|
| "command not found" | Open a new terminal (the PATH is not reloaded) |
| Downloads hang (SSL, timeout) | Proxy: try another network, or raise your hand |
| "401", "invalid API key" | Wrong key or provider: redo step 3 |
| git asks for a password | Not logged in: redo step 6 |
| GSE-One installed before opencode 2 | Install opencode 2, then redo step 5 |
| node missing, or older than v20 | Redo step 2, then open a new terminal |
| The tutor window says a folder is not allowed | Your project is outside `~/ai4se`: move it there, or `~/ai4se/ai4se-kit/tutor add <path>` (list: `~/ai4se/ai4se-kit/tutor paths`) |

### Links

Kit habits: at the start of each half-day, `~/ai4se/ai4se-kit/tutor update` (gets the latest syllabus). Check the machine any time: `sh ~/ai4se/ai4se-kit/check-learner.sh`. GSE-One: `~/ai4se/gensem/gse-one-spec.md § 0.1 — Prerequisites`; `§ 1.1 — Coding Agents and Plugin Architecture`. Glossary: terminal, PATH, model key, provider, registry, tutor window.

## FreeSelfApp workshop — part 1

### Key ideas

Your first prototype — **by pure prompting**: 2 × 45 minutes, no rules, no plan, on purpose. This is the VibeCoding of this morning (hd01 § VibeCoding), felt first-hand. Today you feel vibe coding; tomorrow you engineer it.

**The core loop with opencode:** (1) *describe* what you want, in plain English; (2) *let it build* — it reads, writes files, runs commands; (3) *run* — open the result in your browser; (4) *react* — say what is wrong, or what is next; and back to 1. That is all you need today. opencode asks before some actions: read the request before you accept.

**Live demo (5 min) — what to watch:** what the trainer types (one plain sentence); the agent reads the folder (empty); it creates files on its own; what it asks and what the trainer answers; something you can open and run.

**The challenge:** a small personal web app that runs in a browser. Any stack (HTML + JS is simplest). You type prompts, not code. Three ideas, or your own (keep it small and personal; use made-up data, no real personal or company data):

| Idea | First prompt |
|---|---|
| Recipe Finder — type ingredients, get matching recipes | `Create a Recipe Finder web app: type ingredients, see recipes.` |
| Habit Tracker — daily checklist with streaks | `Build a Habit Tracker web app: daily check-off and streaks.` |
| Movie Watchlist — browse, save and rate movies | `Create a Movie Watchlist web app: save movies, rate them 1-5.` |

**git = save points** you can come back to. We learn it properly tomorrow; today, one command after each working step.

### Exercise — FreeSelfApp

**Goal:** your small web app, by prompting only.

**Steps:**

1. Create a fresh folder and start opencode in it:
   ```bash
   mkdir -p ~/ai4se/freeselfapp
   cd ~/ai4se/freeselfapp
   git init
   opencode
   ```
2. Paste your first prompt, then iterate with the core loop.
3. It works? Save it, in another terminal in the same folder:
   ```bash
   git add -A && git commit -m "it works"
   ```
4. Take notes as you build, in `notes.md` in your folder: what surprised you; what broke, and who fixed it (you or the AI?); how many prompts so far; one thing you would have done by hand.
5. Part 2 (15:30): add one feature you really want; ask the agent to explain one file — do you get it?; commit after each working step; update `notes.md`. At 16:10: last commit, notes ready.

**Done when:** the app opens in the browser, does one thing you wanted, and `git log` shows 2+ commits.

**Mid-point (15:15):** it opens, and 1 commit.

**If stuck:** rephrase (a smaller, more precise request) → paste the error to the agent ("this fails with …") → your tutor window → raise your hand for technical blockers. Do not worry about code quality today: there is no "right way" — just build.

**Debrief (16:15):** your notes and one example (next section).

### Frequent errors

- Asking for the whole app in one huge prompt: ask for a first visible thing, then add.
- Committing nothing until the end — then one bad answer breaks everything with no way back.
- Typing a new instruction while the agent is still working: one instruction at a time.
- Real data in the app or in prompts (hd01 § EU AI Act and rules for this week).

## FreeSelfApp workshop — part 2

Same sheet as part 1 (step 5). The point of part 2 is to *notice*: which feature did you get without understanding how? Could you explain the file you asked about?

## Debrief and hands-up quiz

### Key ideas

**By hand vs AI.** Each of you gives one example in 30 seconds, in two columns: *what I would have done by hand* / *what the AI did*. Example from the slide: "I would have searched how to save data in the browser" / "the AI used localStorage — I never checked how".

**Three questions** (3 minutes with your neighbour, then together):

1. When did the agent surprise you — good or bad?
2. What broke, and who fixed it?
3. Would you give this app to a client tomorrow? Why not?

Most answers to question 3 are "no" — and the reasons (no tests, code never read, no idea what it does with data) are exactly the VibeEngineering principles of tomorrow.

**Tomorrow — day 2:** CalcApp, a shared starter project; git first (status, diff, commit, branch); you drive the agent with your plan; AI code review with HIGH / MEDIUM / LOW. Same tools, different discipline. No homework — keep your key sheet.

### Back to this morning (cycles 01-03)

| This afternoon | This morning's idea | Cycle |
|---|---|---|
| You had to explain your app again | The model has no memory | CCSET01 |
| The agent did more than you asked | Autonomy needs a human in the loop | CCSET02 |
| It works — would you ship it? | VibeCoding is not engineering | CCSET02 |
| Your key, its permissions, what you pasted | Practical rules, the AI Act | CCSET03 |

Tomorrow: the same kind of app, engineered — by hand, on CalcApp.

### Links

GSE-One: `§ P14 — Knowledge Transfer (Coaching)`. Glossary: commit, localStorage, prototype.

## Hands-up quiz

True or false? Hands up for TRUE.

1. The model remembers yesterday's chat. — **FALSE**: no memory, the context is re-sent every time (hd01 § The model has no memory).
2. Every token sent and received costs money. — **TRUE**: long chats and big files cost more; your key is capped (hd01 § Model families, your key, tokens).
3. Pasting your API key in a prompt is fine. — **FALSE**: never — a prompt leaves your machine (hd01 § EU AI Act and rules for this week).
4. Vibe coding = accepting AI code unread. — **TRUE**: the definition — and your afternoon (hd01 § VibeCoding).
5. A commit is a save point you can return to. — **TRUE**: tomorrow, a commit after every step (hd03 § Git first).
