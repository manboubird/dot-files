#!/bin/bash

GIT_REPO=${DOT_FILES_GIT_REPO:-"git://github.com/manboubird/dot-files.git"}
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
USER_LOCAL_HOME="${USER_LOCAL_HOME:-${HOME}/.local}"

main(){
  init
  cd
  local dot_files="${HOME}/.dot-files"
  if [ -d "${dot_files}" ]; then
    echo "The repository already exists. Skip cloning repository."
  else
    echo "Try to clone repository $GIT_REPO ..."
    git clone "$GIT_REPO" "${dot_files}" || exit "$?"
  fi
  symbolic_link_to_dir "$(ls -1d $dot_files/config/*)" "${XDG_CONFIG_HOME}"
  symbolic_link_to_dot_files "$(ls -1d $dot_files/dot/*)"
  symbolic_link_to_dir "$(ls -1d $dot_files/local/bin/*)" "${USER_LOCAL_HOME}/bin"
}

symbolic_link_to_dot_local_bin(){
symbolic_link_to_dir(){
  local files=$1
  local dst_root=${2:-"."}
  echo "Create symbolic links to directory ..."
  for file in ${files[@]}; do
    ln -vsf "$file" "${dst_root}/" 
  done
}

symbolic_link_to_dot_files(){
  local files=$1
  echo "Create symbolic links to dot files ..."
  for file in ${files[@]}; do
    local filename=$(basename $file)
    ln -vsf "${file}" ".$filename"
  done
}

init(){
  mkdir -p "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" "${XDG_DATA_HOME}" "${USER_LOCAL_HOME}/bin"
}

main
exit 0
