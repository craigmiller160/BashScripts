#!/bin/bash
# Remove symlink files

function delete_symlink {
	if [[ "$1" == ".git" ]]; then
		echo "Skipping"
		return 0
	fi

	if [[ -L "$1" ]]; then
		echo "Deleting symlink $1"
		rm "$1"
	else
		echo "Ignoring non-symlink $1"
	fi
}

export -f delete_symlink

find . ! -path './.git/*' -exec bash -c 'delete_symlink "$0"' {} \;