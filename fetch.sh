#!/bin/bash

WORKDIR=/camera
CAMERADIR=/mnt/camera
LASTFILE=$WORKDIR/last.jpg

while sleep 10
do
    # mount camera
    gphotofs $CAMERADIR  2>&1

    # Has camera powered off
    ls  $CAMERADIR > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo UNMOUNTING [$?];
        fusermount -u $CAMERADIR;
        continue;
    fi

    # first run find newesst file
    if [ ! -f $LASTFILE ]; then
	echo "finding newest"
        newest=`find $CAMERADIR -type f -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2 | tail -n 1`
        cp $newest $LASTFILE
    fi

    NEWFILES=`find $CAMERADIR -newer $LASTFILE -type f`
    for newfile in $NEWFILES
    do
        echo "Resize and upload file: $newfile" 
        convert $newfile -resize 640x480 $WORKDIR/resized.jpg
        # do upload
        curl -F upload=@resized.jpg http://natpas.nathejk.dk/upload-image.php
        if [ $? -eq 0 ]; then
            # upload succeeded
            cp --preserve=all $newfile $LASTFILE
        fi
    done
    fusermount -u $CAMERADIR
done
