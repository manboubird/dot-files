#!/bin/bash
set -euo pipefail

DOT_FILES_DIR="${DOT_FILES_DIR:-$HOME/.dot-files}"
DOT_DIR="$DOT_FILES_DIR/dot"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Files in dot/ that are never symlinked (legacy, machine-specific, or unused)
DOT_EXCLUDE=(
  bash_logout
  bash_profile
  bashrc
  bashrc.after
  bashrc.command
  ctags
  drake
  gvimrc
  ivy2
  jenkins-clirc
  lein
  os-types
  rstcheck.cfg
  sbt
  scalding
  scalding_repl
  screenrc
  source-highlight
  vimrc
)

# Files always expected to be linked; print info if missing from dot/
DOT_DEFAULT=(
  ackrc
  tmux
  zshenv
  zshrc
  zshrc.after
)

is_excluded() {
  local name="$1"
  for x in "${DOT_EXCLUDE[@]}"; do
    [ "$x" = "$name" ] && return 0
  done
  return 1
}

link_one() {
  local src="$1" target="$2"
  # Remove existing symlink so ln -sf replaces it rather than nesting inside it.
  # Real directories are intentionally left alone.
  [ -L "$target" ] && rm "$target"
  ln -vsf "$src" "$target"
}

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
    link_one "$f" "$XDG_CONFIG_HOME/$(basename "$f")"
  done
fi

# dot/<other> → ~/.<name>  (dot prefix added at link time; excludes listed above)
for f in "$DOT_DIR"/*; do
  [ -e "$f" ] || continue  # guard against empty dir glob expansion
  name="$(basename "$f")"
  [ "$name" = "config" ] && continue
  is_excluded "$name" && continue
  link_one "$f" "$HOME/.$name"
done

# Verify expected defaults are present
for name in "${DOT_DEFAULT[@]}"; do
  [ -e "$DOT_DIR/$name" ] || echo "[info] $name not found in dot/, skipping"
done

# local/bin/* → ~/local/bin/<name>  (no dot prefix)
mkdir -p "$HOME/local/bin"
if [ -d "$DOT_FILES_DIR/local/bin" ]; then
  for f in "$DOT_FILES_DIR/local/bin"/*; do
    [ -e "$f" ] || continue  # guard against empty dir glob expansion
    link_one "$f" "$HOME/local/bin/$(basename "$f")"
  done
fi

echo "Done. Run: DOTFILE_MACHINE_PROFILE=<profile> bash setup/link_dot_env.sh"
