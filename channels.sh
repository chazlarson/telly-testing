#!/bin/bash

source "${PWD}/config" "$1"

./channel_count.sh "$1"
./channel_list.sh  "$1"
