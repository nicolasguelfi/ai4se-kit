#!/usr/bin/env bash
# AI4SE course VM template — step 1: system part (run ONCE in the template, with sudo).
#
#   sudo bash 1-system.sh [student-user]        (default user: the one who called sudo)
#
# Installs what needs root and is the same for every learner:
#   - base tools: git, curl, build tools, python3 + venv, jq, sqlite3, tree, unzip;
#   - GitHub CLI (gh) from the official GitHub apt repository;
#   - Node.js LTS from NodeSource (system-wide: no nvm needed in the VM);
#   - time zone Europe/Luxembourg;
#   - VS Code settings for the course (editor AI off, no telemetry, no update or
#     release-notes pop-ups, no extension recommendations) for the student user
#     and for /etc/skel (accounts created later).
# Never installs a key, a login or an identity. Safe to run again (idempotent).
#
# Options (environment): NODE_MAJOR=24 (Node.js major version), SKIP_UPGRADE=1
# (do not run apt-get upgrade), TZ_NAME=Europe/Luxembourg.

set -euo pipefail

NODE_MAJOR="${NODE_MAJOR:-24}"
TZ_NAME="${TZ_NAME:-Europe/Luxembourg}"

say()  { printf '\n== %s\n' "$*"; }
step() { printf '  - %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || die "run it with sudo: sudo bash $0"
. /etc/os-release
[ "${ID:-}" = "ubuntu" ] || die "this script is for Ubuntu (found: ${ID:-unknown})"

STUDENT="${1:-${SUDO_USER:-}}"
[ -n "$STUDENT" ] && [ "$STUDENT" != "root" ] || die "give the student user name: sudo bash $0 student"
id "$STUDENT" >/dev/null 2>&1 || die "user '$STUDENT' does not exist"
STUDENT_HOME=$(getent passwd "$STUDENT" | cut -d: -f6)

export DEBIAN_FRONTEND=noninteractive
APT="apt-get -y -q -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold"

say "Ubuntu ${VERSION_ID:-?} — student user: $STUDENT ($STUDENT_HOME)"

# --- 1. packages ----------------------------------------------------------------
say "1. System update and base tools"
apt-get update -q
if [ "${SKIP_UPGRADE:-0}" != "1" ]; then $APT upgrade; fi
$APT install git curl wget ca-certificates gnupg build-essential python3 python3-venv \
  python3-pip jq sqlite3 tree unzip xdg-utils
step "base tools installed"

# --- 2. GitHub CLI --------------------------------------------------------------
say "2. GitHub CLI (gh)"
if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
  install -d -m 755 /etc/apt/keyrings
  wget -nv -O /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    https://cli.github.com/packages/githubcli-archive-keyring.gpg
  chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  printf 'deb [arch=%s signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\n' \
    "$(dpkg --print-architecture)" > /etc/apt/sources.list.d/github-cli.list
  apt-get update -q
fi
$APT install gh
step "$(gh --version | head -n 1)"

# --- 3. Node.js -----------------------------------------------------------------
say "3. Node.js $NODE_MAJOR LTS"
cur=$(node --version 2>/dev/null | sed 's/^v//; s/\..*//' || true)
if [ "${cur:-0}" != "$NODE_MAJOR" ]; then
  curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -
  $APT install nodejs
fi
step "node $(node --version), npm $(npm --version)"

# --- 4. time zone ---------------------------------------------------------------
say "4. Time zone"
if command -v timedatectl >/dev/null 2>&1 && timedatectl set-timezone "$TZ_NAME" 2>/dev/null; then :
else ln -sf "/usr/share/zoneinfo/$TZ_NAME" /etc/localtime; printf '%s\n' "$TZ_NAME" > /etc/timezone
fi
step "$TZ_NAME"

# --- 5. VS Code settings --------------------------------------------------------
say "5. VS Code settings for the course"
write_vscode_settings() {  # $1 = settings.json path; merges, keeps the user's other keys
  python3 - "$1" <<'PY'
import json, os, sys
path = sys.argv[1]
course = {
    "chat.disableAIFeatures": True,          # the editor's own AI is off: only opencode writes code
    "chat.commandCenter.enabled": False,
    "telemetry.telemetryLevel": "off",
    "update.mode": "none",                   # same version for the whole week
    "update.showReleaseNotes": False,
    "workbench.startupEditor": "none",
    "workbench.welcomePage.walkthroughs.openOnInstall": False,
    "extensions.ignoreRecommendations": True,  # no "install the Docker extensions?" pop-up
    "git.autofetch": False,
    "git.openRepositoryInParentFolders": "never",
    "files.autoSave": "afterDelay",
    "workbench.editorAssociations": {"*.md": "vscode.markdown.preview.editor"},
}
data = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except Exception:
        os.replace(path, path + ".bak")
        print(f"  ! {path} was not plain JSON: kept as {path}.bak")
data.update(course)
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
}
if command -v code >/dev/null 2>&1 || [ -d /usr/share/code ] || [ -d /snap/code ]; then
  # create the student's folders as the student (a root-owned ~/.config would break gh, opencode…)
  install -d -o "$STUDENT" -g "$(id -gn "$STUDENT")" "$STUDENT_HOME/.config" "$STUDENT_HOME/.config/Code" \
    "$STUDENT_HOME/.config/Code/User"
  for home in "$STUDENT_HOME" /etc/skel; do
    f="$home/.config/Code/User/settings.json"
    write_vscode_settings "$f"
    step "settings written: $f"
  done
  chown "$STUDENT:$(id -gn "$STUDENT")" "$STUDENT_HOME/.config/Code/User/settings.json"
else
  step "VS Code not found: settings skipped"
fi

# --- 6. tidy --------------------------------------------------------------------
say "6. Clean the package cache"
$APT autoremove
apt-get clean
step "done"

say "System part finished. Next: log in as '$STUDENT' and run  bash 2-student.sh"
