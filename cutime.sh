#!/bin/bash
# Example to run -> ./cutime.sh videoname.mp4 time_start time_end
# ./cutime.sh videoname.mp4 00:00:17 00:00:56

# CUTIME: v1.0 - Paulo Santiago 02-07-2021

FILENAME="$1"
TIMES=$2
TIMEE=$3
DIRNAME=`echo "$FILENAME" | cut -d'.' -f1`
COMPLEMENTO="_cutime"

if [ ! -d "${DIRNAME}${COMPLEMENTO}" ]; then
	mkdir "${DIRNAME}${COMPLEMENTO}"
fi

TS=`echo "$TIMES" | tr : -`
TE=`echo "$TIMEE" | tr : -`
ffmpeg -i $FILENAME -ss "${TIMES}" -to "${TIMEE}" -c copy "${DIRNAME}${COMPLEMENTO}"/"${DIRNAME}_${TS}_${TE}".mp4 -loglevel quiet -nostats -hide_banner

echo "file '${DIRNAME}_${TS}_${TE}.mp4'" >> "${DIRNAME}${COMPLEMENTO}/listvideo.txt"
echo "------------> !!!!!! Done !!!!!"

