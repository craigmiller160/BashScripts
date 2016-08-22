#!/bin/bash
# Script to convert a jar to java 6

# The function to execute to convert a class file to java 6
function j6patch() {
	printf "\x00\x00\x00\x32" |dd of=$1 seek=4 bs=1 count=4 conv=notrunc
}

if [ $# -ne 1 ]; then
	echo "Error! The name of the jar to convert must be provided"
	exit 1
fi

# Export the j6patch function so that it can be used with the find command later in the script
export -f j6patch

# Assign values for the current and new jar names
jar_name="$1"
new_jar_name="${jar_name/.jar/}-j6.jar"

# Remove any existing jars with the new name, and any conflicting directories
rm $new_jar_name 2>/dev/null
rm -rf ${jar_name/.jar/} 2>/dev/null

# Create temporary location for unpacking jar and copy jar there
mkdir ${jar_name/.jar/}
cp $jar_name ${jar_name/.jar/}
cd ${jar_name/.jar/}

# Unpackage and delete the jar
jar xf $jar_name
rm $jar_name

# Find all class files and run the patch on them
find . -name \*.class -exec bash -c 'j6patch "{}"' \;
files=$(ls -l | awk '{print $9}' | tr '\n' ' ')

# If a manifest exists, use it. Otherwise, use default
if [ -f ./META-INF/MANIFEST.MF ]; then
	jar cfm $new_jar_name META-INF/MANIFEST.MF $files
else
	jar cf $new_jar_name $files
fi

# Cleanup files and move new contents back to original directory
rm ../$jar_name
cp $new_jar_name ../
cd ..
rm -rf ${jar_name/.jar/}