# ai4se-kit — learner kit for the AI4SE course

Two small shell scripts for the learners of the course **"AI for Software Engineering"
(AI4SE)**, used with [opencode](https://opencode.ai) 2 and the
[GSE-One](https://github.com/nicolasguelfi/gensem) methodology plugin (v0.90.0).

## The two commands

Install the `@tutor` agent (and a default opencode model if you have none):

```sh
curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/ai4se-kit/main/setup-learner.sh | sh
```

Check that your machine is ready (green ✓ / red ✗ list, with a fix hint for each red line).
Run it **from your project folder**, because GSE-One is installed per project:

```sh
curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/ai4se-kit/main/check-learner.sh | sh
```

## What each script touches

| Script | Reads | Writes |
|---|---|---|
| `setup-learner.sh` | the kit files (downloaded from this repository) | `~/.config/opencode/agents/tutor.md` (a different existing copy is first backed up to `tutor.md.bak.<date>`); `~/.config/opencode/opencode.json` **only** if it has no `"model"` key (one key added, backup kept) |
| `check-learner.sh` | versions of opencode, git, gh, node, npm; `opencode auth list` (connection names only, never a key); the GSE-One `VERSION` file of the project (`.gse/registry`, `.opencode/`) or of the machine install (`~/.gse-one`, `~/.config/opencode/`); `~/.config/opencode/agents/tutor.md`; `git config user.name/email`; `gh auth status` | nothing |

Both scripts are POSIX `sh`, can be run several times, and never print a secret.
`XDG_CONFIG_HOME` / `XDG_DATA_HOME` are honoured when set.

## The `@tutor` agent

An opencode **subagent** prepared by the trainer for this course. It is an AI, not the
trainer. In opencode, type `@tutor` followed by your question: it looks at where you are
(`git status`, `git log`, `.gse/status.yaml`), gives the smallest next step, and sends
you to the trainer for machine, model-key, server, or lost-work problems.

It is **read-only**: it cannot edit files, and its shell access is limited to
`git status/log/diff/branch/tag`, `ls`, `cat .gse/*` and version commands.

`tutor.md` is built by `setup-learner.sh` from:

- `agents/tutor.md.tmpl` — frontmatter (mode, permissions) and instructions;
- `knowledge/schedule.md`, `knowledge/recovery.md`, `knowledge/faq.md` — course
  knowledge appended to the prompt (the agent does not need to read files outside
  your project).

To update the tutor, re-run `setup-learner.sh`.

## Feedback

Problems with the course or GSE-One: open an issue on
[nicolasguelfi/gensem](https://github.com/nicolasguelfi/gensem/issues) with the label
`ai4se-ed2`. The repository is public — never paste keys, passwords, or confidential data.

## For the trainer

- `AI4SE_MODEL` at the top of `setup-learner.sh` holds the default model
  (`provider_id/model_id`); while it starts with `TODO` no model is written.
  It can also be overridden per run: `... | AI4SE_MODEL=provider/model sh`.
- `AI4SE_KIT_REF` selects the branch or tag the files are downloaded from (default `main`).
