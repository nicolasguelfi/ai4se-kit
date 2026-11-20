# HD11 — Day 6 morning: finish, deliver, freeze; audit your project

*AI for Software Engineering (AI4SE), edition 2 — Friday 11 December 2026, 09:00-12:45.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 6 morning.*

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 09:00 | 15 | Welcome: `tutor update`, `/gse-resume` |
| 09:15 | 75 | Finish the sprint (E20) |
| 10:30 | 15 | Break |
| 10:45 | 45 | Finish the sprint |
| 11:30 | 45 | E22 — Deliver (11:30), then freeze (12:00) |
| 12:15 | 30 | E23 — Audit your project (cycle CCSET03 applied) |
| 12:45 | 60 | Lunch |

## Learning goals

At the end of this half-day you can:

1. Finish rather than start: hold a delivery time by cutting scope.
2. Deliver with GSE-One in Lightweight mode, and decide on a HIGH integrity finding.
3. Find the empty shells of your own app and state its known limits in the README.
4. Audit your own project against the AI Act, licences, secrets and personal data.

## Welcome and the finish line

### Key ideas

**Today.** 09:15 finish the sprint (E20) · 11:30 deliver, then freeze at 12:00 (E22) · 12:15 audit your project: AI Act, licences, secrets, data (E23) · 13:45 prepare your demo; gallery in two rotations, 14:00 and 14:45 (E24) · 15:45 lessons learned; your Monday-morning plan (E25) · 16:35 final questionnaire, certificates, resources. First: `~/ai4se/ai4se-kit/tutor update` in the tutor window, then `/gse-resume` in your project.

**Until 11:30: finish, do not start.** Finish the task in progress; start a new one only if it fits. `/gse-status`: what is left? Move what will not make it to the backlog. Every task's tests green before the delivery. Note the moments you will show this afternoon: a Gate you changed, a finding, a refusal. A small thing that works beats a big one that does not run.

## Deliver, then freeze (E22)

### Key ideas

**Freeze** (12:00): no new feature, only fixes and honesty. An *empty shell* looks finished but does nothing — a button with no action, a function that raises `NotImplemented`, a `TODO`, fake data. Find them before a visitor does: remove them, or list them as known limits.

**README: your project card.** What a visitor reads first — and what the trainer checks at 13:45:

```markdown
# <Project name>
<One sentence: who it is for, which problem it solves.>

## Run it
<the commands to install and start it>

## Live
<the address — CalcApp's if this project is not deployed>

## Known limits
- <what does not work yet; each empty shell you kept>

## Ethics and compliance
<written at 12:15, exercise E23>
```

Saying your limits yourself is part of the delivery.

### Exercise — Deliver, Then Freeze (Day 6 · 11:30 · 45 min)

*CCSET08 and CCSET14 · Exercise E22*

**Goal:** A version you can present, honest about its limits.

**Steps:**

