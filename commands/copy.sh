#!/bin/bash
# Advanced copy script

echo "Running advanced copy script"

if [ -d "$1" ]; then
	echo "Found directory"
else
	echo "Not a directory"
	exit 1
fi

file_count="$(find $1 -type f | wc -l)"

echo $file_count

IFS=$'\n'
file_array="$(find $1 -type f)"
directory_array="$(find $1 -type d)"


for i in $file_array; do
	echo $i
done

for i in $directory_array; do
	echo $i | sed 's|^$1/||p'
done
