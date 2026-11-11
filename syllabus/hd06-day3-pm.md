# HD06 — Day 3 afternoon: first use of GSE-One — discover, plan, requirements and design

*AI for Software Engineering (AI4SE), edition 2 — Thursday 3 December 2026, 13:30-17:00.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 3 afternoon.*

This afternoon you use GSE-One for the first time, on your own CalcApp, in **Full** mode. Each exercise puts into practice a cycle of this morning (hd05). Keep the orientation page next to you ([orientation.md](orientation.md)).

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 13:30 | 60 | E11 — Discover GSE-One on your CalcApp (exercise 50, debrief 10) — cycle CCSET09 |
| 14:30 | 45 | E12 — Plan the sprint with GSE-One (recall 5, exercise 35, debrief 5) — cycle CCSET06, again |
| 15:15 | 15 | Break |
| 15:30 | 75 | E13 — Requirements and design (exercise 65, debrief 10) — cycles CCSET10 and CCSET11 |
| 16:45 | 15 | Day close: push to GitHub, `/gse-pause`, hands-up quiz |

## Learning goals

At the end of this half-day you can:

1. Install GSE-One in a project and start it with `/gse-go`, then find where it keeps its state (`.gse/`).
2. Pass a Gate with the 3-question grid, and change or refuse at least one proposal per activity.
3. Validate a sprint plan and compare it with a plan written by hand.
4. Obtain testable functional requirements and at least one measurable non-functional requirement, then a validated design, with the links between them.

## Discover GSE-One

### Key ideas

GSE-One is installed **per project**: the same command as on day 1, run inside your CalcApp folder this time.

```bash
cd ~/ai4se/calcapp && git switch -c chore/gse-one main
curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/gensem/v0.90.0/install.sh \
  | GSE_PLATFORM=opencode GSE_VERSION=v0.90.0 sh
cat .gse/registry      # prints .opencode
git add . && git commit -m "chore: install GSE-One v0.90.0"
git switch main && git merge --no-ff --no-edit chore/gse-one
```

The new files are part of your project: committed on a branch, merged into `main` (since yesterday evening `main` holds your v0.1, and it only receives merges). `/gse-go` is the single entry point: it profiles you (expertise, language, how much you want to be involved), proposes a mode at a Gate, and chooses the next activity. Its state lives in `.gse/`: `profile.yaml` (you), `status.yaml` (where the project is), `backlog.yaml` (the work items), `plan.yaml` (the current sprint).

### Exercise — Discover GSE-One on Your CalcApp (13:30 · 50 min)

*CCSET09 · Exercise E11 (P1)*

**Goal:** Bring your CalcApp under GSE-One and pass your first Gate.

**Steps:**

1. `cd ~/ai4se/calcapp` (since yesterday `main` holds your v0.1); install GSE-One on a branch merged into `main` (commands just before this sheet; same install command as day 1, installation step 5).
2. Start `opencode`, type `/gse-go`, answer the profile questions in plain language.
3. At the mode Gate choose Full; apply the 3-question grid and write your answers in the tracking sheet.
4. Open `.gse/profile.yaml` (do you recognise yourself?) and `.gse/status.yaml`, then run `/gse-status`.
5. Ask the agent to commit straight on `main`. Look for its Gate: the agent refuses by itself, explains the protect-main guardrail and offers safe paths (a branch, …). Pick one, and note the Gate. (The hook would block the commit only if the agent tried anyway.)

**Done when:** `/gse-status` shows the project in Full mode, and the guardrail Gate (refusal + safe options) is noted in the tracking sheet.

**Mid-point:** 14:00 — the profile questions are done.

**If stuck:** Your tutor window → restart from the tag `p3-start` → raise your hand.

**Debrief:** Which principles from this morning did you see: a Gate, a guardrail, the memory in files?

### Frequent errors

