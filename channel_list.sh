#!/bin/sh

source ${PWD}/config "$1" "$2"

./m3u.sh | egrep -ie "group-title=\".*(${DEFAULT_FILTER}).*\",.*" | sort | ${SEDCMD} 's/#EXTINF.* group-title="\(.*\)",\(.*\)\r/\2\t\1/' | sort | uniq