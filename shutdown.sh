#!/bin/bash
# Shutdown script

zenity --question --text "Automated system shutdown set to begin in 30 seconds." --ok-label="Shutdown Now" --cancel-label="Cancel Shutdown" --title "System Shutdown" --display=:0.0 --timeout 30


# XAUTHORITY=/home/craig/.Xauthority

# echo $?
# echo $choice

if [ $? -ne 1 ]; then
	zenity --info --display=:0.0 --text "Preparing to shut down machine" --timeout 3
	sleep 1
	systemctl poweroff -i
else
	zenity --info --display=:0.0 --text "System shutdown cancelled." --timeout 3
fi 
