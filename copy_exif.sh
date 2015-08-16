#!/bin/sh
# @author Markus Birth <markus@birth-online.de>
# Syntax: ./copy_exif.sh imagefile1 imagefile2
# Copies EXIF/XMP metadata from imagefile1 to imagefile2
# Needs: exiv2

if [ -f "$1" -a -f "$2" ]; then
    BASENAME_1=`echo "$1" | sed -nre 's/^(.*)\.[^.]+$/\1/p'`
    BASENAME_2=`echo "$2" | sed -nre 's/^(.*)\.[^.]+$/\1/p'`
    exiv2 ex "$1"
    mv "$BASENAME_1.exv" "$BASENAME_2.exv"
    exiv2 im "$2"
    rm "$BASENAME_2.exv"
else
    echo "Syntax: $0 [source file] [target file]"
    echo "        Will copy metadata from first to second file."
fi
