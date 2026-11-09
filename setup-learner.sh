#!/bin/sh
# AI4SE learner setup — installs the @tutor opencode subagent and, if none is set,
# a default opencode model. Safe to run several times (idempotent).
#
#   curl -fsSL https://raw.githubusercontent.com/nicolasguelfi/ai4se-kit/main/setup-learner.sh | sh
#
# Touches only:
#   ~/.config/opencode/agents/tutor.md   (written; an existing different copy is backed up)
#   ~/.config/opencode/opencode.json     (only if it has no "model": one key is added)
# Never reads or writes keys / credentials.

# Default model written to opencode.json when the learner has none.
# Format: provider_id/model_id. Can be overridden: AI4SE_MODEL=... sh setup-learner.sh
AI4SE_MODEL="${AI4SE_MODEL:-TODO(NG): reference model}"

# Where to fetch the kit files when the script is piped from curl.
AI4SE_KIT_REF="${AI4SE_KIT_REF:-main}"
KIT_RAW="${AI4SE_KIT_RAW:-https://raw.githubusercontent.com/nicolasguelfi/ai4se-kit/${AI4SE_KIT_REF}}"
KNOWLEDGE_FILES="schedule.md recovery.md faq.md"

set -eu

say()  { printf '%s\n' "$*"; }
step() { printf '  - %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
AGENTS_DIR="$CONFIG_DIR/agents"
TUTOR="$AGENTS_DIR/tutor.md"
OC_JSON="$CONFIG_DIR/opencode.json"

TMP="$(mktemp -d 2>/dev/null || mktemp -d -t ai4se)"
trap 'rm -rf "$TMP"' EXIT INT TERM

say "AI4SE learner setup"

# --- 1. Locate the kit sources (local clone, or download) -------------------
KIT_DIR="${AI4SE_KIT_DIR:-}"
if [ -z "$KIT_DIR" ]; then
  case "$0" in
    */setup-learner.sh) d=$(dirname "$0"); [ -f "$d/agents/tutor.md.tmpl" ] && KIT_DIR=$d ;;
  esac
fi
if [ -z "$KIT_DIR" ]; then
  command -v curl >/dev/null 2>&1 || die "curl is required"
  KIT_DIR="$TMP/kit"
  mkdir -p "$KIT_DIR/agents" "$KIT_DIR/knowledge"
  curl -fsSL "$KIT_RAW/agents/tutor.md.tmpl" -o "$KIT_DIR/agents/tutor.md.tmpl" \
    || die "cannot download the tutor template from $KIT_RAW"
  for f in $KNOWLEDGE_FILES; do
    curl -fsSL "$KIT_RAW/knowledge/$f" -o "$KIT_DIR/knowledge/$f" \
      || die "cannot download knowledge/$f"
  done
  step "kit files downloaded from $KIT_RAW"
else
  step "kit files read from $KIT_DIR"
fi

# --- 2. Build tutor.md = template + knowledge files -------------------------
NEW="$TMP/tutor.md"
{
  cat "$KIT_DIR/agents/tutor.md.tmpl"
  printf '\n# Course knowledge\n'
  for f in $KNOWLEDGE_FILES; do
    printf '\n'
    # shift headings one level down so they nest under "Course knowledge"
    sed 's/^#/##/' "$KIT_DIR/knowledge/$f"
  done
  printf '\n<!-- built by ai4se-kit setup-learner.sh — do not edit, re-run the script -->\n'
} > "$NEW"
head -n 1 "$NEW" | grep -q '^---$' || die "built tutor.md has no frontmatter"

mkdir -p "$AGENTS_DIR"
if [ -f "$TUTOR" ] && cmp -s "$NEW" "$TUTOR"; then
  step "tutor agent already up to date: $TUTOR"
else
  if [ -f "$TUTOR" ]; then
    BAK="$TUTOR.bak.$(date +%Y%m%d-%H%M%S)"
    cp "$TUTOR" "$BAK"
    step "previous tutor agent backed up to $BAK"
  fi
  cp "$NEW" "$TUTOR"
  step "tutor agent written: $TUTOR ($(wc -c < "$TUTOR" | tr -d ' ') bytes)"
fi

# --- 3. Default model (only if none is configured) --------------------------
case "$AI4SE_MODEL" in
  TODO*|"")
    step "default model: not set by this kit version (the trainer gives it in class)"
    ;;
  *)
    if [ -f "$OC_JSON" ] && grep -q '"model"[[:space:]]*:' "$OC_JSON"; then
      step "opencode.json already has a model: left unchanged"
    elif [ ! -f "$OC_JSON" ]; then
      printf '{\n  "$schema": "https://opencode.ai/config.json",\n  "model": "%s"\n}\n' \
        "$AI4SE_MODEL" > "$OC_JSON"
      step "opencode.json created with model $AI4SE_MODEL"
    else
      cp "$OC_JSON" "$OC_JSON.bak.$(date +%Y%m%d-%H%M%S)"
      # insert "model" right after the first "{" (comma only if the object is not empty)
      awk -v m="$AI4SE_MODEL" '
        { buf = buf $0 "\n" }
        END {
          i = index(buf, "{")
          if (i == 0) { printf "%s", buf; exit 1 }
          rest = substr(buf, i + 1)
          tmp = rest; gsub(/[ \t\r\n]/, "", tmp)
          sep = (substr(tmp, 1, 1) == "}") ? "\n" : ","
          printf "%s\n  \"model\": \"%s\"%s%s", substr(buf, 1, i), m, sep, rest
        }' "$OC_JSON" > "$TMP/oc.json" || die "could not update $OC_JSON — add \"model\": \"$AI4SE_MODEL\" by hand"
      cp "$TMP/oc.json" "$OC_JSON"
      step "model $AI4SE_MODEL added to $OC_JSON (backup kept next to it)"
    fi
    ;;
esac

say "Done. In opencode, type @tutor followed by your question."
say "Next: run check-learner.sh to verify your machine."
