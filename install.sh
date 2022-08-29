#!/bin/bash

# this script installs the spotify ad muter scripts

if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit 1
fi

SPOTIFY_INSTALL_PATH=/usr/share/spotify/

echo "INSTALL XDOTOOL..."
apt update && apt install xdotool

echo "MAKE SCRIPTS EXECUTABLE ..."
chmod a+x restart_on_ad.sh spotify_ad_mute.sh

echo "COPY SCRIPTS TO $SPOTIFY_INSTALL_PATH ..."
cp restart_on_ad.sh spotify_ad_mute.sh $SPOTIFY_INSTALL_PATH

echo "CREATING SYMLINK TO ${SPOTIFY_INSTALL_PATH}spotify_ad_mute.sh ..."
rm /usr/bin/spotify
ln -s $SPOTIFY_INSTALL_PATH/spotify_ad_mute.sh /usr/bin/spotify
echo "Spotify ad muter successfully installed!"
