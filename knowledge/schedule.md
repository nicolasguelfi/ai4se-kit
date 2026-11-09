# Course schedule (AI4SE, edition 2)

Six days in three blocks of two days. Times are indicative; practice may run longer —
each day ends with a buffer for catching up.

## Day 1 — Generative AI, vibe coding, installation

| Time | Session |
|---|---|
| 09:00 | Welcome, round table, level check (show of hands) |
| 09:30 | What you will be able to do: 6 course goals; how we work (practice first, `@tutor`, GitHub issues, daily buffer). The published programme mentions Cursor: we use **opencode** |
| 09:45 | Generative AI fundamentals + 3 key notions: from LLM to agent; the model has no memory; model families, what your key gives you, tokens = cost |
| 10:35 | Break |
| 10:50 | From VibeCoding to VibeEngineering (acts I-III) |
| 11:35 | Act IV — tools: autonomy levels, opencode (the course tool), other tools, local LLMs, MCP + notion 4: AI Act and practical rules (what never goes into a prompt, which permissions to give an agent) |
| 12:15 | Lunch |
| 13:15 | **Installation in the room**: opencode, model key, GSE-One v0.90.0 (pinned), `@tutor`, GitHub account + `gh auth login`, `check-learner.sh` all green |
| 14:30 | FreeSelfApp workshop, part 1 — naive prototype with opencode |
| 15:15 | Break |
| 15:30 | FreeSelfApp workshop, part 2 |
| 16:15 | Debrief: "what I would have done by hand / what the AI did", show-of-hands quiz, day 2 preview |
| 16:45 | Buffer (late installations, questions) |

## Day 2 — CalcApp, git first, steering opencode

Running example: **CalcApp**, public starter `https://github.com/nicolasguelfi/calcapp-starter`,
recovery tags `j2-start`, `j2-part1`, `j2-v0.1`.

| Time | Session |
|---|---|
| 09:00 | Welcome, day 1 recap, "same tools, different discipline", the artefact chain |
| 09:15 | **Git first** on the starter cloned at `j2-start`: status, diff, commit, one branch per feature, restore |
| 09:50 | **Steering opencode**: AI-readable project structure, `AGENTS.md`, context and `@file`, *plan* agent then *build* agent (Tab switches), task list, MCP and Context7 in `opencode.json` — 3 short demos, each followed by a try |
| 10:45 | Break |
| 11:00 | **Technical plan workshop**: elicit CalcApp requirements with the *plan* agent, split into atomic tasks → you write `docs/plan.md` and commit it |
| 11:30 | **CalcApp v0.1, part 1**: TDD with the AI (red, green, mutant test) on the first task of your own plan, one branch per task |
| 12:15 | Lunch |
| 13:15 | **CalcApp v0.1, part 2**: next tasks of your plan (navigation, data). Late? restart from tag `j2-part1` |
| 14:30 | **AI code review**: what the AI sees and misses, review size, HIGH / MEDIUM / LOW triage (GSE-One format) |
| 15:00 | Break |
| 15:15 | **Review of the day's diff** (`git diff j2-start`): AI review, triage, chosen fixes (at least one argued refusal), README 80/20 |
| 16:15 | **Ship v0.1**: merge into `main`, tag `v0.1`. Late? restart from tag `j2-v0.1` |
| 16:30 | **Bridge to GSE-One**: today's manual loop (plan → tasks → TDD → review → delivery) next to the `/gse-…` commands; debrief; quiz |
| 17:00 | Buffer: catch-up, questions, `@tutor` |

## Days 3-6 (summary)

- **Day 3** — The GSE-One method on CalcApp, practices P1 onwards (`/gse-go`, requirements, design, Gates); work pushed to GitHub every evening.
- **Day 4** — GSE-One on CalcApp continued up to P7 (tests, review, delivery), 30 min "measuring quality"; **mini-project launch** at the end of the day (one-page scope, Lightweight mode).
- **Day 5** — Mini-project work + deployment (by waves, guided by the trainer).
- **Day 6** — Finish the mini-project, applied ethics, gallery demo in two rotations, closing and final questionnaire.
