#!/usr/bin/env bash
# AI4SE — Swiss-army knife for the local rehearsal VM (VirtualBox on a Mac, created by setup-mac-vm.sh).
# Run it on the Mac, in Terminal. Every command is safe to repeat.
#
#   bash vm.sh status                 state, SSH, uptime, desktop sessions, xrdp — in one look
#   bash vm.sh start                  start the VM without a window (headless)
#   bash vm.sh stop                   clean shutdown; forced power-off after 90 s if Ubuntu ignores it
#   bash vm.sh restart                clean reboot through SSH; falls back to stop + start, then to a hard reset
#   bash vm.sh reset                  hard reset (like pulling the plug) — last resort
#   bash vm.sh fix-rdp                grey or black Windows App screen: close the stuck desktop session,
#                                     unlock, turn off screen lock and idle blanking, restart xrdp
#   bash vm.sh keyboard               m gives « ; »: re-apply the Mac AZERTY layout now, and on every RDP reconnect
#   bash vm.sh diag                   full diagnosis (paste it to Claude): disk, memory, services, sessions, logs
#   bash vm.sh ssh [command]          shell (or one command) in the VM as student — plain /usr/bin/ssh, so
#                                     Ghostty's terminfo step cannot hang it
#   bash vm.sh connect                how to connect with Windows App (and opens it)
#   bash vm.sh snap [name]            take a snapshot (VM running or not; never --live: it crashed the VM)
#   bash vm.sh snaps                  list the snapshots (* = current)
#   bash vm.sh restore <name>         power off, restore that snapshot, start again
#   bash vm.sh snap-delete <name>     delete a snapshot (asks first)
#
# Settings (environment): VM_NAME=ai4se-ubuntu. The VM folder and its SSH key are found from VirtualBox.

set -uo pipefail

VM_NAME="${VM_NAME:-ai4se-ubuntu}"
SSH_PORT="${SSH_PORT:-2222}"
RDP_PORT="${RDP_PORT:-3390}"

say()  { printf '\n== %s\n' "$*"; }
step() { printf '  - %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

command -v VBoxManage >/dev/null 2>&1 || die "VirtualBox (VBoxManage) is not installed — run setup-mac-vm.sh first"
info() { VBoxManage showvminfo "$VM_NAME" --machinereadable 2>/dev/null; }
info >/dev/null || die "no VirtualBox VM named $VM_NAME (VBoxManage list vms) — create it with setup-mac-vm.sh"
state() { info | sed -n 's/^VMState="\(.*\)"/\1/p'; }
CFG=$(info | sed -n 's/^CfgFile="\(.*\)"/\1/p')
KEY="$(dirname "$CFG")/vmkey"

vmssh() {  # plain ssh: no Ghostty wrapper, short timeouts, no known_hosts noise
  /usr/bin/ssh -q -i "$KEY" -p "$SSH_PORT" -o ConnectTimeout=8 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 \
    -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    student@127.0.0.1 "$@"
}
ssh_ok() { vmssh true 2>/dev/null; }
wait_ssh() {  # $1 = seconds
  local t=0; while [ "$t" -lt "$1" ]; do ssh_ok && return 0; sleep 5; t=$((t + 5)); done; return 1
}
wait_off() {  # $1 = seconds
  local t=0; while [ "$t" -lt "$1" ]; do [ "$(state)" = poweroff ] || [ "$(state)" = aborted ] || [ "$(state)" = saved ] && return 0; sleep 3; t=$((t + 3)); done; return 1
}
start_headless() {
  case "$(state)" in
    running) step "already running" ;;
    *) VBoxManage startvm "$VM_NAME" --type headless >/dev/null || die "could not start $VM_NAME (try: bash vm.sh diag)"
       step "started (headless)" ;;
  esac
  printf '  - waiting for Ubuntu (up to 3 min)…\n'
  wait_ssh 180 && step "Ubuntu answers on SSH" || step "Ubuntu not answering yet — try 'bash vm.sh status' in a minute"
}
stop_clean() {
  [ "$(state)" = running ] || { step "not running ($(state))"; return 0; }
  if ssh_ok; then vmssh 'sudo systemctl poweroff' >/dev/null 2>&1 || true; step "shutdown asked through SSH"
  else VBoxManage controlvm "$VM_NAME" acpipowerbutton >/dev/null 2>&1; step "power button pressed (SSH not answering)"; fi
  if wait_off 90; then step "stopped"; else
    step "Ubuntu did not stop within 90 s: forcing power-off"
    VBoxManage controlvm "$VM_NAME" poweroff >/dev/null 2>&1; wait_off 30 && step "stopped (forced)"
  fi
}
desktop_sessions() {  # the student's xrdp desktop sessions (not the SSH ones)
  vmssh 'for s in $(loginctl list-sessions --no-legend | awk "\$3==\"student\"{print \$1}"); do
           [ "$(loginctl show-session "$s" -p Service --value)" = xrdp-sesman ] && echo "$s"; done' 2>/dev/null
}

