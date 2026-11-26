# Recovery procedures

When stuck, always in this order: **your tutor window → the recovery tag → raise your
hand.** The tutor window is the second terminal opened with `~/ai4se/ai4se-kit/tutor`;
it diagnoses and gives the smallest next step, but never changes your files.

## Late by more than 15 minutes? Restart from a recovery tag

Do not try to catch up line by line. Clone the public starter at the tag of the current
exercise, in a **new folder** next to your old one, and continue from there. Example with
tag `j2-part1` (replace it with the tag of your exercise):

```sh
cd ~/ai4se
git clone https://github.com/nicolasguelfi/calcapp-starter calcapp-restart
cd calcapp-restart
git checkout -b mywork j2-part1
npm ci
npm run test:run
```

**Why the tag in `git checkout -b mywork j2-part1`.** Every commit has an identifier (e.g. `6225c63`); a tag is a readable name fixed on one commit (`j2-part1` is `6225c63`, it never moves), while a branch is a name that moves forward with each new commit. Without a starting point, a new branch starts at the current commit (HEAD): right after the clone, the latest commit of `main`, not the checkpoint you need. `git checkout j2-part1` alone (without `-b`) puts you on no branch (« detached HEAD »): commits made there belong to no branch and can be lost. Newer equivalent: `git switch -c mywork j2-part1`.

| Tag | Use it to restart… |
|---|---|
| `j2-start` | HD03 (day 2 morning): git first, steering opencode, technical plan |
| `j2-part1` | HD04 (day 2 afternoon): CalcApp v0.1, part 2 |
| `j2-v0.1` | HD04 end: v0.1 ready for delivery, bridge to GSE-One |
| `p3-start` | HD05-HD06 (day 3 morning, then E11-E12 in the afternoon): CalcApp v0.1, ready for GSE-One |
| `p5-start` | HD06 (day 3 afternoon, E13): GSE-One installed, sprint plan approved, before requirements and design |
| `p6-start` | HD07 (day 4 morning, E14): requirements, design and preview validated, quality kit in; start of tests |
| `p7-start` | HD08 (day 4 afternoon, E16): sprint produced and reviewed (`review.md`); start of fix and delivery |

From `p3-start` on (day 3), GSE-One takes `main` as the reference: restart on `main`, not
on `mywork` — `git switch -C main p3-start` instead of `git checkout -b mywork j2-start`.
Exception, `p7-start`: the sprint work sits on the sprint branch, so restart with
`git switch -C gse/sprint-01/integration p7-start` then `git branch -f main p6-start`
(`/gse-deliver` then merges the sprint into `main`).

The tags `p5-start`, `p6-start` and `p7-start` carry no learner profile. Before `/gse-go`
(or `/gse-resume`), copy your own from your old folder: `cp ../calcapp/.gse/profile.yaml .gse/`.
Otherwise GSE-One asks you the profile questions again.

The half-day sheet says which tag to use; `git fetch --tags && git tag` lists them all.
Keep your old folder: nothing is deleted, you can compare later. The tutor window already
sees the new folder if it is under `~/ai4se`.

## GSE-One: stopping and resuming

- `/gse-pause` — commits pending work and saves a checkpoint (where you are, what is
  pending). Use it before a break, at the end of the day, or before changing machine.
- `/gse-resume` — reloads the last checkpoint and tells you where you were.
- `/gse-status` — shows the current sprint, activity and next step at any time.

Reference: spec § 12.5 — Checkpoint Format; activities `pause.md` and `resume.md`
(see [gse-guide](gse-guide.md)).

## GSE-One backup tags

Before risky git operations (merges, branch deletions) GSE-One creates tags named
`gse-backup/…` (for example `gse-backup/sprint-01-pre-main-merge`).

- List them: `git tag -l 'gse-backup/*'`
- Pick one from the list: `TAG=gse-backup/sprint-01-pre-main-merge` (change it to the one you want)
- Look at it without changing anything: `git log --oneline -5 "$TAG"`
- Restore safely **on a new branch** (your current branch is untouched):
  `git switch -c recover-1 "$TAG"`

Never use `git reset --hard` or delete branches to "clean up": call the trainer instead.
Reference: spec § 10.6 — Safety and Recovery.

## "The agent went off track" — 6 steps, in order

This is the back of the printed orientation page. Stop at the first step that solves it.

1. **Discuss** — at the next Gate, choose *Discuss* instead of approving; say what you
   expected and ask the agent to explain its plan.
2. **`/gse-status`** — check where GSE-One thinks you are (activity, sprint, pending
   steps). Mismatches usually explain odd behaviour.
3. **Refuse the change** — reject the proposal at the Gate, or tell the agent "do not
   apply this; undo your last change" and check with `git status` / `git diff`.
4. **`/gse-pause` then `/gse-resume`** — saves state and reloads it cleanly; this also
   resets a confused conversation (start a new opencode session in between if needed).
5. **Restore a backup tag** — `git tag -l 'gse-backup/*'`, then
   `TAG=` the one you pick, then `git switch -c recover-1 "$TAG"` (see above).
6. **Call the trainer** — raise your hand; do not type more commands meanwhile.

You can ask your tutor window at any step: it reads your `git status`, `git log` and
`.gse/` state and tells you which step fits.

## The tutor window itself does not work

1. Close it and reopen it: `~/ai4se/ai4se-kit/tutor`.
2. Update the kit: `~/ai4se/ai4se-kit/tutor update`.
3. Check the machine: `sh ~/ai4se/ai4se-kit/check-learner.sh`.
4. Still broken → raise your hand (and keep working with the half-day sheet meanwhile:
   everything the tutor knows is in `~/ai4se/ai4se-kit/syllabus/`).

## When to go straight to the trainer

Do not spend time on these — raise your hand:
- model key or quota problems (errors about credits, authentication, rate limits);
- anything about the deployment server or its credentials;
- a machine problem still there after two exchanges with the tutor window;
- work you think you have lost (do not run more git commands first);
- anything personal.
