#!/bin/sh
# AI4SE learner checklist — read-only. Prints one green ✓ or red ✗ line per check,
# with a one-line fix hint for each ✗. Exit code 0 only if everything is green.
#
#   sh ~/ai4se/ai4se-kit/check-learner.sh
#
# Run it from your project folder: GSE-One is usually installed per project.
# Writes nothing, prints no secret (the model-key store is only tested for existence).

GSE_EXPECTED="0.90.0"
OPENCODE_MIN="2.0.0"
NODE_MIN="20.19.0"   # Vite 7 needs Node 20.19+ (or 22.12+)

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  GREEN=$(printf '\033[32m'); RED=$(printf '\033[31m'); DIM=$(printf '\033[2m'); RESET=$(printf '\033[0m')
else
  GREEN=""; RED=""; DIM=""; RESET=""
fi
FAILS=0
ok()  { printf '%s✓%s %s\n' "$GREEN" "$RESET" "$1"; }
ko()  { printf '%s✗%s %s\n    %s→ %s%s\n' "$RED" "$RESET" "$1" "$DIM" "$2" "$RESET"; FAILS=$((FAILS + 1)); }
has() { command -v "$1" >/dev/null 2>&1; }
# first x.y[.z] number in a string
vnum() { printf '%s\n' "$1" | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1; }
# ver_ge A B  -> true if A >= B
ver_ge() {
  awk -v a="$1" -v b="$2" 'BEGIN {
    na = split(a, x, "."); nb = split(b, y, ".")
    for (i = 1; i <= 3; i++) { p = (i <= na) ? x[i] + 0 : 0; q = (i <= nb) ? y[i] + 0 : 0
      if (p > q) exit 0; if (p < q) exit 1 }
    exit 0 }'
}

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/opencode"
AI4SE_HOME="${AI4SE_HOME:-$HOME/ai4se}"
KIT_DIR="$AI4SE_HOME/ai4se-kit"
AI4SE_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/ai4se"

printf 'AI4SE learner checklist (folder: %s)\n\n' "$(pwd)"

# 1. opencode >= 2
if has opencode; then
  v=$(vnum "$(opencode --version 2>/dev/null)")
  if [ -n "$v" ] && ver_ge "$v" "$OPENCODE_MIN"; then
    ok "opencode $v"
  else
    ko "opencode ${v:-?} is too old (need $OPENCODE_MIN or newer)" "update opencode (see the installation slide), then re-run the GSE-One installer"
  fi
else
  ko "opencode is not installed" "install opencode (see the installation slide), then open a new terminal"
fi

# 2. model provider configured — existence only, the key itself is never printed.
#    OpenCode 2 keeps credentials in its SQLite database; `opencode auth list` shows
#    connection names only (no secret). OpenCode 1 used auth.json in the data dir.
auth=""
if has opencode; then
  auth=$(opencode auth list --standalone --format json 2>/dev/null) || auth=""
fi
if printf '%s' "$auth" | grep -Eq '"type": *"credential"'; then
  ok "opencode model provider configured (stored credential)"
elif printf '%s' "$auth" | grep -Eq '"type": *"env"'; then
  ok "opencode model provider configured (key from an environment variable)"
elif [ -s "$DATA_DIR/auth.json" ] && [ "$(tr -d ' \t\r\n' < "$DATA_DIR/auth.json")" != "{}" ]; then
  ok "opencode model provider configured (legacy $DATA_DIR/auth.json)"
else
  ko "no model provider configured for opencode" "run: opencode auth login  (paste the key from your paper sheet — never in a file or a chat)"
fi

# 3. GSE-One pinned version (project install first, then machine install)
gse_ver=""; gse_where=""
if [ -s .gse/registry ]; then
  reg=$(head -n 1 .gse/registry)
  if [ -f "$reg/VERSION" ]; then gse_ver=$(head -n 1 "$reg/VERSION"); gse_where="this project ($reg)"; fi
fi
if [ -z "$gse_ver" ] && [ -f .opencode/VERSION ]; then
  gse_ver=$(head -n 1 .opencode/VERSION); gse_where="this project (.opencode)"
fi
if [ -z "$gse_ver" ] && [ -s "$HOME/.gse-one" ]; then
  reg=$(head -n 1 "$HOME/.gse-one")
  if [ -f "$reg/VERSION" ]; then gse_ver=$(head -n 1 "$reg/VERSION"); gse_where="machine ($reg)"; fi
fi
if [ -z "$gse_ver" ] && [ -f "$CONFIG_DIR/VERSION" ]; then
  gse_ver=$(head -n 1 "$CONFIG_DIR/VERSION"); gse_where="machine ($CONFIG_DIR)"