- `/gse-go` is not recognised → opencode was started before the install, or in another folder: quit, `cd ~/ai4se/calcapp`, restart `opencode`.
- The agent proposes to commit on `main` → refuse. GSE-One itself refuses at a Gate and offers safe paths (a branch, …); its hook blocks the commit only if the agent tries anyway. Work on the task branches GSE-One creates: `main` only receives their merges.
- You accept every Gate without reading → apply the grid; a Gate you always accept is not a Gate.

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § 0.2 — Quickstart — Your First 20 Minutes`; `§ 3.2 — Onboarding` (profile); `§ 9.3 — Git-Specific Guardrails`; `§ 12.4 — Status State File`. Glossary: Gate, profile, mode, guardrail, `.gse/`.

## Plan the sprint with GSE-One

### Key ideas

The cycle of day 2 (CCSET06), now with the method. A sprint is a cycle sized by a **complexity budget** in points, not a calendar period. GSE-One collects what exists (collect), finds what is missing (assess), then proposes a plan (plan): tasks, each with its size, its branch and its order. The plan is a Gate: nothing is built before you validate it. `.gse/plan.yaml` is a living plan, kept up to date during the sprint.

### Exercise — Plan the Sprint with GSE-One (14:35 · 35 min)

*CCSET06 again, now with GSE-One · Exercise E12 (P3)*

**Goal:** A sprint plan you validated, with at least one change of your own.

**Steps:**

1. Let `/gse-go` chain collect → assess → plan (or run `/gse-plan`).
2. Open `.gse/plan.yaml`: count the tasks and the complexity points.
3. At the plan Gate, apply the grid and change at least one thing: split, reorder or remove a task.
4. Compare with the `docs/plan.md` you wrote by hand on day 2.

**Done when:** `/gse-status` shows a validated plan, and your change is noted in the tracking sheet.

**If stuck:** Your tutor window → restart from the tag `p3-start` → raise your hand.

**Debrief:** What did GSE-One's plan see that your `docs/plan.md` missed — and the other way round?

### Links

GSE-One: `§ 3.5 — Discovery & Planning`; `§ 8 — Complexity Budget`; `§ 4.7 — Assess — Gap Analysis`. Glossary: sprint, complexity budget, backlog, task.

## Requirements and design

### Key ideas

This morning's cycles CCSET10 and CCSET11 in practice. `/gse-reqs` starts with a conversation in plain language, then writes requirements (REQ-…) with Given / When / Then acceptance criteria, functional and non-functional, and ends with a quality checklist. `/gse-design` proposes the architecture decisions — a Gate. `/gse-preview` shows what will be built before building it. `/gse-status` shows the chain requirement → design → task: traceability.

### Exercise — Requirements and Design (15:30 · 65 min)

*CCSET10 and CCSET11 · Exercise E13 (P5)*

**Goal:** The functional and non-functional requirements of CalcApp's next version, then a validated design.

**Steps:**

1. `/gse-reqs`: answer in plain language; check that every functional requirement has testable acceptance criteria (Given / When / Then).
2. Add yourself at least one measurable non-functional requirement, for example "1,000 expenses are listed in less than 200 ms".
3. `/gse-design`: a Gate — apply the grid.
4. `/gse-preview`: compare with what you had in mind.
5. `/gse-status`: check the chain requirement → design → task.

**Done when:** `reqs.md` holds at least 3 functional requirements and 1 measurable non-functional one; the design is validated; the links show in `/gse-status`.

**Mid-point:** 16:00 — the requirements are validated.

**If stuck:** Your tutor window → restart from the tag `p5-start` → raise your hand.

**Debrief:** Which elicitation technique did the agent use? Which non-functional requirement was missing?

### Frequent errors

- Requirements full of vague words ("fast", "easy") → ask the agent for a scale, a meter and a goal (hd05, CCSET11).
- No non-functional requirement at all → add one yourself; the agent rarely insists.
- The preview does not match your idea → say so now: it is the cheapest moment to change.

### Links

GSE-One: `§ 3.6 — Engineering` (`/gse-reqs`, `/gse-design`); `§ 5 — Preview`; `§ 11 — Decision Journal`. Glossary: requirement, acceptance criterion, design decision, preview, traceability.

## Hands-up quiz

1. "The app is fast." Requirement or wish? — *A wish, until it has a scale, a meter and a goal.*
2. Name two elicitation techniques, and when to use each. — *Interview for goals and the "why"; observation for the real work; prototype when the user cannot describe it.*
3. Verification or validation: a demo to the user? — *Validation: is it the right product?*
4. Why should the expected result of a test not come from the code? — *A test that copies the code copies its bugs: take it from the requirement.*
5. Which GSE-One file says where your project is? — *`.gse/status.yaml`, or simply `/gse-status`.*

Before you leave: push to GitHub (`git push mine --all && git push mine --tags`), then `/gse-pause`.
