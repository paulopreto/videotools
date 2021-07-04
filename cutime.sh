#!/bin/bash
# Example to run -> ./cutime.sh videoname.mp4 time_start time_end
# ./cutime.sh videoname.mp4 00:00:17 00:00:56
#
# CUTIME: v1.0 - Paulo Santiago 02-07-2021

FILENAME="$1"
TIMES=$2
TIMEE=$3
DIRNAME=`echo "$FILENAME" | cut -d'.' -f1`
COMPLEMENTO="_cut"

if [ ! -d "${DIRNAME}${COMPLEMENTO}" ]; then
	mkdir "${DIRNAME}${COMPLEMENTO}"
fi

TS=`echo "$TIMES" | tr : -`
TE=`echo "$TIMEE" | tr : -`


if [ $# -gt 3 ]; then
	if [ $4 -eq 1 ]; then
		#ffmpeg -i $FILENAME -ss "${TIMES}" -to "${TIMEE}" -vcodec libx264 -pix_fmt yuv420p -acodec aac "${DIRNAME}${COMPLEMENTO}"/"${DIRNAME}_${TS}_${TE}".mp4 -loglevel quiet -nostats -hide_banner
		ffmpeg -i $FILENAME -ss "${TIMES}" -to "${TIMEE}" -vcodec libx265 -pix_fmt yuv420p -vtag hvc1 "${DIRNAME}${COMPLEMENTO}"/"${DIRNAME}_${TS}_${TE}".mp4 -loglevel quiet -nostats -hide_banner
		echo -e "\nO arquivo além de cortado foi codificado em H265"
	else
		ffmpeg -ss "${TIMES}" -i $FILENAME -t "${TIMEE}" -vcodec copy -acodec copy "${DIRNAME}${COMPLEMENTO}"/"${DIRNAME}_${TS}_${TE}".mp4 -loglevel quiet -nostats -hide_banner
	fi
else
	ffmpeg -ss "${TIMES}" -i $FILENAME -t "${TIMEE}" -vcodec copy -acodec copy "${DIRNAME}${COMPLEMENTO}"/"${DIRNAME}_${TS}_${TE}".mp4 -loglevel quiet -nostats -hide_banner
fi

echo "file '${DIRNAME}_${TS}_${TE}.mp4'" >> "${DIRNAME}${COMPLEMENTO}/listvideo.txt"
echo -e "\n!!!!!! DONE !!!!!"
