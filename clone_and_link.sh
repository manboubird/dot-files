#!/bin/bash
GIT_REPO=git://github.com/manboubird/dot-files.git 

files=.dot-files/files
cd &&
[ -d '.dot-files' ] || git clone "$GIT_REPO" .dot-files &&
ls -1d $files/* $files/.* | while read f; do
  [ "$f" == "$files/." ] ||
  [ "$f" == "$files/.." ] ||
  [ "$f" == "$files/.git" ] ||
  [[ "$f" == *".swp" ]] ||
  ln -vsf "$f" .
done

mkdir -p $HOME/local/bin 
bin="$HOME/.dot-files/local/bin"
cd && 
[ -d '.dot-files' ] &&
ls -1d $bin/* | while read f; do
  [ "$f" == "$bin/." ] ||
  [ "$f" == "$bin/.." ] ||
  [ "$f" == "$bin/.git" ] ||
  [[ "$f" == *".swp" ]] ||
  ln -vsf "$f" $HOME/local/bin/
done

