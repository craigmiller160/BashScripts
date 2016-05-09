#!/bin/bash
# Script to delete files passed to it

if [ $# -ne 1 ]; then
	echo "Error! Script needs to be run with a single argument that is the regex for the files to delete"
	exit 1
fi

IFS=$'\n'

files=$(ls -a | grep $1 | awk '{print "\"" $0 "\"" }')

## TODO ensure directory support

echo "This script will delete the following files:"
for f in $files; do
	echo "  $f"
done

valid=false

while ! $valid ; do
	read -p "Do you want to proceed? (y/n): "
	case $REPLY in
		y)
			valid=true
			echo "Deleting, please wait"
			echo $files
			rm ${files[@]}
		;;
		n)
			valid=true
		;;
		*)
			echo "Invalid input, please try again"
		;;
	esac
done



exit 0