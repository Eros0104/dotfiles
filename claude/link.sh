#!/usr/bin/env sh
# Link Claude Code config from this dotfiles/claude dir into ~/.claude, preserving structure.
# Safe to re-run. An existing real file is backed up once to <file>.pre-dotfiles before linking.
# Usage: ./link.sh [file ...]  — no args links everything (except this script)

DOTFILES_CLAUDE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

link_file() {
  src="$1"
  rel="${src#"$DOTFILES_CLAUDE/"}"
  dst="$CLAUDE_DIR/$rel"

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok       $rel"
  elif [ -L "$dst" ]; then
    echo "relink   $rel"
    ln -sf "$src" "$dst"
  elif [ -e "$dst" ]; then
    [ -e "$dst.pre-dotfiles" ] || cp "$dst" "$dst.pre-dotfiles"
    ln -sf "$src" "$dst"
    echo "linked   $rel  (original backed up to $rel.pre-dotfiles)"
  else
    ln -s "$src" "$dst"
    echo "linked   $rel"
  fi
}

if [ $# -gt 0 ]; then
  for f in "$@"; do
    link_file "$(cd "$(dirname "$f")" && pwd)/$(basename "$f")"
  done
else
  find "$DOTFILES_CLAUDE" -type f ! -name "$(basename "$0")" ! -name '*.pre-dotfiles' | sort | while read -r f; do
    link_file "$f"
  done
fi
