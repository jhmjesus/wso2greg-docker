#!/bin/bash

set -e

. ./init-setup.sh

# check if the WSO2 non-root user home exists
test ! -d ${WORKING_DIRECTORY} && echo "WSO2 Docker non-root user home does not exist" && exit 1

# check if the WSO2 product home exists
test ! -d ${WSO2_SERVER_HOME} && echo "WSO2 Docker product home does not exist" && exit 1

# start WSO2 Carbon server
echo "Start WSO2 Carbon server" >&2
# start the server with the provided startup arguments
sh ${WSO2_SERVER_HOME}/bin/wso2server.sh "$@"
