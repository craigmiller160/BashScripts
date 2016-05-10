#!/bin/bash
# System restore script

# Variables
MEDIA="MyPassport"
BACKUP="Seagate Expansion Drive"
EXTERNAL_PLEX="/media/craig/Seagate Expansion Drive/Plex Media Server"
INTERNAL_PLEX="/var/lib/plexmediaserver/Library/Application Support"
LIST="/usr/share/gnome/applications/defaults.list"
MEDIA_DRIVE="/home/craig/MediaDrive"
PLEX_INSTALL="/media/craig/Seagate Expansion Drive/Backup/plexmediaserver-install.deb"

# Colors
RED='\033[0;31m'
NC='\033[0m'

# Special function for installing and configuring Plex.
function install_configure_plex {
	# Install Plex Application
	dpkg -i "$PLEX_FILE_NAME"

	# Stop the service to configure its settings
	service plexmediaserver stop

	# Restore meta data from backup
	echo "Copying Plex Media Server MetaData Backup. This may take some time."
	rm -rf "$INTERNAL_PLEX/Plex Media Server/"
	rsync -a --info=progress2 "$EXTERNAL_PLEX" "$INTERNAL_PLEX"
	chown -R plex:plex "$INTERNAL_PLEX/Plex Media Server/"
	rm "$PLEX_FILE_NAME"

	# Setup the media Hard Drive so that Plex can read from it.
	echo "Configuring Mount for Media Drive. Please wait."
	DEV_DRIVE=$(blkid -L "My Passport")
	UUID=$(blkid -o value -s UUID "$DEV_DRIVE")
	umount "$DEV_DRIVE"
	mkdir "$MEDIA_DRIVE"
	echo "UUID=$UUID $MEDIA_DRIVE ntfs-3g defaults,nofail,permissions,auto 0 1" | tee -a /etc/fstab
	mount $MEDIA_DRIVE
	chown -R craig:plex $MEDIA_DRIVE

	# Start Plex
	service plexmediaserver start

	# Refresh Plex Libraries
	# echo "Refreshing Plex libraries"
	# export LD_LIBRARY_PATH=/usr/lib/plexmediaserver
	# wget http://127.0.0.1:32400/library/sections/2/refresh
	# wget http://127.0.0.1:32400/library/sections/1/refresh

	# Add plex values to environment variables
	echo "Adding Plex environment variables"
	echo "export PLEX_HOME=/var/lib/plexmediaserver/Library/Application\ Support/PlexMediaServer" >> ~/.profile
	echo "export LD_LIBRARY_PATH=/usr/lib/plexmediaserver" >> ~/.profile

	return 0
}


