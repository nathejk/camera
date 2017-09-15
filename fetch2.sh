#!/bin/bash

WORKDIR=/camera
CAMERADIR=/home/pirate/photos
LASTFILE=$WORKDIR/last.jpg


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
