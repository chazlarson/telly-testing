#!/bin/bash

source ${PWD}/config

curl -fLs "${M3U_URL}" | sed "s/${IPTVUSER}/REDACTED/" | sed "s/${IPTVPASS}/REDACTED/"
