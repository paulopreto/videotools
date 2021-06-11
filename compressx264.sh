#!/bin/bash
# Example to run -> ./compressx264.sh
#
# COMPRESSX264: v1.0 - Paulo Santiago 10-06-2021

for i in *.mp4;
  do name=`echo "$i" | cut -d'.' -f1`
  echo "$name"
  mkdir compressed_x264
  ffmpeg -i "$i" -vcodec libx264 -pix_fmt yuv420p -acodec aac "./compressed_x264/${name}"_x264".mp4" -hide_banner
  echo "$name ------------> !!!!!! Done !!!!!"
done
