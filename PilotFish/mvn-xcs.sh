#!/bin/bash
# Shortcuts to building with maven

XCS_DIR=/Users/craigmiller/PilotFish/DevRoot/xcs
export JAVA_HOME=$JAVA8_HOME

echo "Select Artifact"
echo "1) XCS Bundle"
echo "2) XCS Console"
echo "3) XCS War"

read -p "Choice: " artifact

echo ""
echo "Select Licensing"
echo "1) None"
echo "2) Hard Stop"
echo "3) Warning"

read -p "Choice: " licensing

licensingArg=""

case $licensing in
	1) licensingArg="" ;;
	2) licensingArg="-Dlicensing=stop" ;;
	3) licensingArg="-Dlicensing=warn" ;;
	*)
		echo "Error! Invalid licensing input"
		exit 1
	;;
esac

case $artifact in
	1) cd "$XCS_DIR/XCS-bundle" ;;
	2) cd "$XCS_DIR/XCS-console" ;;
	3) cd "$XCS_DIR/XCS-war" ;;
	*)
		echo "Error! Invalid artifact input"
		exit 1
	;;
esac

mvn package -DskipTests $licensingArg

