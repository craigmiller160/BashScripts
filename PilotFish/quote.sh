#!/bin/bash
# Script to quote output

IFS=$'\n'

echo $#

for i in $@; do
	echo $i | sed 's/^/"/g' | sed 's/$/"/g'
done