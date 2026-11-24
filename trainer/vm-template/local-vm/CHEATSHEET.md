# Cheat sheet — the rehearsal VM across several Macs

Each command is alone in its block: copy, paste into the **Mac's** Terminal (never inside the VM), Enter.
Every command runs as written. When a value is yours to choose (a snapshot name, an archive), a first
command sets it in a shell variable — change the value in that line, then run the next one. Full help: `vm --help`.

Under each command, two lines say **what state the VM must be in** and **what to do with the Windows App
window**. General rule: **no command needs a logoff inside Ubuntu**, nor quitting the Windows App
application. When the VM stops or restarts, the window simply loses the connection: **save your open files
in the VM first**, then reconnect to the same PC once the VM is back.

## 0. Once per Mac

A `vm` shortcut (then `vm …` works from any folder):

```bash
echo "alias vm='bash \"/Volumes/Mac_Data/Win_data/data/backups/Dropbox-nicolas.guelfi@laposte.net/messir Dropbox/Nicolas Guelfi/users/NG/Projets/AISE/ROS/trainings/AI4SE/githubs/ai4se-kit/trainer/vm-template/local-vm/vm.sh\"'" >> ~/.zshrc && exec $SHELL
```

Windows App:

```bash
brew install --cask windows-app
```

VirtualBox only (to import an existing VM):

```bash
brew install --cask virtualbox
```

Create a new VM (also installs Homebrew and VirtualBox, ≈ 25 min), from the kit's `local-vm` folder:

```bash
bash setup-mac-vm.sh
```

## 1. Day to day

**Where is the VM at**

- VM: any state
- Windows App: nothing to do, the window may stay open

```bash
vm status
```

**Start**

- VM: stopped (if it already runs, the command says so and does nothing)
- Windows App: no window yet: connect once the command is done

```bash
vm start
```

**Connection details, and open Windows App**

- VM: running
- Windows App: opens the application; PC `localhost:3390`, `student` / `student`, session Xorg

```bash
vm connect
```

**Stop cleanly**

- VM: running
- Windows App: the connection cuts; save your files in the VM first

```bash
vm stop
```

**A terminal inside the VM (without Windows App)**

- VM: running
- Windows App: nothing to do
- `exit` or `Ctrl + D` to leave it

```bash
vm ssh
```

## 2. Protect your work

**Snapshot (set its name first — change `after-step-4` to yours)**

- VM: running or stopped
- Windows App: may stay open, **no logoff needed**; the VM freezes a few seconds then resumes — do not type meanwhile
- VM running: the snapshot also keeps the open windows and the memory; for a « clean » state, save your files first. It is stored inside the VM folder (`Snapshots/`), never next to vm.sh

```bash
NAME="after-step-4"
```

```bash
vm snap "$NAME"
```

**List the snapshots**

- VM: any state
- Windows App: nothing to do

```bash
vm snaps
```

**Go back to a snapshot** (look up its name with `vm snaps`, set it, then restore)

- VM: any state (the command powers it off, asks for confirmation, then restarts it)
- Windows App: the connection cuts; everything done since the snapshot is lost; reconnect afterwards

```bash
NAME="after-step-4"
```

```bash
vm restore "$NAME"
```

**Delete a snapshot** (name from `vm snaps`)

- VM: any state
- Windows App: nothing to do

```bash
NAME="after-step-4"
```

```bash
vm snap-delete "$NAME"
```

**Full backup (≈ 7 min) into `~/VMs/backups/ai4se-ubuntu/`**

- VM: running or stopped; if running, the command stops it during the copy then restarts it
- Windows App: the connection cuts for ≈ 7 min; save your files first; reconnect at the end

```bash
vm backup
```

## 3. Moving to another Mac

**Golden rule:** one active copy at a time. Before leaving a Mac, always `vm backup`.

### On the Mac you leave

**Full backup**

- VM: running or stopped (stopped during the copy)
- Windows App: the connection cuts; save your files first

```bash
vm backup
```

Transfer the newest `ai4se-ubuntu-….tar.gz` of `~/VMs/backups/ai4se-ubuntu/` (the name printed by `vm backup`) by AirDrop or external disk (not Dropbox).

### On the other Mac

**File the received archive**

- VM: —
- Windows App: —

```bash
mkdir -p ~/VMs/backups/ai4se-ubuntu && mv ~/Downloads/ai4se-ubuntu-*.tar.gz ~/VMs/backups/ai4se-ubuntu/
```

