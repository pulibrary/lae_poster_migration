#!/bin/bash

#
# Executes ./xquery/analysis.xq. Used while working on main.xq. Dumps Saxon's
# XQuery results to stdout.
#

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

saxon="java -classpath $HERE/lib/saxon9he.jar net.sf.saxon.Query"

$saxon -q:$HERE/xquery/analysis.xq src_dir=$HERE/data
