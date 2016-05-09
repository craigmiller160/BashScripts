#!/bin/bash
# Script to delete files passed to it

if [ $# -ne 1 ]; then
	echo "Error! Script needs to be run with a single argument that is the regex for the files to delete"
	exit 1
fi

IFS=$'\n'

files=($(ls -a | grep $1)) # | awk '{print "\"" $0 "\"" }')

## TODO include variable for directory
## TODO indicate a directory in the output

echo "This script will delete the following files:"
printf '  %q\n' "${files[@]}"

valid=false

while ! $valid ; do
	read -p "Do you want to proceed? (y/n): "
	case $REPLY in
		y)
			valid=true
			echo "Deleting, please wait"
			rm -rf ${files[@]}
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