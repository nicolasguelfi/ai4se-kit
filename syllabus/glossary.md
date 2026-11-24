# Glossary — AI4SE (edition 2)

The course vocabulary, in alphabetical order. **HDnn** = the half-day where the term is
taught (see [programme](00-programme.md)). For GSE-One terms, the full definition is in
`~/ai4se/gensem/gse-one-spec.md` § 16 — Glossary (see [gse-guide](gse-guide.md)).
GSE-One commands are written in their opencode form (`/gse-go`).

---

**Acceptance criteria** — Observable conditions, often written Given / When / Then, that say
when a requirement is met; they become validation tests. *HD03, HD06.*

**Advisor ticket** — Advice the trainer (or another external expert) leaves on your project as a
GitHub issue labelled `gse-advisor`, without touching your files. When you open your next sprint,
`/gse-plan` shows them: you accept, keep in the pool, or decline with a reason; the decision is yours. *HD06.*

**Agent (coding agent)** — A program that loops: the model proposes an action, a tool runs it
(read a file, edit, run a command), the result goes back to the model. opencode is one. *HD01.*

**AGENTS.md** — A file at the project root with standing instructions the agent reads at
every session (conventions, commands, rules). `/init` drafts one. *HD03.*

**AI Act** — The EU regulation on artificial intelligence: obligations depend on the risk
category of the system. Applied to your own project on day 6. *HD01, HD11.*

**Artefact** — Any project deliverable: code, requirements, design, tests, docs, notes.
In GSE-One, "artefacts are everything" (P3): what is not written down does not exist. *HD05.*

**ATDD (acceptance-test-driven development)** — Each requirement's acceptance criteria
(Given / When / Then) become tests written and seen failing before the code; the step is a
feature, not a tiny behaviour. GSE-One's default for code tasks (`testing.strategy`). *HD03, HD07.*

**Auto / Inform / Gate** — GSE-One's three decision tiers: the agent decides silently
(Auto), decides and tells you in one line (Inform), or must wait for your validation (Gate).
*HD05, HD06.*

**Backlog** — The single list of all work items (TASK-NNN), either in the *pool* (not
planned) or in a sprint. `/gse-backlog`, file `.gse/backlog.yaml`. *HD06.*

**Backup tag** — A git tag `gse-backup/…` that GSE-One creates before a risky operation
(merge, branch deletion) so you can restore the previous state. *HD08; see recovery.md.*

**Branch** — A separate line of commits. Rule of the course: one branch per feature or
task, never commit directly on `main`. *HD03.*

**Build agent / Plan agent** — opencode's two default agents: *plan* reads and proposes
without editing; *build* edits files and runs commands. Switch with Shift+Tab. *HD03.*

**Checkpoint** — A snapshot of where you are in GSE-One (sprint, activity, pending work),
saved by `/gse-pause` in `.gse/checkpoints/` and reloaded by `/gse-resume`. *HD08.*

**CI (continuous integration)** — Automatic build, lint and tests on every push (e.g.
GitHub Actions); gives a green/red signal that does not depend on the agent's word. *HD07.*

**Commit** — A save point of your files in git, with a message. You can always come back
to it. *HD02, HD03.*

**Complexity budget** — The number of points a sprint can absorb (1 point ≈ one hour of
work for the AI + you pair). A sprint ends when the budget is used or tasks are delivered. *HD06.*

**Compound** — End-of-sprint capitalization (`/gse-compound`) on three axes: Axe 1 project
learnings, Axe 2 feedback on the method, Axe 3 your competencies. *HD08.*

**Confidence level** — The tag GSE-One puts on a claim: Verified, High, Moderate or Low.
A low-confidence claim on a critical point becomes a Gate. *HD07.*

**Container / image** — An *image* is a frozen package of the app with everything it needs
to run (system, runtime, built code); a *container* is one running copy of an image,
isolated and disposable. Built from a Dockerfile. *HD09.*

**Context (context window)** — Everything the model sees in one request: your prompt,
files, tool results, history. It is limited and costs tokens. *HD01, HD03.*

**Context7** — An MCP server that gives the agent up-to-date library documentation;
added with `opencode mcp add`, under `mcp.servers` in `opencode.json`. *HD03.*

**DEC-NNN (decision)** — A recorded decision with context, options, choice and
consequences, kept in `.gse/decisions.md`. *HD06.*

**Deliver** — `/gse-deliver`: merge the reviewed work, tag a release, write release notes,
clean up branches; it closes the sprint. *HD08, HD11.*

**Demo tag** — `demo`: the git tag on the delivered commit you present in the gallery
(day 6, 11:30; a tag, not a commit). *HD11, HD12.*

**Deployment** — Making the app run on a server with a public address. In the course:
a Dockerfile in the starter, guided waves of 5 learners. *HD09.*

**DES-NNN (design element)** — An architecture or design decision traced to requirements,
in `docs/sprints/sprint-NN/design.md`. *HD06.*

**Devil's advocate** — A review perspective where the agent challenges its own work:
hallucinated libraries, unverified claims, missing alternatives (P16). *HD07.*

