#!/bin/bash
# Example to run -> ./concatvideo.sh folder_name
#
# CONCATVIDEO: v1.0 - Paulo Santiago 02-07-2021

DIRNAME=$1
if [ ! -d $1 ]; then
	echo "Folder $1 does not exist!!!"
fi

ffmpeg -f concat -i "${DIRNAME}/listvideo.txt" -c copy "${DIRNAME}/${DIRNAME}_concat".mp4 -loglevel quiet -nostats -hide_banner

echo "-----------> !!!!!! Done !!!!!"