fi
gse_ver=$(printf '%s' "$gse_ver" | tr -d ' v\r')
GSE_FIX="curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/gensem/v$GSE_EXPECTED/install.sh | GSE_PLATFORM=opencode GSE_VERSION=v$GSE_EXPECTED sh"
if [ "$gse_ver" = "$GSE_EXPECTED" ]; then
  ok "GSE-One v$gse_ver — $gse_where"
elif [ -n "$gse_ver" ]; then
  ko "GSE-One v$gse_ver found in $gse_where, the course uses v$GSE_EXPECTED" "in your project folder run: $GSE_FIX"
else
  ko "GSE-One not found (from this folder)" "cd to your project folder and re-run this check; if still red run: $GSE_FIX"
fi

# 4. tutor: kit clone, launcher, folders list, GSE-One clone, no leftover global @tutor
KIT_FIX="git clone https://github.com/nicolasguelfi/ai4se-kit $AI4SE_HOME/ai4se-kit && sh $AI4SE_HOME/ai4se-kit/setup-learner.sh"
if [ -x "$KIT_DIR/tutor" ] && [ -f "$KIT_DIR/.opencode/agents/tutor.md" ]; then
  ok "tutor kit $(head -n 1 "$KIT_DIR/VERSION" 2>/dev/null || printf '?') — $KIT_DIR"
elif [ -d "$KIT_DIR/.git" ]; then
  ko "tutor kit found in $KIT_DIR but incomplete or not executable" "run: sh $KIT_DIR/setup-learner.sh  (still red → $KIT_DIR/tutor update)"
else
  ko "tutor kit not found in $KIT_DIR" "run: $KIT_FIX"
fi
if [ -s "$AI4SE_CONF/tutor-paths" ]; then
  ok "tutor folders list — $AI4SE_CONF/tutor-paths"
else
  ko "tutor folders list missing ($AI4SE_CONF/tutor-paths)" "run: sh $KIT_DIR/setup-learner.sh"
fi
gse_clone=""
[ -d "$AI4SE_HOME/gensem/.git" ] && gse_clone=$(git -C "$AI4SE_HOME/gensem" describe --tags --exact-match 2>/dev/null || printf 'not on a tag')
if [ "$gse_clone" = "v$GSE_EXPECTED" ]; then
  ok "GSE-One documentation clone v$GSE_EXPECTED — $AI4SE_HOME/gensem"
elif [ -n "$gse_clone" ]; then
  ko "GSE-One documentation clone is '$gse_clone', the course uses v$GSE_EXPECTED" "run: rm -rf $AI4SE_HOME/gensem && sh $KIT_DIR/setup-learner.sh"
else
  ko "GSE-One documentation clone missing ($AI4SE_HOME/gensem)" "run: sh $KIT_DIR/setup-learner.sh"
fi
if [ -f "$CONFIG_DIR/agents/tutor.md" ]; then
  ko "old global @tutor agent still installed ($CONFIG_DIR/agents/tutor.md)" "run: sh $KIT_DIR/setup-learner.sh  (it moves it away; the tutor now has its own window)"
fi

# 5. git + identity
if has git; then
  name=$(git config --get user.name 2>/dev/null); email=$(git config --get user.email 2>/dev/null)
  if [ -n "$name" ] && [ -n "$email" ]; then
    ok "git $(vnum "$(git --version)") — identity set"
  else
    ko "git identity not set" "run: git config --global user.name \"First Last\" && git config --global user.email \"you@example.com\""
  fi
else
  ko "git is not installed" "install git (macOS: xcode-select --install; Linux: your package manager; Windows: git-scm.com)"
fi

# 6. GitHub CLI + login
if has gh; then
  if gh auth status >/dev/null 2>&1; then
    ok "GitHub CLI logged in"
  else
    ko "GitHub CLI not logged in" "run: gh auth login  (GitHub.com, HTTPS, login with a web browser)"
  fi
else
  ko "GitHub CLI (gh) is not installed" "install it from https://cli.github.com, then run: gh auth login"
fi

# 7. node + npm (CalcApp)
if has node; then
  v=$(vnum "$(node --version 2>/dev/null)")
  if [ -n "$v" ] && ver_ge "$v" "$NODE_MIN"; then
    ok "node $v"
  else
    ko "node ${v:-?} is too old (need $NODE_MIN or newer)" "install the current LTS from https://nodejs.org, then open a new terminal"
  fi
else
  ko "node is not installed" "install the current LTS from https://nodejs.org, then open a new terminal"
fi
if has npm; then
  ok "npm $(vnum "$(npm --version 2>/dev/null)")"
else
  ko "npm is not installed" "npm comes with node: reinstall node from https://nodejs.org"
fi

printf '\n'
if [ "$FAILS" -eq 0 ]; then
  printf '%sAll green — you are ready.%s\n' "$GREEN" "$RESET"
  exit 0
fi
printf '%s%d check(s) red.%s Fix them one by one, re-run this script; stuck after 2 tries → raise your hand.\n' "$RED" "$FAILS" "$RESET"
exit 1
