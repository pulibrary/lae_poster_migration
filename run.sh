#!/bin/bash

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SAXON="java -classpath $HERE/lib/saxon9he.jar net.sf.saxon.Query"

TMPFILE=/tmp/tmp.json
OUTFILE=$HERE/lae.json

# Use this and comment out the rest of the script if you just want to dump
# Saxon's XQuery results to stdout
$SAXON -q:$HERE/xquery/main.xq src_dir=$HERE/data

# $SAXON -o:$TMPFILE -q:$HERE/xquery/main.xq src_dir=$HERE/data
#
# # Format and indent on a separate file so that we don't swallow errors from
# # Saxon.
# if [ $? == 0 ]; then
#   cat $TMPFILE | jq '.' > $OUTFILE
# fi
#
# if [ $? == 0 ]; then
#   rm $TMPFILE
# fi
