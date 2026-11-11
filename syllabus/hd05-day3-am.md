# HD05 — Day 3 morning: software engineering concepts, requirements, qualities, verification

*AI for Software Engineering (AI4SE), edition 2 — Thursday 3 December 2026, 09:00-12:30.*
*Content licensed CC BY 4.0. Slide deck: "GSE-One — Generative SE Methods", day 3 morning.*

This morning is theory: four cycles (CCSET09 to CCSET12). Each ends with one slide, *How GSE-One solves it* — a concept, not a demo. You use GSE-One for the first time this afternoon (hd06).

| Time | Min | Sequence (section of this sheet) |
|---|--:|---|
| 09:00 | 15 | Welcome: recall of days 1-2, your CalcApp on GitHub |
| 09:15 | 60 | CCSET09 — Software engineering concepts, defining your GenSEM (theory 50, GSE-One 10) |
| 10:15 | 45 | CCSET10 — Requirements elicitation (theory 40, GSE-One 5) |
| 11:00 | 15 | Break |
| 11:15 | 45 | CCSET11 — Non-functional requirements (theory 40, GSE-One 5) |
| 12:00 | 30 | CCSET12 — Verification and validation (theory 25, GSE-One 5) |
| 12:30 | 60 | Lunch |

## Learning goals

At the end of this half-day you can:

1. Say why a method matters more, not less, with a coding agent, and name what a GenSEM must define.
2. Choose an elicitation technique for a situation, and write a user story with Given / When / Then acceptance criteria.
3. Turn a vague quality wish into a measurable non-functional requirement.
4. Tell verification from validation, pick test levels, and design test cases from equivalence classes and boundaries.
5. Explain, for each of these four topics, which solution GSE-One chose.

## Welcome: recall of days 1-2, your CalcApp on GitHub

### Key ideas

Days 1-2 were done by hand: you vibe coded FreeSelfApp, then engineered CalcApp v0.1 with a written plan, tests first, one branch per task, an AI review you triaged, and a tagged delivery. It worked — at a cost: re-explaining the project to the agent, keeping the plan up to date, remembering every check, and no trace of your decisions. Today asks why a method helps, then gives you one that carries this discipline for you.

Your CalcApp goes to your own GitHub repository, pushed every evening:

```bash
cd ~/ai4se/calcapp && git switch main
gh repo create calcapp --public --source=. --remote=mine
git push mine --all && git push mine --tags
gh repo view --web
```

Write the repository address in the tracking sheet. The repository is public: no key, no password.

## CCSET09 — Software engineering concepts, defining your GenSEM

### Key ideas

**The centre of gravity moves.** With an agent, writing code becomes cheap; deciding *what* to build, checking it and keeping it maintainable become the work. The developer moves from implementer to orchestrator.

**Evidence, not impressions.** Controlled studies report large speed-ups on small, well-defined tasks, while a randomised study of experienced developers on their own projects measured them 19 % *slower* with AI — and they believed they were faster. Gains depend on the process around the tool, not on the tool alone.

**Risks that motivate a method**: insecure or hallucinated code, technical debt, loss of understanding, and no trace of why the code is the way it is.

**The landscape.** Several generative software engineering methods exist (AgileGen, Agentic DevOps, SE 3.0, V-Bounce, Promptware engineering…). None is complete; they answer the same questions.

**What a GenSEM must define:**

| Ingredient | The question it answers |
|---|---|
| Lifecycle | the activities and their order, from the idea to delivery, then learning |
| Artefacts | what is written down: requirements, plan, design, tests, decisions |
| Roles | what the human decides, what the agent may do alone |
| Decision rules | which decisions need a human, with which information |
| Quality gates | the checks before moving on: tests, review, evidence |
| Learning | how lessons of one cycle improve the next |

Your own GenSEM can be small. It cannot be implicit.

### How GSE-One solves it (CCSET09, concept only)

*The problem:* without an explicit method, every session reinvents the lifecycle, and the agent decides what you forgot to decide.

- 16 principles, among them: artefacts are everything, the human in the loop, risk classification, agent fallibility.
- One lifecycle per sprint: collect → assess → plan → requirements → design → preview → tests → production → review → fix → delivery → capitalisation.
- Three modes sized to the project: **Full** (CalcApp), **Lightweight** (your mini-project), **Micro**.
- Gates where you decide, with a 3-question grid: *Do I understand what is proposed? What do I lose if it is wrong? Would I have chosen differently?* At least one change or one refusal per activity, noted in the tracking sheet.

You receive the printed **orientation page** now (also in this kit: [orientation.md](orientation.md)).

### Links

