#!/bin/sh

source ${PWD}/config "$1" "$2"

./group_count.sh "$1" "hush"
./group_list.sh  "$1" "hush"
