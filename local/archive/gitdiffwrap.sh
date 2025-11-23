#!/bin/bash
if [ -z DIFF ]; then
  DIFF="/usr/bin/vimdiff"
fi
LEFT=${2}
RIGHT=${5}
$DIFF $LEFT $RIGHT
