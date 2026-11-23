#!/usr/bin/env bash
# AI4SE course VM template — step 4: read-only check, as the student user.
#
#   bash 4-verify.sh            checks the template (tools present, nothing personal left)
#   bash 4-verify.sh --clone    the same on a fresh clone (also checks the machine id)
#
# Changes nothing. Prints one ✓ / ✗ / · line per check; exit code 0 only if no ✗.

PATH="$HOME/.opencode/bin:$PATH"
FAILS=0
ok()   { printf '✓ %s\n' "$1"; }
ko()   { printf '✗ %s\n    → %s\n' "$1" "$2"; FAILS=$((FAILS + 1)); }
info() { printf '· %s\n' "$1"; }
has()  { command -v "$1" >/dev/null 2>&1; }
vnum() { printf '%s\n' "$1" | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1; }
ver_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n 1)" = "$2" ]; }

printf 'AI4SE VM template check — user %s on %s\n\n' "$(id -un)" "$(hostname)"

echo "Tools"
for t in git curl python3 gh; do
  if has "$t"; then ok "$t $(vnum "$("$t" --version 2>&1 | head -n 1)")"; else ko "$t missing" "sudo bash 1-system.sh"; fi
done
if has node && ver_ge "$(vnum "$(node --version)")" 20.19.0; then ok "node $(node --version) / npm $(npm --version 2>/dev/null)"
else ko "node missing or older than 20.19" "sudo bash 1-system.sh"; fi
if has code; then ok "VS Code $(code --version 2>/dev/null | head -n 1)"; else info "VS Code not found (optional)"; fi
S="$HOME/.config/Code/User/settings.json"
if [ -f "$S" ] && grep -q '"chat.disableAIFeatures": true' "$S"; then ok "VS Code: editor AI off"
elif has code; then ko "VS Code: editor AI not turned off" "sudo bash 1-system.sh"; fi
if has opencode; then ok "opencode $(vnum "$(opencode --version 2>/dev/null)") (pre-installed)"; else info "opencode not pre-installed (learners: installation step 1)"; fi
if [ -x "$HOME/ai4se/ai4se-kit/tutor" ]; then ok "course kit pre-installed — $(head -n 1 "$HOME/ai4se/ai4se-kit/VERSION")"; else info "course kit not pre-installed (learners: installation step 4)"; fi

echo; echo "Nothing personal left"
auth=""
has opencode && auth=$(opencode auth list --standalone --format json 2>/dev/null)
if printf '%s' "$auth" | grep -Eq '"type": *"credential"' \
   || { [ -s "$HOME/.local/share/opencode/auth.json" ] && [ "$(tr -d ' \t\r\n' < "$HOME/.local/share/opencode/auth.json")" != "{}" ]; }; then
  ko "opencode still holds a model credential" "sudo bash 3-seal.sh --apply"
else ok "no opencode credential"; fi
if has gh && gh auth status >/dev/null 2>&1; then ko "gh is logged in" "sudo bash 3-seal.sh --apply"; else ok "gh not logged in"; fi
if [ -n "$(git config --global user.name 2>/dev/null)$(git config --global user.email 2>/dev/null)" ]; then
  ko "git identity still set" "sudo bash 3-seal.sh --apply"; else ok "no git identity"; fi
if ls "$HOME"/.ssh/id_* >/dev/null 2>&1; then ko "SSH keys in ~/.ssh" "sudo bash 3-seal.sh --apply"; else ok "no SSH key"; fi
if [ -s "$HOME/.bash_history" ]; then info "~/.bash_history not empty (normal after you typed commands; 3-seal.sh empties it)"; fi

if [ "${1:-}" = "--clone" ]; then
  echo; echo "Clone"
  if [ -s /etc/machine-id ]; then ok "machine id generated: $(cut -c1-8 /etc/machine-id)… (compare between two clones: must differ)"
  else ko "machine id empty" "reboot the clone once"; fi
fi

echo; echo "Network (sites the course needs)"
for u in https://github.com https://api.github.com https://raw.githubusercontent.com https://opencode.ai \
         https://openrouter.ai https://registry.npmjs.org https://ai4se6d-genai-intro.streamtex.org; do
  code=$(curl -s -o /dev/null -m 10 -w '%{http_code}' "$u" 2>/dev/null)
  case "$code" in 2*|3*|401|403|404) ok "$u ($code)" ;; *) ko "$u unreachable (${code:-no answer})" "network or proxy of the lab: tell the IT team" ;; esac
done

echo; echo "Machine"
free_gb=$(df -Pk "$HOME" | awk 'NR==2 {printf "%d", $4/1048576}')
[ "$free_gb" -ge 10 ] && ok "disk: ${free_gb} GB free" || ko "disk: only ${free_gb} GB free" "give the VM at least 10 GB free"
mem_gb=$(awk '/MemTotal/ {printf "%d", $2/1048576 + 0.5}' /proc/meminfo)
[ "$mem_gb" -ge 4 ] && ok "memory: ${mem_gb} GB" || ko "memory: ${mem_gb} GB" "4 GB or more recommended (VS Code + 2 opencode + node)"

echo
if [ "$FAILS" -eq 0 ]; then echo "All checks passed."; else echo "$FAILS check(s) failed."; fi
[ "$FAILS" -eq 0 ]
