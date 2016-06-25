#!/bin/bash
# Fix symlinks

DEV_ROOT="/Users/craigmiller/PilotFish/DevRoot"
PROJECT="$DEV_ROOT/.project"

function replace_link {

	path="$1"
	
	echo "Fixing $path"
	rm -rf "$path"
	ln -s "$PROJECT/$path" "$path"
}

export -f replace_link
export DEV_ROOT="$DEV_ROOT"
export PROJECT="$PROJECT"

find . -type l -exec bash -c 'replace_link {}' \;