GSE-One: `~/ai4se/gensem/gse-one-spec.md § 1.4 — Design Philosophy`; `§ 2 — Core Principles`; `§ 3.10 — Commands by Lifecycle Phase`. Glossary: GenSEM, lifecycle, Gate, mode, principle.

## CCSET10 — Requirements elicitation

### Key ideas

**Why it matters.** Finding and fixing a severe problem after delivery is often 100 times more expensive than during requirements and design (Boehm & Basili, 2001). With an agent, code is cheap, but a wrong requirement is still expensive: the agent builds it fast, and well.

**A good requirement** (ISO/IEC/IEEE 29148) is, among other things, *unambiguous* ("the list of 1,000 expenses shows in under 200 ms", not "the list loads quickly"), *verifiable*, *singular* (one need per requirement) and *necessary* (traceable to someone who needs it).

**Who and where to ask.** Stakeholders: each kind of user, the customer who pays, operations and support, regulators. Sources: the current process, existing documents and systems, complaints and support tickets, competing products. A requirement nobody can trace to a stakeholder is a guess.

**Techniques** (Zowghi & Coulin, 2005) — combine several:

| Technique | Best for | Watch out |
|---|---|---|
| Interview | goals, context, the "why" | people say what they think they do |
| Observation | the real work, tacit habits | slow; being watched changes behaviour |
| Workshop | conflicts between stakeholders | the loudest voice wins |
| Questionnaire | many users, simple facts | no follow-up question |
| Scenarios | concrete steps, exceptions | misses the rare cases |
| Prototype | "I'll know it when I see it" | the mock-up becomes the product |

**User stories**: *As a person on a budget, I want to see my monthly total by category, so that I know where my money goes.* Check them with INVEST: Independent, Negotiable, Valuable, Estimable, Small, Testable (Wake, 2003).

**Acceptance criteria** in Given / When / Then form (North, 2006) — each criterion is an example you could turn into a test:

```gherkin
Scenario: monthly total of one category
  Given expenses of 12.50 and 7.50 in "Food" in March
    And an expense of 30.00 in "Transport" in March
  When I open the March summary
  Then the "Food" total is 20.00
    And the "Transport" total is 30.00
```

**Ambiguity hides decisions**: "monthly" (calendar month or last 30 days?), "category" (fixed list or free text?), "amount" (currency, refunds, decimals?), "delete" (for ever or recoverable?). If you do not decide, the agent decides — silently.

**Eliciting with an AI.** It helps: it asks the questions you forgot, drafts stories fast, spots ambiguous words. Watch out: it invents requirements nobody asked for, fills gaps with generic answers, agrees with you too easily. Research on generative AI in requirements engineering is young: most studies are early-stage (Cheng et al., 2025).

### How GSE-One solves it (CCSET10, concept only)

*The problem:* requirements left implicit are decided by the agent, and nobody can check them later.

- `/gse-reqs` starts with a conversation in plain language, before any formal writing.
- Each requirement gets an identifier (REQ-…) and testable acceptance criteria (Given / When / Then).
- Every requirement is linked to the tasks and tests that cover it: that link is traceability.
- The requirements are validated at a Gate before design starts.

### Links

GSE-One: `§ 3.6 — Engineering` (`/gse-reqs`); `§ 1.2 — Agile Software Engineering Foundations` (user stories, acceptance criteria). Glossary: stakeholder, elicitation, user story, acceptance criterion, traceability.

## CCSET11 — Non-functional requirements

### Key ideas

**Functional vs non-functional.** A functional requirement says *what* the system does ("add an expense"); a non-functional one says *how well* ("saved even if the browser closes", "the monthly total shows in under 200 ms for 1,000 expenses"). Missing a functional requirement removes a feature; missing a quality makes every feature slow, unsafe or unusable. The line is not always sharp (Glinz, 2007). Users rarely state qualities: you have to ask.

**A checklist of qualities**: ISO/IEC 25010:2023 lists nine product quality characteristics — functional suitability, performance efficiency, compatibility, interaction capability (learnable, accessible), reliability, security, maintainability, flexibility, safety.

