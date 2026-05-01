#!/usr/bin/env sh
# Link files from this dotfiles/nvim dir into ~/.config/nvim, preserving structure.
# Usage: ./link.sh [file ...]  — no args links everything

DOTFILES_NVIM="$(cd "$(dirname "$0")" && pwd)"
NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

link_file() {
  src="$1"
  rel="${src#"$DOTFILES_NVIM/"}"
  dst="$NVIM_CONFIG/$rel"

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok       $rel"
  elif [ -L "$dst" ]; then
    echo "relink   $rel"
    ln -sf "$src" "$dst"
  elif [ -e "$dst" ]; then
    echo "skip     $rel  (exists, not a symlink)"
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
  find "$DOTFILES_NVIM" -type f ! -name "$(basename "$0")" | sort | while read -r f; do
    link_file "$f"
  done
fi
