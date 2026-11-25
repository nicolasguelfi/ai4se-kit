# HD02 — Day 1 afternoon: setup in the room, FreeSelfApp, presentations

*AI for Software Engineering (AI4SE), edition 2 — Thursday 26 November 2026, 13:15-17:00.*
*Content licensed CC BY 4.0. Slide deck: "Hands-on Setup & First Prototype" (opencode 2 + GSE-One v0.93.4).*

Everything happens in the room: no installation was expected before the course, and there is no homework.

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:15 | 75 | Installation in the room |
| 14:30 | 45 | FreeSelfApp: build, change, present |
| 15:15 | 15 | Break |
| 15:30 | 60 | Presentations (6 min each, Google Meet) |
| 16:30 | 20 | Questions on any project |
| 16:50 | 10 | Wrap-up and hands-up quiz |

No separate buffer: late installations are finished during the break and the questions.

## Learning goals

At the end of this half-day you can:

1. Open a terminal, run opencode 2 with your course key, and know where your files live (`~/ai4se/`).
2. Open your **tutor window** (a second terminal) and ask it a question about the course.
3. Build a small web app by prompting only, and save working states with git commits.
4. Present your project in 6 minutes, and question any project: what was asked, built and checked — and what was not.

## Installation in the room

### Key ideas

You install your toolchain one step per slide, nine steps numbered 0 to 8. Each step has its own "Done when": do not go to the next step before it is true. The order matters: opencode must exist before GSE-One is installed, and the course kit before the tutor window can open.

Your work this week lives in one plain folder, **`~/ai4se/`**. It is *not* a git repository: it holds sibling repositories side by side — `ai4se-kit` (the course kit), `gensem` (the GSE-One sources, for reading), `freeselfapp` (this afternoon), `calcapp` (tomorrow). Keep your course projects there: your tutor window can only read the folders listed in its configuration, and by default that list is `~/ai4se`.

The **tutor window** is a second opencode session, opened in the kit folder, separate from your work session. It is an AI prepared by the trainer — not the trainer. It reads the syllabus and your projects, never changes them, never reads secrets (`.env` files, keys, `~/.ssh`, credentials), and tells you when to call the trainer (key or quota problems, a machine still broken after two exchanges, lost work, personal matters).

### Exercise — Installation (75 min)

**Goal:** your toolchain, one step at a time.

**Steps:**

0. **Open a terminal** (~5 min). Windows: the Ubuntu (WSL) app or the course VM — not PowerShell. Ubuntu: Ctrl + Alt + T. macOS: Cmd + Space → `Terminal` → Enter. Type `echo $SHELL`. *Done when* it ends in `bash` or `zsh`.
1. **Install opencode 2** (~10 min).
   ```bash
   # Windows (WSL) | Ubuntu | macOS
   curl -fsSL https://opencode.ai/v2/install | bash
   ```
   ```bash
   # or, any system with Node
   npm install -g @opencode/cli
   ```
   Then `opencode --version`; only if it says « command not found », reload the terminal with `exec $SHELL` and retry. Still `1.x`? An old opencode 1 in `~/.opencode/bin` comes first: run the `curl` command above, it updates it in place. *Done when* it prints `2.x.y` (e.g. 2.2.6).
2. **Node.js LTS** (~5 min) — needed tomorrow to run CalcApp (npm). Already ≥ 20? Skip.
   ```bash
   # Windows (WSL) | Ubuntu — nvm
   sudo apt-get install -y libatomic1   # nvm's Node needs it on a minimal Ubuntu
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh | bash
   . "$HOME/.nvm/nvm.sh"                # load nvm in this terminal (no new terminal needed)
   nvm install --lts
   # macOS
   brew install node
   # check — every system
   node --version && npm --version
   ```
   *Done when* node shows v20 or more and npm a version.
