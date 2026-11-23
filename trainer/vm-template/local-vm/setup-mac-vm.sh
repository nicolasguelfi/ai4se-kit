#!/usr/bin/env bash
# AI4SE — prepare any Apple Silicon Mac and create the local rehearsal VM, in one command.
#
#   bash setup-mac-vm.sh                    check / install what is missing, then create the VM
#   bash setup-mac-vm.sh --with-tailscale   same, and install the Tailscale app if missing
#   bash setup-mac-vm.sh --dry-run          say what would be done, change nothing
#
# Steps (each one is skipped when already done, so the script is safe to run again):
#   1. checks the Mac has Apple Silicon (arm64);
#   2. installs Homebrew if missing, then VirtualBox (Homebrew cask, Apple Silicon build) if missing;
#      stops cleanly, with what to do, if macOS still has to allow VirtualBox (System Settings);
#   3. optional (--with-tailscale): installs the Tailscale app if missing (you then sign in yourself);
#   4. picks the VM folder (VM_BASE, default ~/VMs), refuses a folder inside Dropbox or iCloud,
#      then runs create-local-vm.sh (≈ 25 min the first time) unless the VM already exists.
#
# Settings (environment): VM_BASE=~/VMs VM_NAME=ai4se-ubuntu, plus those of create-local-vm.sh
# (VM_PASSWORD, VM_RAM_MB, VM_CPUS, VM_DISK_GB, RDP_PORT, SSH_PORT, TAILSCALE_RDP).
# Homebrew and VirtualBox ask for your Mac password (administrator account needed).

set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
VM_NAME="${VM_NAME:-ai4se-ubuntu}"
VM_BASE="${VM_BASE:-$HOME/VMs}"
VBOX_MIN="7.1"
DRY=0; TS=0
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    --with-tailscale) TS=1 ;;
    -h|--help) sed -n '2,19p' "$0"; exit 0 ;;
    *) printf 'ERROR: unknown option %s (--dry-run, --with-tailscale)\n' "$a" >&2; exit 1 ;;
  esac
done

say()  { printf '\n== %s\n' "$*"; }
step() { printf '  - %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
run()  { if [ "$DRY" = 1 ]; then printf '  [dry-run] would run: %s\n' "$*"; else "$@"; fi; }
[ "$DRY" = 1 ] && say "Dry run: nothing will be installed or created"

say "1. Mac with Apple Silicon"
[ "$(uname -s)/$(uname -m)" = "Darwin/arm64" ] || die "this script targets a Mac with Apple Silicon (found $(uname -s)/$(uname -m))"
step "OK ($(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null))"

say "2. Homebrew and VirtualBox"
if ! command -v brew >/dev/null 2>&1 && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if command -v brew >/dev/null 2>&1; then
  step "Homebrew already installed"
else
  step "Homebrew missing: installing it (official script, asks for your password)"
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ "$DRY" = 0 ]; then
    [ -x /opt/homebrew/bin/brew ] || die "Homebrew was not installed in /opt/homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

if command -v VBoxManage >/dev/null 2>&1; then
  v=$(VBoxManage --version 2>/dev/null | sed 's/r.*//')
  step "VirtualBox already installed ($v)"
  if [ "$(printf '%s\n%s\n' "$VBOX_MIN" "$v" | sort -V | head -n 1)" != "$VBOX_MIN" ]; then
    die "VirtualBox $v is too old: $VBOX_MIN or newer is needed (brew upgrade --cask virtualbox, or virtualbox.org)"
  fi
else
  step "VirtualBox missing: installing it (Homebrew cask, Apple Silicon build; asks for your password)"
  run brew install --cask virtualbox
fi
if [ "$DRY" = 0 ] && ! VBoxManage list hostinfo >/dev/null 2>&1; then
  cat <<'EOF'

VirtualBox is installed but macOS has not let it run yet. Do this, then run this script again:
  1. open System Settings → Privacy & Security;
  2. scroll down to the message about "Oracle" or "VirtualBox" and click Allow (password asked);
  3. restart the Mac if macOS asks for it.
EOF
  exit 2
fi
[ "$DRY" = 1 ] || step "VirtualBox runs"

say "3. Tailscale (optional, for RDP from your other devices)"
if command -v tailscale >/dev/null 2>&1 || [ -d /Applications/Tailscale.app ]; then
  step "Tailscale already installed"
  tailscale status >/dev/null 2>&1 && step "Tailscale is up" \
    || step "Tailscale is not signed in: open the Tailscale app and sign in, then re-run to add the Tailscale RDP access"
elif [ "$TS" = 1 ]; then
  step "installing the Tailscale app (Homebrew cask tailscale-app)"
  run brew install --cask tailscale-app
  step "then open Tailscale from Applications and sign in; re-run this script to add the Tailscale RDP access"
else
  step "skipped (add --with-tailscale to install it); the VM stays reachable on this Mac: localhost:3390"
fi

say "4. VM folder and VM"
case "$VM_BASE" in /*) ;; *) VM_BASE="$PWD/$VM_BASE" ;; esac
case "$VM_BASE" in
  *Dropbox*|*"Library/Mobile Documents"*|*"Library/CloudStorage"*|*iCloud*)
    die "VM_BASE=$VM_BASE is inside Dropbox or iCloud: a 10-20 GB disk image must not be synchronised (choose e.g. ~/VMs)" ;;
esac
step "VM folder: $VM_BASE/$VM_NAME"
if command -v VBoxManage >/dev/null 2>&1 && VBoxManage list vms 2>/dev/null | grep -q "\"$VM_NAME\""; then
  step "the VM $VM_NAME already exists: nothing to create"
  VBoxManage showvminfo "$VM_NAME" --machinereadable | grep -E '^VMState=|^Forwarding' | sed 's/^/    /'
  printf '\nConnect with Windows App: PC "localhost:3390", user student, session Xorg.\n'
  exit 0
fi
run mkdir -p "$VM_BASE"
run env VM_BASE="$VM_BASE" VM_NAME="$VM_NAME" bash "$HERE/create-local-vm.sh"
[ "$DRY" = 1 ] && printf '\nDry run finished: nothing was changed.\n'
exit 0
