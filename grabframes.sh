#!/bin/bash
# Example to run -> ./grabframes.sh videoname.mp4 [0,3,5,7,9]
#
# GRABFRAMES: v1.0 - Paulo Santiago 10-06-2021

FILENAME="$1"
FRAMES="$2"
DIRNAME=`echo "$FILENAME" | cut -d'.' -f1`
COMPLEMENTO="_grab"
mkdir "$DIRNAME$COMPLEMENTO"
printf '%s' "$FRAMES" |
sed 's:\[\|\]::g; s:[, ]\+:\n:g' |
xargs printf '%03d\n' |
xargs -IFRAME ffmpeg -i "$FILENAME" -vf "select=eq(n\,FRAME)" -vframes 1 "$DIRNAME$COMPLEMENTO"/FRAME.png -hide_banner
