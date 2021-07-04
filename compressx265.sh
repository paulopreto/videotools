#!/bin/bash
# Example to run -> ./compressx265.sh
#
# COMPRESSX265: v1.0 - Paulo Santiago 04-07-2021

if [ -z $1 ]
  then
  EXTNAME=$"mp4"
else
  EXTNAME=$1
fi

for i in *."${EXTNAME}";
  do name=`echo "$i" | cut -d'.' -f1`
  echo "$name"
  mkdir compressed_x265
  ffmpeg -i "$i" -vcodec libx265 -vtag hvc1 "./compressed_x265/${name}"_x265".mp4" -hide_banner
  echo "$name ------------> !!!!!! Done !!!!!"
done
