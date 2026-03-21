#!/bin/bash
# link_dot_env.sh — Link machine-specific env profile files to $HOME and $XDG_CONFIG_HOME.
#
# Usage:
#   bash setup/link_dot_env.sh
#   DOTFILE_MACHINE_PROFILE=<profile> bash setup/link_dot_env.sh
#
# For each file in env/<profile>/:
#   - Files/dirs other than 'config/' are symlinked into $HOME
#   - env/<profile>/config/<name> (dir): if ~/.config/<name> is a managed symlink,
#     breaks it into a real dir, re-links managed files, then overlays profile files
#   - env/<profile>/config/<name> (file): symlinked directly into ~/.config/
#
# Prerequisites: 'trash' must be installed (brew install trash) before running
# on a machine that has managed XDG symlinks to convert.
set -euo pipefail

DOT_FILES="${DOT_FILES:-$HOME/.dot-files}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
PROFILE="${DOTFILE_MACHINE_PROFILE:-default}"
ENV_DIR="$DOT_FILES/env/$PROFILE"

if [ ! -d "$ENV_DIR" ]; then
  echo "Profile '$PROFILE' not found at $ENV_DIR. Falling back to default."
  ENV_DIR="$DOT_FILES/env/default"
fi

if [ ! -d "$ENV_DIR" ]; then
  echo "No env profile found at $ENV_DIR. Skipping."
  exit 0
fi

echo "Linking env profile: $PROFILE"

# Link $HOME files — skip 'config' subdir (handled separately below)
shopt -s dotglob nullglob
for f in "$ENV_DIR"/*; do
  name="$(basename "$f")"
  [ "$name" = "config" ] && continue
  ln -vsf "$f" "$HOME/$name"
done
shopt -u dotglob nullglob

# Config overlay: env/<profile>/config/ entries → $XDG_CONFIG_HOME/
if [ -d "$ENV_DIR/config" ]; then
  shopt -s dotglob nullglob
  for src in "$ENV_DIR/config"/*; do
    [ -e "$src" ] || continue
    name="$(basename "$src")"
    target="$XDG_CONFIG_HOME/$name"

    if [ -d "$src" ]; then
      managed="$DOT_FILES/dot/config/$name"
      if [ -L "$target" ] && [ "$(readlink "$target")" = "$managed" ]; then
        # Break managed symlink → real dir; re-link each managed entry.
        # Subdirs are re-linked as a single symlink (not recursed into).
        # trash is used per project shell safety rule (not rm).
        trash "$target"
        mkdir -p "$target"
        for mf in "$managed"/*; do
          [ -e "$mf" ] || continue
          ln -vsf "$mf" "$target/$(basename "$mf")"
        done
      elif [ ! -d "$target" ]; then
        mkdir -p "$target"
      fi
      # Overlay profile files last — they win over same-named managed files.
      # Any file named 'functions' is skipped unconditionally to protect the
      # command loader helpers in dot/config/zsh/command/functions.
      # Profile authors: use 'functions.local' for overrides instead.
      for ef in "$src"/*; do
        [ -e "$ef" ] || continue
        [ "$(basename "$ef")" = "functions" ] && continue
        ln -vsf "$ef" "$target/$(basename "$ef")"
      done

    else
      # Source is a file → link directly into $XDG_CONFIG_HOME/
      ln -vsf "$src" "$XDG_CONFIG_HOME/$name"
    fi
  done
  shopt -u dotglob nullglob
fi

echo "Done."