If it **already** has an `ai4se-ubuntu` VM (`VBoxManage list vms` shows it) — otherwise go straight to the import:

**1) Stop it**

- VM: running
- Windows App: close the window of this VM

```bash
vm stop
```

**2) Remove it from VirtualBox (its files stay)**

- VM: stopped
- Windows App: —

```bash
VBoxManage unregistervm ai4se-ubuntu
```

**3) Move its files aside**

- VM: removed from VirtualBox
- Windows App: —

```bash
mv ~/VMs/ai4se-ubuntu ~/VMs/ai4se-ubuntu-old
```

**Import the most recent archive** (the first line finds it, the second imports it)

- VM: no `ai4se-ubuntu` VM registered on this Mac; VirtualBox installed
- Windows App: no window yet: connect once the command is done (it starts the VM)

```bash
ARCHIVE=$(ls -t ~/VMs/backups/ai4se-ubuntu/*.tar.gz | head -n 1) && echo "$ARCHIVE"
```

```bash
vm import "$ARCHIVE"
```

**Check the state**

- VM: running
- Windows App: nothing to do

```bash
vm status
```

**Check that the snapshots came along**

- VM: any state
- Windows App: nothing to do

```bash
vm snaps
```

## 4. Common problems

**Grey or black screen in Windows App**

- VM: running
- Windows App: **close the window first**, run the command, then reconnect and wait up to a minute

```bash
vm fix-rdp
```

**The `m` key types `;`**

- VM: running
- Windows App: **keep the window open** (the command acts on the open session)

```bash
vm keyboard
```

**The VM does not answer**

- VM: running (frozen or not)
- Windows App: the connection cuts; reconnect afterwards

```bash
vm restart
```

**Still nothing (hard cut, last resort)**

- VM: running
- Windows App: the connection cuts; whatever was not saved in the VM is lost

```bash
vm reset
```

**« already locked by a session »**

- VM: still running or shutting down: look at its state
- Windows App: nothing to do

```bash
vm status
```

**`ssh` stuck on « Setting up xterm-ghostty »: Ctrl+C, then**

- VM: running
- Windows App: nothing to do

```bash
vm ssh
```

**A step broke everything inside the VM** (set the last good snapshot's name from `vm snaps`)

- VM: any state
- Windows App: the connection cuts; what was done since the snapshot is lost

```bash
NAME="after-step-4"
```

```bash
vm restore "$NAME"
```

**VirtualBox says the VM is « inaccessible »**: import the latest backup (section 3), or ask Claude.

**Unknown problem — diagnosis to paste to Claude**

- VM: any state (if the VM does not answer, the command captures its screen)
- Windows App: nothing to do

```bash
vm diag
```

Several VMs: set the VM's name once in the terminal (change `other-vm` to yours), then every `vm` command targets it:

```bash
export VM_NAME="other-vm"
```

```bash
vm status
```

Back to the default VM:

```bash
unset VM_NAME
```

## 5. Keyboard shortcuts inside the VM (Ubuntu, through Windows App)

**First things first.** Inside the VM, **Ctrl** copies, pastes and saves — as on Windows, even from a Mac.
The Mac's **⌘ Cmd** key becomes the **Super** key (the Windows key) there: `Cmd + C` does not copy in the
VM. In Ubuntu's **Terminal**, add **Shift**: `Ctrl + Shift + C` / `Ctrl + Shift + V` (because `Ctrl + C`
stops the running command there).

### Copy / paste