**Diff** — The line-by-line difference between two states (`git diff`). What you review
before committing and what an AI review should look at. *HD03, HD04.*

**Dockerfile** — A recipe to build a container image of the app (install, build, run).
The CalcApp starter ships a tested one; `/gse-deploy` writes one only if it is missing. *HD09.*

**Empty stub** — Code that looks finished but does nothing (placeholder, `TODO`, fake
data). Hunted on day 6 before the demo. *HD11.*

**Environment variable** — A named value a program reads from its environment when it
starts (`PORT`, an API key): how the same image gets a different configuration on each
machine. *HD09.*

**FR / NFR** — Functional requirement (what the system does) / non-functional requirement
(a quality: performance, accessibility, security…). *HD06.*

**FreeSelfApp** — The day-1 workshop: a small personal web app built by prompting only,
to feel vibe coding first-hand. *HD02.*

**Freeze** — On day 6 at noon: no more change to the app's code; only rehearse the demo.
Not to be confused with GSE-One's *sprint freeze*. *HD11.*

**Full / Lightweight / Micro (modes)** — GSE-One's three ceremony levels. Full: the whole
lifecycle (CalcApp). Lightweight: PLAN → REQS → PRODUCE → DELIVER (mini-project). Micro:
throw-away scripts (not used). Chosen at a Gate after `/gse-go`. *HD05, HD08.*

**Gallery** — The day-6 demos: half of the room presents at their laptop (5-7 minutes,
imposed structure), the other half visits with a 3-question grid; then swap. *HD12.*

**Gate** — A decision the agent may not take for you: it shows options and consequences
and waits. Before approving, ask: Do I understand it? What do I lose if it is wrong?
Would I have chosen differently? If in doubt, choose *Discuss*. *HD05.*

**gh** — GitHub's command-line tool; `gh auth login` connects your machine to your
GitHub account. *HD02.*

**git** — The version control system used from day 2 as a safety net. *HD03.*

**GSE-One** — "Generative Software Engineering One": the methodology plugin (v0.93.3 in
the course) that turns the coding agent into an orchestrator of a structured lifecycle
with 24 commands. *HD04 (bridge), HD05.*

**Guardrail** — A protection against risky actions, at three levels: Soft (warns), Hard
(blocks until you justify), Emergency (halts until you acknowledge the risk). Example:
commit on `main` is blocked. *HD06.*

**Hallucination** — A confident but false output: an invented function, library, API or
fact. Check before trusting. *HD01, HD07.*

**Health check** — An address the platform calls regularly to know a container is alive.
Healthy does not mean the right version is live. *HD09.*

**Health score** — GSE-One's 0-10 quality indicator (8 dimensions in Full mode, 3 in
Lightweight). `/gse-health`. *HD05, HD08.*

**HIGH / MEDIUM / LOW** — The severity scale of review findings, used by hand on day 2 and
by GSE-One's `/gse-review`. CRITICAL exists only by escalation of a false "Verified"
claim. *HD04, HD07.*

**HUG** — GSE-One's profiling activity (`/gse-hug`, run by `/gse-go` the first time): your
expertise, language, verbosity, decision involvement… so the agent adapts. *HD05.*

