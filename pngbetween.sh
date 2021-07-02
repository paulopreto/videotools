#!/bin/bash
# Example to run -> ./pngbetween.sh videoname.mp4 frame_start frame_end 
#
# PNGBETWEEN: v1.0 - Paulo Santiago 10-06-2021

FILENAME="$1"
START=$2
END=$3
DIRNAME=`echo "$FILENAME" | cut -d'.' -f1`
COMPLEMENTO="_png_${START}_${END}"
mkdir "$DIRNAME$COMPLEMENTO"
ffmpeg -i $FILENAME -vf select="between(n\,$START\,$END)" -vsync 0 "$DIRNAME$COMPLEMENTO"/%09d.png -loglevel quiet -nostats -hide_banner
echo "------------> !!!!!! Done !!!!!"