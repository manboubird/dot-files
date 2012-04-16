#!/bin/bash
GIT_REPO=git://github.com/manboubird/dot-files.git 
cd &&
[ -d '.dot-files' ] || git clone "$GIT_REPO" .dot-files &&
ls -1d .dot-files/files/* .dot-files/files/.* | while read f; do
  [ "$f" == '.dot-files/files/.' ] ||
  [ "$f" == '.dot-files/files/..' ] ||
  [ "$f" == '.dot-files/files/.git' ] ||
  ln -vsf "$f" .
done