3. **Your model key** (~10 min). The trainer sends it to you by Teams direct message or e-mail. Run `opencode auth login`, type `openrouter` and choose OpenRouter, paste the key when asked. Never put it in a committed file, a prompt, a screenshot or an issue. *Done when* `opencode auth list` shows it.
4. **The course kit** (~5 min).
   ```bash
   git clone https://github.com/nicolasguelfi/ai4se-kit ~/ai4se/ai4se-kit && sh ~/ai4se/ai4se-kit/setup-learner.sh
   ```
   The setup clones GSE-One v0.93.4 into `~/ai4se/gensem` (for reading, not an installation), writes the list of folders your tutor window may read (`~/.config/ai4se/tutor-paths`, `~/ai4se` by default) and sets the default model for the workshops. It never touches your key. *Done when* it ends with « Done. » — then go on with step 5 (the check of step 7 shows red lines until steps 5-6 are done).
   **Another folder?** You may clone the kit elsewhere, for example `~/dev/ai4se6d/ai4se-kit`: the setup, the tutor and the check then use the folder that holds the kit (`~/dev/ai4se6d`) as your course folder. In every command of the course, replace `~/ai4se` by that folder, and create your projects in it. Avoid a folder synced by Dropbox, iCloud (Desktop and Documents on many Macs) or OneDrive.
5. **GSE-One v0.93.4** (~10 min) — needs opencode 2 (step 1). It installs into a test folder:
   ```bash
   mkdir -p ~/ai4se/gse-check && cd ~/ai4se/gse-check
   curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/gensem/v0.93.4/install.sh \
     | GSE_PLATFORM=opencode GSE_VERSION=v0.93.4 sh
   ```
   *Done when* `cat .gse/registry` prints `.opencode`.
6. **GitHub login and git identity** (~15 min). No account? `github.com/signup` (a personal one is fine).
   ```bash
   # Windows (WSL) | Ubuntu
   sudo apt install gh
   ```
   ```bash
   # macOS
   brew install gh
   ```
   ```bash
   # then, every system
   gh auth login           # GitHub.com, HTTPS, browser
   git config --global user.name  "Your Name"
   git config --global user.email "you@example.com"
   git config --global init.defaultBranch main
   ```
   Use the e-mail of your GitHub account. The one-time code can be typed in **any** browser, even on your own computer: open `github.com/login/device`. On Ubuntu, lines like `update.go:193: cannot change mount namespace …` come from the Firefox snap: harmless — wait, do **not** press Ctrl+C (it stops the login). *Done when* `gh auth status` says "Logged in" and `git config --global --list` shows your name and e-mail.
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

**Then, if time allows (~5 min): the course editor.** Install VSCodium and turn its AI off — [ide-guide § 2](ide-guide.md). In the course VM it is VS Code, already installed: nothing to do. Not done today? Do it tomorrow morning before the first exercise.

**Mid-point (13:50):** step 4 or beyond.

**If stuck — "3 before me":** (1) the slide: reread the step and its "Done when"; (2) your neighbour: two pairs of eyes; (3) your tutor window, once step 8 works; (4) raise your hand for machine, key or lost-work problems. The trainer is alone for about 20 people: the first three solve most problems.

### Frequent errors

| You see… | Do this |
|---|---|
| "command not found" | Reload the terminal: `exec $SHELL` (the PATH is not reloaded) |
| Downloads hang (SSL, timeout) | Proxy: try another network, or raise your hand |
| "401", "invalid API key" | Wrong key or provider: redo step 3 |
| git asks for a password | Not logged in: redo step 6 |
| GSE-One installed before opencode 2 | Install opencode 2, then redo step 5 |
| node missing, or older than v20 | Redo step 2 |
| `libatomic.so.1: cannot open shared object file` | `sudo apt-get install -y libatomic1` (Ubuntu / WSL), then `node --version` |
| `gh auth login` prints `update.go … mount namespace` lines | Harmless (Firefox snap): wait, no Ctrl+C — or type the code at `github.com/login/device` in any browser |
| The tutor window says a folder is not allowed | Your project is outside `~/ai4se`: move it there, or `~/ai4se/ai4se-kit/tutor add ~/path/to/your-project` (list: `~/ai4se/ai4se-kit/tutor paths`) |

