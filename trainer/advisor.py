#!/usr/bin/env python3
"""AI4SE advisor board — the trainer's read-only view of every learner's project.

For each repository of a private roster, it fetches the latest state from the remote (or reads a local
folder), reads what GSE-One keeps in the repository (`.gse/config.yaml`, `plan.yaml`, `status.yaml`,
`backlog.yaml`, `decisions.md`, `deploy.json`, the sprint review) and the git history, and writes ONE local
HTML page: one row per learner and project, the rows that need attention first.

  python3 advisor.py --roster /private/place/roster.csv            # fetch, then write advisor.html next to the roster
  python3 advisor.py --roster roster.csv --no-fetch --no-http      # offline: reuse the cache, do not call the apps

Asynchronous by design: nothing runs on the learners' machines and nothing is asked of them beyond pushing
their work. Run it whenever you want a fresh view. It sees only what has been pushed.

Read-only: it never writes to a learner's repository (clones live in a cache folder). The roster and the
page hold learners' names: keep them in a private folder, never in a repository.
Needs: python 3.9+, git; PyYAML (`pip install pyyaml`) for full detail — without it a reduced view is shown.
"""
from __future__ import annotations

import argparse
import csv
import datetime as dt
import html
import json
import re
import subprocess
import sys
import urllib.request
from pathlib import Path

try:
    import yaml  # type: ignore
except ImportError:  # reduced view
    yaml = None

NOW = dt.datetime.now(dt.timezone.utc)


def run(args: list[str], cwd: Path | None = None, timeout: int = 90) -> tuple[int, str]:
    try:
        p = subprocess.run(args, cwd=cwd, capture_output=True, text=True, timeout=timeout,
                           env={"GIT_TERMINAL_PROMPT": "0", "PATH": "/usr/bin:/bin:/usr/local/bin:/opt/homebrew/bin",
                                "HOME": str(Path.home())})
        return p.returncode, (p.stdout or "") + (p.stderr or "")
    except (subprocess.TimeoutExpired, OSError) as e:
        return 124, str(e)


def read_roster(path: Path) -> list[dict]:
    """CSV with a header: id,name,repo[,project][,url]. Lines starting with # are ignored.
    `repo` is a GitHub address (https or owner/name) or a local folder; one line per repository."""
    rows = []
    with path.open(newline="", encoding="utf-8") as fh:
        lines = [l for l in fh if l.strip() and not l.lstrip().startswith("#")]
    for r in csv.DictReader(lines):
        r = {k.strip().lower(): (v or "").strip() for k, v in r.items() if k}
        if r.get("id") and r.get("repo"):
            rows.append(r)
    return rows


def sync(entry: dict, cache: Path, fetch: bool) -> tuple[Path | None, str, str]:
    """Return (git dir to read, ref namespace, problem). Local folders are read in place."""
    repo = entry["repo"]
    local = Path(repo).expanduser()
    if local.exists():
        return (local, "refs/heads", "") if (local / ".git").exists() else (None, "", "not a git repository")
    url = repo if "://" in repo or repo.startswith("git@") else f"https://github.com/{repo.strip('/')}"
    slug = re.sub(r"[^A-Za-z0-9_.-]+", "_", url.split("github.com")[-1].strip("/:").removesuffix(".git"))
    dest = cache / entry["id"] / slug
    if not dest.exists():
        if not fetch:
            return None, "", "not in the cache yet (run without --no-fetch)"
        dest.parent.mkdir(parents=True, exist_ok=True)
        rc, out = run(["git", "clone", "--quiet", "--no-checkout", url, str(dest)], timeout=180)
        if rc:
            return None, "", "cannot read the repository (private and not invited, or wrong address)"
    if dest.exists():  # read-only by construction: an invited collaborator could push, the clone cannot
        run(["git", "remote", "set-url", "--push", "origin", "DISABLED-advisor-clones-are-read-only"], dest, timeout=10)
    if dest.exists() and fetch:
        rc, out = run(["git", "fetch", "--quiet", "--prune", "--tags", "origin"], dest, timeout=120)
        if rc:
            return dest, "refs/remotes/origin", "fetch failed — showing the last state read"
    return dest, "refs/remotes/origin", ""


