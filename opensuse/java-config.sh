#!/bin/bash
# Script to update alternatives paths so that Linux knows where Java is

### TODO The /usr/local/bin references, ensure that they actually exist by default

# if [ $# -lt 1 ]; then
# 	echo "Error! Wrong number of arguments for this script"
# 	exit 1
# fi

# JAVA_PATH="$1"

# if [ ! -d "$JAVA_HOME" ]; then
# 	echo "Error! JAVA_HOME environment variable has not been set"
# 	exit 1
# fi

# sudo zypper rm icedtea-web -y

sudo update-alternatives --install /usr/bin/java java /usr/java/latest/bin/java 1551
sudo update-alternatives --install /usr/bin/javadoc javadoc /usr/java/latest/bin/javadoc 1551
sudo update-alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 1551
sudo update-alternatives --install /usr/bin/javap javap /usr/java/latest/bin/javap 1551
sudo update-alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 1551
sudo update-alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 1551
sudo update-alternatives --install /usr/bin/javah javah /usr/java/latest/bin/javah 1551
sudo update-alternatives --install /usr/bin/jarsigner jarsigner /usr/java/latest/bin/jarsigner 1551

sudo update-alternatives –set java "/usr/java/latest/bin/java"
sudo update-alternatives –set javac "/usr/java/latest/bin/javac"
sudo update-alternatives –set javaws "/usr/java/latest/bin/javaws"

sudo update-alternatives --config java
sudo update-alternatives --config javac


# sudo update-alternatives –install "/usr/bin/java" "java" "$JAVA_HOME/bin/java" 1
# sudo update-alternatives –install "/usr/bin/javac" "javac" "$JAVA_HOME/bin/javac" 1
# sudo update-alternatives –install "/usr/bin/javaws" "javaws" "$JAVA_HOME/bin/javaws" 1
# sudo update-alternatives –set java "$JAVA_HOME/bin/java"
# sudo update-alternatives –set javac "$JAVA_HOME/bin/javac"
# sudo update-alternatives –set javaws "$JAVA_HOME/bin/javaws"
