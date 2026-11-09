# Recovery procedures

## Late by more than 15 minutes? Restart from a recovery tag

Do not try to catch up line by line. Clone the public starter at the tag of the current
exercise, in a **new folder**, and continue from there. Example with tag `j2-part1`
(replace it by the tag of your exercise):

```sh
git clone https://github.com/nicolasguelfi/calcapp-starter calcapp-restart
cd calcapp-restart
git checkout -b mywork j2-part1
npm ci
npm run test:run
```

| Tag | Use it to restart… |
|---|---|
| `j2-start` | Day 2 morning: git first, steering opencode, technical plan |
| `j2-part1` | Day 2 afternoon: CalcApp v0.1 part 2 |
| `j2-v0.1` | Day 2 end: code review, bridge to GSE-One (v0.1 shipped) |

More tags are added for later days (`p3-start`, …): `git tag` after `git fetch --tags` lists them.
Keep your old folder: nothing is deleted, you can compare later.

## GSE-One: stopping and resuming

- `/gse-pause` — saves a checkpoint (where you are, what is pending). Use it before a
  break, at the end of the day, or before changing machine.
- `/gse-resume` — reloads the last checkpoint and tells you where you were.
- `/gse-status` — shows the current sprint, activity, and next step at any time.

## GSE-One backup tags

Before risky git operations (merges, branch deletions) GSE-One creates tags named
`gse-backup/…` (for example `gse-backup/sprint-01-pre-main-merge`).

- List them: `git tag -l 'gse-backup/*'`
- Look at one without changing anything: `git log --oneline -5 <tag>`
- Restore safely **on a new branch** (your current branch is untouched):
  `git switch -c recover-1 <tag>`

Never use `git reset --hard` or delete branches to "clean up": call the trainer instead.

## "The agent went off track" — 6 steps, in order

Stop at the first step that solves it.

1. **Discuss** — at the next Gate, choose *Discuss* instead of approving; say what you
   expected and ask the agent to explain its plan.
2. **`/gse-status`** — check where GSE-One thinks you are (activity, sprint, pending
   steps). Mismatches usually explain odd behaviour.
3. **Refuse the change** — reject the proposal at the Gate, or tell the agent "do not
   apply this; undo your last change" and check with `git status` / `git diff`.
4. **`/gse-pause` then `/gse-resume`** — saves state and reloads it cleanly; this also
   resets a confused conversation (start a new opencode session in between if needed).
5. **Restore a backup tag** — `git tag -l 'gse-backup/*'`, then
   `git switch -c recover-1 <tag>` (see above).
6. **Call the trainer** — raise your hand; do not type more commands meanwhile.
