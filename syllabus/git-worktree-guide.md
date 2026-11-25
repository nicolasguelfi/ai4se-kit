# Branch or worktree? — a hello.py example

*Content licensed CC BY 4.0.*

**In one sentence:** a branch is another line of commits; a worktree is another folder where
one branch is checked out — so you can see and work on two branches at the same time.

**What you build:** a program that says hello in English, then French on a branch, German in a
worktree — and at the end, after two merges (one with a conflict), one program on `main` that
says hello in all three languages.

Checked with git 2.54. Every command below runs as written. It works in a throwaway folder,
`~/hello-demo`, that you delete at the end.

## 1. The picture

The course uses one picture for git (day 2, « Where Your Changes Live »):

| Git | Picture |
|---|---|
| your files on disk | **the scene**: what you arrange before the shot |
| `git add` | pose the subjects you want in the photo |
| `git commit` | **click the shutter**: a photo of the scene goes into the album |
| the repository (`.git`) | **the album**; it stores only what changed from one photo to the next |
| the history | each photo notes the one before it: photos form a **series** |
| a branch | a **bookmark** on the latest photo of a series |
| `git switch` | **rearrange the same scene** as on the latest photo of another series |
| a worktree | **one more scene**, in its own folder, for another series |
| a merge | one new photo with the retouches of two series |
| a conflict | both series retouched the same spot: you choose, or combine |

- **Branch only:** one scene. To go to another series, you rearrange it. What you have not
  photographed (not committed) stays on the scene and follows you into the other series.
- **Worktree:** several scenes side by side, one per series. Each keeps its arrangement; you
  see both at once. A bookmark sits on one scene at a time.

## 2. Set up

Create the folder and go into it:

```bash
mkdir ~/hello-demo && cd ~/hello-demo
```

Start a repository on `main`:

```bash
git init -b main
```

A program that says hello:

```bash
echo 'print("Hello")' > hello.py
```

Worktrees will live in `.worktrees/`; git must not track that folder:

```bash
echo '.worktrees/' > .gitignore
```

First photo:

```bash
git add hello.py .gitignore && git commit -m "hello in English"
```

```bash
python3 hello.py
```

It prints `Hello`.

## 3. Branch only — one scene

Create the branch `french` and switch to it:

```bash
git switch -c french
```

Add a French line to the program, **without committing**:

```bash
echo 'print("Bonjour")' >> hello.py
```

Go back to `main`:

```bash
git switch main
```

```bash
python3 hello.py
```

It prints `Hello` **and `Bonjour`**: the uncommitted line followed you onto `main`. Git only
moves what is in photos; what is still on the scene stays there.

Go back to `french` and take the photo:

```bash
git switch french && git commit -am "hello in French"
```

Now `main` says only `Hello`:

```bash
git switch main && python3 hello.py
```

And `french` says `Hello` and `Bonjour`:

```bash
git switch french && python3 hello.py
```

**What you saw:** one scene — the English version *or* the French one, never both at once;
and an uncommitted change travels with you when you switch.

Back to `main` for the next part:

```bash
git switch main
```

## 4. Worktree — a second scene

A second scene in `.worktrees/german`, on a new branch `german` that starts from `main`:

```bash
git worktree add -b german .worktrees/german main
```

Add a German line **in that scene**, without committing:

```bash
echo 'print("Hallo")' >> .worktrees/german/hello.py
```

Run both scenes:

```bash
python3 hello.py
```

```bash
python3 .worktrees/german/hello.py
```

The first prints `Hello`, the second `Hello` and `Hallo`: **two branches at the same time**.

The main scene is untouched — the German line stays in its own scene:

```bash
git status --short
```

It prints nothing. Take the German photo, from inside its scene:

```bash
cd .worktrees/german && git commit -am "hello in German" && cd ~/hello-demo
```

## 5. One album, three series

Your commit ids (the 7 characters) will differ from the ones shown here.

```bash
git log --oneline --all --graph
```

```text
* 7f550b1 hello in German
| * ed8bc38 hello in French
|/
* 435ae49 hello in English
```

The two scenes and their bookmarks:

```bash
git worktree list
```

A bookmark sits on one scene at a time — this is refused:

```bash
git switch german
```

```text
fatal: 'german' is already used by worktree at '…/hello-demo/.worktrees/german'
```

To work on `german`, go to its folder instead of switching. To use it on `main`, merge it.

## 6. First merge: French, no conflict

You are on `main`, in the main scene. Bring the French series in:

```bash
git merge french
```

```text
Fast-forward
```

`main` had no new photo since `french` started, so git just moves the `main` bookmark forward
to the French photo:

```bash
python3 hello.py
```

It prints `Hello` and `Bonjour`.

## 7. Second merge: German, a conflict

Now bring the German series in:

```bash
git merge german
```

```text
CONFLICT (content): Merge conflict in hello.py
Automatic merge failed; fix conflicts and then commit the result.
```

Both series retouched **the same spot** — the line after `Hello`: French put `Bonjour` there,
German put `Hallo`. Git cannot choose. It writes both versions into the file, between markers:

```bash
cat hello.py
```

```text
print("Hello")
<<<<<<< HEAD
print("Bonjour")
=======
print("Hallo")
>>>>>>> german
```

`HEAD` is what `main` has (French); `german` is what comes in. Here both are right: you
**combine** them. Write the file as you want it — no markers left:

```bash
printf 'print("Hello")\nprint("Bonjour")\nprint("Hallo")\n' > hello.py
```

In a real project you edit the file in your editor (VSCodium shows « Accept Both Changes »),
or ask opencode: « Resolve the conflict in hello.py: keep both lines. Show me the file. »

Tell git the conflict is solved, and take the merge photo:

```bash
git add hello.py && git commit -m "merge german: hello in three languages"
```

## 8. The result

```bash
python3 hello.py
```

```text
Hello
Bonjour
Hallo
```

The album: two series that split after the English photo, joined by the merge photo:

```bash
git log --oneline --all --graph
```

```text
*   7266797 merge german: hello in three languages
|\
| * 7f550b1 hello in German
* | ed8bc38 hello in French
|/
* 435ae49 hello in English
```

## 9. Clean up

Both series are in `main`: remove the second scene (its folder), then the two bookmarks:

```bash
git worktree remove .worktrees/german
```

```bash
git branch -d french german
```

Only `main` is left, in one scene:

```bash
git branch && git worktree list
```

Delete the whole example:

```bash
cd ~ && rm -rf ~/hello-demo
```

## 10. When to use which

| | Branch only | Worktree per task |
|---|---|---|
| change task | commit (or put aside) first, then `git switch` | go to the task's folder; nothing to put away |
| urgent fix in the middle of a task | put the task aside first | open another scene; the task stays as it is |
| two tasks at once (you and the agent, or several agents) | no | yes, one scene each |
| disk space | one copy of the files | one copy per worktree (+ its own `npm ci`) |
| commands | anywhere in the project | in the right folder: a command at the root acts on the root's branch |

Branches or worktrees, the merge is the same: the work of each series comes back to `main`,
and a conflict appears when two series changed the same spot.

One task at a time, no interruptions: a branch is enough. Interruptions, parallel work, an agent
working while you review: a worktree per task — what GSE-One does from day 3 (`.worktrees/…`,
one per task, merged after your decision). Small projects can turn it off with
`git.strategy: branch-only` in `.gse/config.yaml`.

See also: [glossary](glossary.md) (Branch, Commit, Merge, Worktree),
[opencode-guide](opencode-guide.md), [gse-guide](gse-guide.md).
