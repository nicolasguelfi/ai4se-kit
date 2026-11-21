# HD09 — Day 5 morning: deployment; your mini-project sprint starts

*AI for Software Engineering (AI4SE), edition 2 — Thursday 10 December 2026, 09:00-12:15.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 5 morning.*

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 09:00 | 15 | Welcome: `tutor update`, `/gse-resume` on your mini-project |
| 09:15 | 20 | CCSET16 — Deployment (theory) |
| 09:35 | 10 | CCSET16 — How GSE-One solves it; how we deploy in this course |
| 09:45 | 60 | Your mini-project sprint (E20): the plan, then the requirements on two models (E21) |
| 10:45 | 15 | Break |
| 11:00 | 75 | The sprint goes on (E20); deployment waves 1 (11:00) and 2 (11:40) deploy CalcApp with the trainer (E19) |
| 12:15 | 60 | Lunch |

## Learning goals

At the end of this half-day you can:

1. Describe the path from code to a running service: build, image, container, server, address.
2. Say where configuration and secrets live, and what to do when a secret has leaked.
3. Tell a build log from a runtime log, and explain why you roll back before you debug.
4. Run the first activities of a Lightweight sprint on your own project: plan, then requirements.
5. Compare two models on the same instruction with a grid — the structure, not the words.

## Welcome: back to your project

### Key ideas

**Today.** 09:15 CCSET16, deployment (the last new cycle of the course) · 09:45 your sprint: the plan, then the requirements on two models (E20, E21) · 11:00 the sprint goes on; deployment waves 1 and 2 (E19) · 13:15 waves 3 and 4 · 15:15 the trainer validates your plan and requirements, one by one · 16:30 debrief of the milestone and of the deployment; push, `/gse-pause`.

**Back to your project.** Yesterday you framed it and started it in Lightweight mode. Pick it up where you stopped:

```bash
~/ai4se/ai4se-kit/tutor update     # in the tutor window
cd <your-project>
opencode
/gse-resume                        # in opencode
```

Project outside `~/ai4se`? Once: `~/ai4se/ai4se-kit/tutor add <path>` — so your tutor window can read it. `/gse-resume` should say: Lightweight mode, card validated, next step the plan.

## CCSET16 — Deployment

### Key ideas

**From code to a service.** Code (your repository, at a tag) → build (install, test, compile) → image (all it needs to run, frozen) → container (the image, running on a server) → address (a name and HTTPS). "It works on my machine" is not a service: another machine, other versions, and nobody there to restart it. Build once, deploy the same image everywhere, so that what you tested is what runs; every step is a script, not a memory (Humble & Farley, 2010).

**Image and container** (Merkel, 2014). An *image* is a frozen package: system, runtime, your built app. A *container* is one running copy of an image, isolated; restart it and it starts fresh. The *Dockerfile* is the recipe of the image, versioned with the code. CalcApp's starter ships a tested one, in two stages — build with Node, run with a small web server, so neither the source code nor Node reaches production (simplified here):

```dockerfile
# stage 1: build
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run test:run && npm run build
# stage 2: run
FROM nginx:1.28-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 3000
HEALTHCHECK CMD wget -q -O /dev/null http://127.0.0.1:3000/
```

**The server and the address.** A *server* is a machine that runs your containers day and night — not your laptop. The container listens on a *port* (CalcApp: `3000`); the server routes the address to it. A *domain* points to the server, and a certificate gives *HTTPS* so the browser trusts it. A *deployment platform* does the chores: it fetches your repository, builds the image, runs the container, routes the domain and restarts the container when it crashes. Your part: a Dockerfile that builds, an app that listens on the expected port, and a configuration kept out of the code.

**Configuration and secrets.** Same image, different places: what changes between your laptop and the server is the *configuration*, read from *environment variables* (`PORT`, a database address, an API key) (The Twelve-Factor App, factor III). *Secrets* — keys, passwords, tokens — never go in the code: `.env` is in `.gitignore`, and a committed `.env.example` lists the names only. A pushed secret is public: deleting the commit is not enough, because clones and forks keep it — **revoke the key**. Meli et al. (2019) found secrets leaked in over 100,000 public GitHub repositories, with thousands of new ones every day.

