#!/bin/bash

MYPATH=/home/fangolnor/BongoCat

SRCPATH=$MYPATH/keys
DSTPATH=$MYPATH/result

FRAME_MAX=745
PER_HIT=3
FST_HIT=1

echo "Wipe directory"
rm -f "$DSTPATH/*"

echo "Write lead-in"
cp -f $SRCPATH/bongo020.png $DSTPATH/000.png
for i in $(seq -f "%03g" 0 20); do
	cp -f $SRCPATH/bongo020.png $DSTPATH/$i.png
done

cp -f $SRCPATH/bongo021.png $DSTPATH/021.png
cp -f $SRCPATH/bongo022.png $DSTPATH/022.png
cp -f $SRCPATH/bongo023.png $DSTPATH/023.png
cp -f $SRCPATH/bongo024.png $DSTPATH/024.png
cp -f $SRCPATH/bongo025.png $DSTPATH/025.png
cp -f $SRCPATH/bongo026.png $DSTPATH/026.png
cp -f $SRCPATH/bongo027.png $DSTPATH/027.png

echo "Write blanks"
for i in $(seq -f "%03g" 28 745); do
	cp -f $SRCPATH/bongo028.png $DSTPATH/$i.png
done

while read -r line; do

	frame=$(echo $line | awk '{print $1;}')
	later=$(echo $line | awk '{print $2;}')
	if [[ "$frame" == "" ]]; then 
		continue; 
	fi

	echo "Push '$later' at frame $frame";

	# Right paw
	if [[ "$later" == "r" ]]; then
		for i in $(seq -f "%03g" $frame $(echo $PER_HIT+$frame | bc)); do
			cp -f $SRCPATH/bongo045.png $DSTPATH/$i.png
		done
	fi

	# Left paw
	if [[ "$later" == "l" ]]; then
		for i in $(seq -f "%03g" $frame $(echo $PER_HIT+$frame | bc)); do
			cp -f $SRCPATH/bongo069.png $DSTPATH/$i.png
		done
	fi
	
	# Fast Right paw
	if [[ "$later" == "x" ]]; then
		for i in $(seq -f "%03g" $frame $(echo $FST_HIT+$frame | bc)); do
			cp -f $SRCPATH/bongo045.png $DSTPATH/$i.png
		done
	fi

	# Fast Left paw
	if [[ "$later" == "y" ]]; then
		for i in $(seq -f "%03g" $frame $(echo $FST_HIT+$frame | bc)); do
			cp -f $SRCPATH/bongo069.png $DSTPATH/$i.png
		done
	fi
	
	# Both paws
	if [[ "$later" == "b" ]]; then
		for i in $(seq -f "%03g" $frame $(echo $PER_HIT+$frame | bc)); do
			cp -f $SRCPATH/bongo098.png $DSTPATH/$i.png
		done
	fi
	
done < "$MYPATH/hitmap.txt"

ffmpeg -y -framerate 30 -i $DSTPATH/%03d.png -i $MYPATH/mnothing.wav -c:a mp3 -ab 192k $MYPATH/video.mp4
#ffmpeg
