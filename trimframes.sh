#!/bin/bash
# Example to run -> ./trimframes.sh videoname.mp4 sincframe range_after_before_sinc
#
# TRIMFRAMES: v1.0 - Paulo Santiago 10-06-2021

FILENAME="$1"
FRAMEKEY=$2
RANGEFRAMES=$3
INI=$[$FRAMEKEY-RANGEFRAMES]
FIM=$[$FRAMEKEY+RANGEFRAMES]
DIRNAME=`echo "$FILENAME" | cut -d'.' -f1`
COMPLEMENTO="_trim"
mkdir "$DIRNAME$COMPLEMENTO"
ffmpeg -i $FILENAME -vf select="between(n\,$INI\,$FIM)" -vsync 0 "$DIRNAME$COMPLEMENTO"/%09d.png -hide_banner
echo "------------> !!!!!! Done !!!!!"
