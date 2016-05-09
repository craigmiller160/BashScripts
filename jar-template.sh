#!/bin/bash
# Script to build a new Version 1.2 RabbitMQ jar.

TARGET_DIR="/Users/craigmiller/Documents/RabbitMQ"
PCKG_PATH="com/pilotfish/custom/rabbitmq"
DEV_DIR="/Users/craigmiller/PilotFishDev/PLIT-2084"
TEMP_DIR="/Users/craigmiller/Documents/temp"
LMS_SRC="/Users/craigmiller/PilotFishLMSDev/src"

TARGET_CLASS_DIR="$TARGET_DIR/$PCKG_PATH"
TARGET_RMQ_1="$TARGET_DIR/com/rabbitmq/client/impl"
TARGET_RMQ_2="$TARGET_DIR/com/rabbitmq/tools/json"
TARGET_RMQ_3="$TARGET_DIR/com/rabbitmq/tools/jsonpc"
TARGET_RMQ_4="$TARGET_DIR/com/rabbitmq/utility"
TARGET_SOURCE_DIR="$LMS_SRC/$PCKG_PATH"

DEV_CLASS_DIR="$DEV_DIR/out/production/PilotFish/$PCKG_PATH"
DEV_SOURCE_DIR="$DEV_DIR/src/$PCKG_PATH"
DEV_LIB_PATH="$DEV_DIR/resources/build/lib/rabbitmq-1.1.jar"

if [ -d $TARGET_DIR ]; then
		echo "--Removing old files"
		rm -rf "$TARGET_DIR"
fi

if [ -d $TEMP_DIR ]; then
	echo "--Removing old files"
	rm -rf $TEMP_DIR
fi

if [ ! -d $TARGET_CLASS_DIR ]; then
		echo "--Creating staging directory"
		mkdir -p "$TARGET_CLASS_DIR"
		mkdir -p $TARGET_RMQ_1
		mkdir -p $TARGET_RMQ_2
		mkdir -p $TARGET_RMQ_3
		mkdir -p $TARGET_RMQ_4
fi

echo "--Copying class files"
cp -R $DEV_CLASS_DIR/ $TARGET_CLASS_DIR

echo "--Extracting rabbitmq-1.1.jar"
mkdir $TEMP_DIR
unzip -d $TEMP_DIR $DEV_LIB_PATH 1>/dev/null

echo "--Copying RabbitMQ files to new staging directory"
cp -R $TEMP_DIR/. $TARGET_DIR

echo "--Copying source files"
cd $LMS_SRC
svn update . 1>/dev/null
if [ $? -eq 0 ]; then
	safe_commit=true
else
	safe_commit=false
fi
cp -R $DEV_SOURCE_DIR/*.java $TARGET_SOURCE_DIR

if $safe_commit ; then
	if [ ! -z "$(svn status)" ]; then
		echo "--Committing source to LMS"
		svn commit -m "Committing update to RabbitMQ utilities" 1>/dev/null
	fi
else
	echo "--Unable to safely commit to LMS"
fi

cd $TARGET_DIR

echo "--Creating rabbitmq-1.2.jar"
jar cf rabbitmq-1.2.jar .

exit 0