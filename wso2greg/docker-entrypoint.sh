#!/bin/bash
# ------------------------------------------------------------------------
# Copyright 2018 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

set -e

. ./init-setup.sh

# home of the directories to be artifact synced within the WSO2 product home
deployment_volume=${WSO2_SERVER_HOME}/repository/deployment/server
# home of the directories with preserved, default deployment artifacts
original_deployment_artifacts=${WORKING_DIRECTORY}/wso2-tmp

# check if the WSO2 non-root user home exists
test ! -d ${WORKING_DIRECTORY} && echo "WSO2 Docker non-root user home does not exist" && exit 1

# check if the WSO2 product home exists
test ! -d ${WSO2_SERVER_HOME} && echo "WSO2 Docker product home does not exist" && exit 1

# start WSO2 Carbon server
echo "Start WSO2 Carbon server" >&2
# start the server with the provided startup arguments
sh ${WSO2_SERVER_HOME}/bin/wso2server.sh "$@"
