#!/bin/bash

echo "$$: starting script, got spotify pid: $1"
SPOTIFY_PID=$1

SP_DEST="org.mpris.MediaPlayer2.spotify"
SP_PATH="/org/mpris/MediaPlayer2"
SP_MEMB="org.mpris.MediaPlayer2.Player"

file_dir=$(dirname $(realpath $(readlink -f $0)))

function ad_playing {
	metadata=$(
		dbus-send                                                                   \
			--print-reply                                  `# We need the reply.`       \
			--dest=$SP_DEST                                                             \
			$SP_PATH                                                                    \
			org.freedesktop.DBus.Properties.Get                                         \
			string:"$SP_MEMB" string:'Metadata'
	)
	# msg=$(head "$metadata")
	# echo "in ad playing, metadata: $metadata"
	(echo $metadata | grep "/com/spotify/ad") || (echo $metadata | grep "spotify:ad")
}

function resume_playing {
	echo "$$: resuming playing"
	dbus-send --print-reply --dest=$SP_DEST $SP_PATH $SP_MEMB.Next > /dev/null
}


while true
do
	if ps -p $SPOTIFY_PID > /dev/null
	then
		touch /tmp/spotPids.txt
	else
		# kill everything if spotify is not running
		while read p; do
			kill $p
		done </tmp/spotPids.txt
		exit
	fi
	if ad_playing
	then
		current_spotify_window_id=$(xdotool search --pid $1)
		readarray -t current_spotify_window_id <<<"$current_spotify_window_id"
		current_spotid=${current_spotify_window_id[1]}
		echo "trying to figure out current state, pid: $current_spotid"
		was_minimized="false"
		if xprop -id $current_spotid | grep "_NET_WM_STATE_HIDDEN"
		then
			was_minimized="true"
		fi
		echo "was minimized: $was_minimized"
		# kill spotify
		echo "ad detected, killing spotify..."
		while read p; do
			kill $p
		done </tmp/spotPids.txt
		sleep 1
		
		echo "start ad muting spotify script"
		$file_dir/spotify_ad_mute.sh &

		sleep 1
		if [[ $was_minimized == "true" ]]
		then
			echo "minimizing window..."
			spotify_pid=$(</tmp/spotPids.txt)
			echo "$$: got spotify pid: $spotify_pid"
			windowIds=$(xdotool search --pid $spotify_pid)
			echo "$$: got window ids: $windowIds"
			readarray -t windowIds <<<"$windowIds"
			echo "$$: middle one: ${windowIds[1]}"
			xdotool windowminimize "${windowIds[1]}"
		fi
		sleep 3
		resume_playing
		exit
	fi
	sleep 3
done
