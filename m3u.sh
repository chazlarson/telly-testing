#!/bin/bash

. ${PWD}/config

curl -fLs "${M3U_URL}" | sed 's/"${USER}"/REDACTED/' | sed 's/"${PASS}"/REDACTED/'
