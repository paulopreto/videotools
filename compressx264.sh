#!/bin/bash
# Example to run -> ./compressx264.sh
#
# COMPRESSX264: v1.0 - Paulo Santiago 10-06-2021

if [ -z $1 ]
  then
  EXTNAME=$"mp4"
else
  EXTNAME=$1
fi

for i in *."${EXTNAME}";
  do name=`echo "$i" | cut -d'.' -f1`
  echo "$name"
  mkdir compressed_x264
  ffmpeg -i "$i" -vcodec libx264 -pix_fmt yuv420p -acodec aac "./compressed_x264/${name}"_x264".mp4" -loglevel quiet -nostats -hide_banner
  echo "$name ------------> !!!!!! Done !!!!!"
done
