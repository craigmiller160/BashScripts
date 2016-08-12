#!/bin/bash
# Script to convert a jar to java 6

jar_name="$1"

mkdir ${jar_name/.jar/}
cp $jar_name ${jar_name/.jar/}
cd ${jar_name/.jar/}

jar xf $jar_name
rm $jar_name

find . -name \*.class |xargs -I {} j6patch {}

files=$(ls -l | awk '{print $9}' | tr '\n' ' ')
jar cf $jar_name $files
rm ../$jar_name
cp $jar_name ../
cd ..
rm -rf ${jar_name/.jar/}