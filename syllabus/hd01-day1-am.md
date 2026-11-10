# HD01 — Day 1 morning: Generative AI, from LLM to AI agent, VibeCoding → VibeEngineering

*AI for Software Engineering (AI4SE), edition 2 — Thursday 26 November 2026, 09:00-12:15.*
*Content licensed CC BY 4.0. Slide decks: "GenAI fundamentals" and "Discovering VibeCoding & VibeEngineering".*

The tutor window does not exist yet this morning (it is installed at 13:15, see hd02 § Installation in the room). This sheet is what you read afterwards, or when you ask the tutor about a morning notion.

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 09:00 | 30 | Welcome and how we work |
| 09:30 | 15 | What you will be able to do |
| 09:45 | 50 | Generative AI fundamentals · From LLM to AI agent · The model has no memory · Model families, your key, tokens |
| 10:35 | 15 | Break |
| 10:50 | 45 | VibeCoding (acts I-II) · VibeEngineering (act III) |
| 11:35 | 40 | Tools: opencode and the others (act IV) · EU AI Act and rules for this week |
| 12:15 | 60 | Lunch |

## Learning goals

At the end of this half-day you can:

1. Explain in two sentences how an LLM produces text (next-token prediction) and why that makes it fallible.
2. Explain the ladder *model → + documents → + tools → AI agent*, and say what opencode is on that ladder.
3. Explain why the model has no memory between requests, and where continuity must live (files and git).
4. Say what your course key gives you, why tokens cost money, and which habits keep the bill small.
5. Define VibeCoding, give three evidence-based dangers, and name the six VibeEngineering principles.
6. Apply the "rules for this week": what never goes into a prompt, what permissions to give an agent.

## Welcome and how we work

### Key ideas

