FROM alpine:latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install dependencies
RUN apk add --no-cache openjdk8-jre tzdata musl-locales musl-locales-lang bash libxml2-utils netcat-openbsd \
    && rm -rf /var/cache/apk/*

ENV JAVA_HOME=/usr/lib/jvm/default-jvm/
ENV PATH=${PATH}:${JAVA_HOME}/bin

# install Temurin OpenJDK 17

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>"  \
      com.wso2.docker.source="https://github.com/wso2/docker-apim/releases/tag/v4.3.0.1"

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
ARG WSO2_DB_USERNAME
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

#ARG WSO2_SERVER_DIST_URL=https://github.com/wso2/${WSO2_SERVER_REPOSITORY}/releases/download/v${WSO2_SERVER_VERSION}/${WSO2_SERVER}.zip
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

RUN mkdir -p /etc/.java/.systemPrefs \
    && chown wso2carbon:wso2 -R /etc/.java/.systemPrefs \
    && chmod 755 /etc/.java/.systemPrefs

# copy init script to user home
COPY --chown=wso2carbon:wso2 docker-entrypoint.sh ${USER_HOME}/

# add the WSO2 product distribution to user's home directory
RUN wget ${WSO2_SERVER_DIST_URL} -O ${USER_HOME}/${WSO2_SERVER}.zip \
    && unzip -o -d ${USER_HOME} ${USER_HOME}/${WSO2_SERVER}.zip \
    && rm -f ${USER_HOME}/${WSO2_SERVER}.zip

#COPY --chown=wso2carbon:wso2 ${WSO2_SERVER}.zip ${USER_HOME}/
#RUN unzip -o -d ${USER_HOME} ${USER_HOME}/${WSO2_SERVER}.zip 

#do COPY org.wso2.carbon.registry.extensions-4.6.3.jar ${WSO2_SERVER_HOME}/repository/components/plugins
#COPY org.wso2.carbon.event.output.adapter.kafka.server.feature-5.0.11.zip ${USER_HOME}

#RUN unzip -o -d ${USER_HOME}/feature ${USER_HOME}/org.wso2.carbon.event.output.adapter.kafka.server.feature-5.0.11.zip
#RUN mv ${USER_HOME}/feature/plugins/org.wso2.carbon.event.output.adapter.kafka-5.0.11.jar ${WSO2_SERVER_HOME}/repository/components/plugins

RUN bash -c 'mkdir -p ${USER_HOME}/solr/{indexed-data,database}'

RUN chown wso2carbon:wso2 -R ${USER_HOME}/solr 

RUN rm ${WSO2_SERVER_HOME}/repository/deployment/server/webapps/cmis.war
RUN rm ${WSO2_SERVER_HOME}/repository/resources/webapps/juddiv3.war
RUN rm ${WSO2_SERVER_HOME}/repository/deployment/server/humantasks/WorkList.zip

RUN wget https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_DRIVER}.zip -O ${USER_HOME}/${MYSQL_DRIVER}.zip \
    && unzip -o -d ${USER_HOME} ${USER_HOME}/${MYSQL_DRIVER}.zip \
    && cp ${USER_HOME}/${MYSQL_DRIVER}/${MYSQL_DRIVER}.jar ${WSO2_SERVER_HOME}/repository/components/lib \
    && rm -f ${USER_HOME}/${MYSQL_DRIVER}.zip

COPY init-setup.sh ${USER_HOME}

#COPY *.crt ${USER_HOME}

#RUN keytool -import -storepass wso2carbon -keypass wso2carbon -noprompt -alias ssl -keystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -file ${USER_HOME}/self-ssl.crt
#RUN keytool -import -storepass wso2carbon -keypass wso2carbon -noprompt -trustcacerts -alias greg -keystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -file ${USER_HOME}/self-ssl.crt

#RUN keytool -import -storepass wso2carbon -keypass wso2carbon -noprompt -alias dist-wso2-repo -keystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -file ${USER_HOME}/product-dist-wso2.crt
#RUN keytool -import -storepass wso2carbon -keypass wso2carbon -noprompt -trustcacerts -alias dist-wso2-repo -keystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -file ${USER_HOME}/product-dist-wso2.crt
#RUN keytool -importkeystore -srckeystore /${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -deststoretype pkcs12
#RUN keytool -import -storepass wso2carbon -keypass wso2carbon -noprompt -trustcacerts -alias dist-wso2-repo -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks -file ${USER_HOME}/product-dist-wso2.crt

#RUN keytool -import -storepass changeit -keypass changeit -noprompt -alias dist-wso2-repo -keystore /usr/lib/jvm/default-jvm/jre/lib/security/cacerts -file ${USER_HOME}/product-dist-wso2.crt

#RUN rm ${USER_HOME}/*.crt

RUN chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}

# remove unnecesary packages
RUN apk del netcat-openbsd

# set the user and work directory
USER ${USER_ID}
WORKDIR ${USER_HOME}

# set environment variables
ENV WORKING_DIRECTORY=${USER_HOME} \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME} 

# expose ports
EXPOSE 9443 
#9763 9999 11111 8280 8243 5672 9711 9611 9099

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]