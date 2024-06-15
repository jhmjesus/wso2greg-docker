FROM alpine:latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install dependencies
RUN apk add --no-cache --allow-untrusted --no-check-certificate openjdk8-jre openjdk8-jre tzdata musl-locales musl-locales-lang bash libxml2-utils netcat-openbsd \
    && rm -rf /var/cache/apk/*

ENV JAVA_HOME=/usr/lib/jvm/default-jvm/
ENV PATH=${PATH}:${JAVA_HOME}/bin

LABEL maintainer="Docker Maintainers <jhmjesus@yahoo.com.br>"  \
    com.wso2.docker.source="https://github.com/jhmjesus/wso2greg-docker"

# set Docker image build arguments
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=10001
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=10001
ARG USER_HOME=/home/${USER}

# build arguments for WSO2 product installation
ARG WSO2_SERVER_NAME="WSO2 Governance Regitry"
ARG WSO2_DIST_SERVER_NAME=wso2greg
ARG WSO2_SERVER_VERSION=5.4.0
ARG WSO2_SERVER_REPOSITORY=product-greg
ARG WSO2_SERVER=${WSO2_DIST_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_DB_USERNAME=${USER}
ARG WSO2_DB_PASSWORD
ARG WSO2_DB_URL
ARG WSO2_DB_DRIVER
ARG WSO2_METRICS_DB_USERNAME
ARG WSO2_METRICS_DB_PASSWORD
ARG WSO2_METRICS_DB_URL
ARG WSO2_METRICS_DB_DRIVER
ARG WSO2_SOCIAL_DB_USERNAME
ARG WSO2_SOCIAL_DB_PASSWORD
ARG WSO2_SOCIAL_DB_URL
ARG WSO2_SOCIAL_DB_DRIVER
ARG WSO2_BPS_DB_USERNAME
ARG WSO2_BPS_DB_PASSWORD
ARG WSO2_BPS_DB_URL
ARG WSO2_BPS_DB_DRIVER
ARG MYSQL_DRIVER=mysql-connector-j-8.4.0
ARG WSO2_HOSTNAME="localhost"

ARG WSO2_LDAP_URL
ARG WSO2_LDAP_CONN_NAME
ARG WSO2_LDAP_CONN_PASSWORD
ARG WSO2_LDAP_USER_SEARCH_BASE
ARG WSO2_LDAP_USERNAME_ATTR
ARG WSO2_LDAP_USERNAME_SEARCH_FILTER
ARG WSO2_LDAP_USERNAME_LIST_FILTER
ARG WSO2_LDAP_GROUP_SEARCH_BASE
ARG WSO2_LDAP_GROUP_NAME_ATTR
ARG WSO2_LDAP_GROUP_NAME_SEARCH_FILTER
ARG WSO2_LDAP_GROUP_LIST_FILTER

# this source was not existis any more WSO2_SERVER_DIST_URL=https://github.com/wso2/${WSO2_SERVER_REPOSITORY}/releases/download/v${WSO2_SERVER_VERSION}/${WSO2_SERVER}.zip
ARG WSO2_SERVER_DIST_URL=https://svn.wso2.org/repos/wso2/scratch/G-Reg/${WSO2_SERVER_VERSION}/${WSO2_SERVER}.zip

# build argument for MOTD
ARG MOTD='printf "\n\
    Welcome to WSO2 Docker Resources \n\
    --------------------------------- \n\
    This Docker container comprises of a WSO2 product, running with its latest GA release \n\
    which is under the Apache License, Version 2.0. \n\
    Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"'
ENV ENV=${USER_HOME}"/.ashrc" \
    WSO2_DB_USERNAME="${WSO2_DB_USERNAME}" \
    WSO2_DB_PASSWORD="${WSO2_DB_PASSWORD}" \
    WSO2_DB_URL="${WSO2_DB_URL}" \
    WSO2_DB_DRIVER="${WSO2_DB_DRIVER}"

# create the non-root user and group and set MOTD login message
RUN \
    addgroup -S -g ${USER_GROUP_ID} ${USER_GROUP} \
    && adduser -S -u ${USER_ID} -h ${USER_HOME} -G ${USER_GROUP} ${USER} \
    && echo ${MOTD} > "${ENV}"

# configure the java system io system preferences    
RUN mkdir -p /etc/.java/.systemPrefs \
    && chown ${USER}:${USER_GROUP} -R /etc/.java/.systemPrefs \
    && chmod 755 /etc/.java/.systemPrefs

# add the WSO2 product distribution to user's home directory
RUN wget --no-check-certificate ${WSO2_SERVER_DIST_URL} -O ${USER_HOME}/${WSO2_SERVER}.zip \
    && unzip -o \
    -d ${USER_HOME} ${USER_HOME}/${WSO2_SERVER}.zip \
    && rm -f ${USER_HOME}/${WSO2_SERVER}.zip

# removing some unnecessary resouces, for my necessities
RUN rm -f ${WSO2_SERVER_HOME}/repository/deployment/server/webapps/cmis.war
RUN rm -f ${WSO2_SERVER_HOME}/repository/resources/webapps/juddiv3.war 
RUN rm -f ${WSO2_SERVER_HOME}/repository/deployment/server/humantasks/WorkList.zip
RUN rm -rf ${WSO2_SERVER_HOME}/samples

# create a solr server directories
RUN bash -c 'mkdir -p ${USER_HOME}/solr/{indexed-data,database}'

# add mysql JDBC driver into WSO2 produt installation
RUN wget --no-check-certificate https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_DRIVER}.zip -O ${USER_HOME}/${MYSQL_DRIVER}.zip \
    && unzip -o -d ${USER_HOME} ${USER_HOME}/${MYSQL_DRIVER}.zip \
    && cp ${USER_HOME}/${MYSQL_DRIVER}/${MYSQL_DRIVER}.jar ${WSO2_SERVER_HOME}/repository/components/lib \
    && rm -rf ${USER_HOME}/${MYSQL_DRIVER}.zip \
    && rm -rf ${USER_HOME}/${MYSQL_DRIVER}

# add permissions to user home     
RUN chown ${USER}:${USER_GROUP} -R ${USER_HOME}

# copy init script to user home
COPY --chown=${USER}:${USER_GROUP} *.sh ${USER_HOME}

RUN chmod 755 ${USER_HOME}/*.sh

# remove unnecesary packages
RUN apk del netcat-openbsd

# set the user and work directory
USER ${USER}
WORKDIR ${USER_HOME}

# set environment variables
ENV WORKING_DIRECTORY=${USER_HOME} \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

# expose ports 
# available GREG ports 9443 9763 9999 11111 8280 8243 5672 9711 9611 9099
EXPOSE 9443 

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]