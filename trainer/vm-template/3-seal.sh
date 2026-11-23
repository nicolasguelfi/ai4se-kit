#!/usr/bin/env bash
# AI4SE course VM template — step 3: seal the template before cloning it (sudo).
#
#   sudo bash 3-seal.sh [student-user]            DRY RUN: lists what would be removed
#   sudo bash 3-seal.sh [student-user] --apply    removes it
#   extra flags with --apply:
#     --reset-browser   also remove the Firefox profile (cookies, saved logins)
#     --reset-keyrings  also remove the GNOME keyrings (passwords saved by apps)
#
# Removes every personal trace the template may hold after your tests, so that no
# learner inherits your key, your GitHub login or your identity:
#   opencode credentials and sessions, gh login, git identity, SSH keys, shell
#   histories, VS Code history and secrets, recent files, caches, temporary files,
#   logs; resets the machine id (each clone gets its own, hence its own network
#   address) and the SSH host keys (regenerated at first boot).
# Keeps: installed tools, VS Code settings, ~/ai4se (kit, GSE-One), desktop settings.
# Prints names only, never file contents.

set -euo pipefail

say()  { printf '\n== %s\n' "$*"; }
item() { printf '  - %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || die "run it with sudo: sudo bash $0"

APPLY=0; BROWSER=0; KEYRINGS=0; STUDENT=""
for a in "$@"; do
  case "$a" in
    --apply) APPLY=1 ;;
    --reset-browser) BROWSER=1 ;;
    --reset-keyrings) KEYRINGS=1 ;;
    -*) die "unknown option $a" ;;
    *) STUDENT=$a ;;
  esac
done
STUDENT="${STUDENT:-${SUDO_USER:-}}"
[ -n "$STUDENT" ] && [ "$STUDENT" != "root" ] || die "give the student user name: sudo bash $0 student"
H=$(getent passwd "$STUDENT" | cut -d: -f6)
[ -d "$H" ] || die "home of '$STUDENT' not found"

if [ "$APPLY" -eq 1 ]; then say "SEALING the template (student: $STUDENT, home: $H)"
else say "DRY RUN — nothing is removed (add --apply to remove). Student: $STUDENT, home: $H"
fi

# remove (or list) existing paths
rm_paths() {
  for p in "$@"; do
    [ -e "$p" ] || [ -L "$p" ] || continue
    size=$(du -sh "$p" 2>/dev/null | cut -f1)
    item "$p ($size)"
    [ "$APPLY" -eq 1 ] && rm -rf -- "$p"
  done
  return 0
}

say "1. Credentials and identities"
rm_paths "$H/.local/share/opencode" "$H/.local/state/opencode" "$H/.cache/opencode" \
         "$H/.config/gh" "$H/.ssh" /root/.ssh/id_* "$H/.git-credentials" "$H/.netrc" \
         "$H/.npmrc"
for f in "$H/.gitconfig" "$H/.config/git/config"; do
  [ -f "$f" ] || continue
  for k in user.name user.email credential.helper; do
    if git config --file "$f" --get "$k" >/dev/null 2>&1; then
      item "$f: $k"
      [ "$APPLY" -eq 1 ] && git config --file "$f" --unset-all "$k"
    fi
  done
done
# secrets typed into shell start-up files: report only (file, line, variable name)
for f in "$H/.bashrc" "$H/.profile" "$H/.bash_profile" "$H/.zshrc" /etc/environment; do
  [ -f "$f" ] || continue
  { grep -nE '^[[:space:]]*(export[[:space:]]+)?[A-Z0-9_]*(API_KEY|TOKEN|SECRET|PASSWORD)[A-Z0-9_]*=' "$f" 2>/dev/null || true; } \
    | sed -E 's/^([0-9]+):[[:space:]]*(export[[:space:]]+)?([A-Z0-9_]+)=.*/\1 \3/' \
    | while read -r line var; do warn "$f line $line defines $var — remove it by hand (not removed automatically)"; done
done

