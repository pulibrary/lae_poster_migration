#!/bin/bash

#
# Convert LAE METS to a simple JSON structure for migration to Plum.
#
# Pass a file name if you want output written to a file, otherwise output
# goes to stdout.
#

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

saxon="java -classpath $HERE/lib/saxon9he.jar net.sf.saxon.Query"

TMPFILE=/tmp/tmp.json

$saxon -o:$TMPFILE -q:$HERE/xquery/main.xq src_dir=$HERE/data

# Format and indent on a separate file so that we don't swallow errors from
# Saxon.
if [[ $? -eq 0 && "$1x" != "x" ]]; then
  cat $TMPFILE | jq '.' > $1
else
  cat $TMPFILE | jq '.'
fi

if [ $? == 0 ]; then
  rm $TMPFILE
fi