The course starts with a round table (first name, main activities, motivation, past experience with AI, VibeCoding, software engineering) and a show-of-hands question: *how much AI do developers already use?* The slide answer, "You're not alone": **76 %** of developers use or plan to use AI tools (Stack Overflow Developer Survey **2024**; the slide's citation is labelled 2026 but points to the 2024 survey) and **90 %** will use AI code assistants **by 2028** (Gartner press release, 1 July 2025). The slide also shows 63 % "use AI tools daily" and 82 % "regularly use AI for coding": these two figures are not confirmed in the trainer's source sheet — treat them as indicative.

How we work this week:

- **Practice first.** A demo never lasts more than 10 minutes; then you do it. Every exercise says when you are *done* with something you can see, for example "`npm test` shows 3 passing tests".
- **Lost? Ask your tutor window.** It is an AI assistant prepared by the trainer, *not the trainer*. It reads your project, never changes it, and tells you when to call the trainer. Order when stuck: your tutor window → the recovery tag of the exercise → raise your hand.
- **Feedback any time** as a GitHub issue on `nicolasguelfi/gensem` with the label `ai4se-ed2`. The repository is **public**: nothing confidential — no key, no client code. Typos, unclear slides, GSE-One bugs: one issue each; they are fixed during the course.
- **Daily buffer.** The last slot of each day is kept free: catch up, ask, finish the exercise.
- **Hands-up quiz** at the end of each day. No grades — it tells us what to revisit.

**Every topic is a cycle.** The week is built of 16 cycles, CCSET01 to CCSET16. Each runs the same four steps: *theory* (the problem, and the solutions known in research and in practice) → *how GSE-One solves it* (one slide, concept only) → *exercise* (on a sheet: goal, steps, done when, if stuck) → *debrief*. On days 1-2 you work by hand with opencode; from day 3 you use GSE-One.

| Day | Cycles |
|---|---|
| 1 (by hand) | 01 Generative AI · 02 VibeCoding → VibeEngineering · 03 Tools, AI Act |
| 2 (by hand) | 04 Git · 05 Driving an agent · 06 Planning · 07 Tests · 08 Review, delivery |
| 3 (GSE-One) | 09 SE concepts, your GenSEM · 10 Requirements elicitation · 11 Non-functional requirements · 12 Verification & validation |
| 4 (GSE-One) | 13 Measuring quality · 14 Delivery, capitalisation · 15 Framing a project |
| 5 (GSE-One) | 16 Deployment |

Days 5-6: your mini-project uses all sixteen. The exercise of this morning's cycles 01-03 is this afternoon's FreeSelfApp.

### Links

Glossary: tutor window, recovery tag, GitHub issue. Course overview: `syllabus/00-programme.md`.

## What you will be able to do

### Key ideas

The course promises six **abilities** you can check at the end of day 6 — not topics:

| Days | Ability | What it looks like |
|---|---|---|
| 1-2 | Drive a coding agent with discipline | give a precise task, read its plan, approve or refuse each action |
| 2 | Plan, build, test and review a small app with an AI agent | CalcApp v0.1: your plan, your tests, an AI review you triage |
| 2 → | Use git as your safety net | commit, branch, compare, go back to a known-good tag |
| 3-4 | Run a structured AI-assisted lifecycle with GSE-One | requirements → plan → build → review → deliver, on CalcApp |
| 4 | Measure quality instead of trusting the agent's word | lint, tests and CI give a green/red signal you can check |
| 5-6 | Ship and present a mini-project | scope, milestones, deployment, gallery demo |

**Cursor vs opencode.** The published programme mentions Cursor. This edition uses **opencode**: open source, provider-agnostic, in the terminal. The concepts (agent loop, plan, permissions, context files) are the same in every coding agent, so the skills transfer.

The 6-day journey: days 1-2 GenAI foundations, LLM → AI agent, VibeEngineering, setup in the room, first prototype, git first, driving opencode on CalcApp, CalcApp v0.1, AI code review, bridge to GSE-One; days 3-4 GSE-One on CalcApp (requirements, plan, build, review) and measuring quality (lint, tests, CI); days 5-6 mini-project (scope, milestones, build, deployment), applied ethics, gallery demo and closure.

## Generative AI fundamentals

### Key ideas

**Artificial intelligence.** Turing (1950) asked "Can machines think?"; McCarthy (1955) defined AI as "the science and engineering of making intelligent machines"; Minsky (1968) as "the science of making machines do things that would require intelligence if done by men".

**Discriminative vs generative.** A *discriminative* model learns to distinguish categories: it estimates P(y | x), the probability of a class y given an input x (spam detection, image classification, sentiment). A *generative* model learns to produce new data: it estimates P(next | context), the probability of the next token given the previous ones (code generation, text, images). Key insight: both classify, but generative AI classifies over language itself — predicting the next token across the whole vocabulary, again and again, turns prediction into creation.

**Four eras.** 1956 symbolic AI (hand-written if-then rules, expert systems; rigid, poor with exceptions). 1990s machine learning (algorithms learn from examples; supervised, unsupervised, reinforcement; classical methods need manual feature engineering). 2010s deep learning (neural networks learn features from raw data, enabled by ReLU, GPUs, massive datasets, embeddings; breakthrough: the Transformer, Vaswani et al., 2017). 2022+ generative AI (billions of parameters, internet-scale data; ChatGPT reached about 100 million users in 2 months — an estimate by UBS/Similarweb reported by Reuters, February 2023). Timeline on the slide: GPT-3 (2020) → ChatGPT (2022) → coding agents (2026).

**For software engineers** GenAI produces source code in dozens of languages, documentation (explanations, specs, commit messages), tests (cases, data, edge cases) and architecture suggestions. The landscape: chat (ChatGPT, Claude, Gemini), code (GitHub Copilot, Cursor, Claude Code, opencode), image (Midjourney, Stable Diffusion, ChatGPT and Gemini images), enterprise (Microsoft 365 Copilot, Gemini in Google Workspace). Providers differ (OpenAI: multimodal, broad knowledge; Anthropic: careful reasoning, long context, code review; Google: ecosystem integration, multimodal native) — and this landscape changes fast. The benchmark slides show Artificial Analysis leaderboards (intelligence index, token usage, cost, score vs release date) as a **snapshot of April 2026**; rankings change every month (artificialanalysis.ai). Token usage distinguishes *input* tokens (everything re-sent at each turn of the agent loop), *reasoning* tokens (hidden thinking) and *output* tokens (the visible answer and tool calls).

**How an LLM generates text (summary of the transformer slides).** An LLM is a next-token prediction engine: given all preceding tokens, it predicts the most plausible continuation. Pipeline: *input → tokenization → embeddings → attention → prediction*. *Tokenization* cuts text into sub-word pieces of 3-4 characters ("developer" → "_develop" + "er"), each a number; a vocabulary holds 30,000-100,000 tokens. *Embeddings* turn each token into a vector (4,096-12,288 dimensions) where similar meanings are close ("function" near "method"). *Self-attention*, the Transformer's key innovation, lets every token weigh every other one in parallel ("river" disambiguates "bank"), over dozens of layers. *Prediction* gives a probability over the whole vocabulary; generation is *autoregressive* (predict → append → repeat), so time and cost grow with length. The *context window* is the working memory — 2,048-4,096 tokens for early models, 128,000 to 10 million today — but bigger is not perfect: in the MRCR "8 needles" benchmark (OpenAI-MRCR; Context Arena data, snapshot April 2026) 8 near-identical requests are hidden in a long conversation and the model must return the i-th one; scores drop as the context grows towards 1 million tokens.

Interactive demo shown in class: https://poloclub.github.io/transformer-explainer/

**How LLMs are built.** Phase 1 pre-training (trillions of tokens from the internet, books, code; thousands of GPUs for weeks → a base model). Phase 2 fine-tuning (curated instruction-response pairs; smaller, targeted). Phase 3 alignment (RLHF: humans rank outputs and a reward model steers the LLM towards Helpful, Harmless, Honest; RLAIF / Constitutional AI: principle-based self-critique).

**Can / cannot.** GenAI can generate code, write and summarise, analyse data, create images, reason and plan in several steps. It cannot guarantee truth (hallucinations are real), replace judgment, access real-time data (training cutoff), understand deeply (pattern matching, not comprehension) or be deterministic (same prompt, different outputs). **Ethics**: bias (models reflect their data), privacy (sensitive data in prompts leaks), copyright (who owns AI output?), transparency (disclose AI use).

## From LLM to AI agent

### Key ideas

A four-step ladder, each step with its trap:

1. **The model alone** writes the most likely continuation of a text. It looks nothing up and checks nothing. *Trap: plausible is not checked.*
2. **+ documents**: it sees only what is put in its context — your question, the conversation, the files given. *Trap: the right passage is missing or outdated.*
3. **+ tools**: the model asks, a program executes (read a file, run a test) and the result comes back. *Trap: "I checked" with no trace of a tool call.*
4. **AI agent**: it chooses its next action itself, in a loop — act, check, choose — until the goal, inside a folder you authorise. *Trap: too wide a folder; not reading its plan.*

An **AI agent = a model + context + tools + a loop**. It decides the next step; nobody wrote the list of steps in advance (sources on the slide: Zaharia et al. 2024, compound AI systems; Anthropic 2024, building effective agents; Willison 2025, "runs tools in a loop to achieve a goal"). In this course we say "AI agent", never "agent" alone for a person.

**opencode is step 4, in your terminal**: it reads files, runs commands (e.g. the tests), edits code — and asks your permission (allow / ask / deny) before acting, inside the project folder. The AI does the long work, action after action; **you keep** the instruction, the plan review, and the move that matters.

### Frequent errors

- Believing an agent's "I ran the tests" without seeing the command and its output.
- Starting opencode in your home folder: the authorised folder is then your whole disk.

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § 1.1 — Coding Agents and Plugin Architecture`; `§ P4 — Human-in-the-Loop by Default`; `§ P15 — Agent Fallibility (Self-Awareness)`. Glossary: LLM, token, context, tool call, AI agent, permission.

## The model has no memory

### Key ideas

**What really happens**: every request **re-sends the whole context** — instructions, conversation, files read so far. The model **learns nothing** from you between requests. A new session is a blank page.

**Continuity lives in files**: `AGENTS.md` (project rules, read at each session), `docs/plan.md` (your plan, task by task), `.gse/` (GSE-One state: where the project is) and the **git history** (what changed, when, and why). This is why day 2 starts with git and `AGENTS.md`, and why GSE-One keeps its state in `.gse/`.

**While the agent works**: read its plan before you approve; prepare the next check (which test, what to look at); don't type over it — one instruction at a time; review the diff (`git diff`) before you commit.

> If it is not in a file or in git, the next session does not know it.

Question asked in the room: "Your session crashed. What does the agent still know?" — Only what is on disk.

### How GSE-One solves it (CCSET01, concept only)

*The problem:* the model has no memory: every new session starts from zero, and a long session overflows the context window.

- The project memory is written in files, in the `.gse/` folder: status, plan, decisions, backlog.
- Every new session reads them back and continues where you stopped.
- A profile (`profile.yaml`) tells the agent who you are and how to talk to you.
- These files are committed with the code: the memory travels with the project, not with the chat.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `§ P3 — Artefacts Are Everything`; `§ 12.4 — Status State File`. Glossary: session, AGENTS.md, `.gse/`.

## Model families, your key, tokens

### Key ideas

**Four model families** (as of November 2026 — names change fast, families do not):

- *US closed models* — OpenAI GPT, Anthropic Claude, Google Gemini. Often at the top of coding benchmarks; API only, weights not published.
- *Open-weight models* — Meta Llama, Google Gemma, OpenAI gpt-oss, Qwen… Weights downloadable: run them yourself (locally, on your server) or through a provider.
- *Mistral, European* — Mistral Large 3 (Dec 2025), Mistral Medium… EU-based provider, many open-weight models.
- *Chinese models* — DeepSeek V4 (Apr 2026), Qwen (Alibaba), Kimi (Moonshot)… Often open-weight and cheap per token; check where your data is processed.

Same agent, different model ⇒ different quality, speed, price and data location. opencode is provider-agnostic, so the choice is one configuration line. This week: one **reference model** chosen by the trainer (named on your key sheet), plus a backup.

**What your key gives you**: one **capped budget** (when it is spent, calls stop), one reference model, and a **secret** — never in a prompt, a commit or an issue.

**Tokens = cost.** The model reads tokens: « Luxem|bourg| is| a| ____ » — fragments, not words, each one a number (the split is illustrative; each model has its own tokenizer). Rule of thumb: **1 token ≈ 4 characters ≈ ¾ of a word**. You pay for every token sent and received, and an agent re-sends the context at every turn, so cost grows with *context size × number of turns*. Back of the envelope: a long agent session re-sending 50k tokens × 40 turns = **2 million input tokens**. Habits: short sessions, one task each, a short `AGENTS.md`, and point to the files needed (`@file`) instead of the whole repository.

### Frequent errors

- One endless session for the whole day: the context (and the bill) keeps growing.
- Pasting the key into a chat "to check it works".

## VibeCoding

### Key ideas

Two warm-up questions: *How much of your code is AI-generated today (0-100 %)?* and *Do you review AI-generated code (never ↔ always)?* Your answers will change by the end of the training.

**Origin.** Karpathy: "The hottest new programming language is English" (24 January 2023). Then, on 2 February 2025: "There's a new kind of coding I call 'vibe coding', where you fully give in to the vibes (…) and forget that the code even exists. (…) I just see stuff, say stuff, run stuff, and copy paste stuff, and it mostly works." Collins English Dictionary made "vibe coding" its Word of the Year 2025 (6 November 2025).

**Definition.** VibeCoding is a practice where developers describe tasks to LLMs, accept generated code **without closely reviewing** its internal structure, and rely on results and follow-up prompts to guide changes. Kitchen metaphor: in traditional software engineering you are the *cook*; in VibeCoding you become the *customer* — you describe the dish, the kitchen prepares it, you taste. What stays: you are still responsible for the result ("you order the dish — but you serve it to your guests").

**Four principles**: (1) *intent over implementation* — describe WHAT, not HOW; (2) *trust in output* — if it works, good enough; the code is not read; (3) *conversational iteration* — bug? describe the symptom, the AI fixes it; (4) *low barrier to entry* — anyone with an idea can build a prototype. **Analogy**: in the 1960s compilers replaced assembly and became a trusted intermediary. But compilers are *deterministic* (same input, same output) while LLMs are *stochastic* (same prompt, different and sometimes wrong code). You can trust a compiler blindly; can you trust an LLM? This afternoon (FreeSelfApp) you practise pure VibeCoding with opencode.

**Act II — the reality check** ("it works… but at what cost?"):

- **Security.** 45 % of AI-generated code samples failed security tests (OWASP Top 10 flaws), 100+ LLMs on Java, Python, C#, JavaScript (Veracode, *2025 GenAI Code Security Report*, July 2025). At least 62 % of 331,000 AI-generated C programs are vulnerable, proven with the ESBMC model checker (Tihanyi et al., FormAI-v2, 2024).
- **Phantom packages.** 5.2 % (commercial models: GPT-3.5, GPT-4, GPT-4 Turbo) to 21.7 % (open-source models: CodeLlama, DeepSeek Coder…) of packages in LLM-generated code do not exist — 576,000 Python and JavaScript samples, 16 LLMs, 205,474 unique hallucinated names (Spracklen et al., USENIX Security 2025). Attackers register these names on PyPI/npm with malicious code: a supply-chain attack.
- **Technical debt (the iceberg).** You see a working prototype; hidden below: unmaintainable code, missing error handling, no tests, brittle architecture. On 211 million changed lines 2020-2024, refactored code fell from 25 % to under 10 % and copy/paste rose from 8.3 % to 12.3 % — copy/paste now exceeds refactoring (GitClear, *AI Copilot Code Quality: 2025 Research*).
- **The AI paradox.** 7 hours per week per team member lost to inefficient processes; 3,266 DevSecOps professionals surveyed (Harris Poll for GitLab, 10 November 2025); 60 % use more than 5 development tools, 49 % more than 5 AI tools. Faster coding creates new bottlenecks (reviewing AI output, debugging hallucinations, integration).
- **The METR paradox.** Randomised controlled trial (METR, 10 July 2025): 16 experienced developers, 246 real issues on mature repositories they knew (5 years on average), Cursor Pro with Claude 3.5/3.7 Sonnet. Tasks took **19 % longer** with AI (95 % CI +2 % to +39 %). They forecast a 24 % speed-up and still believed afterwards they had been 20 % faster; they accepted fewer than 44 % of generations. Update of 24 February 2026: with late-2025 tools, returning developers −18 % time (CI −38 % to +9 %, not significant); METR says a speed-up is now likely but cannot be measured reliably.
- **The trust crisis.** 33 % of developers trust the accuracy of AI output in 2025 (43 % in 2024) while use rose from 76 % to 84 %; 46 % distrust it (31 % in 2024); top frustration (66 %): solutions "almost right, but not quite"; 45 %: debugging AI code takes longer (Stack Overflow Developer Survey 2025). The 2026 survey (6 October 2026) reworded the question: 48 % trust AI output only when they can easily verify it. *Adoption is rising, trust is falling: verify before you trust.*
- **Demo vs production.** The demo works; production requires security, scalability, maintainability, monitoring, error handling, edge cases, compliance. That gap is where engineering lives.
- **What can be delegated?** Anthropic's internal study (2 December 2025): 132 engineers and researchers self-report using Claude in about 60 % of their work but can fully delegate only 0-20 % (self-reported, AI-lab staff: an upper bound). Bain *Technology Report 2025* (23 September 2025): 10-15 % productivity gain with assistants alone, 25-30 % with end-to-end process redesign, because writing and testing code is only ~25-35 % of the time from idea to launch.

VibeCoding has its place (personal prototypes, throwaway demos, learning) — not for production, enterprise, regulated environments or shared code. *A gala dinner for 200 guests with dietary requirements and press: would you cook the same way?*

## VibeEngineering

### Key ideas

The bridge question: **speed AND quality?** Kent Beck drew the line: "vibe coding" is when you don't read the code; engineering is when you **own** every decision. Karpathy's term has been evolving towards "agentic engineering" — AI agents executing, humans steering.

**Six principles of VibeEngineering:**

1. **Requirements before prompts** — functional and non-functional requirements are explicitly defined *before* engaging the AI agent (the client's order before the kitchen starts).
2. **Test-driven generation** — tests defined BEFORE implementation; tests define the *contract*, the AI generates code that must pass (taste at every step).
3. **Architectural intent** — design decisions (patterns, components, boundaries) before generation; context files communicate them to the AI (the slide cites `.cursorrules` and `CLAUDE.md`; in opencode this file is `AGENTS.md`).
4. **Iterative refinement** — planned iterations with scope, acceptance criteria and review gates; each cycle delivers a validated increment, not "everything at once".
5. **Human review at boundaries** — architectural decisions, security-critical code, integration points, validation results: quality control at critical checkpoints, not on every line.
6. **Context engineering** — systematically managing what the agent sees: structured project rules, memory, tool configurations (MCP servers) — "the agent sees what you curate".

**The spectrum**: naive VibeCoding (no requirements, tests or review — personal prototypes only); guided (informal requirements, manual evaluation — internal tools); structured (written requirements, some tests, review of critical paths — team projects); VibeEngineering (full requirements, test-driven generation, architecture, CI/CD, systematic review — production).

**Evidence.** Agents that follow a process (Scrum, FlowGen on GPT-3.5) reach a **15 %** higher benchmark pass rate (Pass@1), and design plus code review also cut code smells (Lin et al., SOEN-101, 2024). Copilot: **−55.8 %** time on a simple lab task, an HTTP server (Peng et al., 2023), versus **+19 %** time on real repository issues (METR 2025) — the difference is complexity *and* discipline. Experience gap: +27-39 % for short-tenure developers vs +8-13 % for long-tenure ones, 4,867 developers in 3 field experiments (Cui et al., 2025 version); subgroup estimates are noisy. AI compensates for missing experience but cannot replace expert judgment.

Tomorrow (day 2) you redo the work with discipline on CalcApp v0.1 and compare: quality, confidence, speed, trade-off.

### How GSE-One solves it (CCSET02, concept only)

*The problem:* vibe coding hands every decision to the agent: insecure code, hallucinated packages, technical debt, found out too late.

- Each decision is classified: **Auto** (the agent acts), **Inform** (it acts and tells you) or **Gate** (it stops and waits for you).
- Risky decisions are always Gates: the agent shows the options and their consequences, you choose.
- Guardrails block dangerous actions before they happen.
- The six VibeEngineering principles become the steps of one lifecycle: requirements, design, tests, production, review, delivery.

*Concept only — you use GSE-One from day 3.*

### Links

GSE-One: `§ 1.2 — Agile Software Engineering Foundations`; `§ P16 — Adversarial Self-Review and User Pushback`. Glossary: VibeCoding, VibeEngineering, TDD, acceptance criterion.

## Tools: opencode and the others

### Key ideas

**Autonomy spectrum**: passive assistance (responds when invoked) → proactive copiloting (suggests, you decide) → task-level delegation (you describe, AI executes) → autonomous agents (AI plans, executes, tests, iterates) → multi-agent orchestration. *The agentic turn*: opencode (plan, build, subagents), Claude Code (subagents, background tasks), GitHub Copilot (issue → pull request), Cursor (IDE, CLI and cloud agents). It plans, edits, runs; you frame and review.

**opencode, our tool**: a terminal agent, open source (MIT), any model provider (this week: your capped key), two built-in agents *plan* and *build* (Tab to switch), project rules in `AGENTS.md` (`/init` drafts it), permissions and MCP servers in `opencode.json`. A first session, as shown on the slide:

```
$ cd ~/ai4se/my-project       # always start in a dedicated project folder
$ opencode                    # the agent works in this folder
> /init                       # reads the code, writes AGENTS.md
[Tab] -> plan                 # read-only: propose a plan first
[Tab] -> build                # now it may edit and run commands
> explain @src/export.js      # @file adds a file to the context
> /gse-status                 # GSE-One commands start with /gse-
```

Plan first, build second, review the diff before you commit. The help of the course is not inside this session: it is your **tutor window**, a second terminal (hd02 § Installation in the room). The slide's `opencode.json` example (model, `permission` ask/allow, an MCP server) is an *example only*: the course kit sets your reference model and permissions stay at opencode defaults.

**Others.** Claude Code (Anthropic; `CLAUDE.md` is the twin of `AGENTS.md`, plan mode the twin of the plan agent; Claude models only). Cursor (AI-native editor, agent and plan modes). GitHub Copilot (IDE agent, cloud agent: issue → pull request). Codex CLI (OpenAI, open source, reads `AGENTS.md`). Gemini CLI (Google; succeeded by Antigravity CLI, May 2026). *Same ideas, new names — learn the concept, not the menu.* **Local LLMs** (Ollama, LM Studio): privacy, offline, fixed cost, fine for small jobs; but weaker on multi-file plans, less reliable tool calls, big hardware, you maintain it. This week: cloud model, capped key; at work: local when data must stay. **MCP (Model Context Protocol)**: an open protocol to plug tools and data into any agent; thousands of servers in a public registry; supported by all five agents; *trust*: a local server runs code on your machine. **Why opencode?** Open source, any provider (one capped key), concepts transfer, terminal-first (files, git, npm, tests), and GSE-One runs on 5 agents so the method goes with you. Keep Cursor or any editor open next to it to read code.

## EU AI Act and rules for this week

### Key ideas

**Risk levels**: *unacceptable* (contrary to EU values, e.g. social scoring) — banned; *high-risk* (safety or fundamental rights: hiring, credit, exams…) — strict requirements and conformity assessment; *low or minimal* (all other AI systems) — nothing, or transparency. Your coding assistant is generally **not** high-risk; what you **build** with it may be.

**Timeline** (Regulation (EU) 2024/1689 as amended by the *Digital Omnibus on AI*, now law: Regulation (EU) 2026/1744, in force 27 July 2026; proposed 19 November 2025; checked on EUR-Lex on 9 November 2026):

| Date | What applies |
|---|---|
| 1 Aug 2024 | Entry into force |
| 2 Feb 2025 | Prohibited practices + AI literacy (Art. 4) |
| 2 Aug 2025 | General-purpose AI models (LLMs) |
| 2 Aug 2026 | Most other rules (transparency, penalties) |
| 2 Dec 2027 | High-risk, stand-alone (Annex III) — was 2 Aug 2026 |
| 2 Aug 2028 | High-risk in products (Annex I) — was 2 Aug 2027 |

**Rules for this week.** *Never in a prompt*: secrets (keys — yours too —, passwords, `.env`), personal data (names, e-mails, health), NDA code (anonymise first). Remember: a prompt leaves your machine. *What the agent may do*: one project folder, never your home; it asks before any shell command; never `--bypass` on a real machine; review every diff before commit. **The AI proposes. You answer for what goes out.**

### Frequent errors

- Using a real client file "just to test" — use made-up data.
- Accepting every permission request without reading it.

### How GSE-One solves it (CCSET03, concept only)

*The problem:* every coding agent has its own settings and commands, and the rules you set in one are lost in the next.

- GSE-One is a plugin: the same rules, commands and specialised agents for opencode, Claude Code, Cursor, Codex CLI and Gemini CLI.
- In opencode, its rules live in `AGENTS.md` and its commands start with `/gse-`.
- Its guardrails act before the agent does: a commit straight on `main` is blocked, a force push is intercepted.

*You install it this afternoon (hd02, step 5). You use it from day 3.*

### Links

GSE-One: `§ 9 — Guardrails`; `§ P11 — Guardrails (Risk Mitigation and Traceability)`. Glossary: AI Act, MCP, permission, `--bypass`.

## Hands-up quiz

The day-1 quiz is asked at the 16:15 debrief (hd02 § Hands-up quiz). Four of its five statements test this morning — true or false?

1. The model remembers yesterday's chat. — **FALSE**: no memory, the context is re-sent every time.
2. Every token sent and received costs money. — **TRUE**: long chats and big files cost more; your key is capped.
3. Pasting your API key in a prompt is fine. — **FALSE**: never — a prompt leaves your machine.
4. Vibe coding = accepting AI code unread. — **TRUE**: that is the definition — and your afternoon.