| Where | Copy | Paste |
|---|---|---|
| In an application of the VM (Firefox, editor, VS Code…) | `Ctrl + C` | `Ctrl + V` |
| In the VM's Terminal | `Ctrl + Shift + C` | `Ctrl + Shift + V` |
| From the Mac to the VM | `⌘ + C` on the Mac | `Ctrl + V` in the VM (`Ctrl + Shift + V` in its Terminal) |
| From the VM to the Mac | `Ctrl + C` in the VM (`Ctrl + Shift + C` in its Terminal) | `⌘ + V` on the Mac |
| From a Windows PC to the VM, and back | `Ctrl + C` | `Ctrl + V` (`Ctrl + Shift + V` in the VM's Terminal) |
| Quick copy, inside the VM only | select the text with the mouse | middle click (wheel) |

Copy and paste between the computer and the VM goes through Windows App: if it does not work, check in
Windows App → right-click the PC → Edit → **Clipboard** ticked, then reconnect. Text passes well; for files,
use `git` or a shared folder instead.

### Ubuntu desktop (GNOME)

| Action | Mac | Windows |
|---|---|---|
| Overview, search an application | `⌘` | `Win` |
| Application list | `⌘ + A` | `Win + A` |
| Open a Terminal | `Ctrl + Alt + T` | `Ctrl + Alt + T` |
| Switch windows (inside the VM) | `Alt + Tab` (⌥ + Tab) | `Alt + Tab` |
| Maximise / restore the window | `⌘ + ↑` / `⌘ + ↓` | `Win + ↑` / `Win + ↓` |
| Window on the left / right half | `⌘ + ←` / `⌘ + →` | `Win + ←` / `Win + →` |
| Close the window | `Alt + F4` (⌥ + fn + F4) | `Alt + F4` |
| Switch keyboard layout | `⌘ + Space` | `Win + Space` |
| Screenshot (inside the VM) | `Shift + Print` if the key exists; otherwise the top-right menu | `Shift + Print` |

### Terminal (inside the VM)

| Action | Shortcut (Mac and Windows) |
|---|---|
| Stop the running command | `Ctrl + C` |
| New tab / new window | `Ctrl + Shift + T` / `Ctrl + Shift + N` |
| Complete a file or command name | `Tab` (twice: all possibilities) |
| Recall previous commands | `↑` / `↓` |
| Search the history | `Ctrl + R` |
| Start / end of line | `Ctrl + A` / `Ctrl + E` |
| Clear the screen | `Ctrl + L` |
| Leave the terminal or the SSH session | `Ctrl + D` |
| Bigger / smaller text | `Ctrl + Shift + +` / `Ctrl + -` |

**Paste from the Mac fails in the Terminal, or shows `^[[200~ … ~`?** xrdp does not serve the clipboard
formats GNOME Terminal asks for (`text/plain;charset=utf-8`, `COMPOUND_TEXT`; seen in the xrdp log,
2026-11-23), so the paste arrives as typed keys. Ways round it: paste into the Text Editor first (`Ctrl + V`),
copy again there, then `Ctrl + Shift + V` in the Terminal; or `xclip -selection clipboard -o` (after
`sudo apt install -y xclip`); or work from the **Mac's** Terminal over SSH, where `⌘ + V` works:
`ssh -i /Volumes/Mac_Data/VMs/ai4se-ubuntu/vmkey -p 2222 student@127.0.0.1` (this Mac only: the key lives in the VM folder).

### opencode (in the VM's Terminal)

opencode takes over the Terminal: inside it, **`Ctrl + C` quits opencode** — it does not copy.

| Action | Shortcut |
|---|---|
| Copy text | select it with the mouse: it is copied at once (opencode default on Linux, `terminal.copy: select`) |
| Copy a whole agent message | `Ctrl + X`, then `Y` |
| Copy with the Terminal's own selection | hold `Shift` while selecting with the mouse, then `Ctrl + Shift + C` |
| Stop the agent, stay in opencode | `Esc` |
| Quit opencode | `Ctrl + C` (careful) |
| Resume the last session (from the project folder) | `opencode -c` |
| Resume a given session | `opencode -s <session id>` |
| Pick a session from the list (inside opencode) | `/sessions`, or `Ctrl + X` then `L` |
| Recent sessions and projects | `Ctrl + O` |
| New session | `Ctrl + X`, then `N` |

If selecting copies nothing, opencode may need a clipboard tool on Linux: `sudo apt install -y xclip`, then
restart opencode; the `Shift` + mouse way does not depend on opencode. (Checked against opencode 2.4.1:
`opencode --help` and its keybind and config documentation; the clipboard path through xrdp was not tested.)

### Common applications (inside the VM)

| Action | Shortcut (Mac and Windows) |
|---|---|
| Save / undo / redo | `Ctrl + S` / `Ctrl + Z` / `Ctrl + Shift + Z` |
| Find in the page or file | `Ctrl + F` |
| Files: type a path / show hidden files | `Ctrl + L` / `Ctrl + H` |
| VS Code: command palette / integrated terminal | `Ctrl + Shift + P` / ``Ctrl + ` `` |

### Windows App window (Mac side)

| Action | Shortcut |
|---|---|
| Full screen / leave full screen | `Ctrl + ⌘ + F` |
| Back to a Mac application | `⌘ + Tab` (handled by macOS, not by the VM) |

Special characters with the Mac AZERTY keyboard (`| \ { } [ ] ~`): normally the **same keys as on the Mac**,
with ⌥ Option (the VM uses the « French (Macintosh) » layout). If a character does not come out as expected:
`vm keyboard` from the Mac, then try again.
