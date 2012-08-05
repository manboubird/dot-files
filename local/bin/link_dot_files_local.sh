#!/bin/bash
if [ -z "$DOT_FILE_LOCAL_DIR" ]; then
  DOT_FILE_LOCAL_DIR=.dot-files.local
fi
files_common="$DOT_FILE_LOCAL_DIR/files/common"
files_host="$DOT_FILE_LOCAL_DIR/files/`hostname -s`"
cd &&
ls -1d $files_common/* $files_common/.* $files_host/* $files_host/.* | 
while read f; do
  [ "$f" == "$files_common/." ] ||
  [ "$f" == "$files_common/.." ] ||
  [ "$f" == "$files_common/.git" ] ||
  [ "$f" == "$files_host/." ] ||
  [ "$f" == "$files_host/.." ] ||
  [ "$f" == "$files_host/.git" ] ||
  ln -vsf "$f" .
done
                       
mkdir -p $HOME/local/bin 
bin="$HOME/$DOT_FILE_LOCAL_DIR/local/bin"
cd && 
[ -d "$DOT_FILE_LOCAL_DIR" ] &&
  ls -1d $bin/* | while read f; do
  [ "$f" == "$bin/." ] ||
  [ "$f" == "$bin/.." ] ||
  [ "$f" == "$bin/.git" ] ||
  ln -vsf "$f" $HOME/local/bin/
done


