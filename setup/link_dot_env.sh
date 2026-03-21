#!/bin/bash
set -euo pipefail

DOT_FILES_DIR="${DOT_FILES_DIR:-$HOME/.dot-files}"
PROFILE="${DOTFILE_MACHINE_PROFILE:-default}"
ENV_DIR="$DOT_FILES_DIR/env/$PROFILE"

if [ ! -d "$ENV_DIR" ]; then
  echo "Profile '$PROFILE' not found at $ENV_DIR. Falling back to default."
  ENV_DIR="$DOT_FILES_DIR/env/default"
fi

if [ ! -d "$ENV_DIR" ]; then
  echo "No env profile found at $ENV_DIR. Skipping."
  exit 0
fi

echo "Linking env profile: $PROFILE"
shopt -s dotglob nullglob
for f in "$ENV_DIR"/*; do
  ln -vsf "$f" "$HOME/$(basename "$f")"
done
shopt -u dotglob nullglob

echo "Done."
