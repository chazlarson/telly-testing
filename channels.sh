#!/bin/sh

source ${PWD}/config "$1" "$2"

./channel_count.sh "$1" "hush"
./channel_list.sh  "$1" "hush"
