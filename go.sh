#!/bin/bash

printf "reading config: \n"
printf "========================================\n"
source ${PWD}/config "$1"

./show_config.sh

printf "\n\ncleaning up existing telly dockers: \n"
printf "========================================\n"
docker stop $(docker ps -a -q -f "name=telly*") && docker system prune -f

printf "\n\nsetting up config files and scripts...\n"

cp telly.config.toml.tmpl telly.config.toml
cp docker.sh.tmpl         docker.sh

${SEDCMD} -i "s/\$PROVIDER/${PROVIDER_NAME}/"                      docker.sh

${SEDCMD} -i "s/\$PROVIDER_NAME/${PROVIDER_NAME}/"                 telly.config.toml
${SEDCMD} -i "s/\$PROVIDER/${PROVIDER}/"                           telly.config.toml

${SEDCMD} -i "s/\$IPTVUSER/${IPTVUSER}/"                           telly.config.toml
${SEDCMD} -i "s/\$IPTVPASS/${IPTVPASS}/"                           telly.config.toml

if [ "$USE_FILE" = true ] ; then
	${SEDCMD} -i "s/\$M3U_URL/\/etc\/telly\/${PROVIDER_NAME}.m3u/" telly.config.toml
	${SEDCMD} -i "s/\$XML_URL/\/etc\/telly\/${PROVIDER_NAME}.xml/" telly.config.toml
else
	${SEDCMD} -i "s/\$M3U_URL/${M3U_URL_ESC}/"                     telly.config.toml
	${SEDCMD} -i "s/\$XML_URL/${XML_URL_ESC}/"                     telly.config.toml
fi

${SEDCMD} -i "s/\$M3U_PATH/${M3U_PATH_ESC}/"                       telly.config.toml
${SEDCMD} -i "s/\$XML_PATH/${XML_PATH_ESC}/"                       telly.config.toml

${SEDCMD} -i "s/\$MYIP/${MYIP}/"                                   telly.config.toml
${SEDCMD} -i "s/\$FILTER/${DEFAULT_FILTER}/"                       telly.config.toml

${SEDCMD} -i "s/\$TIMEZONE/${TIME_ZONE}/"                          telly.config.toml


# printf "\n\npreflighting filters: \n"
# printf "========================================\n"
# printf "group count:   " && ./group_count.sh   ${DEFAULT_FILTER} quiet
# printf "channel count: " && ./channel_count.sh ${DEFAULT_FILTER} quiet

if [ "$USE_FILE" = true ] ; then
    printf "\n\ncleaning up and retrieving data files: \n"
    printf "========================================\n"
    rm -f  ${M3U_PATH}
    rm -f  ${XML_PATH}
    ./m3u-stock.sh > ${M3U_PATH}
    ./xml-stock.sh > ${XML_PATH}
fi

printf "\n\nbuilding and running docker container: \n"
printf "========================================\n"
./docker.sh
