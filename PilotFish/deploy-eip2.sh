#!/bin/bash
# Deploy eip.war to tomcat

SETTINGS="$HOME/.deploy-eip.conf"

EIP_WAR="eip.war"
EIP_DASHBOARD_WAR="eip.dashboard.war"

eip_name=""

# Require superuser permissions to run the script
if [ $UID != 0 ]; then
	echo "This script must be run with superuser permissions."
	exit 1
fi

# Prompt to see which war file is being deployed
read -p "Which eip.war do you want to deploy? eip.war (1) or eip.dashboard.war (2): "
case $REPLY in
	1) eip_name="$EIP_WAR" ;;
	2) eip_name="$EIP_DASHBOARD_WAR" ;;
	*) echo "Error! Invalid input! Please try again."
	   exit 1 
	;;
esac

# Test if that war file exists in the current directory
if [ ! -f "./$eip_name" ]; then
	echo "Error! No file named $eip_name in the current directory"
	exit 1
fi

EIP_SERVER_PATH=""
EIP_LOG_PATH=""
TOMCAT=""
USER_GROUP=""

if [ -f "$SETTINGS" ]; then
	source "$SETTINGS"
fi

run=true
while $run ; do
	if [ "$EIP_SERVER_PATH" == "" ]; then
		read -p "Please provide path to eipServer.conf: "
		EIP_SERVER_PATH="$REPLY"
	fi

	# Ensure that the variable ends with the filename
	if [[ "$EIP_SERVER_PATH" != */eipServer.conf ]]; then
		EIP_SERVER_PATH="$(echo "$EIP_SERVER_PATH" | sed -e 's/\/$//g')"
		EIP_SERVER_PATH+=/eipServer.conf
	fi

	if [ "$EIP_LOG_PATH" == "" ]; then
		read -p "Please provide path to eip.log: "
		EIP_LOG_PATH="$REPLY"
	fi

	# Ensure that the variable ends with the filename
	if [[ "$EIP_LOG_PATH" != */eip.log ]]; then
		EIP_LOG_PATH="$(echo "$EIP_LOG_PATH" | sed -e 's/\/$//g')"
		EIP_LOG_PATH+=/eip.log
	fi

	if [ "$TOMCAT" == "" ]; then
		read -p "Please provide path to Tomcat webapps directory: "
		TOMCAT="$REPLY"
	fi

	if [ "$USER_GROUP" == "" ]; then
		read -p "Please provide the linux username assigned to Tomcat: "
		user="$REPLY"
		read -p "Please provide the linux groupname assigned to Tomcat: "
		group="$REPLY"
		USER_GROUP="$user:$group"
	fi

	echo ""
	echo "Current deployment settings:"
	echo "1) Path to eipServer.conf: $EIP_SERVER_PATH"
	echo "2) Path to eip.log: $EIP_LOG_PATH"
	echo "3) Path to Tomcat webapps: $TOMCAT"
	echo "4) User/Group assigned to Tomcat: $USER_GROUP"
	echo ""
	read -p "Do you want to use these settings? (y/n): "
	case "$REPLY" in
		y|Y) run=false ;;
		n|N) 
			run=true
			read -p "Enter the number of the setting you wish to change: "
			case "$REPLY" in
				1) EIP_SERVER_PATH="" ;;
				2) EIP_LOG_PATH="" ;;
				3) TOMCAT="" ;;
				4) USER_GROUP="" ;;
				*) echo "Invalid entry, please try again" ;;
			esac
		;;
		*) echo "Invalid input, please try again." ;;
	esac

done

echo "Saving settings..."
echo "# deploy-eip.sh script configuration settings" > "$SETTINGS"
echo "EIP_SERVER_PATH=$EIP_SERVER_PATH" >> "$SETTINGS"
echo "EIP_LOG_PATH=$EIP_LOG_PATH" >> "$SETTINGS"
echo "TOMCAT=$TOMCAT" >> "$SETTINGS"
echo "USER_GROUP=$USER_GROUP" >> "$SETTINGS"

# The rest of this is the process of deploying the file
echo "Stopping tomcat6 service"
catalina.sh stop 2>/dev/null

echo "Deleting any existing eip war"
rm -rf $TOMCAT/eip*

echo "Copying $eip_name to $TOMCAT"
cp "$eip_name" "$TOMCAT"

echo "Unpacking $eip_name"
mkdir "$TOMCAT/${eip_name/.war/}"
cp "$TOMCAT/$eip_name" "$TOMCAT/${eip_name/.war/}"
cd "$TOMCAT/${eip_name/.war/}"
jar xf "$eip_name"
rm "$eip_name"

echo "Updating web.xml values"

escaped_conf="$(echo "$EIP_SERVER_PATH" | sed -e 's/[\/&]/\\&/g')"
escaped_log="$(echo "$EIP_LOG_PATH" | sed -e 's/[\/&]/\\&/g')"

cd "WEB-INF"
cat web.xml | sed "s/\${eip.war.home}\/logs\/eip.log/$escaped_log/g" | sed "s/\/eipServer.conf/$escaped_conf/g" > web2.xml
mv web2.xml web.xml

cd "$TOMCAT"
chown -R "$USER_GROUP" "$TOMCAT/${eip_name/.war/}"

echo "Deployment complete!"
read -p "Do you want to start tomcat now? (y/n): "
case "$REPLY" in
	y|Y) catalina.sh start ;;
	n|N) ;;
	*) echo "Invalid input! You can start Tomcat manually at any time" ;;
esac


