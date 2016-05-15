#!/bin/bash
# OpenSUSE Media Codec Script

sudo zypper addrepo -f http://packman.inode.at/suse/openSUSE_Leap_42.1/ packman

### TODO this has a prompt about strategies that you need 
to choose option 1 for

sudo zypper install k3b-codecs ffmpeg lame phonon-backend-vlc phonon4qt5-backend-vlc vlc-codecs flash-player

sudo zypper remove phonon-backend-gstreamer phonon4qt5-backend-gstreamer
