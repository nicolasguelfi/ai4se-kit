# Cheat sheet — the rehearsal VM across several Macs

Each command is alone in its block: copy, paste into the **Mac's** Terminal (never inside the VM), Enter.
Replace the names between `<…>`. Full help: `vm --help`.

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

**Snapshot (name of your choice)**

- VM: running or stopped
- Windows App: may stay open, **no logoff needed**; the VM freezes a few seconds then resumes — do not type meanwhile
- VM running: the snapshot also keeps the open windows and the memory; for a « clean » state, save your files first. It is stored inside the VM folder (`Snapshots/`), never next to vm.sh

```bash
vm snap <name>
```

**List the snapshots**

- VM: any state
- Windows App: nothing to do

```bash
vm snaps
```

**Go back to a snapshot**

- VM: any state (the command powers it off, asks for confirmation, then restarts it)
- Windows App: the connection cuts; everything done since the snapshot is lost; reconnect afterwards

```bash
vm restore <name>
```

**Delete a snapshot**

- VM: any state
- Windows App: nothing to do

```bash
vm snap-delete <name>
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

Transfer `~/VMs/backups/ai4se-ubuntu/ai4se-ubuntu-<date>.tar.gz` by AirDrop or external disk (not Dropbox).

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

**Import (replace `<date>` with the archive's)**

- VM: no `ai4se-ubuntu` VM registered on this Mac; VirtualBox installed
- Windows App: no window yet: connect once the command is done (it starts the VM)

```bash
vm import ~/VMs/backups/ai4se-ubuntu/ai4se-ubuntu-<date>.tar.gz
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

**A step broke everything inside the VM**

- VM: any state
- Windows App: the connection cuts; what was done since the snapshot is lost

```bash
vm restore <last-good-snapshot>
```

**VirtualBox says the VM is « inaccessible »**: import the latest backup (section 3), or ask Claude.

**Unknown problem — diagnosis to paste to Claude**

- VM: any state (if the VM does not answer, the command captures its screen)
- Windows App: nothing to do

```bash
vm diag
```

Several VMs: prefix with the name, for example:

```bash
VM_NAME=<other-vm> vm status
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
