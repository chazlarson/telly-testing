#!/bin/bash

printf "reading config: \n"
printf "========================================\n"
source ${PWD}/config "$1"

printf "\n\ncleaning up existing telly dockers: \n"
printf "========================================\n"
docker stop $(docker ps -a -q -f "name=telly*") && docker system prune -f

printf "\n\nsetting up config files and scripts...\n"

cp telly.config.toml.tmpl telly.config.toml
cp docker.sh.tmpl         docker.sh

${SEDCMD} -i "s/\$PROVIDER/${PROVIDER_NAME}/"       docker.sh

${SEDCMD} -i "s/\$PROVIDER_NAME/${PROVIDER_NAME}/"  telly.config.toml
${SEDCMD} -i "s/\$PROVIDER/${PROVIDER}/"            telly.config.toml

${SEDCMD} -i "s/\$USER/${USER}/"                    telly.config.toml
${SEDCMD} -i "s/\$PASS/${PASS}/"                    telly.config.toml

${SEDCMD} -i "s/\$M3U_URL/${M3U_URL_ESC}/"          telly.config.toml
${SEDCMD} -i "s/\$XML_URL/${XML_URL_ESC}/"          telly.config.toml

${SEDCMD} -i "s/\$MYIP/${MYIP}/"                    telly.config.toml
${SEDCMD} -i "s/\$FILTER/${DEFAULT_FILTER}/"        telly.config.toml

# printf "\n\npreflighting filters: \n"
# printf "========================================\n"
# printf "group count:   " && ./group_count.sh   ${DEFAULT_FILTER} quiet
# printf "channel count: " && ./channel_count.sh ${DEFAULT_FILTER} quiet

printf "\n\nbuilding and running docker container: \n"
printf "========================================\n"
./docker.sh
