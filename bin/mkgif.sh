#!/usr/bin/env bash

#################################################
## 
## The directory is assumed to hold a file named
## pics.tar.gz with the following structure: 
##    pics/
##    pics/pic00.png
##    pics/pic01.png
##    ...
##
#################################################
[ "x$1" = "x" ] && echo "USAGE: bash $0 dirname fps" && exit 
[ "x$2" = "x" ] && echo "USAGE: bash $0 dirname fps" && exit 
# REMOVE OPTIONAL TRAILING SLASH
DIR=${1%/}
FPS=$2

TMPFILE=play.txt
CONTAINER=mp4
KEEPVIDEO=0
WIDTH=640
OUTNAME=$(echo $DIR | tr "-" "\n" | tail -n1 | sed "s@/@@")-${WIDTH}-${FPS}
#OUTNAME=${DIR}-${WIDTH}-${FPS}

if [ $FPS -gt 10 ] 
then
        DURATION="0.0$((1000/$FPS))"
else 
        DURATION="0.$((1000/$FPS))"
fi


# EXTRACT PICS
tar xfC ${DIR}/pics.tar.gz ${DIR}

for f in $(ls ${DIR}/pics/*png)
do 
    echo "$f"
    echo "file $f" >> ${TMPFILE}
    echo "duration ${DURATION}" >> ${TMPFILE}
done 

ffmpeg \
    -f concat -i ${TMPFILE} \
    -c:v libx264 \
    -pix_fmt yuv420p \
    -loop 1 \
    -r ${FPS} \
    -y ${DIR}/${OUTNAME}.${CONTAINER}
rm ${TMPFILE}
rm -rf ${DIR}/pics

ffmpeg \
    -i ${DIR}/${OUTNAME}.${CONTAINER} \
    -vf "fps=${FPS},scale=${WIDTH}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -y ${DIR}/${OUTNAME}.gif

! [ ${KEEPVIDEO} -gt 0 ] && rm ${DIR}/${OUTNAME}.${CONTAINER}
