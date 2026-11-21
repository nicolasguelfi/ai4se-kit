# Trainer tools

Not used by learners. `setup-learner.sh` and the tutor never read this folder.

## advisor.py — the advisor board

A read-only view of every learner's project, for the trainer: one local HTML page, one row per learner and
project, the rows that need attention first. It reads what is **pushed** to each repository — the git history
and the state GSE-One keeps in `.gse/` — and nothing else. Nothing runs on the learners' machines.

```bash
cp ~/ai4se/ai4se-kit/trainer/roster.example.csv ~/somewhere-private/roster.csv   # then fill it
python3 ~/ai4se/ai4se-kit/trainer/advisor.py --roster ~/somewhere-private/roster.csv
open ~/somewhere-private/advisor.html
```

Run it again whenever you want a fresh view: it fetches the latest pushed state each time
(`--no-fetch` reuses the cache, `--no-http` skips the calls to the live applications,
`--stale-min 120` sets after how many minutes without a push a project is flagged quiet).

| Column | Read from |
|---|---|
| Last push | git: the most recent commit on any branch, commits since midnight |
| Where they are | `.gse/config.yaml` (mode), `.gse/plan.yaml` (sprint, steps done, step in progress, steps left), `.gse/status.yaml` |
| Tasks | `.gse/backlog.yaml`: tasks of the sprint by status; points consumed on the budget |
| Tests | `.gse/backlog.yaml`: produced tasks with passing test evidence — **as declared**, tests are not re-run |
| Alerts | nothing pushed for a while · produced tasks without test evidence · failing tests · open review findings · over budget · `.gse/` ignored by git · repository not readable · live app not answering |
| Live app | the `url` column of the roster, or `.gse/deploy.json`; one HTTP call |

**Privacy.** The roster and the page hold names: keep both outside any repository. The clones are stored in
`.advisor-cache/` next to the roster; delete the folder after the course.

**Private repositories.** A learner's private repository is readable once the learner has invited the trainer
(GitHub → Settings → Collaborators) and the trainer's `git` is signed in (`gh auth login`). On a personal
GitHub account an invited collaborator can also write: the tool itself never writes.

**Limits.** It sees only what was pushed: ask for a push before each break. Figures are what the learner's
GSE-One state declares. Needs PyYAML for the full view (`pip install pyyaml`).
