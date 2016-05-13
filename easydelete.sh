#!/bin/bash
# Script
# Name: Delete
# Author: Craig Miller
# Description: A script to allow for a more powerful delete operation. It is more powerful than your usual rm operation.

# Option: -g --regex = Use a regular expression


REGEX=false
PATHS=()

function parse_argument {

    case $1 in
        --regex)
            ### TODO find a way to throw an error with the flags if any paths have been assigned
            if $REGEX ; then
                echo "Error! Regex argument passed more than once"
                exit 1
            else
                REGEX=true
            fi
        ;;
        -*)
            dash_count=0
            for (( i=0; i<${#1}; i++ )); do
                case ${1:$i:1} in
                    -)
                        dash_count=$((dash_count + 1))
                        if [ $dash_count -gt 1 ]; then
                            echo "Error! Invalid argument: $1"
                            exit 1
                        fi
                    ;;
                    g)
                        if $REGEX ; then
                            echo "Error! Regex argument passed more than once"
                            exit 1
                        else
                            REGEX=true
                        fi
                    ;;
                esac
            done
        ;;
        *)
            if $REGEX && [ ${#PATHS[@]} -eq 1 ]; then
                echo "Error! Only one path pattern is allowed for a regex operation"
                exit 1
            else
                echo "Path: $1 -- ${PATHS[@]}"
                PATHS+=($1)
            fi
        ;;
    esac
    
}

if [ $# -lt 1 ]; then
	echo "Error! Missing arguments to specify what to delete"
	exit 1
fi

IFS=$'\n'

for arg in $@; do
    parse_argument $arg
done



if [ $REGEX ]; then
    ### TODO check to see if the regex value exists, if not return an error
    files=($(ls -ap | grep ${PATHS[0]})) # | awk '{print "\"" $0 "\"" }')
else
    ### TODO non-regex operations need to check if the file actually exists
    files=${PATHS[@]}
fi




## TODO make directory removal optional
## TODO indicate a directory in the output
## TODO make regex vs literal name optional


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
