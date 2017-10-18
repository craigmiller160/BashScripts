#!/bin/bash
# Builds HTTP XML jar

BASE_DIR=~/PilotFish/httpxml

OUT_DIR=~/PilotFish/DevRoot/Main/out/production
OUT_CORE_DIR=$OUT_DIR/PilotFish
OUT_HTTPXML_DIR=$OUT_DIR/modules-httpxml

UTILS_PATH=com/pilotfish/utils
EVAL_XML_PATH=com/pilotfish/eip/evalxml
MAPPER_EXTS_PATH=com/pilotfish/eip/gui/mapper/extensions
MAPPER_FORMATS_PATH=com/pilotfish/eip/gui/mapper/formats
HTTPXML_PATH=com/pilotfish/eip/modules/httpxml

XML_UTIL_CLASS="XMLUtil*.class"

if [[ -d $BASE_DIR ]]; then
	echo "Deleting existing directory: $BASE_DIR"
	rm -rf $BASE_DIR
fi

echo "Creating directory: $BASE_DIR"
mkdir $BASE_DIR
echo "Creating directory: $BASE_DIR/$UTILS_PATH"
mkdir -p $BASE_DIR/$UTILS_PATH
echo "Creating directory: $BASE_DIR/$EVAL_XML_PATH"
mkdir -p $BASE_DIR/$EVAL_XML_PATH
echo "Creating directory: $BASE_DIR/$MAPPER_EXTS_PATH"
mkdir -p $BASE_DIR/$MAPPER_EXTS_PATH
echo "Creating directory: $BASE_DIR/$MAPPER_FORMATS_PATH"
mkdir -p $BASE_DIR/$MAPPER_FORMATS_PATH
echo "Creating directory: $BASE_DIR/$HTTPXML_PATH"
mkdir -p $BASE_DIR/$HTTPXML_PATH

echo "Copying evalxml classes"
cp -R $OUT_CORE_DIR/$EVAL_XML_PATH/* $BASE_DIR/$EVAL_XML_PATH
echo "Copying HTTP XML classes"
cp -R $OUT_HTTPXML_DIR/$HTTPXML_PATH/* $BASE_DIR/$HTTPXML_PATH
echo "Copying HTTP XML Mapper Extensions"
cp -R $OUT_HTTPXML_DIR/$MAPPER_EXTS_PATH/* $BASE_DIR/$MAPPER_EXTS_PATH
echo "Copying HTTP XML Mapper Formats"
cp -R $OUT_HTTPXML_DIR/$MAPPER_FORMATS_PATH/* $BASE_DIR/$MAPPER_FORMATS_PATH
echo "Copying XMLUtil class"
cp $OUT_CORE_DIR/$UTILS_PATH/$XML_UTIL_CLASS $BASE_DIR/$UTILS_PATH

date_stamp=$(date +"%Y%m%d")
jar_name="httpxml_$date_stamp.jar"
echo "Building Jar: $jar_name"
cd $BASE_DIR
jar cf $jar_name com

echo "Build Complete"