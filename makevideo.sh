#!/bin/bash
# Example to run -> ./makevideo.sh 30 'img%09d'
#
# MAKEVIDEO: v1.0 - Paulo Santiago 10-06-2021

FPS=$1
PATTERN=$2

if [ -z "$2" ]; then
  ffmpeg -framerate $FPS -i '%09d.png' -vcodec libx264 -pix_fmt yuv420p vid2_fps"$FPS".mp4
else
  ffmpeg -framerate $FPS -i "$2"".png" -vcodec libx264 -pix_fmt yuv420p vid2_fps"$FPS".mp4
fi
# Only Linux
#ffmpeg -framerate $FPS -pattern_type glob -i '*.png' -vcodec libx264 -pix_fmt yuv420p vid_fps"$FPS".mp4
