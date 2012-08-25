#!/bin/bash
#
# rsync dot files to a remote host
# 
[ ! -d ~/.dot-files ] && echo " ~/.dot-files does not exists." && exit 1

while getopts "l" opts; do
  case $opts in
    l)
      CREATE_LINK="true"
      ;;
    \?)
      exit 1
      ;;
  esac
done

shift `expr $OPTIND - 1`

if [ $# -lt 1 ]; then
  echo "One argument of destination {USER}@{HOSTNAME} is required."
  exit 1
fi

while (($#)); do
  DST=$1
  echo "Start rsync dot-files to destination: $DST"
  rsync -auv --delete --exclude ".git" --exclude "*.swp" --exclude "rsync_dotfiles_bk"  --backup --backup-dir=rsync_dotfiles_bk/`date +%Y%m%d_%H%M%S` ~/.dot-files/ $DST:~/.dot-files
  if [ "$CREATE_LINK" == "true" ]; then
    echo "Create symbolic links of dot-files"
    ssh $DST "bash ~/.dot-files/clone_and_link.sh"
  fi
  echo "Complete rsync to destination: $DST"
  echo "---"
  shift
done
