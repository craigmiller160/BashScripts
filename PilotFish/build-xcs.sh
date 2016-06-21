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
install4J_jarLoc="/Applications/install4j 5/bin/ant.jar"
##########################

EI_CONSOLE="eiConsole.buildRelease"
EIP_WAR="eip.war.buildAll"
EIC_BUNDLE="eicBundle.buildRelease"
CLEAN=false

echo "Build PilotFish Application"
echo ""
echo "Select the type of build to run:"
echo "  1) eiConsole"
echo "  2) eiPlatform (war)"
echo "  3) eiConsole + eiPlatform (installer)"
echo "  4) Clean (remove files created by installation)"
echo ""

read -p "Choice: "
case "$REPLY" in
	1) ANT_TARGET="$EI_CONSOLE" ;;
	2) ANT_TARGET="$EIP_WAR" ;;
	3) ANT_TARGET="$EIC_BUNDLE" ;;
	4) CLEAN=true ;;
	*) 
		echo "Error! Invalid input"
		exit 1
	;;
esac

if ! $CLEAN ; then
	ant -f resources/build/build_new_main.xml "$ANT_TARGET" -Dinstall4J.jarLoc="$install4J_jarLoc"
	echo "Copying application components to output directory, please wait..."
	case "$ANT_TARGET" in
		"$EI_CONSOLE")
			rm -rf "$HOME/xcs-app/eiConsole" 1>/dev/null 2>/dev/null
			mkdir -p "$HOME/xcs-app/eiConsole"
			cp -R ./resources/releases/eiConsole/build/* "$HOME/xcs-app/eiConsole"
		;;
		"$EIP_WAR")
			rm -rf "$HOME/xcs-app/eipWar" 1>/dev/null 2>/dev/null
			mkdir -p "$HOME/xcs-app/eipWar"
			cp -R ./dist/* "$HOME/xcs-app/eipWar"
		;;
		"$EIC_BUNDLE")
			rm -rf "$HOME/xcs-app/eicBundle" 1>/dev/null 2>/dev/null
			mkdir -p "$HOME/xcs-app/eicBundle"
			cp -R ./resources/releases/eiPlatform-Windows/build/* "$HOME/xcs-app/eicBundle"
		;;
	esac
	echo "Build complete. Application is located at $HOME/xcs-app"

	echo ""
	echo "Do you want to clean your project directory of all build files?"
	read -p "Clean? (y/n): "
	case $REPLY in
		y) CLEAN=true ;;
		n) CLEAN=false ;;
		*)
			echo "Error! Invalid input"
		;;
	esac
fi

if $CLEAN ; then
	echo ""
	echo "This will clean your project directory of all build files"
	echo "Any uncommitted changes will likely be lost as well"
	read -p "Proceed? (y/n): "
	case $REPLY in
		y) CLEAN=true ;;
		n) CLEAN=false ;;
		*)
			echo "Error! Invalid input"
		;;
	esac
	if $CLEAN ; then
		echo "Cleaning, please wait..."
		rm -rf resources/releases/eiPlatform-Windows/build/ 1>/dev/null 2>/dev/null
		rm resources/releases/eiPlatform-Windows/staging/api_access_roles.properties 1>/dev/null 2>/dev/null
		rm resources/releases/eiPlatform-Windows/staging/module_access_roles.properties 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/staging/server/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/temp/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eip-lite-server/build/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eip-lite-server/staging/docs/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eip-lite-server/staging/server/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/staging/api/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/staging/dashboardui/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/staging/dashboardui_cleaned/ 1>/dev/null 2>/dev/null
		rm resources/releases/eiPlatform-Windows/staging/dataSources.xml 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/staging/docs/ 1>/dev/null 2>/dev/null
		rm resources/releases/eiPlatform-Windows/staging/eas.conf 1>/dev/null 2>/dev/null
		rm resources/releases/eiPlatform-Windows/staging/eassettings.txt 1>/dev/null 2>/dev/null
		rm resources/releases/eiPlatform-Windows/staging/license-notices.txt 1>/dev/null 2>/dev/null
		rm resources/releases/eiPlatform-Windows/staging/license.txt 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/staging/runtime/ 1>/dev/null 2>/dev/null
		rm -rf resources/releases/eiPlatform-Windows/staging/samples/ 1>/dev/null 2>/dev/null
		git checkout . 1>/dev/null 2>/dev/null
	fi
fi