#!/bin/bash
# SVN add script

IFS=$'\n'

files=($(svn status | egrep "^\? *$1" | awk -F' ' '{$1=""; print $0 }' | sed -e 's/^[[:space:]]*//'))


echo "The following files and directories will be added to SVN:"
for f in ${files[@]}; do
	echo "  $f"
done

valid=false

while ! $valid; do
	read -p "Do you want to proceed? (y/n): "
	case $REPLY in
		y)
			valid=true
			echo "Adding files"
			#svn add ${files[@]/ /\ }
			for f in ${files[@]}; do
				# f2=$(echo "$f" | sed -e 's/^[[:space:]]*//')
				echo "$f"
				svn add "$f"
			done
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