1. 11:30, `/gse-deliver`: its integrity check lists at most 5 findings; a HIGH one stops the merge until you decide (fix it, or accept the risk as a recorded decision). Choose the merge strategy at the Gate.
2. Push the delivery: `git push origin main --tags`.
3. 12:00, freeze: no new feature from now on. Hunt the empty shells: `git grep -n -E "NotImplemented|TODO|FIXME"`; launch the app and click every button, run every step of your demo.
4. On a branch (`git switch -c docs/demo`), the README: the project card (a one-sentence pitch, how to launch it, the live address — CalcApp's if your project is not deployed) and a section "Known limits". Commit.
5. Bring it to `main` and mark the demo version: `git switch main`, `git merge --no-ff docs/demo`, `git tag demo`, `git push origin main demo`.

**Done when:** The tag `demo` is on GitHub, and the README shows the project card and the known limits.

**Mid-point:** 12:00 — the delivery is on `main` and pushed; the freeze starts.

**If stuck:** A HIGH finding blocks the merge? Small: fix it now. Otherwise accept the risk at the Gate and list it in the known limits. Then your tutor window → raise your hand.

**Debrief:** How many empty shells did you find? Which limit would you rather say yourself than have a visitor find?

### Frequent errors

- Adding "one last feature" after 12:00 → it is the one that breaks the demo; write it in the backlog.
- Committing the README straight on `main` → the guardrail refuses it; use the `docs/demo` branch, then merge.
- Forgetting to push the tag → `git push origin main demo`; check the tag on GitHub.

### Links

GSE-One: `§ 13.2 — Lightweight Mode` (minimal integrity check at delivery); `§ 10.4 — Merge Strategy (Gate Decision)`; `§ 10.6 — Safety and Recovery` (backup tags). Glossary: deliver, freeze, empty stub, known limits, tag, project card.

## Audit your project — CCSET03 applied (E23)

### Key ideas

**Day 1, now on your project** (recall: [hd01 § EU AI Act and rules for this week](hd01-day1-am.md#eu-ai-act-and-rules-for-this-week)).

- **AI Act** (Regulation (EU) 2024/1689): the risk level of what you build — unacceptable, high, low or minimal. Transparency: people must know they deal with an AI, or with AI-made content.
- **Licences**: your repository's licence, and your dependencies' — may you use them this way?
- **Secrets**: never in git. A leaked key is revoked, not just deleted (hd09, CCSET16).
- **Personal data** (GDPR, Regulation (EU) 2016/679): keep the fewest, say why and for how long; demo with made-up data.

**Your README: ethics and compliance.** Four short answers; "not sure, because…" is a valid answer. On a branch, merged into `main` as at 12:00; then push.

```markdown
## Ethics and compliance
- AI Act: <does the app use AI? risk level; how users are told>
- Licences: <this repository's licence; dependencies checked; any doubt>
- Secrets: <.env never committed; history checked on <date>>
- Personal data: <which, where, why, how long — or "none">
```

### Exercise — Audit Your Project (Day 6 · 12:15 · 30 min)

*CCSET03 applied · Exercise E23*

**Goal:** Check your own project against the AI Act, licences, secrets and personal data.

**Steps:**

1. AI Act: does your app use AI? If so, which risk level (day 1: unacceptable, high, low or minimal)? Does the user know they deal with an AI, or with AI-made content (transparency)?
2. Licences: a `LICENSE` file in your repository? The licence of each direct dependency (`npm view <package> license`, `pip show <package>`): does one forbid your use?
3. Secrets: `git log --all --oneline -- .env` prints nothing; `git grep -n -i -E "api.?key|secret|password|token"` shows no real value. A leaked key is revoked, not just deleted.
4. Personal data: which ones does your app keep (names, e-mails, health…), where, why, for how long? Keep the fewest; demo with made-up data.
5. Write the four answers in a README section "Ethics and compliance", on a branch merged into `main` as at 12:00; push.

**Done when:** The README of `main`, on GitHub, has a section "Ethics and compliance" with your four answers.

**If stuck:** Not sure of a risk level or a licence? Write "not sure, because…": an honest doubt is a valid answer. Then your tutor window → raise your hand.

**Debrief:** Who found a secret in their history, or a licence they did not know? What would change for a real client?

### Frequent errors

- "My app has no AI, so the AI Act does not apply" → right for the risk level; but say so in the README, it is an answer.
- `.env` found in the history → do not just delete the file: tell the trainer and revoke the key.
- Real names or e-mails in the demo data → replace them with made-up ones before the gallery.

### Links

Day 1: [hd01 § EU AI Act and rules for this week](hd01-day1-am.md#eu-ai-act-and-rules-for-this-week). GSE-One: `§ 9 — Guardrails`. Glossary: AI Act, licence, secret, personal data.

## References

European Union (2016), *Regulation (EU) 2016/679 (General Data Protection Regulation)*. · European Union (2024), *Regulation (EU) 2024/1689 (Artificial Intelligence Act)*, amended by Regulation (EU) 2026/1744. · Meli, McNiece, Reaves (2019), *How Bad Can It Git?*, NDSS.
