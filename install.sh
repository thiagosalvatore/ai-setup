#!/usr/bin/env bash
#
# Installs this repo's AI setup into your global Claude config (~/.claude):
#   1. Merges CLAUDE.md into ~/.claude/CLAUDE.md inside a managed block, so your
#      existing content (gstack, RTK, etc.) is preserved and only the ai-setup block
#      is updated on re-runs.
#   2. Symlinks each skill in skills/ into ~/.claude/skills/, so every project can use
#      them. Symlinks keep this repo as the single source of truth.
#
# Idempotent: safe to run again after you edit CLAUDE.md or add a skill.
#
# Override the target dir with CLAUDE_HOME=/path ./install.sh
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
TARGET_CLAUDE_MD="$CLAUDE_HOME/CLAUDE.md"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DEST="$CLAUDE_HOME/skills"

BEGIN_MARKER="<!-- BEGIN ai-setup (managed by ai-setup/install.sh — edit the source repo, not here) -->"
END_MARKER="<!-- END ai-setup -->"

mkdir -p "$CLAUDE_HOME"

# --- 1. Merge CLAUDE.md into ~/.claude/CLAUDE.md ------------------------------

block_file="$(mktemp)"
trap 'rm -f "$block_file"' EXIT
{
  printf '%s\n' "$BEGIN_MARKER"
  cat "$REPO_DIR/CLAUDE.md"
  printf '%s\n' "$END_MARKER"
} > "$block_file"

if [ ! -f "$TARGET_CLAUDE_MD" ]; then
  cp "$block_file" "$TARGET_CLAUDE_MD"
  echo "CLAUDE.md  created  $TARGET_CLAUDE_MD"
elif grep -qF "$BEGIN_MARKER" "$TARGET_CLAUDE_MD"; then
  tmp="$(mktemp)"
  awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" -v blockfile="$block_file" '
    BEGIN { while ((getline line < blockfile) > 0) block = block line "\n" }
    $0 == begin { inblock = 1; printf "%s", block; next }
    $0 == end   { inblock = 0; next }
    !inblock    { print }
  ' "$TARGET_CLAUDE_MD" > "$tmp"
  mv "$tmp" "$TARGET_CLAUDE_MD"
  echo "CLAUDE.md  updated  $TARGET_CLAUDE_MD (managed block refreshed)"
else
  printf '\n' >> "$TARGET_CLAUDE_MD"
  cat "$block_file" >> "$TARGET_CLAUDE_MD"
  echo "CLAUDE.md  merged   $TARGET_CLAUDE_MD (managed block appended)"
fi

# --- 2. Symlink skills into ~/.claude/skills ---------------------------------

mkdir -p "$SKILLS_DEST"
for dir in "$SKILLS_SRC"/*/; do
  name="$(basename "$dir")"
  [ "$name" = "_template" ] && continue
  [ -f "$dir/SKILL.md" ] || continue

  dest="$SKILLS_DEST/$name"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "skill      SKIP     $name (a real directory already exists at $dest)"
    continue
  fi
  ln -sfn "${dir%/}" "$dest"
  echo "skill      linked   $name -> $dest"
done

echo "Done."
