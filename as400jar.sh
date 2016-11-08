TARGET_DIR="/Users/craigmiller/Documents/AS400"

TARGET_CLASS_DIR="$TARGET_DIR/com/pilotfish/eip/modules/other"
TARGET_SOURCE_DIR="$TARGET_DIR/source/com/pilotfish/eip/modules/other"
TARGET_LIB_DIR="/Users/craigmiller/Documents/jt400"

DEV_DIR="/Users/craigmiller/PilotFish"

DEV_CLASS_DIR="$DEV_DIR/out/production/PilotFish/com/pilotfish/eip/modules/other"
DEV_SOURCE_DIR="$DEV_DIR/src/com/pilotfish/eip/modules/other"
DEV_LIB_DIR="$DEV_DIR/resources/build/lib"

DEST_DIR="/Users/craigmiller/Documents/GammaDynacare/GammaDynacare/Workflows/interfaces/Mirror Project (ICM Connector)/lib"

if [ -d $TARGET_DIR ]
	then
		echo "--Removing old files"
		rm -rf $TARGET_DIR
fi

if [ ! -d $TARGET_CLASS_DIR ]
	then
		echo "--Creating target class directory"
		mkdir -p $TARGET_CLASS_DIR
fi

if [ ! -d $TARGET_SOURCE_DIR ]
	then
		echo "--Creating target source directory"
		mkdir -p $TARGET_SOURCE_DIR
fi

echo "--Copying class files"
cp -R $DEV_CLASS_DIR/AS400DataQueueListener*.class $TARGET_CLASS_DIR
cp -R $DEV_CLASS_DIR/AS400DataQueueTransport*.class $TARGET_CLASS_DIR

echo "--Copying source files"
cp -R $DEV_SOURCE_DIR/AS400DataQueueListener.java $TARGET_SOURCE_DIR
cp -R $DEV_SOURCE_DIR/AS400DataQueueTransport.java $TARGET_SOURCE_DIR

# echo "--Converting to Java 6"
# printf "\x00\x00\x00\x32" |dd of=$TARGET_CLASS_DIR/PDFImageOverlayProcessor.class seek=4 bs=1 count=4 conv=notrunc

cd $TARGET_DIR

echo "--Creating AS400 Jar"
jar cf AS400DataQueues.jar .

if [ -f "$DEST_DIR/AS400DataQueues.jar" ]
	then
		echo "--Deleting old AS400 jar in Mirror Project"
		rm -rf "$DEST_DIR/AS400DataQueues.jar"
fi

echo "--Copying jar to Mirror Project"
cp "$TARGET_DIR/AS400DataQueues.jar" "$DEST_DIR"