**Integrity check (minimal)** — In Lightweight mode, the check `/gse-deliver` runs before
merging (devil's advocate, at most 5 findings); a HIGH finding stops the merge until you
decide. *HD08, HD11.*

**Issue (GitHub)** — A ticket on a repository. Course feedback: issues on
`nicolasguelfi/gensem` with label `ai4se-ed2` — public, never confidential. *HD01.*

**Known limits** — The README section that lists what does not work yet, written in the
last task of the sprint (day 6, from 11:00). *HD11.*

**LC00-LC03** — GSE-One's lifecycle phases: LC00 onboarding, LC01 discovery & planning,
LC02 development sprint, LC03 capitalization. *HD05.*

**Licence** — The terms under which code may be used, changed and shared (MIT,
Apache-2.0, GPL…): your repository's and your dependencies'. *HD11.*

**LLM (large language model)** — A model trained to predict the next token of text; the
engine inside every coding agent. *HD01.*

**Lint** — Static checks of code style and likely bugs, run by a tool (e.g. ESLint). *HD07.*

**Logs** — What a program wrote while it ran. *Build log*: while the image is built;
*runtime log*: while the container runs. Read for the first error. *HD09, HD10.*

**MCP (Model Context Protocol)** — A standard to plug external tools and data sources into
an agent. *HD01, HD03.*

**Merge** — Bringing the commits of one branch into another. In GSE-One, a merge into
`main` is a Gate. *HD04, HD08.*

**Milestone** — A fixed time with a result you can check: the project card (day 4), plan
and requirements validated (day 5, 16:30), first delivery (day 6, 11:30). *HD08, HD10.*

**Mini-project** — Your own small professional project (one user, one problem, 2-4
requirements), framed on one page, run in Lightweight mode, delivered and demonstrated
on day 6. *HD08-HD12.*

**Model key** — Your personal, capped credential to call the model provider. It is a
secret: stored by `opencode auth login`, never in a file, prompt or issue. *HD02.*

**Monday-morning plan** — The first concrete thing you will do differently at work, when,
and how you will know it worked. *HD12.*

**Mutant test** — Deliberately break the code: if no test fails, your tests do not protect
that behaviour. *HD03.*

**No memory** — The model forgets everything between sessions; files and git are the
memory. That is why GSE-One writes `.gse/` and why you commit often. *HD01.*

**opencode** — The open-source terminal coding agent used in the course (version 2). *HD01, HD02.*

**opencode.json** — opencode's configuration file (model, MCP servers, permissions). *HD03.*

**Orientation page** — The printed page of days 3-6: front "where am I?", back "when the
agent goes off track" (the 6 steps in recovery.md). *HD05.*

**Permissions** — What the agent may do without asking (edit, run commands, access
folders). Give the least needed. *HD01, HD03.*

**Personal data** — Any information about an identifiable person (name, e-mail, health…).
Keep the fewest, say why and for how long (GDPR); demo with made-up data. *HD11.*

**Plan (`docs/plan.md`, `plan.yaml`)** — Day 2: your hand-written list of 5-8 atomic tasks.
Days 3-6: GSE-One's living sprint plan in `.gse/plan.yaml` (`/gse-plan`). *HD03, HD06.*

**Preview** — `/gse-preview`: see what will be built before building it (description or
minimal scaffold). *HD06.*

**Principles P1-P16** — The 16 rules behind GSE-One (e.g. P4 Human-in-the-Loop, P7 Risk
Classification, P12 Version Control, P16 Adversarial Review). *HD05.*

**Produce** — `/gse-produce`: implement a task on its own feature branch and worktree,
starting from its failing acceptance test (setting `testing.strategy`), then run the tests. *HD07.*

**Project card** — The page that frames the mini-project (day 4, `docs/project.md`), then
the top of its README: pitch, how to run it, live address, known limits (day 6).
*HD08, HD11.*

**Prompt** — What you send to the model. Never put keys, passwords, personal or client
data in a prompt. *HD01.*

**Recovery tag** — A tag of the public CalcApp starter (`j2-start`, `j2-part1`, `j2-v0.1`,
`p3-start`, …) to restart an exercise from a known state in a new folder. *HD03; see recovery.md.*

**REQ-NNN (requirement)** — A requirement with testable acceptance criteria, in
`docs/sprints/sprint-NN/reqs.md`. No production without one (Full and Lightweight). *HD06.*

**Review** — Critical reading of a change. Day 2: AI review of your diff, triaged by hand.
GSE-One: `/gse-review`, several perspectives, findings in `review.md`. *HD04, HD07.*

**Rollback** — Going back to the last version that worked (a tag, the previous image) when
a deployment breaks: roll back first, debug after. *HD09.*

**RVW-NNN (review finding)** — One finding of a GSE-One review, with a perspective and a
severity. *HD07.*

**Secret** — A key, password or token. Never in the code or in git (`.env` ignored,
`.env.example` committed); a leaked secret is revoked, not just deleted. *HD02, HD09,
HD11.*

**Spike** — A short throw-away experiment to answer a technical question
(`/gse-task --spike`, max 3 points); produces a DEC, the code is not kept. *HD08.*

**Sprint** — A GSE-One work cycle bounded by a complexity budget, not by the calendar.
*HD05, HD06.*

**Sprint freeze** — Once a sprint is delivered it is closed: new work opens the next
sprint (GSE-One proposes "Start next sprint now"). *HD08.*

**Starter** — The public repository `nicolasguelfi/calcapp-starter`: the CalcApp code base
with its recovery tags. *HD03.*

**Tag** — A permanent name on a commit (`v0.1`, `j2-start`). *HD04.*

**TASK-NNN** — One work item of the GSE-One backlog, tracked from idea to delivery. *HD06.*

**TDD (test-driven development)** — Write a failing unit test first (red), make it pass (green),
then clean up, in many tiny steps. With an AI: you decide or review the test, the agent writes the code.
GSE-One applies the same idea at the level of acceptance tests: see ATDD. *HD03.*

**Token** — The unit of text a model reads and writes; every token sent and received
costs money. *HD01.*

**Traceability** — Links between artefacts: requirement → design → test → code (P6). *HD06.*

**TST-NNN (test)** — A test definition traced to a requirement or a design element. *HD07.*

**Tutor window** — A second terminal running the course tutor (`~/ai4se/ai4se-kit/tutor`):
an AI prepared by the trainer, read-only, which answers from the syllabus and GSE-One and
tells you when to call the trainer. Stuck? → tutor window → recovery tag → raise your hand. *HD02.*

**Verification / Validation** — Verification: "did we build it right?" (traced to design).
Validation: "did we build the right thing?" (traced to requirements). *HD07.*

**Vibe coding / Vibe engineering** — Vibe coding: accept AI-generated code without
reading it. Vibe engineering: the same tools with plans, tests, reviews and git. *HD01.*

**Worktree** — A separate working folder for one git branch (`.worktrees/…`), so GSE-One
can work on a task without touching your other work. *HD07.*
