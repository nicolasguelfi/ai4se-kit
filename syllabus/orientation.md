# Orientation page — GSE-One in opencode

*AI4SE edition 2. Printed and handed out on day 3 (09:00-12:30, cycle CCSET09); keep it next to your laptop until day 6.*

## Front — where am I?

**The activities of a sprint, in order** (Full mode, CalcApp):
collect → assess → plan → requirements → design → preview → tests → production → review → fix → delivery → capitalisation.
Lightweight mode (your mini-project) keeps plan → requirements → production → delivery, with fewer Gates.

| You want to… | Type |
|---|---|
| know where the project is, what comes next | `/gse-status` |
| let GSE-One choose the next step | `/gse-go` |
| stop for today, keep everything | `/gse-pause` |
| start again tomorrow | `/gse-resume` |
| note an idea for later | `/gse-backlog` |
| see the health of the project | `/gse-health` |

- A sprint is finished after **delivery**, then **capitalisation** (`/gse-compound`).
- Modes: **CalcApp in Full**, **your mini-project in Lightweight**.
- One command form in opencode: `/gse-…` (the GSE-One documentation writes `/gse:…`, the Claude Code form).
- At every **Gate**, three questions: *Do I understand what is proposed? What do I lose if it is wrong? Would I have chosen differently?* — and at least one change or one refusal per activity, noted in the tracking sheet.

## Back — when the agent drifts

1. **Stop and discuss.** Ask the agent why; do not type over it.
2. **`/gse-status`** — where are we really?
3. **Refuse the change.** Say no, with one sentence of reason.
4. **`/gse-pause`, then `/gse-resume`** — a clean restart from the saved state.
5. **Go back to a safety tag**: `git tag --list 'gse-backup/*'`, then ask the trainer before resetting.
6. **Call the trainer** — always for the machine, the key, the server, or lost work.

**What to do if…**

- *The agent asks a question you do not understand* → answer "explain it more simply"; it adapts to your profile.
- *A command does nothing* → check you are in the project folder (`pwd`), then `cat .gse/registry` prints `.opencode`.
- *The agent wants to commit on `main`* → refuse: one branch per task; the guardrail blocks it anyway.
- *You are 15 minutes late on an exercise* → restart from the exercise's recovery tag (on the slide).
- *You do not know what to do next* → `/gse-status`, then your tutor window.
