#!/bin/bash

printf "reading config: \n"
printf "========================================\n"
source "${PWD}/config" "$1"

echo PROVIDER......... $PROVIDER
echo PROVIDER_NAME.... $PROVIDER_NAME
echo IPTVUSER......... $IPTVUSER
echo IPTVPASS......... $IPTVPASS
echo M3U_URL.......... $M3U_URL
echo XML_URL.......... $XML_URL

echo SEDCMD........... $SEDCMD
echo MYIP............. $MYIP
echo DEFAULT_FILTER... $DEFAULT_FILTER
echo USE_FILE......... $USE_FILE

echo M3U_PATH......... $M3U_PATH
echo XML_PATH......... $XML_PATH