say "2. Histories and recent files"
rm_paths "$H/.bash_history" "$H/.zsh_history" "$H/.python_history" "$H/.node_repl_history" \
         "$H/.lesshst" "$H/.wget-hsts" "$H/.local/share/recently-used.xbel" \
         /root/.bash_history /root/.python_history

say "3. VS Code history and secrets (settings and extensions kept)"
for c in "$H/.config/Code" "$H/.config/VSCodium"; do
  rm_paths "$c/User/workspaceStorage" "$c/User/History" "$c/User/globalStorage/state.vscdb" \
           "$c/User/globalStorage/state.vscdb.backup" "$c/Backups" "$c/logs" "$c/CachedData" \
           "$c/Cache" "$c/Code Cache" "$c/Cookies" "$c/Cookies-journal" "$c/Local Storage" \
           "$c/Session Storage"
done

say "4. Browser and keyrings"
FF_PROFILES=("$H/snap/firefox/common/.mozilla" "$H/.mozilla")
if [ "$BROWSER" -eq 1 ]; then rm_paths "${FF_PROFILES[@]}"
else for p in "${FF_PROFILES[@]}"; do [ -e "$p" ] && warn "kept: $p — if you logged in to a site (GitHub…) during your tests, re-run with --reset-browser"; done
fi
if [ "$KEYRINGS" -eq 1 ]; then rm_paths "$H/.local/share/keyrings"
else [ -d "$H/.local/share/keyrings" ] && warn "kept: $H/.local/share/keyrings — if an app saved a password during your tests, re-run with --reset-keyrings"
fi

say "5. Caches, temporary files, logs"
rm_paths "$H/.cache/pip" "$H/.cache/thumbnails" "$H/.npm/_cacache" "$H/.npm/_logs"
if [ "$APPLY" -eq 1 ]; then
  find /tmp /var/tmp -mindepth 1 -maxdepth 1 -mtime +0 -exec rm -rf -- {} + 2>/dev/null || true
  apt-get clean
  journalctl --vacuum-time=1s >/dev/null 2>&1 || true
  find /var/log -type f \( -name '*.gz' -o -name '*.[0-9]' \) -delete 2>/dev/null || true
  find /var/log -type f -exec truncate -s 0 {} + 2>/dev/null || true
  item "temporary files, apt cache and logs emptied"
else
  item "/tmp, /var/tmp (older than one day), apt cache, system logs: would be emptied"
fi

say "6. Machine identity (each clone gets its own)"
item "/etc/machine-id: would be emptied (regenerated at next boot)"
if [ "$APPLY" -eq 1 ]; then
  truncate -s 0 /etc/machine-id
  rm -f /var/lib/dbus/machine-id && ln -s /etc/machine-id /var/lib/dbus/machine-id
fi
if ls /etc/ssh/ssh_host_* >/dev/null 2>&1; then
  item "/etc/ssh/ssh_host_*: would be removed, regenerated at first boot"
  if [ "$APPLY" -eq 1 ]; then
    rm -f /etc/ssh/ssh_host_*
    cat > /etc/systemd/system/ai4se-ssh-hostkeys.service <<'UNIT'
[Unit]
Description=Regenerate SSH host keys after cloning (AI4SE template)
Before=ssh.service sshd.service
ConditionPathExistsGlob=!/etc/ssh/ssh_host_*_key

[Service]
Type=oneshot
ExecStart=/usr/bin/ssh-keygen -A

[Install]
WantedBy=multi-user.target
UNIT
    systemctl enable ai4se-ssh-hostkeys.service >/dev/null 2>&1 || true
  fi
fi
if command -v cloud-init >/dev/null 2>&1; then
  item "cloud-init state: would be cleaned (runs again on each clone)"
  [ "$APPLY" -eq 1 ] && cloud-init clean --logs >/dev/null 2>&1 || true
fi

if [ "$APPLY" -eq 1 ]; then
  say "Sealed. Now: sudo poweroff — do NOT log in again before turning the VM into a template"
  say "(logging in again recreates a history; then re-run this script)."
else
  say "Dry run finished. If the list is right:  sudo bash $0 $STUDENT --apply"
fi
