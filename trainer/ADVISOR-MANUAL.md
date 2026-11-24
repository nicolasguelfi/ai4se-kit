# Advisor manual — following and advising the learners' projects

For the trainer (or any external expert). You **advise**, the learner **decides**: you never write in their
repository. Your only way to act is an **advisor ticket**: a GitHub issue labelled `gse-advisor`, opened on
their repository. GSE-One (v0.93.4 and later) shows it to them when they open their next sprint
(`/gse-plan`): they **accept** it into the sprint, **keep** it for later, or **decline** it with a reason.
GSE-One writes their decision on the ticket: you read it from GitHub, without opening their files.

This manual is for you. [`ADVISOR-SESSION.md`](ADVISOR-SESSION.md) is the procedure your coding agent
(Claude Code, opencode…) loads by itself when you start it in your private folder: you never need to read it
to do the job.

Each command is alone in its block, to paste into **your Mac's** Terminal. Replace the names between `<…>`.
The tools are in `~/ai4se/ai4se-kit/trainer/` (or the kit's `trainer` folder on your Macs).

## 1. How it works, in one minute

| Step | Who | What |
|---|---|---|
| 1 | You | `advisor.py` reads what each learner has **pushed** to GitHub and writes an HTML page: one row per project, alerts first |
| 2 | You + your agent (Claude Code or opencode) | the agent inspects one project **read-only** and proposes at most 3 pieces of advice |
| 3 | You | you keep, edit or drop each proposal |
| 4 | Your agent | it creates only the tickets you accepted (`gse-advisor`) |
| 5 | The learner | when their next sprint opens, GSE-One asks **one question** for all your tickets: accept / keep / decline with a reason |
| 6 | GSE-One | it answers on each ticket; declined → closed at once; accepted → closed when the task is delivered |
| 7 | You | `advisor_tickets.py list` shows every ticket and its decision |

Timing: your advice is studied **at the learner's next sprint**, never in the middle of one (it does not
break their work in progress). A ticket opened during sprint 2 is seen when sprint 3 opens.

## 2. Once, before the course

Log `gh` into GitHub (to read private repositories and open tickets):

```bash
gh auth login
```

Check:

```bash
gh auth status
```

Create your **private** folder (outside any repository and outside Dropbox: the list holds names):

```bash
mkdir -p ~/ai4se-advisor
```

Copy the roster template:

```bash
cp ~/ai4se/ai4se-kit/trainer/roster.example.csv ~/ai4se-advisor/roster.csv
```

Fill it in (one line per repository; a learner with CalcApp and a mini-project has two lines):

```bash
open -e ~/ai4se-advisor/roster.csv
```

Columns: `id` (v01, v02… as in the tracking sheet), `name` (for you only), `repo` (`account/repo` or GitHub
address), `project` (optional), `url` (live application address, optional).

**Access to the repositories.** CalcApp is public (nothing to do). A **private** mini-project must invite you:
GitHub → Settings → Collaborators → `nicolasguelfi` (sheet hd08 asks the learners to). Accept the invitations
you receive by e-mail or on github.com/notifications.

Prepare the folder for your coding agent (Claude Code, opencode, Codex or Gemini):

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py session --roster ~/ai4se-advisor/roster.csv
```

This writes `AGENTS.md`, `CLAUDE.md` and `GEMINI.md` in `~/ai4se-advisor/`: your agent reads there the
procedure `trainer/ADVISOR-SESSION.md` (read-only, at most 3 tickets per project, your yes before each ticket).

## 3. During the course — at each break or half-day

Ask the learners to **push** their work (the board only sees what is pushed): « `git push` before the break ».

Refresh the board:

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor.py --roster ~/ai4se-advisor/roster.csv
```

Open it:

```bash
open ~/ai4se-advisor/advisor.html
```

Alerts to look at first: nothing pushed for a while, produced tasks without test evidence, failing tests,
open review findings, over budget, `.gse/` ignored by git, repository not readable, live application not
answering.

Start your agent in your private folder (either one):

```bash
cd ~/ai4se-advisor && claude
```

```bash
cd ~/ai4se-advisor && opencode
```

Then simply tell it, for example: « Inspect v03's project (calcapp) and propose advisor tickets. »
The agent reads the project without writing anything in it, shows you its proposals (problem, evidence, why
it matters, suggestion) and waits for your choice. It creates only those you keep.

**Good advice** (what the agent aims for): at most 3 per project and per round; one problem per ticket;
precise evidence (file and line, commit, `.gse/` field); in English, the course language. Two kinds:
*product* (a bug, a missing test, a requirement not met) and *method* (a skipped review, tests declared but
absent, a decision not recorded, a sprint too big).

Create a ticket **by hand**, without an agent — write the text to a file, then a dry run:

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py create --repo <account/repo> --title "<title>" --body-file <file.md> --dry-run
```

Then for real:

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py create --repo <account/repo> --title "<title>" --body-file <file.md>
```

## 4. Following the decisions

All your tickets and each learner's decision:

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py list --roster ~/ai4se-advisor/roster.csv
```

One repository:

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py list --repo <account/repo>
```

Reading it: « not studied yet » = the learner has not opened a new sprint yet; a comment « Accepted / Kept /
Declined … (GSE-One) » = their decision and their reason. A reasoned decline is a good outcome: the learner
decides. To discuss it, answer on the ticket or in the room.

## 5. What the learner sees

When their next sprint opens, GSE-One fetches your tickets and asks **one question** for all of them: for each,
accept into this sprint / keep for later / decline with a one-line reason. Each decision is recorded in their
journal (`.gse/decisions.md`, DEC-…). No question at all when there is no ticket. Without a GitHub repository
or without a signed-in `gh` on their side, the step is skipped with one information line (the ticket waits for
the next sprint).

## 6. Common problems

| Symptom | What to do |
|---|---|
| A board row says « cannot read the repository » | private repository without an invitation, or a wrong address in `roster.csv` |
| The board does not show today's work | the learner has not pushed: `git push` |
| `create` fails: insufficient rights | private repository: you need the collaborator invitation |
| The learner never saw your tickets | no new sprint opened yet, or their `gh` is not signed in (`gh auth status` on their side), or their GSE-One is older than 0.93.4 (`tutor version`) |
| A ticket stays open after « Accepted » | normal: it closes when the matching task is delivered (`/gse-deliver`) |

## 7. Privacy and end of the course

- `roster.csv` and `advisor.html` hold names: they stay in your private folder, never in a repository.
- Tickets are visible to anyone who can see the repository (public for CalcApp): no name, no grade, no personal
  judgement in them — only the technical or method problem.
- The repository copies (`~/ai4se-advisor/.advisor-cache/`) have push disabled; delete that folder after the
  course.

Technical documentation: [`README.md`](README.md). Procedure followed by the agent:
[`ADVISOR-SESSION.md`](ADVISOR-SESSION.md).
