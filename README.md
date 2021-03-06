# Bash script to put shot date from EXIF into file name

When organize your photo library, it is convenient to use sort files based on date of shot. But quite often SWLRs do not provide this option (e.g. mine allows only format first 3 letters of the file name and then it creates picture files with the names like **<ABC>_<1234>.nef**. When camera reaches 9999th shot, it starts again with 0001. Therefore I needed some tool/script which will help me to organize files properly.

Using power of Linux shell and command line tools I made a script which extracts necessary information from the EXIF of the picture file and adds the date into the file name.

## Required packages

To extract information from file I use `identify` tool from the **ImageMagick** suite of tools. My version of **ImageMagick** is **6.9.7-4**.
In my script I rename only **JPG** and **PNG** files, but you can add more extensions.

## The script itself

- Script shall receive target directory as an input.
- Script creates new sub directory there called **with_dates**.
- Scripts extracts following field from EXIF: **DateTimeOriginal**.
	- > It might be, that your camera uses different field (e.g. **DateTime** or **DateTimeDigitalized).** Then you shall modify or extend the script to use those fields to extract the data. My SLR (Nikon D7000), my smart phones put **DateTimeOriginal** field in the EXIF. To check what kind of EXIF data writes your camera, you can use simple command: `identify -verbose FILE | grep exif`.
- Copies original picture file into the **with_dates** sub folder with the following name format: **[DATE]_[ORIGINAL FILE NAME].[EXTENSION]** (e.g. 2019-02-01_IMAGE0001.JGP).
	- Where DATE is formatted as follows: `%Y-%m-%d` (e.g. 2019-02-01)

If you wish, you can modify the script to extract and put even time of shot in the file name.


```sh
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

```

Original script file you can download here [exif-date.sh](files/exif-date.sh)
