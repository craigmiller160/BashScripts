#!/bin/bash
# A script to search a series of jars for the logConfig.xml

CURRENT_DIR=$(pwd)

find_file=""

function main {
	read -p "File to search for:"
	find_file="$REPLY"

	if [[ $find_file == "" ]]; then
		echo "Error! No file to search for selected"
		exit 1
	else
		read -p "Confirm file to search for: $find_file"
		case $REPLY in
			y|Y) ;;
			n|N)
				echo "Script cancelled, please try again."
				exit 0
			;;
			*)
				echo "Error, invalid input!"
				exit 1
			;;
		esac
	fi

	echo "Directory to search for $find_file: $CURRENT_DIR"
	read -p "Do you want to proceed? (y/n): "
	case $REPLY in
		y|Y) execute ;;
		n|N) 
			echo "Exiting script"
			exit 0
		;;
		*)
			echo "Error, invalid input!"
			exit 1
		;;
	esac
}

function execute {
	# Export the functions and start the find process
	export -f process_file
	export -f process_jar
	export "find_file=$find_file"
	find . -exec bash -c 'process_file "$0"' {} \;
}

function process_file {
	file="$1"

	# If the file is a jar, unpack and search it. Otherwise, test it to see if it is the logConfig.xml file
	if [[ "$file" == *.jar ]]; then
		process_jar "$file"
	else
		if [[ "$file" == "$find_file" ]] || [[ "$file" == *"$find_file" ]]; then
			echo "Found: $file"
		fi
	fi
}

function process_jar {
	jar_file="$1"

	# Unpack the jar
	filename=$(basename $jar_file)
	dirname="${filename%.*}"
	7z x "-o$dirname" -aoa "$jar_file" 1>/dev/null #2>/dev/null

	# Search the jar's directory
	find "$dirname" -exec bash -c 'process_file "$0"' {} \;

	# Delete the directory when finished
	rm -rf "$dirname"
}

main