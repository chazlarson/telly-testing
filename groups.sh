#!/bin/bash

source "${PWD}/config" "$1"

./group_count.sh "$1"
./group_list.sh  "$1"