**Logs: what really happened.** The *build log* is written while the image is built: it shows the install, test or compile step that failed (day 4's CI again). The *runtime log* is written while the container runs: crashes, errors, the requests it received. The app writes to its standard output and the platform collects it (Twelve-Factor, factor XI). Read for the first error, not the last line. A *health check* is an address the platform calls to know the container is alive — but **healthy ≠ the right version**: compare the commit that is live with the one you pushed.

**When it breaks: roll back.** Roll back first, debug after: redeploy the last version that worked. That is only possible if you kept it — tagged releases, the previous image, one change per deployment. Data is the hard part: a changed database does not go back by itself. Teams measure how often a change fails and how long it takes to restore the service (Forsgren et al., 2018). A deployment you cannot undo is a bet.

### How GSE-One solves it (CCSET16, concept only)

*The problem:* going live takes many steps a beginner does not know, and a half-done deployment is hard to resume.

- `/gse-deploy` guides the whole path in one flow, from the server to the live address.
- It writes a Dockerfile only if your project has none, picked by project type and shown to you first: CalcApp's own Dockerfile is kept.
- Its state is a file, `.gse/deploy.json`: the steps already done are skipped on a re-run, so an interrupted deployment resumes.
- After deploying, it checks that the app answers — and that the live version is the one you pushed.

### How we deploy in this course

- **Your repository.** Your own CalcApp repository becomes `origin` (`mine` until now; the starter becomes `starter`). Push `main`: the server builds what is on GitHub, not what is on your laptop.
- **Your identifier.** `v` + your number in the tracking sheet, e.g. `v07`. Your app lives at `https://calcapp-v07.<course domain>` — never your name: the address is public.
- **The course file.** The trainer gives you `.env.training` at the deployment table; copy it into CalcApp as `.env`. Git ignores it: never commit it.
- **The command.** `/gse-deploy`, role Learner: it checks the file and your remote, builds the image, starts the container, gets the HTTPS certificate and calls the app until it answers (1-3 min). Run it again after a fix: it reuses your app.
- **Your logs.** `/gse-deploy --logs` shows the last 100 lines of your running app (`--lines 300` for more). A build that fails leaves no running app: run `npm run test:run && npm run build` on your laptop, the server runs the same steps.
- **The waves.** 5 learners at the deployment table: 11:00, 11:40, 13:15, 14:00; the others go on with their sprint.
- **The token.** The course file holds a token that reaches every app on the server: deploy only your own. After the course the token is revoked and every app removed.

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § 3.8 — Deployment`; the activity `~/ai4se/gensem/gse-one/src/activities/deploy.md` (Phase 6 — Deploy Application). Glossary: container, image, Dockerfile, environment variable, secret, logs, health check, rollback.

## Your mini-project sprint (E20, E21)

### Key ideas

**Your sprint, in Lightweight mode:** plan (`/gse-plan`) → requirements (`/gse-reqs`) → production (`/gse-produce`) → delivery (`/gse-deliver`). There is no tests, review, fix or capitalisation step: a small test strategy is generated at production, and delivery runs a **minimal integrity check** (devil's advocate, at most 5 findings; a HIGH one stops the merge until you decide). 8 to 10 complexity points; every extra idea goes to `/gse-backlog`. The 3-question grid at every Gate; push before each break and every evening. Milestones: day 5 16:30 plan and requirements validated · day 6 11:30 first delivery · 12:00 freeze.

**Two models, one grid.** The same `/gse-reqs` on the course model (A: `openrouter/deepseek/deepseek-v4.1-flash`) and on the backup model (B: `openrouter/minimax/minimax-m3.1-flash`, chosen in opencode with `/models`), with the same answers, then:

| Criterion | Model A (course) | Model B (backup) |
|---|---|---|
| Number of requirements | … | … |
| Testable ones (Given / When / Then) | … | … |
| Non-functional requirement forgotten | … | … |
| Questions it asked you | … | … |
| Cost (tokens, $ spent) | … | … |

**Compare the structure, not the words.** A longer, more fluent list is not a better one: count what can be tested, what is missing, and what the model asked before writing.

### Exercise — Your Mini-Project Sprint (Day 5 · 09:45 → day 6 · 11:30)

*All cycles · Exercise E20 (your mini-project, Lightweight mode)*

**Goal:** Apply the loop you learned, on your own, in Lightweight mode: plan → requirements → production → delivery.

**Steps:**

1. `/gse-plan`: a sprint of 8 to 10 complexity points; its last task, day 6 from 11:00, the empty-shell hunt and the README (sheet E22). What does not fit goes to the backlog (`/gse-backlog`).
2. `/gse-reqs`: 2 to 5 requirements with Given / When / Then criteria, at least one of them a measurable non-functional requirement (sheet E21: you run it on two models).
3. Show your plan and requirements to the trainer: day 5, 15:15-16:30, one by one.
4. `/gse-produce`, task by task: each task on its branch, its tests run. Lightweight has no `/gse-tests` step: a minimal test strategy is generated for you.
5. At every Gate, the 3-question grid: at least one change or one refusal per activity, in the tracking sheet.
6. Every evening: `/gse-pause`, then `git push --all origin`.
7. Day 6, 11:30: first delivery with `/gse-deliver` (sheet E22).

**Done when:** Day 5, 16:30: requirements and plan validated by the trainer. Day 6, 11:30: the first delivery is on `main`.

**Mid-point:** Day 5, 12:15 — the plan is validated and the requirements are written.

**If stuck:** Your tutor window (project outside `~/ai4se`? `~/ai4se/ai4se-kit/tutor add <path>`) → the back of your orientation page, "when the agent drifts" → raise your hand. No recovery tag: the project is yours.

**Debrief:** Day 5, 16:30: what did you move to the backlog to hold the 11:30 delivery? Which Gate did you change, and why?

### Exercise — Compare Two Models (Day 5 · 09:45 · 60 min, with the plan)

*CCSET05 and CCSET10 · Exercise E21*

**Goal:** Keep the better version of your requirements, by giving the same instruction to two models.

**Steps:**

1. After `/gse-plan`, copy your project next to it, for the second model: `cp -R . ../<project>-model-b`.
2. Model A, in your project — the course model `openrouter/deepseek/deepseek-v4.1-flash`: run `/gse-reqs` and write down your answers to its questions.
3. Model B, in the copy: start `opencode`, type `/models`, pick `openrouter/minimax/minimax-m3.1-flash`, then `/gse-reqs` with the same answers.
4. Fill the grid for each model: number of requirements, testable ones (Given / When / Then), the non-functional requirement it forgot, the questions it asked, the cost (sidebar: tokens, $ spent).
5. Compare the structure, not the words. Keep the better version: if it is B, copy its `docs/sprints/sprint-01/reqs.md` over yours and ask the agent to check it against your plan.

**Done when:** The grid is filled for both models and the version you keep is noted in the tracking sheet.

**If stuck:** `/models` does not show the model? Type part of its name to filter the list. Then your tutor window → raise your hand.

**Debrief:** Which model asked the better questions? Did the cheaper run lose anything that matters? Compare the structure, not the words.

### Frequent errors

- A plan over 10 points "because each task is small" → move tasks to the backlog now, not tomorrow at 11:00.
- Running model B in your own project instead of the copy → it overwrites model A's requirements; keep the copy for B.
- Judging the models on style or length → count testable requirements and forgotten qualities instead.
- Waiting for the trainer's validation without working → keep producing; the validation comes to you between 15:15 and 16:30.

### Links

GSE-One: `§ 13.2 — Lightweight Mode`; `§ 8 — Complexity Budget`; `§ 3.6 — Engineering` (`/gse-reqs`, `/gse-produce`); `§ 3.4 — Backlog`. Glossary: Lightweight mode, complexity budget, backlog, requirement, acceptance criteria, devil's advocate.

## Deployment waves (E19)

### Key ideas

Waves of 5 learners deploy CalcApp with the trainer, at the deployment table, while the others go on with their sprint: wave 1 at 11:00, wave 2 at 11:40, wave 3 at 13:15, wave 4 at 14:00. CalcApp first, so you learn the path on an app that is known to build.

### Exercise — Deploy CalcApp (Day 5 · waves of 5 learners, 11:00-14:45 · 35-45 min per wave)

*CCSET16 · Exercise E19*

**Goal:** CalcApp online at its own address, to learn the path before your project.

**Steps:**

1. Before your wave, in `~/ai4se/calcapp` on `main`: make your own repository the one that gets deployed (`git remote rename origin starter`, then `git remote rename mine origin`), then `git push origin main`. The server builds what is on GitHub, not what is on your laptop.
2. At the deployment table, the trainer gives you the course file `.env.training`. Copy it into CalcApp as `.env`, open it and set `DEPLOY_USER=` to your learner identifier (`v` + your number in the tracking sheet, e.g. `v07`) — never your name: the address is public. `git status` must not list `.env`.
3. In opencode: `/gse-deploy`, choose Learner. It checks `.env` and your remote, then builds and starts CalcApp (1-3 min). A warning about uncommitted `.gse/` files only: accept it.
4. Open the address it gives (`https://calcapp-<identifier>.<course domain>`) and do one calculation.
5. `/gse-deploy --logs`: find your own visit in the log, then the other lines — who else is calling your app?
6. Write your address in the tracking sheet.

**Done when:** CalcApp answers at its HTTPS address, you found your own visit in its logs, and the address is in the tracking sheet.

**If stuck:** The build failed? Run `npm run test:run && npm run build` on your laptop: the server runs the same steps. Fix, push, run `/gse-deploy` again (it reuses your app). A 503 page: the container is starting, wait one minute. Then the trainer, at the deployment table.

**Debrief:** At 16:30, debrief of cycle 16: what got stuck, where you read your logs, and what the robots in your log were looking for.

## References

Forsgren, Humble, Kim (2018), *Accelerate*. · Humble, Farley (2010), *Continuous Delivery*. · Meli, McNiece, Reaves (2019), *How Bad Can It Git? Characterizing Secret Leakage in Public GitHub Repositories*, NDSS. · Merkel (2014), *Docker: Lightweight Linux Containers for Consistent Development and Deployment*, Linux Journal. · Wiggins (2011), *The Twelve-Factor App*, 12factor.net.
