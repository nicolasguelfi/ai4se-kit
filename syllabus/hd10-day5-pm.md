# HD10 — Day 5 afternoon: the sprint goes on; milestone at 16:30

*AI for Software Engineering (AI4SE), edition 2 — Thursday 10 December 2026, 13:15-17:00.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 5 afternoon.*

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:15 | 105 | The sprint goes on (E20); deployment waves 3 (13:15) and 4 (14:00) (E19, hd09) |
| 15:00 | 15 | Break |
| 15:15 | 75 | The sprint goes on; milestone: the trainer validates plans and requirements, one by one |
| 16:30 | 15 | Debrief: the milestone, the deployment (cycle 16) |
| 16:45 | 15 | Buffer: push, `/gse-pause` |

## Learning goals

At the end of this half-day you can:

1. Produce your tasks one by one in Lightweight mode, each on its branch, with its tests run.
2. Cut scope early to hold a delivery date, and keep what you cut in the backlog.
3. Defend your plan and requirements in two minutes.
4. Say what got stuck in a deployment, and which log you read first.

## The sprint goes on (E20)

### Key ideas

**This afternoon.** 13:15 the sprint goes on, deployment waves 3 (13:15) and 4 (14:00) · 15:00 break · 15:15 the sprint goes on while the trainer validates plans and requirements, one by one · 16:30 milestone and debrief: the day, the deployment · 16:45 push, `/gse-pause`, buffer.

The steps are those of sheet E20 (hd09): `/gse-produce` task by task, each task on its branch, its tests run; the 3-question grid at every Gate; extra ideas to `/gse-backlog`.

## Milestone: plan and requirements

### Key ideas

**What the trainer checks, in two minutes:**

1. The plan holds in 8 to 10 points; each task traces to a requirement.
2. 2 to 5 requirements, each with Given / When / Then.
3. At least one measurable non-functional requirement.
4. What is out of scope sits in the backlog.

**Delivered by 11:30 tomorrow? If not, cut now.** The validation runs from 15:15 to 16:30, one by one (twenty validations do not fit in fifteen minutes): keep working until your turn.

### Frequent errors

- Waiting for your turn without producing → the validation comes to you; keep going.
- Starting a new task at 16:20 → finish the one in progress, then push.
- A requirement without acceptance criteria → `/gse-produce` will not start a task that no testable requirement covers.

### Links

GSE-One: `§ 13.2 — Lightweight Mode`; `§ 8 — Complexity Budget`; `§ 3.4 — Backlog`. Glossary: milestone, backlog, complexity budget, acceptance criteria.

## Debrief of the day

### Key ideas

**The milestone.** Is every plan validated? What went to the backlog to hold 11:30 tomorrow? Which Gate did you change, and why?

**The deployment (cycle 16).** What got stuck? Build log or runtime log: where did you look first? Was the live version the one you pushed?

Before you leave: `/gse-pause`, then `git push --all origin`.