def show(git: Path, ref: str, path: str) -> str | None:
    rc, out = run(["git", "show", f"{ref}:{path}"], git, timeout=30)
    return None if rc else out


def load(text: str | None):
    if text is None or yaml is None:
        return None
    try:
        return yaml.safe_load(text)
    except Exception:  # a learner's file may be broken: that is a finding, not a crash
        return "BROKEN"


def grab(text: str | None, key: str) -> str:
    """Fallback without PyYAML: first `key: value` of a file."""
    m = re.search(rf"^\s*{re.escape(key)}:\s*\"?([^\"#\n]*)", text or "", re.M)
    return m.group(1).strip() if m else ""


def parse_time(s) -> dt.datetime | None:
    try:
        t = dt.datetime.fromisoformat(str(s).replace("Z", "+00:00"))
        return t if t.tzinfo else t.replace(tzinfo=dt.timezone.utc)
    except (ValueError, TypeError):
        return None


def ago(t: dt.datetime | None) -> str:
    if not t:
        return "—"
    m = int((NOW - t).total_seconds() // 60)
    if m < 0:
        return "now"
    if m < 60:
        return f"{m} min"
    if m < 60 * 36:
        return f"{m // 60} h {m % 60:02d}"
    return f"{m // 1440} d"


def http_status(url: str) -> str:
    try:
        req = urllib.request.Request(url, method="GET", headers={"User-Agent": "ai4se-advisor"})
        with urllib.request.urlopen(req, timeout=12) as r:
            return str(r.status)
    except urllib.error.HTTPError as e:
        return str(e.code)
    except Exception:
        return "no answer"


def inspect(entry: dict, cache: Path, fetch: bool, http: bool, stale_min: int) -> dict:
    d: dict = {"id": entry["id"], "name": entry.get("name", ""), "project": entry.get("project", ""),
               "repo": entry["repo"], "alerts": [], "notes": []}
    git, ns, problem = sync(entry, cache, fetch)
    if problem:
        (d["alerts"] if git is None else d["notes"]).append(problem)
    if git is None:
        d["score"] = 100
        return d
    rc, out = run(["git", "for-each-ref", "--sort=-committerdate", "--count=30",
                   "--format=%(refname)\t%(committerdate:iso8601-strict)\t%(subject)", ns], git)
    refs = [l.split("\t") for l in out.splitlines() if "\t" in l and not l.split("\t")[0].endswith("/HEAD")]
    if not refs:
        d["alerts"].append("empty repository: nothing pushed yet")
        d["score"] = 90
        return d
    ref, when, subject = refs[0]
    d["branch"] = ref.replace(ns + "/", "")
    d["last_commit"] = parse_time(when)
    d["last_subject"] = subject[:90]
    d["branches"] = len(refs)
    since = NOW.astimezone().replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
    rc, out = run(["git", "rev-list", "--count", f"--since={since}", "--all" if ns == "refs/heads" else "--remotes"], git)
    d["commits_today"] = int(out.strip()) if rc == 0 and out.strip().isdigit() else 0
    if not d["project"]:
        d["project"] = Path(entry["repo"].rstrip("/")).name.removesuffix(".git")

    # GSE-One state: read on the freshest branch that has it (work lives on sprint and task branches).
    state_ref = next((r[0] for r in refs if show(git, r[0], ".gse/config.yaml") is not None), None)
    if state_ref is None:
        d["gse"] = False
        ignore = show(git, ref, ".gitignore") or ""
        if re.search(r"^\s*/?\.gse/?\s*$", ignore, re.M):
            d["alerts"].append("`.gse/` is in .gitignore: the GSE-One state is not shared — remove that line, commit `.gse/`, push")
        else:
            d["notes"].append("no GSE-One state in the repository (days 1-2, or GSE-One not started yet)")
    else:
        d["gse"] = True
        d["state_branch"] = state_ref.replace(ns + "/", "")
        t = {n: show(git, state_ref, f".gse/{n}") for n in
             ("config.yaml", "plan.yaml", "status.yaml", "backlog.yaml", "decisions.md", "deploy.json")}
        cfg, plan, status, backlog = (load(t[n]) for n in ("config.yaml", "plan.yaml", "status.yaml", "backlog.yaml"))
        for name, obj in (("config.yaml", cfg), ("plan.yaml", plan), ("status.yaml", status), ("backlog.yaml", backlog)):
            if obj == "BROKEN":
                d["alerts"].append(f".gse/{name} cannot be read (broken YAML)")
        ok = lambda o: isinstance(o, dict)
        d["mode"] = ((cfg.get("lifecycle") or {}).get("mode") if ok(cfg) else None) or grab(t["config.yaml"], "mode") or "?"
        d["gse_version"] = (status.get("gse_version") if ok(status) else None) or grab(t["status.yaml"], "gse_version")
        if ok(plan):
            wf = plan.get("workflow") or {}
            d["sprint"] = plan.get("sprint")
            d["sprint_status"] = plan.get("status")
            d["active"] = wf.get("active")
            d["pending"] = [str(x) for x in (wf.get("pending") or [])]
            d["done_steps"] = [str((x or {}).get("activity", x)) if isinstance(x, dict) else str(x) for x in (wf.get("completed") or [])]
            b = plan.get("budget") or {}
            d["budget"] = (b.get("consumed"), b.get("total"))
            d["goal"] = str(plan.get("goal") or "")[:160]
        elif t["plan.yaml"] is None:
            d["notes"].append("no sprint plan yet")
        else:
            d["sprint"], d["sprint_status"], d["active"] = grab(t["plan.yaml"], "sprint"), grab(t["plan.yaml"], "status"), grab(t["plan.yaml"], "active")
        if ok(status):
            d["last_activity"] = status.get("last_activity")
            d["health"] = (status.get("health") or {}).get("score")
            d["paused"] = bool(status.get("session_paused"))
            d["findings_open"] = status.get("review_findings_open")
        items = (backlog.get("items") if ok(backlog) else None) or []
        tasks = [i for i in items if isinstance(i, dict)]
        cur = [i for i in tasks if d.get("sprint") in (None, "", i.get("sprint")) or i.get("sprint") == d.get("sprint")]
        counts: dict[str, int] = {}
        for i in cur:
            counts[str(i.get("status", "?"))] = counts.get(str(i.get("status", "?")), 0) + 1
        d["tasks"] = counts
        d["tasks_total"] = len(cur)
        ev = [(i.get("test_evidence") or {}) for i in cur if str(i.get("status")) in ("review", "reviewed", "fixing", "done", "delivered")]
        d["tests"] = {"with": sum(1 for e in ev if str(e.get("status")) == "pass"), "of": len(ev),
                      "fail": sum(1 for e in ev if str(e.get("status")) == "fail")}
        rates = [e.get("pass_rate") for e in ev if isinstance(e.get("pass_rate"), (int, float))]
        d["pass_rate"] = round(sum(rates) / len(rates)) if rates else None
        d["decisions"] = len(re.findall(r"^#{1,4}\s*DEC-\d+", t["decisions.md"] or "", re.M)) or len(set(re.findall(r"\bDEC-\d+", t["decisions.md"] or "")))
        d["deviations"] = len(re.findall(r"deviation|override|accept(?:ed)? the risk|--skip-tests", t["decisions.md"] or "", re.I))
        rc, out = run(["git", "ls-tree", "-r", "--name-only", state_ref, "docs/sprints"], git)
        reviews = sorted(p for p in out.splitlines() if p.endswith("/review.md"))
        if reviews:
            rv = show(git, state_ref, reviews[-1]) or ""
            blocks = re.split(r"(?=RVW-\d+)", rv)
            d["high_open"] = sum(1 for b in blocks if re.search(r"\bHIGH\b", b[:400]) and not re.search(r"status:\s*(fixed|resolved|accepted)|✅", b[:600], re.I))
        d["docs"] = sorted({Path(p).name for p in out.splitlines() if p.count("/") == 3})
        try:
            dep = json.loads(t["deploy.json"]) if t["deploy.json"] else {}
            apps = dep.get("applications") or []
            if apps and not entry.get("url"):
                entry["url"] = (apps[-1] or {}).get("url", "")
        except ValueError:
            pass

    if entry.get("url"):
        d["url"] = entry["url"]
        d["url_status"] = http_status(entry["url"]) if http else "not checked"

    # What needs the trainer first.
    mins = (NOW - d["last_commit"]).total_seconds() / 60 if d.get("last_commit") else 10 ** 6
    if mins > stale_min:
        d["alerts"].append(f"nothing pushed for {ago(d.get('last_commit'))}")
    if d.get("gse"):
        if d.get("tests", {}).get("fail"):
            d["alerts"].append(f"{d['tests']['fail']} task(s) with failing tests")
        if d.get("tests", {}).get("of") and d["tests"]["with"] < d["tests"]["of"]:
            d["alerts"].append(f"{d['tests']['of'] - d['tests']['with']} produced task(s) without passing test evidence")
        declared = d.get("findings_open")
        if isinstance(declared, int) and declared > 0:
            d["alerts"].append(f"{declared} review finding(s) declared open")
        elif d.get("high_open") and d.get("sprint_status") != "completed":
            d["alerts"].append(f"{d['high_open']} HIGH review finding(s) — check that they are closed")
        b = d.get("budget") or (None, None)
        if isinstance(b[0], (int, float)) and isinstance(b[1], (int, float)) and b[1] and b[0] > b[1]:
            d["alerts"].append(f"over budget ({b[0]}/{b[1]} points)")
        if d.get("paused"):
            d["notes"].append("session paused (/gse-pause)")
    if d.get("url") and d.get("url_status") not in ("200", "not checked"):
        d["alerts"].append(f"live app does not answer ({d['url_status']})")
    d["score"] = len(d["alerts"]) * 10 + (5 if not d.get("gse") else 0)
    return d


CSS = """
:root{--bg:#f6f7f9;--card:#fff;--ink:#16202b;--mute:#5d6b7a;--line:#dfe4ea;--ok:#157347;--okbg:#e3f4ea;--warn:#8a5200;--warnbg:#fdf0d5;--bad:#a61b29;--badbg:#fbe3e6;--acc:#1f5fbf}
@media (prefers-color-scheme:dark){:root:not([data-theme=light]){--bg:#11161c;--card:#1a212a;--ink:#e8edf2;--mute:#9aa7b4;--line:#2c3743;--ok:#6fd39a;--okbg:#153524;--warn:#f0c36a;--warnbg:#3a2e12;--bad:#ff8f9a;--badbg:#43181e;--acc:#7fb2ff}}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:15px/1.45 system-ui,-apple-system,Segoe UI,sans-serif}
main{max-width:1500px;margin:0 auto;padding:20px 16px 60px}h1{font-size:22px;margin:0 0 2px}.sub{color:var(--mute);margin:0 0 16px}
.sum{display:flex;gap:10px;flex-wrap:wrap;margin:0 0 16px}.sum div{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:8px 14px}.sum b{font-size:20px;display:block}
.wrap{overflow-x:auto;background:var(--card);border:1px solid var(--line);border-radius:12px}table{border-collapse:collapse;width:100%;min-width:1080px}
th:nth-child(4),td:nth-child(4){min-width:230px}th:nth-child(3),td:nth-child(3){min-width:120px;white-space:nowrap}td:nth-child(7){max-width:420px}td:nth-child(7) .chip{white-space:normal;border-radius:10px}
th,td{padding:9px 10px;text-align:left;vertical-align:top;border-bottom:1px solid var(--line)}th{font-size:12px;text-transform:uppercase;letter-spacing:.04em;color:var(--mute);position:sticky;top:0;background:var(--card)}
tr:last-child td{border-bottom:0}.id{font-weight:700;font-variant-numeric:tabular-nums}.mute{color:var(--mute);font-size:13px}
.chip{display:inline-block;padding:1px 8px;border-radius:999px;font-size:12.5px;margin:1px 3px 1px 0;border:1px solid var(--line);white-space:nowrap}
.ok{color:var(--ok);background:var(--okbg);border-color:transparent}.warn{color:var(--warn);background:var(--warnbg);border-color:transparent}.bad{color:var(--bad);background:var(--badbg);border-color:transparent}
a{color:var(--acc)}details{margin-top:4px}summary{cursor:pointer;color:var(--mute);font-size:13px}code{font-size:12.5px}
.bar{height:6px;border-radius:3px;background:var(--line);overflow:hidden;width:110px;margin-top:4px}.bar i{display:block;height:100%;background:var(--acc)}
"""


def e(x) -> str:
    return html.escape(str(x if x is not None else ""))


def chip(text, cls="") -> str:
    return f'<span class="chip {cls}">{e(text)}</span>'


def render(rows: list[dict], roster: Path, stale_min: int) -> str:
    rows = sorted(rows, key=lambda r: (-r["score"], r["id"], r.get("project", "")))
    people = len({r["id"] for r in rows})
    need = sum(1 for r in rows if r["alerts"])
    live = sum(1 for r in rows if r.get("url_status") == "200")
    out = [f"<!doctype html><html lang='en'><head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'>"
           f"<title>AI4SE advisor board</title><style>{CSS}</style></head><body><main>",
           "<h1>AI4SE advisor board</h1>",
           f"<p class='sub'>Read {NOW.astimezone():%Y-%m-%d %H:%M} · roster <code>{e(roster.name)}</code> · only what has been pushed is visible · "
           f"“quiet” = nothing pushed for more than {stale_min} min · private page: learners' names inside</p>",
           f"<div class='sum'><div><b>{people}</b>learners</div><div><b>{len(rows)}</b>projects</div>"
           f"<div><b>{need}</b>need attention</div><div><b>{live}</b>apps answering</div></div>",
           "<div class='wrap'><table><thead><tr><th>Learner</th><th>Project</th><th>Last push · commits</th><th>Where they are</th>"
           "<th>Tasks</th><th>Tests</th><th>Alerts</th><th>Live app</th></tr></thead><tbody>"]
    for r in rows:
        who = f"<span class='id'>{e(r['id'])}</span><br><span class='mute'>{e(r.get('name'))}</span>"
        repo = r["repo"]
        link = repo if "://" in repo else (f"https://github.com/{repo}" if re.fullmatch(r"[\w.-]+/[\w.-]+", repo) else "")
        proj = (f"<a href='{e(link)}'>{e(r.get('project'))}</a>" if link else e(r.get("project"))) + \
               (f"<br><span class='mute'>{e(r.get('branch'))}</span>" if r.get("branch") else "")
        push = f"{e(ago(r.get('last_commit')))} ago<br><span class='mute'>{r.get('commits_today', 0)} today</span>" if r.get("last_commit") else "—"
        if r.get("gse"):
            done, pend = r.get("done_steps", []), r.get("pending", [])
            total = len(done) + len(pend) + (1 if r.get("active") else 0)
            steps = (chip("▶ " + str(r["active"]), "warn") if r.get("active") else "") + \
                    (f"<span class='mute'>{len(done)}/{total} steps done" + (f" · last: {e(done[-1])}" if done else "") +
                     (f" · next: {e(pend[0])}" if pend else "") + "</span>" if total else "")
            where = f"{chip(r.get('mode'))}sprint {e(r.get('sprint', '?'))} {chip(r.get('sprint_status') or '?', 'ok' if r.get('sprint_status') == 'completed' else '')}<br>{steps}"
            where += f"<br><span class='mute'>GSE-One {e(r.get('gse_version') or '?')}</span>"
            order = ["open", "planned", "in-progress", "review", "fixing", "reviewed", "done", "delivered", "deferred"]
            tc = r.get("tasks") or {}
            tasks = "".join(chip(f"{tc[k]} {k}", "ok" if k in ("delivered", "done", "reviewed") else "warn" if k in ("in-progress", "review", "fixing") else "")
                            for k in order + sorted(set(tc) - set(order)) if tc.get(k)) or "<span class='mute'>none</span>"
            b = r.get("budget") or (None, None)
            if isinstance(b[0], (int, float)) and isinstance(b[1], (int, float)) and b[1]:
                tasks += f"<div class='mute'>{b[0]}/{b[1]} points</div><div class='bar'><i style='width:{min(100, round(100 * b[0] / b[1]))}%'></i></div>"
            ts = r.get("tests") or {}
            tests = "<span class='mute'>nothing produced yet</span>" if not ts.get("of") else (chip(f"{ts.get('with', 0)}/{ts.get('of', 0)} with passing tests", "ok" if ts.get("of") and ts.get("with") == ts.get("of") else "warn" if ts.get("of") else "")
                     + (f"<br><span class='mute'>pass rate {r['pass_rate']} % (declared)</span>" if r.get("pass_rate") is not None else ""))
        else:
            where = "<span class='mute'>no GSE-One state</span>"
            tasks = tests = "<span class='mute'>—</span>"
        alerts = "".join(chip(a, "bad") for a in r["alerts"]) or chip("nothing to flag", "ok")
        alerts += "".join(f"<br><span class='mute'>{e(n)}</span>" for n in r["notes"])
        det = []
        if r.get("goal"):
            det.append(f"goal: {e(r['goal'])}")
        if r.get("last_subject"):
            det.append(f"last commit: {e(r['last_subject'])}")
        if r.get("gse"):
            det.append(f"decisions recorded: {r.get('decisions', 0)} · mentions of deviations or accepted risks: {r.get('deviations', 0)}"
                       + (f" · health {r['health']}" if r.get("health") is not None else "")
                       + (f" · HIGH findings not closed: {r['high_open']}" if r.get("high_open") is not None else ""))
            if r.get("done_steps") or r.get("pending"):
                det.append("steps done: " + (", ".join(e(x) for x in r.get("done_steps", [])) or "none") +
                           " · left: " + (", ".join(e(x) for x in r.get("pending", [])) or "none"))
            if r.get("docs"):
                det.append("sprint documents: " + ", ".join(e(x) for x in r["docs"]))
            if r.get("state_branch") and r["state_branch"] != r.get("branch"):
                det.append(f"GSE-One state read on branch {e(r['state_branch'])}")
        if det:
            alerts += "<details><summary>details</summary><div class='mute'>" + "<br>".join(det) + "</div></details>"
        if r.get("url"):
            st = r.get("url_status")
            app = f"<a href='{e(r['url'])}'>{e(re.sub(r'^https?://', '', r['url']))}</a><br>" + chip(st, "ok" if st == "200" else "" if st == "not checked" else "bad")
        else:
            app = "<span class='mute'>—</span>"
        out.append(f"<tr><td>{who}</td><td>{proj}</td><td>{push}</td><td>{where}</td><td>{tasks}</td><td>{tests}</td><td>{alerts}</td><td>{app}</td></tr>")
    out.append("</tbody></table></div><p class='mute'>Facts read from each repository, not verdicts: a figure is what the learner's "
               "GSE-One state declares; tests are not re-run here. A learner who works without pushing looks quiet.</p></main></body></html>")
    return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser(description="Trainer's read-only board of the learners' projects (AI4SE).")
    ap.add_argument("--roster", required=True, type=Path, help="private CSV: id,name,repo[,project][,url]")
    ap.add_argument("--out", type=Path, help="HTML page to write (default: advisor.html next to the roster)")
    ap.add_argument("--cache", type=Path, help="folder for the read-only clones (default: .advisor-cache next to the roster)")
    ap.add_argument("--no-fetch", action="store_true", help="do not contact GitHub: reuse the cache")
    ap.add_argument("--no-http", action="store_true", help="do not call the live applications")
    ap.add_argument("--stale-min", type=int, default=120, help="minutes without a push before a project is flagged quiet (default 120)")
    a = ap.parse_args()
    roster = a.roster.expanduser().resolve()
    if not roster.exists():
        print(f"roster not found: {roster}", file=sys.stderr)
        return 2
    out = a.out or roster.parent / "advisor.html"
    cache = a.cache or roster.parent / ".advisor-cache"
    entries = read_roster(roster)
    if not entries:
        print("the roster has no usable line (needs the header id,name,repo and at least one row)", file=sys.stderr)
        return 2
    if yaml is None:
        print("note: PyYAML is not installed — reduced view (pip install pyyaml for tasks, tests and steps)", file=sys.stderr)
    rows = []
    for en in entries:
        rows.append(inspect(en, cache, not a.no_fetch, not a.no_http, a.stale_min))
        r = rows[-1]
        print(f"{r['id']:>6}  {r.get('project', ''):<22} {ago(r.get('last_commit')):>9}  {len(r['alerts'])} alert(s)")
    out.write_text(render(rows, roster, a.stale_min), encoding="utf-8")
    print(f"\n{len(rows)} project(s) → {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
