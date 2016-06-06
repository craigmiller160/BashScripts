#!/bin/bash
# Deploy eip.war to tomcat
# To make this script work, simply supply your own values for the platform dependent variables

### PLATFORM DEPENDENT VARIABLES #######################
# The path to the Tomcat webapps directory
TOMCAT=/var/lib/tomcat6/webapps
# The path to the pre-built web.xml file, with the parameter values for the log file and eipServer.conf file locations already set
WEB_XML_PATH=/home/craigmiller/Documents/web.xml
########################################################

EIP_WAR="eip.war"
EIP_DASHBOARD_WAR="eip.dashboard.war"

eip_name=""

# The main function to execute the script
function main {

	# Prompt to see which war file is being deployed
	read -p "Which eip.war do you want to deploy? eip.war (1) or eip.dashboard.war (2): "
	case $REPLY in
		1) eip_name="$EIP_WAR" ;;
		2) eip_name="$EIP_DASHBOARD_WAR" ;;
		*) echo "Error! Invalid input! Please try again."
		   exit 1 ;;
	esac

	# Test if that war file exists in the current directory
	if [ ! -f "./$eip_name" ]; then
		echo "Error! No file named $eip_name in the current directory"
		exit 1
	fi

	# The rest of this is the process of deploying the file
	echo "Stopping tomcat6 service"
	sudo service tomcat6 stop

	if [ -f "$TOMCAT/$eip_name" ]; then
		echo "Deleting existing $eip_name file"
		sudo rm "$TOMCAT/$eip_name"
	fi 

	if [ -d "$TOMCAT/${eip_name/.war/}" ]; then
		echo "Deleting existing ${eip_name/.war/} directory"
		sudo rm -rf "$TOMCAT/${eip_name/.war/}"
	fi

	echo "Copying $eip_name to $TOMCAT"
	sudo cp "$eip_name" "$TOMCAT"

	echo "Unpacking $eip_name"
	sudo mkdir "$TOMCAT/${eip_name/.war/}"
	sudo cp "$TOMCAT/$eip_name" "$TOMCAT/${eip_name/.war/}"
	cd "$TOMCAT/${eip_name/.war/}"
	sudo jar xf "$eip_name"
	sudo rm "$eip_name"

	echo "Replacing web.xml with updated version"
	sudo rm "WEB-INF/web.xml"
	sudo cp "$WEB_XML_PATH" "WEB-INF"

	cd "$TOMCAT"
	sudo chown -R tomcat6:tomcat6 "$TOMCAT/${eip_name/.war/}"

	echo "Restarting tomcat6 service"
	sudo service tomcat6 start

	echo "Operation complete"

}

# Execute main function
main


