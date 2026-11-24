# opencode — mini guide and cheat sheet

*Content licensed CC BY 4.0.*

**In one sentence:** opencode is the coding agent of the course: you write in plain words what you
want, it reads your project, proposes, edits files and runs commands — and **you** decide what stays.

Checked with opencode 2.4.1. Every command below runs as written; a value that is yours to choose is
set in a variable on the line just before.

## 1. Two windows, two roles

| Window | Opened with | Role |
|---|---|---|
| **Project** | `opencode` in your project folder | the agent that works on your code (and runs GSE-One from day 3) |
| **Tutor** | `~/ai4se/ai4se-kit/tutor` in a second terminal | an AI helper that reads the course and your project, and never writes |

Start opencode in the project folder — it works on the folder it was started in:

```bash
cd ~/ai4se/calcapp
```

```bash
opencode
```

## 2. The two agents: plan and build

**Shift+Tab** switches between them; the current one is shown at the bottom of the window.

| Agent | Does | When |
|---|---|---|
| **plan** | explores and proposes; does not edit your files | understand the code, prepare a change, review |
| **build** | edits files and runs commands | once you agree with the plan |

Good habit: **plan first** (« what would you change, and why? »), read the answer, then Shift+Tab to
**build** and say « do it ».

## 3. Talking to the agent

| You type | It does |
|---|---|
| plain words, then **Enter** | sends your request |
| `@` then a file name | attaches that file to your request (`@src/App.tsx`; a line range: `@src/App.tsx#20-45`) |
| `!` at the start, then a command | runs a shell command; its output stays in the conversation (`!git diff`) |
| `/` | lists the commands (see § 5); keep typing to filter |
| **Shift+Enter** | new line in your request, without sending |
| **Enter** while it works | adds an instruction to steer it |

A good request names the file, the goal and the check:
« In @src/App.tsx, reject a negative amount. Write the failing test first. Run `npm run test:run`. »

## 4. Keyboard shortcuts

**Ctrl+X** is the *leader* key: press Ctrl+X, release, then the letter.

| Action | Keys |
|---|---|
| Switch agent (plan ↔ build) | Shift+Tab |
| **Stop the agent now** | **Esc** |
| Undo the last request and what the agent did after it | Ctrl+X, then U |
| Redo | Ctrl+X, then R |
| New session (fresh conversation) | Ctrl+X, then N |
| Back to an earlier session | Ctrl+X, then L |
| Choose the model | Ctrl+X, then M |
| Copy the last message | Ctrl+X, then Y |
| All commands (palette) | Ctrl+P |
| Scroll | PageUp / PageDown |
| **Quit opencode** | Ctrl+X, then Q |

## 5. Commands inside opencode

| Command | Does |
|---|---|
| `/init` | reads the project and writes `AGENTS.md`, the standing instructions the agent follows |
| `/new` | new session |
| `/sessions` | back to an earlier session |
| `/models` | choose the model |
| `/agents` | choose the agent |
| `/undo` · `/redo` | undo / redo the last request and its changes |
| `/editor` | write a long request in your text editor |
| `/gse-go`, `/gse-status`, `/gse-pause`, `/gse-resume`, … | GSE-One, from day 3 (see [gse-guide](gse-guide.md)) |

`/undo` reverts what the agent changed in the session; it is not a replacement for git. Before a big
change, commit (or let GSE-One commit).

## 6. In the terminal (outside opencode)

Open opencode in the current folder:

```bash
opencode
```

Continue the last session of this folder:

```bash
opencode --continue
```

Store your model key (sent by the trainer by Teams direct message or e-mail): type `openrouter`, choose
OpenRouter, paste the key when asked:

```bash
opencode auth login
```

Check that the key is stored:

```bash
opencode auth list
```

List the available models:

```bash
opencode models
```

Version:

```bash
opencode --version
```

## 7. Settings the course gives you

`setup-learner.sh` (installation step 4) adds these settings to your opencode configuration
(`~/.config/opencode/opencode.json`), **without changing the ones you already have** (a backup copy is kept):

| Setting | Effect |
|---|---|
| Secrets unreadable | the agent may not read `.env` files (except `.env.example`), keys (`*.pem`, `*.key`, `~/.ssh`, `~/.aws`, `~/.gnupg`), opencode's own configuration, `.git/config`, `.netrc`, `*credentials*` — neither with its read tool nor with a shell command |
| Risky commands ask first | before `git push`, `sudo`, `rm -rf` / `rm -r`, global installs (`npm install -g`, `pip install`), downloads (`curl`, `wget`), opencode asks you — read the command, then allow or refuse |
| No public sharing | sharing a conversation at a public address is off (`"share": "disabled"`): a session holds your code and paths |

Everything else runs without asking, so the agent (and GSE-One) can work at a normal pace. The full list
is in the kit: `~/ai4se/ai4se-kit/opencode.learner.json`. Check that the settings are there:

```bash
sh ~/ai4se/ai4se-kit/check-learner.sh
```

Missing (for example after reinstalling opencode)? Run the setup again — it only adds what is missing:

```bash
sh ~/ai4se/ai4se-kit/setup-learner.sh
```

## 8. Habits that keep you in control

- **Read before you accept**: after the agent works, `!git diff` (or the editor's Source Control, see
  [ide-guide](ide-guide.md)) — then commit only what you understood.
- **One task per session**: start a new one (Ctrl+X, then N) when you change task; long sessions get slow
  and confused. With GSE-One, `/gse-pause` first.
- **Stop early**: Esc as soon as the agent goes the wrong way, then say what you want instead.
- **Never paste your key** into a request, a file, a screenshot or an issue.
- **The model of the course** is set by the kit; change it only when an exercise asks (Ctrl+X, then M).

## 9. When something goes wrong

| You see… | Do this |
|---|---|
| `opencode: command not found` | reload the terminal: `exec $SHELL` |
| « 401 », « invalid API key » | redo `opencode auth login` with the key the trainer sent |
| The agent loops or goes off track | Esc, then a shorter, more precise request; or Ctrl+X then U to undo it |
| It edited the wrong files | Ctrl+X then U, or `!git restore .` to drop uncommitted changes (final) |
| The window does not answer | Esc; still frozen: Ctrl+X then Q, then `opencode --continue` |
| Lost after a break | `/gse-resume` (from day 3), or `opencode --continue` |