KBD_LINE='setxkbmap -layout fr -variant mac  # ai4se: xrdp resets the layout on each reconnect'
keyboard_fix() {  # now (every desktop display of student) + durable (xrdp reconnect hook), idempotent
  vmssh "for d in /tmp/.X11-unix/X*; do [ -O \"\$d\" ] && DISPLAY=\":\${d##*X}\" XAUTHORITY=\"\$HOME/.Xauthority\" setxkbmap -layout fr -variant mac; done
         grep -qF 'ai4se: xrdp resets' /etc/xrdp/reconnectwm.sh || echo \"$KBD_LINE\" | sudo tee -a /etc/xrdp/reconnectwm.sh >/dev/null"
}

cmd="${1:-status}"; shift 2>/dev/null || true
case "$cmd" in
  status)
    say "VM $VM_NAME — $(state)"
    step "folder: $(dirname "$CFG")"
    cur=$(info | sed -n 's/^CurrentSnapshotName="\(.*\)"/\1/p' | head -n 1); step "current snapshot: ${cur:-none}"
    info | grep '^Forwarding' | sed 's/^Forwarding([0-9]*)=/  - port forward: /'
    if [ "$(state)" = running ]; then
      if ssh_ok; then
        step "SSH: OK — $(vmssh 'uptime -p')"
        step "xrdp: $(vmssh 'systemctl is-active xrdp xrdp-sesman | paste -sd/ -')"
        d=$(desktop_sessions | paste -sd' ' -); step "desktop sessions (Windows App): ${d:-none}"
        step "disk: $(vmssh "df -h / | awk 'NR==2{print \$5\" used of \"\$2}'")"
      else
        step "SSH: not answering (still booting? wait a minute, or: bash vm.sh restart)"
      fi
    fi ;;
  start)   say "Start"; start_headless ;;
  stop)    say "Stop"; stop_clean ;;
  restart)
    say "Restart"
    if [ "$(state)" = running ] && ssh_ok; then
      vmssh 'sudo systemctl reboot' >/dev/null 2>&1 || true; step "reboot asked through SSH"; sleep 15
      wait_ssh 180 && step "back up — $(vmssh 'uptime -p')" || { step "not back after 3 min: hard reset"; VBoxManage controlvm "$VM_NAME" reset; wait_ssh 180 && step "back up after reset"; }
    else
      stop_clean; start_headless
    fi
    printf '\nThen connect with Windows App and wait up to a minute for the desktop.\n' ;;
  reset)   say "Hard reset"; VBoxManage controlvm "$VM_NAME" reset && step "reset sent"; wait_ssh 180 && step "back up" ;;
  fix-rdp)
    say "Repair the Windows App (RDP) desktop"
    ssh_ok || die "the VM does not answer on SSH: try 'bash vm.sh restart' first"
    for s in $(desktop_sessions); do vmssh "sudo loginctl terminate-session $s" && step "closed stuck desktop session $s"; done
    vmssh 'export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
           gsettings set org.gnome.desktop.screensaver lock-enabled false 2>/dev/null
           gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null
           gsettings set org.gnome.desktop.lockdown disable-lock-screen true 2>/dev/null
           sudo loginctl unlock-sessions; sudo systemctl restart xrdp-sesman xrdp' && step "screen lock and idle blanking off; xrdp restarted"
    keyboard_fix && step "Mac AZERTY layout re-applied on every RDP reconnect"
    printf '\nClose every Windows App window of this PC, then connect again (localhost:%s) and wait up to a minute.\n' "$RDP_PORT" ;;
  keyboard)
    say "Keyboard (Mac AZERTY)"
    ssh_ok || die "the VM does not answer on SSH: try 'bash vm.sh restart' first"
    keyboard_fix && step "applied to the open desktop, and to every future RDP reconnect" ;;
  diag)
    say "Diagnosis of $VM_NAME — $(date '+%Y-%m-%d %H:%M')"
    step "VirtualBox state: $(state)"
    if ssh_ok; then
      vmssh 'echo "== uptime"; uptime
             echo "== disk"; df -h / | tail -1
             echo "== memory"; free -m | head -2
             echo "== failed services"; systemctl --failed --no-legend
             echo "== sessions"; loginctl list-sessions --no-legend
             echo "== xrdp"; systemctl is-active xrdp xrdp-sesman
             echo "== desktop processes"; ps -u student -o pid,etime,cmd --sort=etime | grep -E "Xorg|gnome-shell|gnome-session" | grep -v grep
             echo "== xrdp-sesman (last 12)"; sudo tail -n 12 /var/log/xrdp-sesman.log
             echo "== gnome-shell (last 15)"; journalctl -b _COMM=gnome-shell --no-pager | grep -v "Overwriting existing binding" | tail -n 15
             echo "== errors this boot (last 20)"; sudo journalctl -b -p err --no-pager | tail -n 20'
    else
      step "SSH not answering — VirtualBox log (last 25 lines):"; tail -n 25 "$(dirname "$CFG")/Logs/VBox.log"
      shot="$HOME/Desktop/vm-screen-$(date +%H%M%S).png"
      VBoxManage controlvm "$VM_NAME" screenshotpng "$shot" 2>/dev/null && step "screen captured: $shot" && open "$shot"
    fi ;;
  ssh)     if [ $# -gt 0 ]; then vmssh "$@"; else /usr/bin/ssh -i "$KEY" -p "$SSH_PORT" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR student@127.0.0.1; fi ;;
  connect)
    say "Windows App"
    step "PC: localhost:$RDP_PORT — user student, password student (unless VM_PASSWORD was set) — session Xorg"
    ts=$(info | sed -n 's/^Forwarding([0-9]*)="rdp-tailscale,tcp,\([^,]*\),.*/\1/p'); [ -n "$ts" ] && step "from your other devices (Tailscale): $ts:$RDP_PORT"
    step "grey or black screen after a minute: bash vm.sh fix-rdp"
    open -a "Windows App" 2>/dev/null || true ;;
  snap)
    name="${1:-snap-$(date +%Y%m%d-%H%M)}"
    say "Snapshot « $name »"
    [ "$(state)" = running ] && step "the VM pauses a few seconds, then resumes (no --live: it crashed the VM on 2026-11-23)"
    VBoxManage snapshot "$VM_NAME" take "$name" --description "taken by vm.sh on $(date '+%Y-%m-%d %H:%M')" && step "done" ;;
  snaps)   say "Snapshots of $VM_NAME"; VBoxManage snapshot "$VM_NAME" list 2>/dev/null || step "none yet (bash vm.sh snap)" ;;
  restore)
    [ $# -ge 1 ] || die "which snapshot? bash vm.sh snaps, then bash vm.sh restore <name>"
    say "Restore « $1 »"
    printf '  Everything done in the VM since that snapshot will be lost. Continue? [y/N] '; read -r a
    [ "$a" = y ] || [ "$a" = Y ] || { step "cancelled"; exit 0; }
    if [ "$(state)" = running ]; then VBoxManage controlvm "$VM_NAME" poweroff >/dev/null 2>&1; wait_off 30; fi
    VBoxManage snapshot "$VM_NAME" restore "$1" || die "restore failed (name? bash vm.sh snaps)"
    step "restored"; start_headless ;;
  snap-delete)
    [ $# -ge 1 ] || die "which snapshot? bash vm.sh snaps"
    printf '  Delete snapshot « %s »? [y/N] ' "$1"; read -r a
    [ "$a" = y ] || [ "$a" = Y ] || { step "cancelled"; exit 0; }
    VBoxManage snapshot "$VM_NAME" delete "$1" && step "deleted" ;;
  -h|--help|help) sed -n '2,23p' "$0" | sed 's/^# \{0,1\}//' ;;
  *) die "unknown command '$cmd' — bash vm.sh help" ;;
esac
