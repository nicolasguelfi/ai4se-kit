# FAQ — the 10 most frequent problems (from edition 1)

## 1. `/gse:go` does nothing / "unknown command"
`/gse:go` is the **Claude Code** spelling. In **opencode** the commands use a dash:
`/gse-go`, `/gse-status`, `/gse-pause`, `/gse-resume`… Type `/gse-` and pick from the list.
If no `/gse-` command appears, GSE-One is not installed in this folder: run
`check-learner.sh` from the project folder and ask the trainer.

## 2. Which mode: Full, Lightweight or Micro?
GSE-One proposes a mode at `/gse-go`. **CalcApp: Full** (the whole lifecycle, to learn
every activity). **Mini-project: Lightweight** (fewer artefacts, faster). Micro is for
tiny throw-away scripts — not used in the course. If the proposed mode differs, choose
*Discuss* and say which mode the course asks for.

## 3. "Where am I in the lifecycle?"
Run `/gse-status`: it shows the sprint, the current activity, and the next step.
Read it before asking the agent to "continue".

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
result (which test, which page, which `git diff`). When it finishes, check before
approving.

## 7. Debug loops ("fix it" → still broken → "fix it"…)
Stop after **2 failed fixes**. Ask the agent for the **root cause** first ("explain why it
fails, do not change code yet"), check it yourself, then ask for one targeted fix.
Still stuck → `@tutor`, then the recovery tag, then raise your hand.

## 8. Git confusion
- Before every commit: `git status` then `git diff` — know what you commit.
- One branch per feature/task: `git switch -c feat/<short-name>`; never commit on `main`.
- Undo uncommitted changes to one file: `git restore <file>` (ask if unsure — it is final).
- Lost? `git log --oneline -5` and `git branch` show where you are.

## 9. Over-ambitious mini-project
Keep it to **one user, one problem, 2-4 requirements**. A small app that works and is
tested beats a big one that does not run at the demo. Cut scope early: extra ideas go
to the backlog.

## 10. Deployment
Wait for **your wave** — the trainer deploys by groups to avoid overloading the server.
Use your **first name** (lowercase, no spaces or accents) as your application id. Any
server error or credential question → raise your hand (never paste credentials anywhere).
