#!/bin/bash
# Example to run --> ./concatvideo.sh folder_name
# Example to run and compress x265 --> ./concatvideo.sh folder_name 1
#
# CONCATVIDEO: v1.0 - Paulo Santiago 02-07-2021

DIRNAME=$1
if [ ! -d $1 ]; then
	echo "Folder $1 does not exist!!!"
fi

ffmpeg -f concat -i "${DIRNAME}/listvideo.txt" -c copy "${DIRNAME}/${DIRNAME}_concat".mp4 -loglevel quiet -nostats -hide_banner

echo "-----------> !!!!!! Done !!!!!"


DIRNAME=$1
if [ ! -d $1 ]; then
	echo "Folder $1 does not exist!!!" && exit
fi

if [ $# -gt 1 ]; then
	if [ $2 -eq 1 ]; then
		ffmpeg -f concat -i "${DIRNAME}/listvideo.txt" -vcodec libx265 -pix_fmt yuv420p -vtag hvc1 "${DIRNAME}/${DIRNAME}_concat".mp4 -loglevel quiet -nostats -hide_banner
		echo -e "\nOs arquivos foram juntados e codificado em H265"
	else
		ffmpeg -f concat -i "${DIRNAME}/listvideo.txt" -c copy "${DIRNAME}/${DIRNAME}_concat".mp4 -loglevel quiet -nostats -hide_banner
		echo -e "\n!!!!!! DONE !!!!!"
	fi	
else
	ffmpeg -f concat -i "${DIRNAME}/listvideo.txt" -c copy "${DIRNAME}/${DIRNAME}_concat".mp4 -loglevel quiet -nostats -hide_banner
	echo -e "\n!!!!!! DONE !!!!!"
fi


