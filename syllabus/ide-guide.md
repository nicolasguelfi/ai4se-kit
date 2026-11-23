# An editor next to opencode — VSCodium mini guide

*Content licensed CC BY 4.0.*

**In one sentence:** opencode changes your project; the editor is for **reading** it.
No step of the course requires an editor, but one makes the code, the changes and the
documents much easier to read.

## 1. Which editor, and the one rule

We recommend **[VSCodium](https://vscodium.com)**: the open-source build of VS Code, free, with
no Copilot account and no Microsoft telemetry.

> **Rule during the workshops: the editor's AI stays off; only opencode writes to the project.**

Why:

- two agents writing in the same folder overwrite each other's work;
- the editor's agent also reads `AGENTS.md` and the GSE-One files and may act on them;
- AI completion writes the code — or the test — in your place: on day 2 the test is yours;
- agent extensions (Cline, Continue, Kilo Code, …) bring a second agent back: do not install them.

## 2. Install

| System | Command |
|---|---|
| macOS | `brew install --cask vscodium` |
| Windows (also with WSL: install the Windows build, open your WSL files through `\\wsl$`) | `winget install VSCodium.VSCodium` |
| Ubuntu | `sudo snap install codium --classic` |
| Other Linux | `flatpak install flathub com.vscodium.codium` (install flatpak first) |

Then, once: **Settings** (macOS `Cmd+,`, Windows/Linux `Ctrl+,`) → search **`disable AI features`**
→ tick it. In `settings.json` this is `"chat.disableAIFeatures": true` (checked in VSCodium 1.112).

Open your project: **File → Open Folder…** → `~/ai4se/calcapp` (or your mini-project).

## 3. Read the code

![VSCodium: the Explorer on the left, a source file on the right](img/ide-1-explorer.png)

The **Explorer** (left) shows the project tree. A file changed since the last commit is marked
**M** (modified) or **U** (new, untracked); the coloured bar in the margin marks changed lines.
Click a file to read it.

## 4. See what the agent changed

![VSCodium: a change shown line by line, added lines in green](img/ide-2-diff.png)

After opencode works, open **Source Control** (`Ctrl+Shift+G`, the branch icon with a number on
the left bar) and click a changed file: the editor shows the old and the new version, added lines
in green, removed lines in red. This is how you check the agent's work before you accept it — the
review habit of day 2.

Commits, branches and merges stay with opencode and GSE-One: **do not use the editor's
Commit or Sync buttons** — GSE-One records its own state with each commit.

## 5. Read the documents

![VSCodium: a Markdown plan shown as a formatted page](img/ide-3-markdown.png)

Plans, requirements and reviews are Markdown files (`docs/plan.md`, and from day 3 the files
under `docs/sprints/` such as `reqs.md` or `review.md`). Open one and press
`Cmd+Shift+V` (macOS) or `Ctrl+Shift+V` to see it formatted; right-click the tab → *Open Preview
to the Side* to keep source and preview side by side.

## 6. Fix one line yourself

You may correct a typo by hand: edit, **save** (`Cmd+S` / `Ctrl+S`), then tell opencode what you
changed so it does not undo it. Anything bigger: ask opencode.

## 7. You already use another editor

- **VS Code:** fine — same setting, `"chat.disableAIFeatures": true`; sign out of Copilot.
- **Cursor:** not during the workshops — its agent is the editor itself.
- **Any other editor:** turn its AI assistant and completion off for the course days.
