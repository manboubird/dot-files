#!/bin/bash
if [ -z DIFF ]; then
  DIFF="/usr/bin/vimdiff"
fi
LEFT=${6}
RIGHT=${7}
$DIFF $LEFT $RIGHT
