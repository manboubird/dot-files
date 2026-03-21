#!/bin/bash
set -euo pipefail

DOT_FILE_LOCAL_DIR="${DOT_FILE_LOCAL_DIR:-$HOME/.dot-files.local}"
FILES_COMMON="$DOT_FILE_LOCAL_DIR/files/common"
FILES_HOST="$DOT_FILE_LOCAL_DIR/files/$(hostname -s)"
LOCAL_BIN_SRC="$DOT_FILE_LOCAL_DIR/local/bin"
LOCAL_BIN_DEST="$HOME/local/bin"

# Top-level dotfiles always linked silently (no subdirectory paths here)
PREDEFINED_DEFAULTS=(
  .zshrc.local
  .zshenv.local
  .gitconfig
  .npmrc
  .netrc
)

log() { echo "==> $1"; }

is_predefined() {
  local name="$1"
  for d in "${PREDEFINED_DEFAULTS[@]}"; do
    [ "$d" = "$name" ] && return 0
  done
  return 1
}

collect_files() {
  local src_dir="$1"
  [ -d "$src_dir" ] || return 0
  (
    shopt -s dotglob nullglob
    for f in "$src_dir"/*; do
      local name
      name="$(basename "$f")"
      [[ "$name" == ".git" ]] && continue
      echo "$f"
    done
  )
}

link_file() {
  local f="$1"
  ln -vsf "$f" "$HOME/$(basename "$f")"
}

interactive_select() {
  local -a extras=("$@")
  echo ""
  echo "Extra files found — select to link (space-separated numbers, 'a'=all, 'n'=none):"
  local i=1
  for f in "${extras[@]}"; do
    printf "  [%d] %s\n" "$i" "$(basename "$f")"
    i=$(( i + 1 ))
  done
  printf "> "
  read -r input

  if [ "$input" = "a" ]; then
    for f in "${extras[@]}"; do link_file "$f"; done
  elif [ "$input" = "n" ] || [ -z "$input" ]; then
    log "Skipped all extras."
  else
    read -ra selections <<< "$input"
    for num in "${selections[@]}"; do
      if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#extras[@]}" ]; then
        link_file "${extras[$((num-1))]}"
      else
        echo "  Skipping invalid selection: $num"
      fi
    done
  fi
}

main() {
  if [ ! -d "$DOT_FILE_LOCAL_DIR" ]; then
    echo "Local dotfiles repo not found at $DOT_FILE_LOCAL_DIR"
    exit 1
  fi

  local -a extras=()
  local -a all_files=()

  while IFS= read -r f; do
    all_files+=("$f")
  done < <({ collect_files "$FILES_COMMON"; collect_files "$FILES_HOST"; })

  for f in "${all_files[@]+"${all_files[@]}"}"; do
    local name
    name="$(basename "$f")"
    if is_predefined "$name"; then
      link_file "$f"
    else
      extras+=("$f")
    fi
  done

  if [ "${#extras[@]}" -gt 0 ]; then
    interactive_select "${extras[@]}"
  fi

  # Link local binaries
  if [ -d "$LOCAL_BIN_SRC" ]; then
    log "Linking local binaries to $LOCAL_BIN_DEST"
    mkdir -p "$LOCAL_BIN_DEST"
    shopt -s nullglob
    for f in "$LOCAL_BIN_SRC"/*; do
      ln -vsf "$f" "$LOCAL_BIN_DEST/$(basename "$f")"
    done
    shopt -u nullglob
  fi

  log "Done."
}

main
