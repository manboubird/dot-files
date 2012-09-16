#!/bin/bash
# tail -f with multiple hosts.
#  ref. http://blog.64p.org/entry/2012/08/24/165701

function kill_children {
    # jobs -l | perl -ne 'print "kill $1\n" if /^\S+?\s+(\d+)/'  | sh;
    pkill -P $$;
    wait;
}

if [ $# -lt 2 ]; then
  echo "Usage: `basename $0` <path to tailed file> <hosts ...>"
  E_BADARGS=65
  exit $E_BADARGS
fi

LOG_PATH=$1
shift
HOSTS="$@"

trap "kill_children" EXIT
for host in $HOSTS; do
    ssh -t $host tail -F ${LOG_PATH} &
done
wait
