# ai4se-kit — learner kit for the AI4SE course

Kit for the learners of the course **"AI for Software Engineering" (AI4SE)**, used with
[opencode](https://opencode.ai) 2 and the [GSE-One](https://github.com/nicolasguelfi/gensem)
methodology plugin (pinned to **v0.90.1**).

It contains:

- **the tutor** — an AI assistant prepared by the trainer (not the trainer) that runs in its
  own opencode window, read-only, and helps you when you are stuck or lost;
- **the syllabus** (`syllabus/`) — the programme of the 12 half-days, one written sheet per
  half-day (published as the course goes), a GSE-One guide, a glossary, a FAQ and recovery
  procedures;
- two scripts: `setup-learner.sh` (installation) and `check-learner.sh` (green/red checklist).

## Commands

| When | Command |
|---|---|
| Install (day 1) | `git clone https://github.com/nicolasguelfi/ai4se-kit ~/ai4se/ai4se-kit && sh ~/ai4se/ai4se-kit/setup-learner.sh` |
| Open the tutor window (a second terminal) | `~/ai4se/ai4se-kit/tutor` |
| Let the tutor read a folder outside `~/ai4se` | `~/ai4se/ai4se-kit/tutor add <path>` |
| List the folders the tutor may read | `~/ai4se/ai4se-kit/tutor paths` |
| Stop the tutor reading a folder | `~/ai4se/ai4se-kit/tutor remove <path>` |
| Update the kit (start of each half-day) | `~/ai4se/ai4se-kit/tutor update` |
| Show versions (kit, GSE-One clone, opencode) | `~/ai4se/ai4se-kit/tutor version` |
| Check the machine | `sh ~/ai4se/ai4se-kit/check-learner.sh` (from your project folder) |

Stuck during an exercise? → **your tutor window** (the right-hand terminal). After `tutor add`,
`tutor remove` or `tutor update`, close and reopen the tutor window.

## The `~/ai4se` folder

`~/ai4se` is a plain folder (not a git repository) that holds the course repositories side by
side — `ai4se-kit`, `gensem` (GSE-One v0.90.1, read by the tutor), your exercise projects… —
never one repository inside another.

## What `setup-learner.sh` does

Safe to run several times. It never reads or writes keys.

- creates `~/ai4se` if needed;
- clones GSE-One at tag `v0.90.1` into `~/ai4se/gensem` (or checks the tag of an existing clone);
- writes `~/.config/ai4se/tutor-paths` (default content: `~/ai4se`) if it does not exist;
- moves away the global `~/.config/opencode/agents/tutor.md` installed by the previous kit
  version (backup `tutor.md.bak.<date>`; there is no `@tutor` any more);
- sets the default opencode model in `~/.config/opencode/opencode.json` **only** if it has
  none and the course model is decided (one key added, backup kept).

## What the tutor can and cannot do

The tutor is the default agent of an opencode session opened in the kit folder by the `tutor`
launcher, with its own configuration (generated at each launch in
`~/.config/ai4se/tutor-opencode.json` from `opencode.base.json` and your folders list).

It **can**:

- read files in the kit, in the folders listed in `~/.config/ai4se/tutor-paths` (default
  `~/ai4se`, so also the GSE-One clone) and their sub-folders;
- find files by name (glob) and search text with `git grep` (tracked files only);
- run read-only commands: `git status / log / diff / show / grep`, `git branch` and `git tag`
  (list only), also as `git -C <folder> …` for the listed folders; `ls` on the listed folders;
  `opencode / node / npm --version`.

It **cannot**:

- edit or create files, run any other command, browse the web, or start sub-agents;
- read any folder that is not listed (refused: "Permission denied: external_directory" or
  "Blocked by configuration policy");
- read secrets, whatever the folder: `.env` and `.env.*` files (`.env.example` stays readable),
  `*.pem`, `*.key`, `id_rsa*`, `id_ed25519*`, `~/.ssh`, `~/.aws`, `~/.gnupg`, `.netrc`,
  `*credentials*`, `.git/config`, the opencode configuration and data folders. These are
  hard **policies** of the configuration: they win over any agent rule.

`git -C <folder>` and `ls <folder>` are accepted only for the listed folders and the kit
(`ls` alone or with simple options lists the kit folder); `..` in a path is refused.

## Files

| Path | Role |
|---|---|
| `tutor` | launcher (POSIX `sh`; needs only `git` and `opencode`) |
| `.opencode/agents/tutor.md` | the tutor agent: permissions + instructions |
| `opencode.base.json` | tutor session config: default agent, course model, secret policies |
| `syllabus/` | course content (CC BY 4.0) |
| `VERSION` | kit version `YYYY-MM-DD.N` (the tutor uses it to remind you to update) |
| `~/.config/ai4se/tutor-paths` | your folders list (one per line, `~` allowed, `#` = comment) |
| `~/.config/ai4se/tutor-model` | optional: a model for the tutor only (`provider/model`) |

## Feedback

Problems with the course or GSE-One: open an issue on
[nicolasguelfi/gensem](https://github.com/nicolasguelfi/gensem/issues) with the label
`ai4se-ed2`. The repository is public — never paste keys, passwords, or confidential data.

## For the trainer

- The course model is the `"model"` line of `opencode.base.json` (`provider/model`). While it
  starts with `TODO` no model is written anywhere; once set and pushed, `tutor update` gives it
  to every tutor window, and re-running `setup-learner.sh` sets it as the global default for
  learners who have none. `AI4SE_MODEL=provider/model sh setup-learner.sh` sets it for one
  machine (written to `~/.config/ai4se/tutor-model` and, if absent, to `opencode.json`).
- `tutor config` only generates the tutor configuration and prints its path (debugging).
- The launcher runs `opencode --standalone`: the opencode background service shared with the
  work session may otherwise serve the tutor window with its own configuration (not verified).
- Overrides for tests: `AI4SE_HOME` (default `~/ai4se`), `AI4SE_GENSEM_URL`.

## Licences

- Scripts and configuration: [MIT](LICENSE).
- Course content in `syllabus/`: [CC BY 4.0](syllabus/LICENSE)
  (<https://creativecommons.org/licenses/by/4.0/>).