# Set the default app for a file type. Requires the file type category and the application to use instead
function set_default_app {

	OLD_LINE=($(grep "^$1.*=" $LIST))
	NEW_LINE=($(grep "^$1.*=" "$LIST" | awk -F'=' '{print $1}'))

	IFS="\n"

	for ((i=0;i<${#OLD_LINE[@]};++i)); do
		echo "Replacing \"${OLD_LINE[i]}\" with \"${NEW_LINE[i]}=$2\""
		sudo replace "${OLD_LINE[i]}" "${NEW_LINE[i]}=$2" -- "$LIST"
	done

	return 0

}

# Install IntelliJ IDE and set it up for use on Ubuntu
function install_intellij {
	
	echo "Extracting IntelliJ IDE"
	tar xvf "ideaIU-14.0.4.tar.gz"
	rm "ideaIU-14.0.4.tar.gz"

	echo "Moving IntelliJ IDE to install directory"
	mv ~/idea-IU-139.1603.1 ~/idea
	mv /home/craig/idea /opt

	echo "Finalizing IntelliJ IDE setup"
	cd /usr/local/bin
	ln -s /opt/idea/bin/idea.sh

	cp /opt/idea/bin/idea.png /usr/share/pixmaps/idea.png

	cd ~
	
	return 0
}

# Test that the script is being run as superuser
if [[ $UID != 0 ]]; then
	echo "This script needs to be run with 'sudo' permissions"
	exit 1
fi

# Output what this script is going to do
echo "Craig-PC Restore Script"
echo "This script will perform the following actions."
echo "1) Upgrade your Ubuntu installation with the latest packages."
echo "2) Install the following software development kits:"
echo "   Java 7 JDK"
echo "   Java 8 JDK"
echo "   Android SDK [TBD]"
echo "3) Install all of the following apps:"
echo "   Android Studio IDE [TBD]"
echo "   Chrome Browser"
echo "   Git VCS"
echo "   IntelliJ IDE"
echo "   Maven 3"
echo "   MySQL Server"
echo "   MySQL Workbench"
echo "   Plex Media Center"
echo "   Skype"
echo "   Sublime Text 3"
echo "   Tixati"
echo "   Ubuntu Restricted Extras  [TBD]"
echo "   Unity Tweak Tool"
echo "   VLC Media Player"
echo "   7zip"
echo "4) Configure the following services:"
echo "   CronTab Shutdown Trigger"
echo "   Enable Unity Workspaces"
echo "   Gnome Terminal Theme"
echo "   PlexMediaServer"

echo "This process will take time. It is highly recommended that you do NOT shut down your machine or run any applications until it is complete."

echo "Do you want to begin the system restore process? (y/n): "
read START

if [ "$START" != "y" ]; then
	echo "Cancelling restoration"
	exit 0
fi

# Move the shell to the user.home directory
cd ~/

# Create user bin directory, and get it on the path
mkdir ~/bin
source ~/.profile

# Additional repoistories
add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" -y
add-apt-repository ppa:webupd8team/sublime-text-3 -y
add-apt-repository ppa:webupd8team/java -y

# Upgrade the installation and Update the apt-get tool's repository data
apt-get update -y
apt-get dist-upgrade -y
apt-get upgrade -y

# Enable workspaces, with the default being 2 per screen
#### TODO this needs to be spun off separately, so it's not run with sudo
# gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2

# Install Ubuntu Restricted Extras
# sudo apt-get install ubuntu-restricted-extras -y # TODO this one has a license agreement

# Install basic apps
apt-get install chromium-browser -y
apt-get install vlc -y
apt-get install skype -y
apt-get install p7zip -y
apt-get install sublime-text-installer -y
apt-get install unity-tweak-tool -y
apt-get install avahi-daemon -y
apt-get install maven -y

# MySQL Setup
DEBIAN_FRONTEND=noninteractive apt-get install -qq -y mysql-server
apt-get install mysql-workbench -y

# Git Setup
apt-get install git -y
git config --global user.email "craigmiller160@gmail.com"
git config --global user.name "craigmiller160"
git config --global credential.helper cache

# Tixati doesn't get installed via apt-get, it is retrieved from the website
# wget www.tixati.com/download/tixati_1.96-1_amd64.deb # Depends on specific version
# sudo dpkg -i tixati_1.96-1_amd64.deb
echo "Downloading Tixati"
TIXATI_DL_URL=$(curl -s http://www.tixati.com/download/linux.html | grep tixati.*amd64.deb | cut -d\" -f2)
TIXATI_ERROR=$(wget "$TIXATI_DL_URL" --no-check-certificate 2>&1 >/dev/null)
TIXATI_FILE_NAME="${TIXATI_DL_URL##*/}"

# Verify that the Tixati file downloaded properly before proceeding
if [ -f "$TIXATI_FILE_NAME" ]
	then
		echo "Installing Tixati"
		TIXATI_DL_STATUS="success"
		dpkg -i "$TIXATI_FILE_NAME"
		rm "$TIXATI_FILE_NAME"
	else
		printf "${RED}Error! Tixati download failed!!${NC}\n"
		TIXATI_DL_STATUS="fail"
fi

# Plex Media Server stuff
# wget "https://downloads.plex.tv/plex-media-server/0.9.15.6.1714-7be11e1/plexmediaserver_0.9.15.6.1714-7be11e1_amd64.deb" # Depends on this specific version
# sudo dpkg -i plexmediaserver_0.9.15.6.1714-7be11e1_amd64.deb
echo "Installing Plex Media Server"
cd ~
#PLEX_DL_URL=$(curl -s https://plex.tv/downloads | grep Ubuntu64 | cut -d\" -f2)
#PLEX_ERROR=$(wget "$PLEX_DL_URL" --no-check-certificate 2>&1 >/dev/null)
#PLEX_FILE_NAME="${PLEX_DL_URL##*/}"

# Verify that the Plex file downloaded properly before proceeding
if [ -f "$PLEX_INSTALL" ]
	then
		echo "Installing Plex Media Server"
		PLEX_DL_STATUS="success"
		install_configure_plex
	else
		printf "${RED}Error! Plex Media Server failed to download{NC}\n"
		printf "${RED}$ERROR${NC}\n"
		PLEX_DL_STATUS="fail"
fi

# Install Java SDK 7 & 8 (Accept Oracle License first)
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get install oracle-java7-installer -y
apt-get install oracle-java8-installer -y

# Set Java environment & path variables
echo "Setting environment variables"
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.profile
echo "export PATH=$PATH:$JAVA_HOME" >> ~/.profile

# Install IntelliJ IDE
echo "Downloading IntelliJ IDE"
INTELLIJ_ERROR=$(wget "http://download.jetbrains.com/idea/ideaIU-14.0.4.tar.gz" --no-check-certificate 2>&1 >/dev/null)
if [ -f "ideaIU-14.0.4.tar.gz" ]
	then
		echo "Installing IntelliJ IDE"
		INTELLIJ_DL_STATUS="success"
		install_intellij

	else
		printf "${RED}Error! IntelliJ IDE failed to download${NC}\n"
		INTELLIJ_DL_STATUS="fail"
fi

# Set nightly shutdown cron job
echo "Configuration cron job to shutdown PC at 3am"
sudo crontab -l > mycron
echo "0 3 * * * /sbin/shutdown -h now" >> mycron
sudo crontab mycron
sudo rm mycron

# Refresh environment variables
source ~/.profile

# Set default apps for certain file types.
echo "Setting default application associations"
set_default_app "video" "vlc.desktop"
set_default_app "text" "sublime-text.desktop"

# Setting theme for Gnome terminal
cd ~/.config
sudo git clone https://github.com/chriskempson/base16-gnome-terminal.git
source base16-gnome-terminal/base16-default.dark.sh
cd ~/

# Finishing Operation
echo "Operation complete. Any errors are reported below."

# Possible errors
if [ "$PLEX_DL_STATUS" != "success" ]
	then
		printf "${RED}  Plex file failed to download, Plex installation skipped{NC}\n"
		printf "${RED}$PLEX_ERROR${NC}\n"
fi

if [ "$TIXATI_DL_STATUS" != "success" ]
	then
		printf "${RED}  Tixati file failed to download, Tixati installation skipped{NC}\n"
		printf "${RED}$TIXATI_ERROR${NC}\n"
fi

if [ "$INTELLIJ_DL_STATUS" != "success" ]
	then
		printf "${RED}   IntelliJ failed to download, IntelliJ installation skipped{NC}\n"
		printf "${RED}$INTELLIJ_ERROR${NC}\n"
fi

exit 0
