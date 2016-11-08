#!/bin/bash
# Script to count lines of code

lines=0

function count_code {
	new_lines=$(cat $1 | wc -l)
	echo $new_lines
	lines=$(($lines + $new_lines))
	echo $lines
}

export -f count_code
find . -name '*.java' -exec bash -c 'count_code "$0"' {} \;

echo "FINAL: $lines"