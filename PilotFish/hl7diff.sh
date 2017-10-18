#!/bin/bash
# Script to use the HL7 diff tool, specifically with the dynacare sample file structure
# Assumes that, from the root of where this script is executed, the following is true:
# - There is a directory called "diff"
# - Inside that directory are two subfolders: "source" & "target".
# - "target" is the directory with the "good" files, the ones we want to match to
# - "source" is the directory with the "work-in-progress" files, the ones we want to make match the target
# - All the files in "source" and "target" are named "sampleX.hl7".
# - Command line arguments are the number for the X part of the filename.
# - Results are always outputted to "diff/out.html"

if [[ $# -lt 3 ]]; then
	echo "Error! Not enough arguments"
	exit 1
fi

OUTPUT="diff/out.html"
NEW_DIR="diff/new"
OLD_DIR="diff/old"

srcfile="source/sample$2.hl7"
targetfile="target/sample$3.hl7"

case $1 in
	"new") dir=$NEW_DIR ;;
	"old") dir=$OLD_DIR ;;
	*)
		echo "Error! Invalid directory argument"
		exit 1
	;;
esac

srcexists=false
targetexists=false

if [[ -f "$dir/$srcfile" ]]; then
	srcexists=true
	echo "Source file found. File: $srcfile"
else
	echo "Error! Source file doesn't exist. File: $srcfile"
fi

if [[ -f "$dir/$targetfile" ]]; then
	targetexists=true
	echo "Target file found. File: $targetfile"
else
	echo "Error! Target file doesn't exist. File: $targetfile"
fi

if $srcexists && $targetexists ; then
	perl hl7diff-txt.pl -w $dir/$srcfile $dir/$targetfile > $OUTPUT
	echo "Diff peformed. Output: $OUTPUT"
	open $OUTPUT
	exit 0
else
	exit 1
fi