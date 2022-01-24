#!/bin/bash
# Example to run --> ./batchcut.sh listvideos2cut.txt
# Example listvideoscut.txt:
#
# GOPRO1.MP4 newname1 10 56
# GOPRO2.MP4 newname2 17 57
#
#
# BATCHCUT: v1.0 - Paulo Santiago 11-10-2021

FILE="$1"
WORKDIR=`echo "$FILE" | cut -d'.' -f1`
mkdir $WORKDIR


while IFS= read -r line ; do
    echo $line
    IFS=' ' read NOMEORIGINAL NOMEFINAL FRAMEI FRAMEF <<< ${line}
    
    echo $NOMEORIGINAL
    echo $NOMEFINAL
    echo $FRAMEI
    echo $FRAMEF
    echo "Iniciando arquivo $NOMEORIGINAL"
    echo 'ffmpeg' -nostdin -i $NOMEORIGINAL -an -vf "select=between(n\,$FRAMEI\,$FRAMEF),setpts=PTS-STARTPTS" "$WORKDIR""/""$NOMEFINAL"".mp4" -hide_banner
    ffmpeg -nostdin -i $NOMEORIGINAL -an -vf "select=between(n\,$FRAMEI\,$FRAMEF),setpts=PTS-STARTPTS" "$WORKDIR""/""$NOMEFINAL"".mp4" -hide_banner
    echo ""$NOMEFINAL" FEITO!"
done < $FILE 
