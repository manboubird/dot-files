#!/bin/bash
set -euo pipefail

DOT_FILES_DIR="${DOT_FILES_DIR:-$HOME/.dot-files}"
DOT_DIR="$DOT_FILES_DIR/dot"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Clone if not present
if [ ! -d "$DOT_FILES_DIR" ]; then
  GIT_REPO="${DOT_FILES_GIT_REPO:-git://github.com/manboubird/dot-files.git}"
  echo "Cloning $GIT_REPO into $DOT_FILES_DIR ..."
  git clone "$GIT_REPO" "$DOT_FILES_DIR"
fi

mkdir -p "$XDG_CONFIG_HOME"

# dot/config/* → ~/.config/<name>  (no dot prefix, one level deep)
if [ -d "$DOT_DIR/config" ]; then
  for f in "$DOT_DIR/config"/*; do
    [ -e "$f" ] || continue  # guard against empty dir glob expansion
    ln -vsf "$f" "$XDG_CONFIG_HOME/$(basename "$f")"
  done
fi

# dot/<other> → ~/.<name>  (dot prefix added at link time)
for f in "$DOT_DIR"/*; do
  [ -e "$f" ] || continue  # guard against empty dir glob expansion
  name="$(basename "$f")"
  [ "$name" = "config" ] && continue
  ln -vsf "$f" "$HOME/.$name"
done

# local/bin/* → ~/local/bin/<name>  (no dot prefix)
mkdir -p "$HOME/local/bin"
if [ -d "$DOT_FILES_DIR/local/bin" ]; then
  for f in "$DOT_FILES_DIR/local/bin"/*; do
    [ -e "$f" ] || continue  # guard against empty dir glob expansion
    ln -vsf "$f" "$HOME/local/bin/$(basename "$f")"
  done
fi

echo "Done. Run: DOTFILE_MACHINE_PROFILE=<profile> bash setup/link_dot_env.sh"
