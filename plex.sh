#!/bin/bash

if [ $# -lt 1 ]; then
	echo "No arguments provided, nothing will be done"
	exit 1
fi

if [ $1 == "refresh" ]; then
	echo "Refreshing PlexMediaServer"
	curl http://localhost:32400/library/sections/1/refresh
	curl http://localhost:32400/library/sections/2/refresh
fi
