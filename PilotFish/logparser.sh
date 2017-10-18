#!/bin/bash
# Script to parse the FTP log text

OUTPUT_FILE="output.txt"
TEMP_FILE="temp.txt"

if [[ $# -ne 1 ]]; then
	echo "Error! Need log file"
	exit 1
fi

if [ -f $OUTPUT_FILE ]; then
	echo "Deleting old output file"
	rm $FTPLOG
fi


cat $1 | sed 's/ DEBUG \[transact\]://' | sed 's/\[/;\[/g' | sort -t ';' -n -k2 -k6 | sed 's/;//g' > $TEMP_FILE

while IFS=$\n read -r line ; do
	
done < $TEMP_FILE