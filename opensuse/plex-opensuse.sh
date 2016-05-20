#!/bin/bash
# Plex Restore Script

# Specify the directory names and paths as variables for the script
MEDIA="My Passport" # External Media HD
BACKUP="Seagate Expansion Drive" # External Backup HD
DRIVE_PATH="/run/media/craig" # Mount path of external drives
MEDIA_PATH="$DRIVE_PATH/$MEDIA" # Mount path of Media HD
BACKUP_PATH="$DRIVE_PATH/$BACKUP" # Mount path of Backup HD
DOWNLOADS="/home/craig/Downloads" # Path to Downloads directory
PLEX_LIB_DIR="/var/lib/plexmediaserver/Library/Application Support" # Plex Lib Directory
BACKUP_PLEX_PATH="$BACKUP_PATH/Plex Media Server"


# This command is mostly here to ensure that superuser access is given right away
# sudo zypper 1>/dev/null 2>/dev/null
# 
# echo "Installing PlexMediaServer"
# 
# # Get the Plex DL URL by scraping the HTML of the webpage
# PLEX_DL_URL=$(curl -s https://plex.tv/downloads | grep Fedora64 | cut -d\" -f2)
# PLEX_FILE_NAME="${PLEX_DL_URL##*/}"
# 
# # Move to the downloads directory to download the Plex installer
# cd "$DOWNLOADS"
# wget "$PLEX_DL_URL" --no-check-certificate
# 
# # If the file doesn't exist, abort the installation
# if [ ! -f "$DOWNLOADS/$PLEX_FILE_NAME" ]; then
#     echo "Error! Unable to find Plex installer file. Aborting installation"
#     exit 1
# fi
# 
# sudo zypper install "$DOWNLOADS/$PLEX_FILE_NAME" -y
# 
# # Stop the service to configure its settings
# sudo service plexmediaserver stop

# Copy Plex MetaData backup
# echo "Copying Plex Media Server MetaData Backup. This may take some time."
# sudo rm -rf "$PLEX_LIB_DIR/Plex Media Server"
# sudo rsync -a --info=progress2 "$BACKUP_PLEX_PATH" "$PLEX_LIB_DIR"
# sudo chown -R plex:plex "$PLEX_LIB_DIR/Plex Media Server"

# Mount MediaDrive so that plex can access it
# echo "Configuring mount for Media Drive, please wait."
# DEV_DRIVE=$(sudo blkid -L "My Passport")
# UUID=$(sudo blkid -o value -s UUID "$DEV_DRIVE")
# sudo umount "$DEV_DRIVE"
# sudo mkdir "/home/craig/MediaDrive"
# echo "UUID=$UUID "/home/craig/MediaDrive" ntfs-3g defaults,nofail,permissions,auto 0 1" | sudo tee -a /etc/fstab
# sudo mount "/home/craig/MediaDrive"
# sudo chown -R craig:plex "/home/craig/MediaDrive"
# 
# # Create Plex ports file
# cd /etc/sysconfig/SuSEfirewall2.d/services
# echo "## Name: Plexmedia Server" | sudo tee plexmedia-server
# echo "## Description: Opens ports for Plex Media Server with broadcast allowed." | sudo tee --append plexmedia-server
# sudo echo "" | sudo tee --append plexmedia-server
# sudo echo "# space separated list of allowed TCP ports" | sudo tee --append plexmedia-server
# sudo echo "TCP=\"3005 8324 32400 32469\"" | sudo tee --append plexmedia-server
# sudo echo "" | sudo tee --append plexmedia-server
# sudo echo "# space separated list of allowed UDP ports" | sudo tee --append plexmedia-server
# sudo echo "UDP=\"1900 5353 32410 32412 32413 32414\"" | sudo tee --append plexmedia-server
# sudo echo "" | sudo tee --append plexmedia-server
# sudo echo "# space separated list of allowed RPC services" | sudo tee --append plexmedia-server
# sudo echo "RPC=\"\"" | sudo tee --append plexmedia-server
# sudo echo "" | sudo tee --append plexmedia-server
# sudo echo "# space separated list of allowed IP protocols" | sudo tee --append plexmedia-server
# sudo echo "IP=\"\"" | sudo tee --append plexmedia-server
# sudo echo "" | sudo tee --append plexmedia-server
# sudo echo "# space separated list of allowed UDP broadcast ports" | sudo tee --append plexmedia-server
# 
# # Allow Plex through the Yast Firewall
sudo yast firewall services add service=service:plexmedia-server zone=INT
# 
# # Restart Plex service
# sudo service plexmediaserver start
