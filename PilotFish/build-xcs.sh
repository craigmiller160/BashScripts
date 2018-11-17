#!/bin/bash
# This is a script to automate the build process for the various application components

# INSTRUCTIONS
# It must be run from the root of your dev environment. You must also have Install4J version 5
# If there are install4j/ant errors, check the platform-dependent variable for the install4J.jarLoc
# For options 2 & 3, you need to configure the installed JREs. JRE7 u80 and JRE8 u45 are what the script looks for.
# Download them and place them in your Install4J's jre folder in the Application directory

##########################
# Platform Dependent Variable
# -Dinstall4J.jarLoc
##########################

INSTALL4J_5="/Applications/install4j 5/bin/ant.jar"
INSTALL4J_7="/Applications/install4j.app/Contents/Resources/app/bin/ant.jar"

BUILD_NEW_MAIN=resources/build/build_new_main.xml
BUILD_NEW_MAIN_GIT=resources/build/build_new_main_git.xml
BUILD_REGRESSION=resources/build/build_regression.xml
EI_CONSOLE="eiConsole.buildAll"
EI_CONSOLE_W_REVISION="eiConsole.buildAll.with.revision"
EIP_WAR="eip.war.buildAll"
EIC_BUNDLE="eicBundle.buildRelease"
EIC_BUNDLE_W_REVISION="eicBundle.buildRelease.with.revision"
REGRESSION_TARGET="package.solo"
CLEAN=false
COPY=false
START_DIR=$(pwd)


if [[ $1 == "-n" ]]; then
	echo "Using Install4J 7"
	install4J_jarLoc="$INSTALL4J_7"
else
	echo "Using Install4J 5"
	install4J_jarLoc="$INSTALL4J_5"
fi

echo "Select the type of build to run:"
echo "  1) eiConsole w/Revision (installer)"
echo "  2) eiConsole All (installer)"
echo "  3) eiPlatform (war)"
echo "  4) eiConsole + eiPlatform (installer)"
echo "  5) Regression Components (solo)"
echo "  6) eiConsole + eiPlatform (installer) + Regression"
echo "  7) Clean (remove files created by installation)"
echo ""

read -p "Choice: "
case "$REPLY" in
	1) 
		ANT_TARGET="$EI_CONSOLE_W_REVISION"
		BUILD_FILE="$BUILD_NEW_MAIN_GIT"
	;;
	2)
		ANT_TARGET="$EI_CONSOLE"
		BUILD_FILE="$BUILD_NEW_MAIN"
	;;
	3)
		ANT_TARGET="$EIP_WAR"
		BUILD_FILE="$BUILD_NEW_MAIN"
	;;
	4) 
		ANT_TARGET="$EIC_BUNDLE_W_REVISION"
		BUILD_FILE="$BUILD_NEW_MAIN_GIT"
	;;
	5)
		ANT_TARGET="$REGRESSION_TARGET"
		BUILD_FILE="$BUILD_REGRESSION"
	;;
	6)
		ANT_TARGET="$EIC_BUNDLE"
		BUILD_FILE="$BUILD_NEW_MAIN"
	;;
	7) CLEAN=true ;;
	*) 
		echo "Error! Invalid input"
		exit 1
	;;
esac

