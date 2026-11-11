# FAQ — the most frequent problems

Collected from edition 1 and updated for edition 2 (opencode 2, GSE-One v0.90.1, tutor
window). When stuck, the order is always: **your tutor window → the recovery tag → raise
your hand.** See also [recovery](recovery.md) and the [glossary](glossary.md).

## 1. `/gse:go` does nothing / "unknown command"
`/gse:go` is the **Claude Code** spelling used in the GSE-One documents. In **opencode**
the commands use a dash: `/gse-go`, `/gse-status`, `/gse-pause`, `/gse-resume`… Type
`/gse-` and pick from the list. If no `/gse-` command appears, GSE-One is not installed in
this folder: `cd` into the project, run `sh ~/ai4se/ai4se-kit/check-learner.sh`, and ask
your tutor window what the red lines mean.

## 2. Which mode: Full, Lightweight or Micro?
GSE-One proposes a mode after `/gse-go`. **CalcApp: Full** (the whole lifecycle, to learn
every activity). **Mini-project: Lightweight** (fewer artefacts, faster). Micro is for
tiny throw-away scripts — not used in the course. If the proposed mode differs, choose
*Discuss* and say which mode the course asks for.

## 3. "Where am I in the lifecycle?"
Run `/gse-status`: it shows the sprint, the current activity and the next step. Read it
before asking the agent to "continue". The printed orientation page (days 3-6) helps you
read it.

## 4. Approving Gates without reading them
A Gate is a decision the agent cannot take for you. Before approving, answer 3 questions:
1. Do I understand what I am approving?
2. What do I lose if it is wrong?
3. Would I have chosen differently?

If any answer is "no / I don't know / yes", choose **Discuss**. Aim for at least one
modification or refusal per activity.

## 5. "The model remembers what we did yesterday"
It does not. The model has **no memory** between sessions: the **files and git** remember.
That is why GSE-One writes `.gse/` files and why you commit often. New session →
`/gse-resume` or `/gse-status` to reload the context.

## 6. Waiting while the agent works
Do not type over a running agent. Read its plan, then prepare how *you* will check the
result (which test, which page, which `git diff`). When it finishes, check before approving.

## 7. Debug loops ("fix it" → still broken → "fix it"…)
Stop after **2 failed fixes**. Ask the agent for the **root cause** first ("explain why it
fails, do not change code yet"), check it yourself, then ask for one targeted fix.
Still stuck → your tutor window, then the recovery tag, then raise your hand.

## 8. Git confusion
- Before every commit: `git status` then `git diff` — know what you commit.
- One branch per feature/task: `git switch -c feat/<short-name>`; never commit on `main`.
- Undo uncommitted changes to one file: `git restore <file>` (it is final — ask if unsure).
- New file not in `git diff`? Untracked files are ignored: `git add` it, then `git diff --staged`.
- Lost? `git log --oneline -5` and `git branch` show where you are.

## 9. Over-ambitious mini-project
Keep it to **one user, one problem, 2-4 requirements**. A small app that works and is
tested beats a big one that does not run at the demo. Cut scope early: extra ideas go
to the backlog (`/gse-backlog`).

## 10. Deployment
Wait for **your wave** — deployment is done in groups of 5 to avoid overloading the
server, guided by the trainer. Use the application id given on the deployment sheet.
Any server error or credential question → raise your hand (never paste credentials
anywhere, not even in the tutor window).

## 11. The tutor window: how do I open it, what can it see?
- Open it in a **second terminal**: `~/ai4se/ai4se-kit/tutor`. Keep your work in the first
  terminal; ask the tutor in the second one ("right-hand terminal").
- It can read the folders listed in its context — by default everything under `~/ai4se`.
  See the list: `~/ai4se/ai4se-kit/tutor paths`.
- Your project is elsewhere (e.g. a professional mini-project)? Add it:
  `~/ai4se/ai4se-kit/tutor add <path>`.
- It never reads secrets (`.env` files, keys, `~/.ssh`, cloud or opencode credentials) and
  never changes a file: it tells you what to type, you type it in your work terminal.
- It is an AI prepared by the trainer, not the trainer: it can be wrong, and it tells you
  when to call the trainer (keys or quota, server, machine problems that persist, lost work).

## 12. The tutor's answers look outdated
Update the kit — do it at the start of every half-day:
`~/ai4se/ai4se-kit/tutor update`. Then restart the tutor window.

## 13. "Permission denied" or "Blocked by configuration policy" in the tutor window
That is intended: the folder is outside the tutor's list, or the file is a secret.
For a folder you want it to see, use `tutor add <path>`. Never try to work around the
secret rules — show the error (not the secret) to the trainer if it blocks you.

## 14. Is my machine ready?
`sh ~/ai4se/ai4se-kit/check-learner.sh` prints a green/red checklist with a fix hint for
each red line. Run it from your project folder (GSE-One is installed per project). It
never prints a secret.

## 15. Where do I find something in GSE-One?
Ask your tutor window, or read [gse-guide](gse-guide.md): which file and which section of
the GSE-One clone in `~/ai4se/gensem` answers which question. Never read the spec whole
(≈ 271 KB): search, then read the section.

## 16. I found a mistake in a slide, a sheet or GSE-One
Open an issue on `nicolasguelfi/gensem` with the label `ai4se-ed2` (one issue per
problem). The repository is public: no key, password, client code or personal data.
