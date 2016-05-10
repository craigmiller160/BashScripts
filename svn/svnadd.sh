#!/bin/bash
# SVN add script

# if [ $# -lt 1 ]; then
# 	echo "Error! Invalid number of arguments for script"
# 	exit 1
# fi

IFS=$'\n'

# if [ $# -lt 1 ]; then
# 	echo "No regex"
# 	files=($(svn status | grep '^?'))
# else
	
# fi

files=($(svn status | grep "^? *$1"))


echo "The following files and directories will be added to SVN:"
for f in ${files[@]}; do
	echo "$f" | awk -F' ' '{ print "  " $NF}'
done

valid=false

while ! $valid; do
	read -p "Do you want to proceed? (y/n): "
	case $REPLY in
		y)
			valid=true
			echo "Adding files"
			## TODO svn add here
		;;
		n)
			valid=true
			echo "Cancelling operation"
		;;
		*)
			echo "Invalid response, please try again"
		;;
	esac
done

