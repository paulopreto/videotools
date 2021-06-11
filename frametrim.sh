#!/bin/bash
# Example to run -> ./frametrim.sh videoname.mp4 5 10
#
# FRAMETRIM: v1.0 - Paulo Santiago 10-06-2021

FILENAME="$1"
FRAMEKEY=$2
RANGEFRAMES=$3
INI=$[$FRAMEKEY-1-RANGEFRAMES]
FIM=$[$FRAMEKEY-1+RANGEFRAMES]
DIRNAME=`echo "$FILENAME" | cut -d'.' -f1`
COMPLEMENTO="_trim"
mkdir "$DIRNAME$COMPLEMENTO"
ffmpeg -i $FILENAME -vf select="between(n\,$INI\,$FIM)" -vsync 0 "$DIRNAME$COMPLEMENTO"/%09d.png -hide_banner
