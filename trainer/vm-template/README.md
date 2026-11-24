# Preparing the course's Ubuntu virtual machine template (trainer)

This guide finalises the template machine **once**, before one copy is created per learner. Four scripts,
in this order:

| Script | Run as | What it does |
|---|---|---|
| `1-system.sh` | `sudo` | system tools: git, gh, Node.js LTS, python3, libatomic1, time zone, VS Code settings (editor AI off, no update or recommendation pop-ups) |
| `2-student.sh` | the `student` account | desktop settings (no screen lock, dock); **option** `--preinstall`: opencode 2, the kit, GSE-One |
| `3-seal.sh` | `sudo` | erases everything personal before cloning (key, GitHub login, git identity, histories…); **dry run by default**, erases only with `--apply` |
| `4-verify.sh` | the `student` account | read-only check: tools, nothing personal, network access to the course sites |

No script installs a key, logs into an account or writes an identity: the model key, the GitHub login and
the git identity are done by each learner (steps 3 and 6 of the day-1 afternoon installation).

Tested in Ubuntu 24.04 (container): installation, second run with no effect, `--preinstall` mode, dry then
real cleanup, check before and after. Not tested: the GNOME desktop part (no screen in the container), to be
checked at step 3 below.

## Before you start

1. **Take a snapshot of the VM** as it is. If something goes wrong, you are back in a minute.
2. Put the scripts in the VM, for example in `~/vm-template/`:
   - if the kit is published: `git clone https://github.com/nicolasguelfi/ai4se-kit /tmp/kit && cp -r /tmp/kit/trainer/vm-template ~/`
   - otherwise: copy the `trainer/vm-template` folder through the shared clipboard, a USB stick or `scp`.

## The steps

### Step 1 — System (≈ 10 min)

In a terminal of the VM, logged in as `student`:

```bash
cd ~/vm-template
```

```bash
sudo bash 1-system.sh
```

*Done when* it prints « System part finished » with no `ERROR` line. You may run it again: it only redoes
what is missing.

### Step 2 — Student account: a decision to take

Desktop settings only (A):

```bash
bash 2-student.sh
```

Or with opencode 2, the kit and GSE-One already installed (B):

```bash
bash 2-student.sh --preinstall
```

Run it **from a desktop terminal** (not over SSH), otherwise the desktop settings are skipped.

| | A. No pre-installation (recommended) | B. With `--preinstall` |
|---|---|---|
| Day 1 afternoon | Learners do steps 1 to 8 as on the slides; step 2 (Node) and the gh installation (step 6) are already done: « already ≥ 20? skip » | Steps 1, 2, 4 and 5 become « check »; what is left: the key (3), GitHub and identity (6), the check (7), the tutor (8) |
| Advantages | What they see matches the slides; they learn where the tools live and can redo the installation on their own machine; the kit is cloned up to date on the day | ≈ 20 min saved; no risk if the room's network is slow when 20 people download at once |
| Drawbacks | Depends on the room's network for 15-20 min | The kit and opencode have the version of the day you prepared the template: learners run `~/ai4se/ai4se-kit/tutor update` first (already part of each half-day routine); the installation slides describe steps already done |
| Risk | Proxy or blocked network: the check of step 4 below detects it before the course | Preparing the template before publishing the kit: learners start from an old kit |

### Step 3 — Test as a learner (≈ 15 min)

Safest: **test on a copy of the template**, not on the template itself. Otherwise, test in the template and
clean up at step 4.

1. Open VS Code: no « Release Notes » window, no Docker extension suggestion, no chat icon; opening a `.md`
   file shows the preview.
2. Check the keyboard (`ch`, `fr`, `us`: your `gsettings` choice is kept), the screen that does not lock, the
   dock (Terminal, VS Code, Firefox, Files).
3. Do the day-1 afternoon installation with **a test key** and **a test GitHub account**, up to the tutor
   window. Open Firefox for `gh auth login`.

### Step 4 — Clean up and shut down (≈ 5 min)

Dry run: lists what will be erased, erases nothing:

```bash
sudo bash 3-seal.sh
```

Then erase:

```bash
sudo bash 3-seal.sh --apply
```

- Read the dry-run list before `--apply`.
- If you logged into GitHub (or another site) in Firefox during the test: add `--reset-browser`.
- If an application saved a password (GNOME keyring): add `--reset-keyrings`. Without a login test, do not
  use these two options.
- A `!` line « defines OPENROUTER_API_KEY » (or another secret) in `.bashrc`: delete that line by hand; the
  script does not modify these files and never prints the value.

Then check (everything must be ✓; the `·` lines are informative):

```bash
bash 4-verify.sh
```

And shut down **without logging in again**:

```bash
sudo poweroff
```

If you log in again after the cleanup, a new history is created: run `3-seal.sh --apply` again.

### Step 5 — Create the copies and check one

1. Turn the VM into a template and create the instances with the platform's tool.
2. On **two** copies: `bash ~/vm-template/4-verify.sh --clone`. The machine identifiers shown must be
   **different** (otherwise the copies may get the same network address).
3. The `~/vm-template` folder may stay on the copies: it holds no secret.

## What each learner still does

- their model key: `opencode auth login` (step 3);
- their GitHub login and git identity: `gh auth login`, `git config --global user.name/email` (step 6);
- without pre-installation: opencode, the kit, GSE-One (steps 1, 4, 5).

At the end of the course, if the machines are reused by other people: recreate them from the template rather
than cleaning them (their keys and logins are in there).

## VS Code or VSCodium?

The slides and the mini guide `syllabus/ide-guide.md` speak of VSCodium on personal machines. In the VM, VS
Code is already installed: with the settings of `1-system.sh`, its AI is turned off the same way
(`chat.disableAIFeatures`). Just tell the learners: « in the VM it is VS Code, its AI is already off ».

## Rehearsing on a Mac (local VM)

To rehearse the template on an Apple Silicon Mac, without a server: `bash local-vm/setup-mac-vm.sh`
(`--dry-run` to see what it would do, `--with-tailscale` for access from your other devices). It installs
what is missing (Homebrew, VirtualBox, optionally Tailscale), refuses a VM folder inside Dropbox or iCloud
(`~/VMs` by default), then runs `local-vm/create-local-vm.sh` (≈ 25 min). Then connect with Windows App:
`localhost:3390`, user `student`, session Xorg.

Day to day, `bash local-vm/vm.sh` handles the common situations: `status`, `start`, `stop`, `restart`,
`fix-rdp` (grey or black Windows App screen), `keyboard`, `diag` (full diagnosis to paste to Claude), `ssh`,
and snapshots: `snap [name]`, `snaps`, `restore <name>`, `snap-delete <name>`. Full backup, also to move the
VM to another Mac: `backup [path]` (one `.tar.gz` with disk, settings, snapshots and SSH key; the VM is
stopped during the copy), then on the other Mac `import <archive>`.
Cheat sheet, one command per copy block, with the VM state each command needs:
[`local-vm/CHEATSHEET.md`](local-vm/CHEATSHEET.md).
Take a snapshot after each successful step (`bash local-vm/vm.sh snap after-step-4`): VirtualBox on Apple
Silicon is still fragile, and a restore takes a minute.
