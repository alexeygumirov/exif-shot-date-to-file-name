# Bash script to put shot date from EXIF into file name

When organize your photo library, it is convinient to use sort files based on date of shot. But quite often SLRs do not provide this option (e.g. mine allows only format first 3 letters of the file name and then it creates picure files with the names like **<ABC>_<1234>.nef**. When camera reaches 9999th shot, it starts again with 0001. Therefore I needed some tool/script which will help me to organize files properly.

Using power of Linux shell and command line tools I made a script which exctracts necessary information from the EXIF of the picture file and adds the date into the file name.

## Required packages

To exctract information from file I use `identify` tool from the **ImageMagick** suite of tools. My version of **ImageMagick** is **6.9.7-4**.
In my script I rename only **JPG** and **PNG** files, but you can add more extensions.

## The script itself

```sh
#!/bin/bash
#
# This script extracts the date of the foto was taken from the EXIF information
# and renames file in such a way, that shot date is places in the beginning of the file name.

# Input parameter to the script is a path to the target folder

SOURCE=$1
INITDIR=$PWD

if [[ ! -e $SOURCE ]]; # First check if the target does exist in the file system
then
	echo "Target does not exist."
	exit 1
fi

if [[ -d $SOURCE ]]; then # Checking if target is a directory.
	cd "$SOURCE"
	mkdir -p with_date/
	for FILE in $(find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) -printf "%f\n")
	do
		SHOT_DATE=$(identify -verbose "$FILE" | grep exif:DateTimeOriginal: | awk -F":" '{print $3"-"$4"-"$5}' | cut -b2-11)
		cp "$FILE" with_date/"$SHOT_DATE"_"$FILE"
	done
	cd "$INITDIR"	
	exit 0
elif [[ ! -d $SOURCE ]]; then # Checking, if target is not a directory (e.g. file, device, etc.)
	echo "Error! Please enter directory as input."
	exit 1
fi

```

Original script file you can download here [exif-date.sh](files/exif-date.sh)
