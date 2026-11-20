# HD12 — Day 6 afternoon: gallery demos, lessons learned, closing

*AI for Software Engineering (AI4SE), edition 2 — Friday 11 December 2026, 13:45-17:00.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 6 afternoon.*

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:45 | 15 | Prepare your demo (E24); the trainer checks the final repositories |
| 14:00 | 45 | Gallery, rotation 1 |
| 14:45 | 45 | Gallery, rotation 2 |
| 15:30 | 15 | Break |
| 15:45 | 30 | E25 — Lessons learned, in groups (keep, change, drop) |
| 16:15 | 20 | Your Monday-morning plan |
| 16:35 | 15 | Final questionnaire |
| 16:50 | 10 | Certificates, resources |

## Learning goals

At the end of this half-day you can:

1. Show your approach in 5 to 7 minutes: the problem, the product, one GSE-One moment, one lesson.
2. Test someone else's project with a short grid, kindly and precisely.
3. Say what you keep, change and drop from this week.
4. Name the first concrete thing you will do differently at work, and how you will know it worked.

## The gallery (E24)

### Key ideas

**Two rotations.** 13:45 everyone prepares. 14:00, rotation 1: half A presents at their laptop, half B visits. 14:45, rotation 2: the roles swap. You give your demo again to each new group of visitors.

**Your 5-7 minutes, at your laptop:** the problem · the product, live · one GSE moment · one lesson · questions. The process is what is judged, not the size.

**Visitors: 3 questions.**

1. Does it solve the problem announced? Try it yourself.
2. Can they show one requirement and the test that checks it?
3. Which limit or risk would you point out?

One line of notes per project you visit. Kind and precise: the same grid will be used on your project.

### Exercise — Gallery Demo (Day 6 · 13:45 · 15 min + 14:00 · 90 min)

*All cycles · Exercise E24*

**Goal:** Show your approach in 5 to 7 minutes, and test the projects of the others.

**Steps:**

1. 13:45, prepare: launch your app from the `demo` tag (`git switch --detach demo`); open the files you will show.
2. Your 5-7 minutes, in this order: the problem (who, what) · the product, live · one GSE moment (a Gate you changed, a finding, a refusal) · one lesson · questions.
3. Two rotations (14:00 and 14:45): half of the room presents at their laptop, the other half visits; then swap.
4. As a visitor: try the product yourself, ask the 3 questions of the visitor grid, write one line per project.

**Done when:** You presented during one rotation and visited during the other, with one line of notes per project visited.

**Mid-point:** 14:45 — swap roles.

**If stuck:** The app breaks during the demo? Show the requirements, the tests and the release notes instead: the process is what is judged.

**Debrief:** Which GSE moment did you see most often? Which project would you use tomorrow? (Taken up in E25.)

### Frequent errors

- A tour of every screen → show one path that solves the problem, then the GSE moment.
- Demoing from an unfinished branch → `git switch --detach demo`, the version you froze.
- Visitors who only watch → take the keyboard and try it; that is question 1.

## Lessons learned and Monday morning (E25)

### Key ideas

**Keep, change, drop.** A retrospective (Derby & Larsen, 2006) of the whole week: what helped (keep it), what hurt (change it), what was useless (drop it) — about the agent, the method and your own habits.

**Your Monday-morning plan:** *On <day>, I will <one concrete action> on <project or team>. First step: <…>. I will know it worked when <something I can see>.* For example: a written plan before asking an agent for code; one branch per task, tests first; the 3-question grid before merging an AI suggestion; a README that states its limits. One action, small enough to start on Monday.

### Exercise — Lessons Learned and Monday Morning (Day 6 · 15:45 · 50 min)

*All cycles · Exercise E25*

**Goal:** What you keep, change or drop, and one first concrete step at work.

**Steps:**

1. Alone, 5 min: three notes — one thing to keep, one to change, one to drop (the agent, the method, your habits).
2. At your table, 15 min: group the notes; choose the table's top keep, change and drop.
3. One voice per table: 2 minutes for the room.
4. 16:15, alone: your Monday-morning plan — the first thing you will do differently at work, when, and how you will know it worked.
5. Tell it to your neighbour in one minute.

**Done when:** Your table's keep / change / drop is reported, and your Monday-morning plan is in the tracking sheet.

**Mid-point:** 16:15 — the table lists are reported.

**If stuck:** No idea for Monday? Pick one habit of this week: a plan before code, tests first, a branch per task, the Gate grid, a README that states its limits.

**Debrief:** The trainer collects the table lists: they feed the next edition, like your issues labelled `ai4se-ed2`.

## Final questionnaire

*Link given in class.* 15 minutes, in the room: it is the main way this course improves. Anything else: a GitHub issue on `nicolasguelfi/gensem`, label `ai4se-ed2` (public: no key, client code or personal data).

## Certificates and what you keep

- Your work in `~/ai4se`: FreeSelfApp, CalcApp with its tags, and your mini-project on GitHub.
- The course kit: the syllabus of the 12 half-days, the glossary, the FAQ (CC BY 4.0) — `~/ai4se/ai4se-kit/syllabus`.
- GSE-One, open source, for opencode, Claude Code, Cursor, Codex CLI and Gemini CLI — `github.com/nicolasguelfi/gensem`.
- After the course you only need your own model key.
- Your certificate of attendance, handed out at the end.

Thank you — build with discipline.

## References

Derby, Larsen (2006), *Agile Retrospectives: Making Good Teams Great*.