setname=false
name=""
if ! $CLEAN ; then
	echo "Do you want to give this set of installers a name? This will be appended to the output directory."
	read -p "Set name? (y/n): "
	case $REPLY in
		y|Y) setname=true ;;
		n|N) setname=false ;;
		*)
			echo "Error! Invalid input. Please try again"
			exit 1
		;;
	esac

	if $setname ; then
		read -p "Name: "
		name="$REPLY"
	fi

	echo $BUILD_FILE
	echo $ANT_TARGET

	if [ $BUILD_FILE == $BUILD_NEW_MAIN_GIT ]; then
		commit=$(git log --oneline -n 1 | awk '{print $1}')
		ant -f "$BUILD_FILE" "$ANT_TARGET" -Dinstall4J.jarLoc="$install4J_jarLoc" -Dgit_commit=$commit
	else
		ant -f "$BUILD_FILE" "$ANT_TARGET" -Dinstall4J.jarLoc="$install4J_jarLoc"
	fi
	
	echo "Copying application components to output directory, please wait..."
	apppath=""
	case "$ANT_TARGET" in
		"$EI_CONSOLE_W_REVISION" | "$EI_CONSOLE")
			rm -rf $HOME/xcs-app/eiConsole* 1>/dev/null 2>/dev/null
			apppath="$HOME/xcs-app/eiConsole"
			if [[ "$name" != "" ]]; then
				apppath="$apppath-$name"
			fi
			mkdir -p "$apppath"
			cp -R ./resources/releases/eiConsole/build/* "$apppath"
		;;
		"$EIP_WAR")
			rm -rf $HOME/xcs-app/eipWar* 1>/dev/null 2>/dev/null
			apppath="$HOME/xcs-app/eipWar"
			if [[ "$name" != "" ]]; then
				apppath="$apppath-$name"
			fi
			mkdir -p "$apppath"
			cp -R ./dist/* "$apppath"
		;;
		"$EIC_BUNDLE_W_REVISION" | "$EIC_BUNDLE")
			rm -rf $HOME/xcs-app/eicBundle* 1>/dev/null 2>/dev/null
			apppath="$HOME/xcs-app/eicBundle"
			if [[ "$name" != "" ]]; then
				apppath="$apppath-$name"
			fi
			mkdir -p "$apppath"
			cp -R ./resources/releases/eiPlatform-Windows/build/* "$apppath"
		;;
		"$REGRESSION_TARGET")
			rm -rf $HOME/xcs-app/regression* 1>/dev/null 2>/dev/null
			apppath="$HOME/xcs-app/regression"
			if [[ "$name" != "" ]]; then
				apppath="$apppath-$name"
			fi
			mkdir -p "$apppath"
			cp -R ./regression/* "$apppath"
		;;
	esac
	echo "Build complete. Application is located at $apppath"

	echo "$ANT_TARGET"

	if [ "$ANT_TARGET" == "$EIC_BUNDLE_W_REVISION" ] || [ "$ANT_TARGET" == "$EIC_BUNDLE" ]; then
		echo ""
		echo "Do you want to copy the build files to pfcommon/XCS?"
		read -p "Copy? (y/n): "
		case $REPLY in
			y|Y) COPY=true ;;
			n|N) COPY=false ;;
			*)
				echo "Error! Invalid input"
			;;
		esac
	else
		echo "Failed to pass ant target test"
	fi

	echo ""
	echo "Do you want to clean your project directory of all build files?"
	read -p "Clean? (y/n): "
	case $REPLY in
		y|Y) CLEAN=true ;;
		n|N) CLEAN=false ;;
		*)
			echo "Error! Invalid input"
		;;
	esac
fi

if $COPY ; then
	echo "Copying build files to pfcommon/XCS"
	sudo rm -rf /usr/local/pfcommon/resources/releases/eiPlatform-Windows/*
	sudo cp -R resources/releases/eiPlatform-Windows/* /usr/local/pfcommon/XCS/resources/releases/eiPlatform-Windows
fi

if $CLEAN ; then
	echo "Cleaning, please wait..."
	cd "$START_DIR"

	# All these folders and/or contents
	rm -rf classes 1>/dev/null 2>/dev/null
	rm -rf eip-staging 1>/dev/null 2>/dev/null
	rm -rf eip-staging-ext 1>/dev/null 2>/dev/null
	rm -rf eip-staging-modules 1>/dev/null 2>/dev/null
	rm -rf dist 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiConsole/build/* 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiConsole/staging/* 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/build/ 1>/dev/null 2>/dev/null

	# Remove specific files from the eiPlatform-windows/staging directory, leaving the contents that should remain
	rm resources/releases/eiPlatform-Windows/staging/api_access_roles.properties 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/module_access_roles.properties 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/server/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/temp/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/runtime/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/samples/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/api/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/dashboardui/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/dashboardui_cleaned/ 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/dataSources.xml 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/docs/ 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/eas.conf 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/eassettings.txt 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/license-notices.txt 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/license.txt 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eiPlatform-Windows/staging/regression 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/securityContext.xml 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/startRegressionJammer.sh 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/startRegressionJammer.cmd 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/startRegressionRemote.sh 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/startRegressionRemote.cmd 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/web-app_2_3.dtd 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/logConfig.xml 1>/dev/null 2>/dev/null
	rm resources/releases/eiPlatform-Windows/staging/ognlSettings.xml 1>/dev/null 2>/dev/null

	# Remove eip-lite files & directories
	rm -rf resources/releases/eip-lite-server/build/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eip-lite-server/staging/docs/ 1>/dev/null 2>/dev/null
	rm -rf resources/releases/eip-lite-server/staging/server/ 1>/dev/null 2>/dev/null

	# Other directories
	rm -rf temp/ 1>/dev/null 2>/dev/null

	# Restore specific files from git that have been changed during this process
	git checkout rman/com/pilotfish/eip/rest/doc/resourcedoc.xml 1>/dev/null 2>/dev/null
	git checkout resources/releases/eiPlatform-Windows/staging/eipServer.conf 1>/dev/null 2>/dev/null
	git checkout resources/releases/eiPlatform-Windows/staging/logConfig.xml 1>/dev/null 2>/dev/null

	# Regression stuff
	rm -rf regression 1>/dev/null 2>/dev/null
fi

# Option to run deploy script for eip.war
if [ "$ANT_TARGET" == "$EIP_WAR" ]; then
	read -p "Do you want to deploy the eip.war to Tomcat? (y/n): "
	case $REPLY in
		y|Y) 
			echo "Running deploy-eip script"
			cd "$apppath"
			sudo deploy-eip.sh 
		;;
	esac
fi