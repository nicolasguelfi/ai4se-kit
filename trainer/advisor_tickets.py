#!/usr/bin/env python3
"""AI4SE advisor tickets — the trainer advises, the learner decides (GSE-One >= 0.93.4).

The trainer never writes in a learner's repository. Advice goes in a GitHub issue labelled `gse-advisor`;
GSE-One studies those issues once per sprint, when the learner opens the next sprint (/gse-plan
--strategic): accept into the sprint, keep in the pool, or decline with a reason — and writes the
decision back on the issue.

  python3 advisor_tickets.py session --roster /private/roster.csv [--agent claude|opencode|codex|gemini]
        prepare the private folder of the roster for a coding-agent session (any agent) and print how to start it
  python3 advisor_tickets.py create --repo owner/name --title "..." --body-file advice.md [--dry-run]
        open one advisor ticket (creates the gse-advisor label on first use)
  python3 advisor_tickets.py list --roster /private/roster.csv     (or --repo owner/name)
        every advisor ticket and what the learner decided

Needs: python 3.9+, gh signed in (gh auth login) with access to the learners' repositories.
"""
from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from advisor import read_roster  # noqa: E402  (same roster as the advisor board)

LABEL = "gse-advisor"
LABEL_DESC = "Advice from an external advisor - studied by GSE-One when the next sprint opens (/gse-plan)"
FOOTER = ("\n\n---\n*Advisor ticket. GSE-One will show it to you when you open your next sprint (`/gse-plan`): "
          "accept it into the sprint, keep it in the pool, or decline it with a reason. The decision is yours.*\n")
PROCEDURE = HERE / "ADVISOR-SESSION.md"


def gh(args: list[str], check: bool = True) -> tuple[int, str]:
    p = subprocess.run(["gh", *args], capture_output=True, text=True)
    out = (p.stdout or "") + (p.stderr or "")
    if check and p.returncode:
        sys.exit(f"gh {' '.join(args[:3])}… failed: {out.strip()[:300]}")
    return p.returncode, out


def slug(repo: str) -> str:
    """owner/name from owner/name, https://github.com/owner/name(.git) or git@github.com:owner/name.git."""
    r = repo.strip().removesuffix(".git").rstrip("/")
    if "github.com" in r:
        r = r.split("github.com", 1)[1].lstrip("/:")
    return r


def cmd_session(a) -> int:
    folder = a.roster.expanduser().resolve().parent
    pointer = (f"# Advisor session (trainer)\n\nYou assist the course trainer as an external advisor. Before anything else, "
               f"read and follow this procedure, which overrides any other habit:\n\n{PROCEDURE}\n\n"
               f"Roster: {a.roster.expanduser().resolve()}\nTools: {HERE / 'advisor.py'} and {HERE / 'advisor_tickets.py'}\n")
    for name in ("AGENTS.md", "GEMINI.md"):
        (folder / name).write_text(pointer, encoding="utf-8")
    (folder / "CLAUDE.md").write_text(pointer + f"\n@{PROCEDURE}\n", encoding="utf-8")
    print(f"Session files written in {folder} (AGENTS.md for opencode/Codex, CLAUDE.md, GEMINI.md).")
    start = {"claude": "claude", "opencode": "opencode", "codex": "codex", "gemini": "gemini"}
    if a.agent:
        exe = start[a.agent]
        if not shutil.which(exe):
            return print(f"{exe} is not on PATH.") or 1
        os.chdir(folder)
        os.execvp(exe, [exe])
    print(f"Start your coding agent there:  cd '{folder}' && claude   (or opencode, codex, gemini)")
    return 0


def cmd_create(a) -> int:
    repo = slug(a.repo)
    body = a.body_file.read_text(encoding="utf-8").rstrip() + FOOTER
    if a.dry_run:
        print(f"[dry-run] {repo}: label {LABEL}; issue « {a.title} »\n{body}")
        return 0
    gh(["auth", "status"])
    rc, out = gh(["label", "create", LABEL, "-R", repo, "--color", "5319E7", "--description", LABEL_DESC], check=False)
    if rc and "already exists" not in out:
        sys.exit(f"cannot create the {LABEL} label on {repo}: {out.strip()[:300]}")
    _, url = gh(["issue", "create", "-R", repo, "--label", LABEL, "--title", a.title, "--body", body])
    print(url.strip())
    return 0


def cmd_list(a) -> int:
    repos = [slug(a.repo)] if a.repo else sorted({slug(r["repo"]) for r in read_roster(a.roster.expanduser())
                                                  if not Path(r["repo"]).expanduser().exists()})
    for repo in repos:
        rc, out = gh(["issue", "list", "-R", repo, "--label", LABEL, "--state", "all", "--limit", "100",
                      "--json", "number,title,state,stateReason,comments,url"], check=False)
        if rc:
            print(f"{repo}: not readable ({out.strip()[:120]})")
            continue
        issues = json.loads(out or "[]")
        print(f"{repo}: {len(issues)} advisor ticket(s)")
        for i in issues:
            last = (i.get("comments") or [{}])[-1].get("body", "").strip().splitlines()
            decision = last[0][:100] if last else "not studied yet (waits for the next /gse-plan)"
            print(f"  #{i['number']:<4} {i['state'].lower():<6} {i['title'][:60]:<60}  {decision}")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("session"); s.add_argument("--roster", required=True, type=Path)
    s.add_argument("--agent", choices=["claude", "opencode", "codex", "gemini"])
    c = sub.add_parser("create"); c.add_argument("--repo", required=True); c.add_argument("--title", required=True)
    c.add_argument("--body-file", required=True, type=Path); c.add_argument("--dry-run", action="store_true")
    l = sub.add_parser("list"); g = l.add_mutually_exclusive_group(required=True)
    g.add_argument("--roster", type=Path); g.add_argument("--repo")
    a = ap.parse_args()
    return {"session": cmd_session, "create": cmd_create, "list": cmd_list}[a.cmd](a)


if __name__ == "__main__":
    sys.exit(main())
