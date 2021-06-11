#!/bin/bash
# Example to run -> ./cutbetween.sh videoname.mp4 start_frame end_frame
#
# CUTBETWEEN: v1.0 - Paulo Santiago 10-06-2021

FILENAME="$1"
FRAMES=$2
FRAMEE=$3
DIRNAME=`echo "$FILENAME" | cut -d'.' -f1`
COMPLEMENTO="_cutbt"
mkdir "$DIRNAME$COMPLEMENTO"
ffmpeg -i $FILENAME -an -vf "select=between(n\,"$FRAMES"\,"$FRAMEE"),setpts=PTS-STARTPTS" "$DIRNAME$COMPLEMENTO"/"$DIRNAME"_"$FRAMES"_"$FRAMEE".mp4 -hide_banner
echo "------------> !!!!!! Done !!!!!"