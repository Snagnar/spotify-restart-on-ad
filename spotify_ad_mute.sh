#!/bin/bash

echo "starting ad muting spotify"

file_dir=$(dirname $(realpath $(readlink -f $0)))
echo "got file dir: $file_dir"
$file_dir/spotify* $@ &
spotPid=$!
echo $spotPid > /tmp/spotPids.txt
$file_dir/restart_on_ad.sh $spotPid &