### Links

Kit habits: at the start of each half-day, `~/ai4se/ai4se-kit/tutor update` (gets the latest syllabus). Check the machine any time: `sh ~/ai4se/ai4se-kit/check-learner.sh`. GSE-One: `~/ai4se/gensem/gse-one-spec.md § 0.1 — Prerequisites`; `§ 1.1 — Coding Agents and Plugin Architecture`. Glossary: terminal, PATH, model key, provider, registry, tutor window.

## FreeSelfApp: build, change, present

### Key ideas

Your first prototype — **by pure prompting**: 45 minutes, three iterations, no rules, no plan, on purpose. This is the VibeCoding of this morning (hd01 § VibeCoding), felt first-hand. Today you feel vibe coding; tomorrow you engineer it.

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
2. **Iteration 1 — v1 (14:30).** Paste your first prompt, then iterate with the core loop. It works? Save it, in another terminal in the same folder:
   ```bash
   git add -A && git commit -m "it works"
   ```
3. **Iteration 2 — the client wants more (14:45: v1 runs + 1 commit).** The trainer names **one more feature**, the same for everybody. Already there? Pick another from this menu: data survives a page reload · export to a file (CSV or JSON) · search or filter the list · edit an existing item · undo the last action · clear error messages on bad input · a summary: counts or totals · works on a phone screen. Check v1 still works, then commit. **14:55:** feature done + commit.
4. **Iteration 3 — your presentation.** Ask opencode exactly:
   ```text
   Make a 6-minute presentation of my project for a team meeting — one HTML file I open in my browser.
   ```
   Open it in your browser. Commit.
5. Take notes as you build, in `notes.md` in your folder — they feed the questions at 16:30: what surprised you; what broke, and who fixed it (you or the AI?); how many prompts; one thing you would have done by hand.

**Done when:** v1 and the client's feature both run, `git log` shows 2+ commits, and your presentation opens in the browser.

**If stuck:** 1. your tutor window 2. rephrase or paste the error to the agent ("this fails with …") 3. raise your hand. Do not worry about code quality today: there is no "right way" — just build.

**15:30:** you present 6 min, sharing your screen on Google Meet (link by Teams direct message or e-mail).

### Frequent errors

- Asking for the whole app in one huge prompt: ask for a first visible thing, then add.
- Committing nothing until the end — then one bad answer breaks everything with no way back.
- Typing a new instruction while the agent is still working: one instruction at a time.
- Real data in the app or in prompts (hd01 § EU AI Act and rules for this week).

## Presentations

- **6 minutes** each — strict.
- Share your screen on **Google Meet** when the trainer calls you (the link comes by Teams direct message or e-mail). **In the room: microphone and speakers OFF in Meet.**
- **No questions now** — note yours, on ANY project.
- All questions together at **16:30**.

## Questions on any project

Any project you saw — for example:

1. When did the agent surprise you — good or bad?
2. What broke, and who fixed it?
3. Would you give this app to a client tomorrow? Why not?

Most answers to question 3 are "no" — and the reasons (no tests, code never read, no idea what it does with data) are exactly the VibeEngineering principles of tomorrow.

**Tomorrow — day 2:** CalcApp, a shared starter project; git first (status, diff, commit, branch); you drive the agent with your plan; AI code review with HIGH / MEDIUM / LOW. Same tools, different discipline. No homework — keep your key.

## Wrap-up and hands-up quiz

### Back to this morning (cycles 01-03)

| This afternoon | This morning's idea | Cycle |
|---|---|---|
| It filled what you did not say with its own guesses | An LLM predicts the most likely continuation | CCSET01 |
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
