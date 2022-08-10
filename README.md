# spotify-restart-on-ad
Restarts the Spotify Desktop Client on Ubuntu when ads are played. This was tested on Ubuntu versions 20.04 - 22.04.

The scripts restart spotify as soon as it starts playing an ad. When restarted, the client should continue playing the next song instead of the advertisement. This method of ad muting does not rely on blocking any ad urls, it simply leverages a bug in the client, which persisted the last couple of years and is likely to remain unfixed in the future.

The script will restart the client keeping the previous window configuration e.g. if it was minimized, it will be minimized again after restart.

## Install

For this to work, you need to have the Spotify Desktop Client installed. **!IMPORTANT!** This does not work with the snap version of Spotify, you need to install the debian package version by following [this guide](https://www.spotify.com/us/download/linux/).

Clone this repository, then cd into it. Now run 
```
sudo ./install.sh
```

This should place the restart scripts in the Spotify installation directory, which is `/usr/share/spotify` per default. If this defers for you, simply edit the `SPOTIFY_INSTALLATION_PATH` in `install.sh`.
