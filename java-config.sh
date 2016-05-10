#!/bin/bash
# Script to update alternatives paths so that Linux knows where Java is

### TODO The /usr/local/bin references, ensure that they actually exist by default

# if [ $# -lt 1 ]; then
# 	echo "Error! Wrong number of arguments for this script"
# 	exit 1
# fi

# JAVA_PATH="$1"

if [ ! -d "$JAVA_HOME" ]; then
	echo "Error! JAVA_HOME environment variable has not been set"
	exit 1
fi

sudo update-alternatives –install "/usr/bin/java" "java" "$JAVA_HOME/bin/java" 1
sudo update-alternatives –install "/usr/bin/javac" "javac" "$JAVA_HOME/bin/javac" 1
sudo update-alternatives –install "/usr/bin/javaws" "javaws" "$JAVA_HOME/bin/javaws" 1
sudo update-alternatives –set java "$JAVA_HOME/bin/java"
sudo update-alternatives –set javac "$JAVA_HOME/bin/javac"
sudo update-alternatives –set javaws "$JAVA_HOME/bin/javaws"