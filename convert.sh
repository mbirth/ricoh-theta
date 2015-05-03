#!/bin/bash
# @author Markus Birth <markus@birth-online.de>

if [ "$#" = "0" ]; then
    echo "RICOH Theta to PhotoSphere converter"
    echo "Usage: $0 file1 [file2 file3 ... fileN]"
    exit 1
fi

if [ -z "$CONCURRENCY_LEVEL" ]; then
    CONCURRENCY_LEVEL=1
fi

SCRIPTREAL=`realpath "$0"`
SCRIPTHELPER=`echo "$SCRIPTREAL" | sed -nre 's/^(.*)\.sh$/\1_single.sh/p'`

if [ ! -f "$SCRIPTHELPER" ]; then
    echo "ERROR: Helper script missing!"
    echo "Make sure it exists as: $SCRIPTHELPER"
    exit 2
fi

find "$@" -print0 | xargs -0 -P $CONCURRENCY_LEVEL -n 1 -I {} $SCRIPTHELPER "{}"
