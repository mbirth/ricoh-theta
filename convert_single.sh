#!/bin/bash
# @author Markus Birth <markus@birth-online.de>
# Needs: Hugin (nona), exiv2, sed, realpath

if [ -f "$1" ]; then
    REALNAME=`realpath "$1"`
    BASENAME=`echo "$REALNAME" | sed -nre 's/^(.*)\.[^.]+$/\1/p'`
    OUTNAME="${BASENAME}_xmp.jpg"
    echo "Input : $REALNAME"
    echo "Output: $OUTNAME"

    if [ -f "$OUTNAME" ]; then
        echo "Output file already exists. Skipping..."
        exit 1
    fi

    INFO=`exiv2 -pa "$REALNAME" | grep "Pose.*Degrees"`
    PITCH=`echo "$INFO" | grep "Pitch" | sed -nre 's/^.* ([0-9.-]+)$/\1/p'`
    ROLL=`echo "$INFO" | grep "Roll" | sed -nre 's/^.* ([0-9.-]+)$/\1/p'`

    echo "Pitch / Roll: $PITCH / $ROLL"

    if [ -z "$PITCH" -o "$PITCH" == "0" -o -z "$ROLL" -o "$ROLL" == "0" ]; then
        echo "No pitch/roll info found or already zero. No processing neccessary."
        exit 2
    fi

#    echo "i w3584 h1792 f4 v360 r$ROLL p$PITCH y0 n\"$REALNAME\"" > "$BASENAME.pto"
#    echo "p w3584 h1792 f2 v360 r0 p0 y0 n\"JPEG q99\"" >> "$BASENAME.pto"
#    nona -o "$OUTNAME" "$BASENAME.pto"
#    rm "$BASENAME.pto"
    echo -e "i w3584 h1792 f4 v360 r$ROLL p$PITCH y0 n\"$REALNAME\"\np w3584 h1792 f2 v360 r0 p0 y0 n\"JPEG q99\"" | nona -g -o "$OUTNAME" /dev/stdin

    exiv2 ex "$REALNAME"
    mv "$BASENAME.exv" "${BASENAME}_xmp.exv"
    exiv2 in -M "reg GPano http://ns.google.com/photos/1.0/panorama/" -M "set Xmp.GPano.PosePitchDegrees 0" -M "set Xmp.GPano.PoseRollDegrees 0" "${BASENAME}_xmp.jpg"
    rm "${BASENAME}_xmp.exv"
else
    echo "RICOH Theta to PhotoSphere converter"
    echo "Usage: $0 file"
    exit 3
fi
