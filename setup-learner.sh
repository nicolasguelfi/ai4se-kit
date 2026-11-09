#!/bin/sh
# AI4SE learner setup — run it from the cloned kit (day 1):
#
#   git clone https://github.com/nicolasguelfi/ai4se-kit ~/ai4se/ai4se-kit && sh ~/ai4se/ai4se-kit/setup-learner.sh
#
# Safe to run several times (idempotent). It:
#   - creates ~/ai4se (a plain folder holding the course repositories side by side);
#   - clones GSE-One v0.90.0 into ~/ai4se/gensem (read by the tutor), or checks the existing clone;
#   - writes ~/.config/ai4se/tutor-paths (folders the tutor may read; default ~/ai4se) if absent;
#   - writes ~/.config/ai4se/tutor-model only if AI4SE_MODEL is given on the command line;
#   - adds a default "model" to ~/.config/opencode/opencode.json only if it has none
#     and the course model is known (one key added, backup kept);
#   - moves away the global ~/.config/opencode/agents/tutor.md of the old kit (backup kept).
# Never reads or writes keys / credentials.
#
# Overrides (trainer / tests): AI4SE_MODEL=provider/model, AI4SE_HOME (default ~/ai4se),
# AI4SE_GENSEM_URL (default https://github.com/nicolasguelfi/gensem).

set -eu

GSE_TAG="v0.90.0"

say()  { printf '%s\n' "$*"; }
step() { printf '  - %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

KIT=$(cd "$(dirname "$0")" && pwd)
[ -f "$KIT/tutor" ] && [ -f "$KIT/opencode.base.json" ] \
  || die "run this script from the cloned kit: sh ~/ai4se/ai4se-kit/setup-learner.sh"

AI4SE_HOME="${AI4SE_HOME:-$HOME/ai4se}"
GSE_URL="${AI4SE_GENSEM_URL:-https://github.com/nicolasguelfi/gensem}"
GSE_DIR="$AI4SE_HOME/gensem"
XDG="${XDG_CONFIG_HOME:-$HOME/.config}"
CONF_DIR="$XDG/ai4se"
PATHS_FILE="$CONF_DIR/tutor-paths"
MODEL_FILE="$CONF_DIR/tutor-model"
OC_DIR="$XDG/opencode"
OC_JSON="$OC_DIR/opencode.json"
OLD_TUTOR="$OC_DIR/agents/tutor.md"
STAMP=$(date +%Y%m%d-%H%M%S)

# course default model = the "model" line of opencode.base.json (TODO… = not decided yet)
KIT_MODEL=$(sed -n 's/^[[:space:]]*"model":[[:space:]]*"\([^"]*\)".*/\1/p' "$KIT/opencode.base.json" | head -n 1)
MODEL="${AI4SE_MODEL:-$KIT_MODEL}"
case "$MODEL" in TODO*|"") MODEL="" ;; esac

say "AI4SE learner setup (kit $(head -n 1 "$KIT/VERSION" 2>/dev/null || printf '?') in $KIT)"

# --- 1. ~/ai4se ---------------------------------------------------------------
mkdir -p "$AI4SE_HOME"
step "course folder: $AI4SE_HOME"

# --- 2. GSE-One clone at the course tag ----------------------------------------
command -v git >/dev/null 2>&1 || die "git is required (macOS: xcode-select --install)"
if [ -d "$GSE_DIR/.git" ]; then
  t=$(git -C "$GSE_DIR" describe --tags --exact-match 2>/dev/null || printf 'not on a tag')
  if [ "$t" = "$GSE_TAG" ]; then
    step "GSE-One clone already at $GSE_TAG: $GSE_DIR"
  else
    warn "GSE-One clone at $GSE_DIR is '$t', the course uses $GSE_TAG"
    warn "fix: rm -rf \"$GSE_DIR\" && sh \"$KIT/setup-learner.sh\""
  fi
elif [ -e "$GSE_DIR" ]; then
  warn "$GSE_DIR exists but is not a git clone — left untouched (move it away, then re-run)"
