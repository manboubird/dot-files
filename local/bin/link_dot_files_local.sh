#!/bin/bash
set -euo pipefail

# Define the local dotfiles directory
DOT_FILE_LOCAL_DIR="${DOT_FILE_LOCAL_DIR:-.dot-files.local}"
FILES_COMMON="$DOT_FILE_LOCAL_DIR/files/common"
FILES_HOST="$DOT_FILE_LOCAL_DIR/files/$(hostname -s)"
LOCAL_BIN_SRC="$HOME/$DOT_FILE_LOCAL_DIR/local/bin"
LOCAL_BIN_DEST="$HOME/local/bin"

log() {
    echo "==> $1"
}

link_files() {
    local src_dir="$1"
    local dest_dir="$2"

    if [ ! -d "$src_dir" ]; then
        return
    fi

    log "Linking files from $src_dir to $dest_dir"
    
    # Enable dotglob to match hidden files
    shopt -s dotglob nullglob

    for f in "$src_dir"/*; do
        local filename
        filename=$(basename "$f")

        # Skip specific directories/files
        if [[ "$filename" == ".git" ]] || [[ "$filename" == "." ]] || [[ "$filename" == ".." ]]; then
            continue
        fi

        # Create symlink
        ln -vsf "$f" "$dest_dir/$filename"
    done

    # Disable dotglob
    shopt -u dotglob nullglob
}

# Main execution
cd "$HOME" || exit 1

# Link common and host-specific files
link_files "$FILES_COMMON" "$HOME"
link_files "$FILES_HOST" "$HOME"

# Link local binaries
if [ -d "$LOCAL_BIN_SRC" ]; then
    mkdir -p "$LOCAL_BIN_DEST"
    link_files "$LOCAL_BIN_SRC" "$LOCAL_BIN_DEST"
fi

log "Done."



