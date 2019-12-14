#!/bin/bash
#
# This script extracts the date of the foto was taken from the EXIF information
# and renames file in such a way, that shot date is places in the beginning of the file name.

# Input parameter to the script is a path to the target folder

SOURCE=$1

if [[ ! -e $SOURCE ]]; # First check if the target does exist in the file system
then
	echo "Target does not exist."
	exit 1
fi

if [[ -d $SOURCE ]]; then # Checking if target is a directory.
	pushd "$SOURCE"
	mkdir -p with_date/
	for FILE in $(find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) -printf "%f\n")
	do
		SHOT_DATE=$(identify -verbose "$FILE" | grep exif:DateTimeOriginal: | awk -F":" '{print $3"-"$4"-"$5}' | cut -b2-11)
		cp "$FILE" with_date/"$SHOT_DATE"_"$FILE"
	done
	popd
	exit 0
elif [[ ! -d $SOURCE ]]; then # Checking, if target is not a directory (e.g. file, device, etc.)
	echo "Error! Please enter directory as input."
	exit 1
fi