**Make it measurable** (Gilb's Planguage). "The summary is fast" becomes: *scale* — seconds from a click on "Summary" to the totals shown; *meter* — an automated test with 1,000 stored expenses on the course laptop; *goal* — under 0.2 s; *tolerable* — under 1 s, beyond that it is a defect.

**Quality attribute scenarios** (Bass, Clements & Kazman) have six parts: source (a user), stimulus (closes the browser while adding an expense), artefact (the stored list), environment (normal use, no network), response (on reopening, every confirmed expense is there), measure (0 confirmed expense lost over 100 trials). Qualities shape the architecture: decide them before the design.

**Qualities conflict**: security ↔ usability (one more login step), performance ↔ maintainability (a clever cache), flexibility ↔ simplicity ("any currency" costs a week, "euros only" costs nothing). A trade-off is a decision: write it down, with its reason.

**What the agent forgets.** In a 2025 study, 45 % of AI-generated code samples failed security tests (Veracode). Asked for qualities, a model proposes relevant ones (Lima et al., 2025); not asked, it optimises for "it works on my screen".

### How GSE-One solves it (CCSET11, concept only)

*The problem:* qualities nobody asked for are not built, and not tested.

- `/gse-reqs` asks for the qualities too, and writes them as requirements with a measure.
- It ends with a checklist inspired by ISO 25010: are the qualities complete and measurable?
- `/gse-design` records each design decision with its reason and the qualities it serves.
- The review checks them again: performance, security, accessibility.

### Links

GSE-One: `§ 3.6 — Engineering` (`/gse-reqs`, `/gse-design`); `§ 11 — Decision Journal`. Glossary: non-functional requirement, quality attribute, trade-off.

## CCSET12 — Verification and validation

### Key ideas

**Two different questions** (Boehm, 1984). *Verification*: am I building the product right? — against the design: unit and integration tests, review. *Validation*: am I building the right product? — against the user's need: acceptance tests, demos. 90 % coverage of a feature nobody needs is verified, not validated.

**Each level has its tests**: requirements ↔ acceptance tests (the user's examples pass); design ↔ integration tests (the parts work together); code ↔ unit tests (each function does what it says). Design the test when you write the specification, not after the code.

**The test pyramid** (Cohn, 2009): many unit tests (fast, precise, cheap), some integration tests, few end-to-end tests (slow, fragile, close to the user). A shape to adapt, not a law: a web front-end needs some end-to-end tests.

**Which cases to test?** Equivalence classes and boundaries (Myers). For "the amount of an expense is a positive number": −5 and 0 (invalid, error shown), 0.01 (boundary, accepted), 25.50 (valid, shown as €25.50), "abc" (invalid, error shown).

**Static and dynamic.** Static verification reads: review of requirements and design, code review (day 2), lint and type checks (day 4). Dynamic verification runs: tests, performance measures, a demo to the user. Review finds what tests cannot run into; tests find what readers miss.

**Who says what is correct?** A test needs an *oracle*, the expected result (Barr et al., 2015). If the agent reads its own code to write the test, the test copies the bug. Take expected results from the requirements, write or read the test before the code (red, then green), and check that a test can fail (the mutant trick of day 2).

### How GSE-One solves it (CCSET12, concept only)

*The problem:* tests written after the code, by the same agent, check what was built — not what was asked.

- `/gse-tests` derives a test strategy from the requirements first: verification and validation, level by level.
- Validation tests trace to the requirements, verification tests to the design.
- Test runs leave evidence; delivery is blocked while a requirement's tests have not passed.
- `/gse-review` is the static side: several reviewers, findings ranked HIGH / MEDIUM / LOW.

*Tomorrow morning: exercise E14 (hd07).*

### Links

GSE-One: `§ 6 — Testing Strategy` (`§ 6.1 — Test Strategy Framework`, `§ 6.3 — Test Execution and Evidence`); `§ 9.3.1 — Test-Specific Guardrails`. Glossary: verification, validation, test level, test pyramid, equivalence class, boundary value, oracle.

## References

Barr, Harman, McMinn, Shahbaz, Yoo (2015), *The Oracle Problem in Software Testing: A Survey*, IEEE TSE 41(5). · Bass, Clements, Kazman (2021), *Software Architecture in Practice*, 4th ed. · Boehm (1984), *Verifying and Validating Software Requirements and Design Specifications*, IEEE Software 1(1). · Boehm, Basili (2001), *Software Defect Reduction Top 10 List*, IEEE Computer 34(1). · Cheng et al. (2025), *Generative AI in Requirements Engineering: A Systematic Mapping Study*. · Cohn (2009), *Succeeding with Agile*. · Gilb (2005), *Competitive Engineering*. · Glinz (2007), *On Non-Functional Requirements*, RE'07. · ISO/IEC 25010:2023. · ISO/IEC/IEEE 29148:2018. · Lima et al. (2025), *Automated NFR Generation with LLMs*. · Myers, Sandler, Badgett (2011), *The Art of Software Testing*, 3rd ed. · North (2006), *Introducing BDD*. · Veracode (2025), *GenAI Code Security Report*. · Wake (2003), *INVEST in Good Stories*. · Zowghi, Coulin (2005), *Requirements Elicitation: A Survey of Techniques, Approaches, and Tools*.
