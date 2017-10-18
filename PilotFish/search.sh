#!/bin/bash
# Searches all files for specific text

function search() {
	if [[ -f "$1" ]]; then
		name=$(basename $1)
		if [[ "${name:0:1}" != "." ]]; then
			count=$(grep "$PATTERN" "$1" | wc -l)
			if [[ $count -gt 0 ]]; then
				echo "Found match in file: $1"
				# grep -n "$PATTERN" "$1"
			fi
		fi
	fi
}

# foo="foo"

# if [[ "${foo:0:1}" != . ]]; then
# 	echo "Working"
# fi

if [[ $# -lt 1 ]]; then
	echo "Must supply a pattern to search for"
	exit 1
fi

export -f search
export PATTERN="$1"

find . -exec bash -c 'search "{}"' \;