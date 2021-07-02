#!/bin/bash
# Example to run -> ./convertavi2mp4.sh
#
# CONVERTAVI2MP4: v1.0 - Paulo Santiago 10-06-2021

for i in *.avi; do
  name=`echo "$i" | cut -d'.' -f1`
  echo "$name"
  mkdir encoded_mp4
  ffmpeg -i "$i" -vcodec libx264 -pix_fmt yuv420p -acodec aac "./encoded_mp4/${name}.mp4" -loglevel quiet -nostats -hide_banner
  echo "$name ------------> !!!!!! Done !!!!!"
done
