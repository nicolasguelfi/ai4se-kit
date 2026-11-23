#!/usr/bin/env bash
# AI4SE course VM template — step 2: student account (run as the student user, NOT with sudo).
#
#   bash 2-student.sh              desktop settings only (learners install the course
#                                  tools themselves, day 1 afternoon, as on the slides)
#   bash 2-student.sh --preinstall also installs opencode 2, the course kit (+ GSE-One
#                                  documentation clone) and GSE-One in ~/ai4se/gse-check,
#                                  so installation steps 1, 2, 4 and 5 become "check it"
#
# Desktop settings (GNOME): no screen lock or blank screen during the course, and
# Terminal, VS Code, Firefox and Files in the dock.
# Never logs in anywhere, never asks for a key: keys, GitHub login and git identity
# stay personal (installation steps 3 and 6, done by each learner).

set -euo pipefail

KIT_URL="https://github.com/nicolasguelfi/ai4se-kit"
GSE_TAG="v0.92.1"

say()  { printf '\n== %s\n' "$*"; }
step() { printf '  - %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -ne 0 ] || die "run it as the student user, without sudo"
PRE=0
case "${1:-}" in
  --preinstall) PRE=1 ;;
  "") ;;
  *) die "unknown option '$1' (only --preinstall)" ;;
esac

# --- 1. desktop -----------------------------------------------------------------
say "1. Desktop settings"
if command -v gsettings >/dev/null 2>&1 && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
  gsettings set org.gnome.desktop.session idle-delay 0 && step "screen never blanks"
  gsettings set org.gnome.desktop.screensaver lock-enabled false && step "no screen lock"
  gsettings set org.gnome.desktop.notifications show-in-lock-screen false || true
  # dock: keep the apps that exist on this machine
  favs=""
  for app in org.gnome.Terminal.desktop code.desktop code_code.desktop firefox_firefox.desktop \
             firefox.desktop org.gnome.Nautilus.desktop; do
    for d in /usr/share/applications /var/lib/snapd/desktop/applications "$HOME/.local/share/applications"; do
      if [ -f "$d/$app" ]; then favs="$favs${favs:+, }'$app'"; break; fi
    done
  done
  [ -n "$favs" ] && gsettings set org.gnome.shell favorite-apps "[$favs]" && step "dock: $favs"
else
  warn "no graphical session (run this script from a terminal of the desktop): desktop settings skipped"
fi

# --- 2. optional pre-installation -----------------------------------------------
if [ "$PRE" -eq 1 ]; then
  say "2. opencode 2"
  export PATH="$HOME/.opencode/bin:$PATH"
  if command -v opencode >/dev/null 2>&1; then
    step "already installed: $(opencode --version 2>/dev/null | head -n 1)"
  else
    curl -fsSL https://opencode.ai/v2/install | bash
    command -v opencode >/dev/null 2>&1 || die "opencode not found after install (open a new terminal and re-run)"
    step "installed: $(opencode --version 2>/dev/null | head -n 1)"
  fi

  say "3. Course kit and GSE-One documentation clone (~/ai4se)"
  mkdir -p "$HOME/ai4se"
  if [ -d "$HOME/ai4se/ai4se-kit/.git" ]; then
    git -C "$HOME/ai4se/ai4se-kit" pull --ff-only -q && step "kit updated"
  else
    git clone -q "$KIT_URL" "$HOME/ai4se/ai4se-kit" && step "kit cloned"
  fi
  sh "$HOME/ai4se/ai4se-kit/setup-learner.sh"

  say "4. GSE-One $GSE_TAG in the test folder ~/ai4se/gse-check"
  mkdir -p "$HOME/ai4se/gse-check"
  ( cd "$HOME/ai4se/gse-check" &&
    curl -fsSL "https://raw.githubusercontent.com/nicolasguelfi/gensem/$GSE_TAG/install.sh" \
      | GSE_PLATFORM=opencode GSE_VERSION="$GSE_TAG" sh )
  [ "$(cat "$HOME/ai4se/gse-check/.gse/registry" 2>/dev/null)" = ".opencode" ] \
    && step "GSE-One installed (.gse/registry = .opencode)" \
    || warn "GSE-One install not confirmed: check ~/ai4se/gse-check"
else
  say "2. Course tools: not pre-installed (learners do installation steps 1-8 themselves)"
fi

say "Student part finished. Next: test (see the guide), then  sudo bash 3-seal.sh"