else
  say "  - cloning GSE-One $GSE_TAG into $GSE_DIR …"
  git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$GSE_TAG" "$GSE_URL" "$GSE_DIR" \
    || die "could not clone $GSE_URL ($GSE_TAG) — check the network, then re-run"
  step "GSE-One $GSE_TAG cloned: $GSE_DIR"
fi

# --- 3. tutor folders list -----------------------------------------------------
mkdir -p "$CONF_DIR"
if [ -f "$PATHS_FILE" ]; then
  step "tutor folders list kept: $PATHS_FILE"
else
  {
    printf '# Folders the AI4SE tutor may read (one per line, ~ allowed, # = comment).\n'
    printf '# Change it with: tutor add <path> / tutor remove <path>\n'
    printf '~/ai4se\n'
  } > "$PATHS_FILE"
  step "tutor folders list written: $PATHS_FILE (~/ai4se)"
fi

# --- 4. old global @tutor subagent (kit 2026-11-09 and before) ----------------
if [ -f "$OLD_TUTOR" ]; then
  mv "$OLD_TUTOR" "$OLD_TUTOR.bak.$STAMP"
  step "old global @tutor agent moved to $OLD_TUTOR.bak.$STAMP (the tutor now has its own window)"
fi

chmod +x "$KIT/tutor" "$KIT/setup-learner.sh" "$KIT/check-learner.sh" 2>/dev/null || true

# --- 5. models -----------------------------------------------------------------
# 5a. tutor model: only an explicit AI4SE_MODEL is stored; otherwise the tutor follows the
#     kit default (opencode.base.json), updated by `tutor update`.
if [ -n "${AI4SE_MODEL:-}" ] && [ -n "$MODEL" ]; then
  printf '%s\n' "$MODEL" > "$MODEL_FILE"
  step "tutor model set to $MODEL ($MODEL_FILE)"
fi

# 5b. global default model for the work session, only if none is configured
if [ -z "$MODEL" ]; then
  step "default model: not set by this kit version (the trainer gives it in class)"
elif [ -f "$OC_JSON" ] && grep -q '"model"[[:space:]]*:' "$OC_JSON"; then
  step "opencode.json already has a model: left unchanged"
elif [ ! -f "$OC_JSON" ]; then
  mkdir -p "$OC_DIR"
  printf '{\n  "$schema": "https://opencode.ai/config.json",\n  "model": "%s"\n}\n' "$MODEL" > "$OC_JSON"
  step "opencode.json created with model $MODEL"
else
  cp "$OC_JSON" "$OC_JSON.bak.$STAMP"
  tmp="$OC_JSON.tmp.$$"
  # insert "model" right after the first "{" (comma only if the object is not empty)
  awk -v m="$MODEL" '
    { buf = buf $0 "\n" }
    END {
      i = index(buf, "{")
      if (i == 0) { printf "%s", buf; exit 1 }
      rest = substr(buf, i + 1)
      t = rest; gsub(/[ \t\r\n]/, "", t)
      sep = (substr(t, 1, 1) == "}") ? "\n" : ","
      printf "%s\n  \"model\": \"%s\"%s%s", substr(buf, 1, i), m, sep, rest
    }' "$OC_JSON" > "$tmp" || { rm -f "$tmp"; die "could not update $OC_JSON — add \"model\": \"$MODEL\" by hand"; }
  mv "$tmp" "$OC_JSON"
  step "model $MODEL added to $OC_JSON (backup: $OC_JSON.bak.$STAMP)"
fi

case "$KIT" in "$HOME"/*) SHOWN="~/${KIT#"$HOME"/}" ;; *) SHOWN=$KIT ;; esac
say ""
say "Done. Next steps:"
say "  1. Open a SECOND terminal (your tutor window) and run:  $SHOWN/tutor"
say "  2. Check your machine:  sh $SHOWN/check-learner.sh"
say "  A project outside ~/ai4se? Let the tutor read it:  $SHOWN/tutor add <path>"
