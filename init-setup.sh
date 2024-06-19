#!/bin/bash

set -e

#################################
# Required Docker image ARG values
[[ -z "$WSO2_DB_URL" || ! -v  WSO2_DB_URL ]] && echo "WSO2_DB_URL is required" && exit 1
[[ -z "$WSO2_DB_DRIVER" || ! -v  WSO2_DB_DRIVER ]] && echo "WSO2_DB_DRIVER is required" && exit 2
[[ -z "$WSO2_DB_PASSWORD" || ! -v  WSO2_DB_PASSWORD ]] && echo "WSO2_DB_PASSWORD is required" && exit 3
[[ -z "$WSO2_DB_USERNAME" || ! -v  WSO2_DB_USERNAME ]] && echo "WSO2_DB_USERNAME is required" && exit 4

#################################
# Host name Server configurations and replacement values
WSO2_SERVER_HOME_DEFAULT="WSO2 Governance Registry"
WSO2_HOSTNAME_DEFAULT="localhost"

WSO2_SERVER_NAME="${WSO2_SERVER_NAME=$WSO2_SERVER_NAME_DEFAULT}"
WSO2_HOSTNAME="${WSO2_HOSTNAME=$WSO2_HOSTNAME_DEFAULT}"

sed -i "29s@www.wso2.org@$WSO2_SERVER_NAME@g" ${WSO2_SERVER_HOME}/repository/conf/carbon.xml
sed -i "59s@www.wso2.org@$WSO2_SERVER_NAME@g" ${WSO2_SERVER_HOME}/repository/conf/multitenancy/cloud-services-desc.xml

# Change Sserver Host name 
sed -i "s@<!--HostName>www.wso2.org</HostName-->@<HostName>$WSO2_HOSTNAME</HostName>@g" ${WSO2_SERVER_HOME}/repository/conf/carbon.xml
sed -i "s@<!--MgtHostName>mgt.wso2.org</MgtHostName-->@<MgtHostName>$WSO2_HOSTNAME</MgtHostName>@g" ${WSO2_SERVER_HOME}/repository/conf/carbon.xml

#################################
# Database configurations and replacement values

# Default values to replace in database configuration files
WSO2_DB_USERNAME_DEFAULT="wso2carbon"
WSO2_DB_PASSWORD_DEFAULT="wso2carbon"
WSO2_DB_DRIVER_DEFAULT="org.h2.Driver"
WSO2_DB_URL_DEFAULT="jdbc:h2:repository/database/WSO2CARBON_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000"
WSO2_METRICS_DB_URL_DEFAULT="jdbc:h2:repository/database/WSO2METRICS_DB;DB_CLOSE_ON_EXIT=FALSE;AUTO_SERVER=TRUE"
WSO2_SOCIAL_DB_URL_DEFAULT="jdbc:h2:repository/database/WSO2SOCIAL_DB;DB_CLOSE_ON_EXIT=FALSE;MVCC=true"
WSO2_BPS_DB_URL_DEFAULT="jdbc:h2:file:repository/database/jpadb;DB_CLOSE_ON_EXIT=FALSE;MVCC=TRUE"

#################################
# Master database configurations
WSO2_DB_USERNAME="${WSO2_DB_USERNAME-$WSO2_DB_USERNAME_DEFAULT}"
WSO2_DB_PASSWORD="${WSO2_DB_PASSWORD-$WSO2_DB_PASSWORD_DEFAULT}"
WSO2_DB_URL="${WSO2_DB_URL-$WSO2_DB_URL_DEFAULT}"
WSO2_DB_DRIVER="${WSO2_DB_DRIVER-$WSO2_DB_DRIVER_DEFAULT}"
WSO2_DB_MAX_ACTIVE="100"
WSO2_DB_MAX_IDLE="20"
WSO2_DB_MAX_WAIT="60000"

# Master datasource configuration file
WSO2_MASTER_DATABASE=${WSO2_SERVER_HOME}/repository/conf/datasources/master-datasources.xml

sed -i "s@$WSO2_DB_URL_DEFAULT@$WSO2_DB_URL@g" $WSO2_MASTER_DATABASE
sed -i "s@username>$WSO2_DB_USERNAME_DEFAULT@username>$WSO2_DB_USERNAME@g" $WSO2_MASTER_DATABASE
sed -i "s@password>$WSO2_DB_PASSWORD_DEFAULT@password>$WSO2_DB_PASSWORD@g" $WSO2_MASTER_DATABASE
sed -i "s@driverClassName>$WSO2_DB_DRIVER_DEFAULT@driverClassName>$WSO2_DB_DRIVER@g" $WSO2_MASTER_DATABASE
sed -i "27s@100@$WSO2_DB_MAX_ACTIVE@g" $WSO2_MASTER_DATABASE
sed -i "28s@10000@$WSO2_DB_MAX_WAIT@g" $WSO2_MASTER_DATABASE

#################################
# Metrics database configurations
WSO2_METRICS_DB_USERNAME="${WSO2_METRICS_DB_USERNAME=$WSO2_DB_USERNAME}"
WSO2_METRICS_DB_PASSWORD="${WSO2_METRICS_DB_PASSWORD=$WSO2_DB_PASSWORD}"
WSO2_METRICS_DB_URL="${WSO2_METRICS_DB_URL=$WSO2_DB_URL}"
WSO2_METRICS_DB_DRIVER="${WSO2_METRICS_DB_DRIVER=$WSO2_DB_DRIVER}"
WSO2_METRICS_DB_MAX_ACTIVE="50"
WSO2_METRICS_DB_MAX_IDLE="20"
WSO2_METRICS_DB_MAX_WAIT="60000"

# Metrics datasource configuration file
WSO2_METRICS_DATABASE=${WSO2_SERVER_HOME}/repository/conf/datasources/metrics-datasources.xml

sed -i "s@$WSO2_METRICS_DB_URL_DEFAULT@$WSO2_METRICS_DB_URL@g" $WSO2_METRICS_DATABASE
sed -i "s@username>$WSO2_DB_USERNAME_DEFAULT@username>$WSO2_METRICS_DB_USERNAME@g" $WSO2_METRICS_DATABASE
sed -i "s@password>$WSO2_DB_PASSWORD_DEFAULT@password>$WSO2_METRICS_DB_PASSWORD@g" $WSO2_METRICS_DATABASE
sed -i "s@driverClassName>$WSO2_DB_DRIVER_DEFAULT@driverClassName>$WSO2_METRICS_DB_DRIVER@g" $WSO2_METRICS_DATABASE
sed -i "37s@100@$WSO2_METRICS_DB_MAX_ACTIVE@g" $WSO2_METRICS_DATABASE
sed -i "38s@10000@$WSO2_METRICS_DB_MAX_WAIT@g" $WSO2_METRICS_DATABASE
sed -i "38i                    <maxIdle>$WSO2_METRICS_DB_MAX_IDLE</maxIdle>" $WSO2_METRICS_DATABASE

#################################
# Social database configurations
WSO2_SOCIAL_DB_USERNAME="${WSO2_SOCIAL_DB_USERNAME=$WSO2_DB_USERNAME}"
WSO2_SOCIAL_DB_PASSWORD="${WSO2_SOCIAL_DB_PASSWORD=$WSO2_DB_PASSWORD}"
WSO2_SOCIAL_DB_URL="${WSO2_SOCIAL_DB_URL=$WSO2_DB_URL}"
WSO2_SOCIAL_DB_DRIVER="${WSO2_SOCIAL_DB_DRIVER=$WSO2_DB_DRIVER}"
WSO2_SOCIAL_DB_MAX_ACTIVE="5"
WSO2_SOCIAL_DB_MAX_IDLE="2"
WSO2_SOCIAL_DB_MAX_WAIT="6000"

# Social datasource configuration file
WSO2_SOCIAL_DATABASE=${WSO2_SERVER_HOME}/repository/conf/datasources/social-datasources.xml

sed -i "s@$WSO2_SOCIAL_DB_URL_DEFAULT@$WSO2_SOCIAL_DB_URL@g" $WSO2_SOCIAL_DATABASE
sed -i "s@username>$WSO2_DB_USERNAME_DEFAULT@username>$WSO2_SOCIAL_DB_USERNAME@g" $WSO2_SOCIAL_DATABASE
sed -i "s@password>$WSO2_DB_PASSWORD_DEFAULT@password>$WSO2_SOCIAL_DB_PASSWORD@g" $WSO2_SOCIAL_DATABASE
sed -i "s@driverClassName>$WSO2_DB_DRIVER_DEFAULT@driverClassName>$WSO2_SOCIAL_DB_DRIVER@g" $WSO2_SOCIAL_DATABASE
sed -i "21s@50@$WSO2_SOCIAL_DB_MAX_ACTIVE@g" $WSO2_SOCIAL_DATABASE
sed -i "22s@60000@$WSO2_SOCIAL_DB_MAX_WAIT@g" $WSO2_SOCIAL_DATABASE
sed -i "22i<maxIdle>$WSO2_SOCIAL_DB_MAX_IDLE</maxIdle>" $WSO2_SOCIAL_DATABASE

#################################
# BPS database configurations
WSO2_BPS_DB_USERNAME="${WSO2_BPS_DB_USERNAME=$WSO2_DB_USERNAME}"
WSO2_BPS_DB_PASSWORD="${WSO2_BPS_DB_PASSWORD=$WSO2_DB_PASSWORD}"
WSO2_BPS_DB_URL="${WSO2_BPS_DB_URL=$WSO2_DB_URL}"
WSO2_BPS_DB_DRIVER="${WSO2_BPS_DB_DRIVER=$WSO2_DB_DRIVER}"
WSO2_BPS_DB_MAX_ACTIVE="10"
WSO2_BPS_DB_MAX_IDLE="2"
WSO2_BPS_DB_MAX_WAIT="1000"

# BPS datasource configuration file
WSO2_BPS_DATABASE=${WSO2_SERVER_HOME}/repository/conf/datasources/bps-datasources.xml

sed -i "s@$WSO2_BPS_DB_URL_DEFAULT@$WSO2_BPS_DB_URL@g" $WSO2_BPS_DATABASE
sed -i "s@username>$WSO2_DB_USERNAME_DEFAULT@username>$WSO2_BPS_DB_USERNAME@g" $WSO2_BPS_DATABASE
sed -i "s@password>$WSO2_DB_PASSWORD_DEFAULT@password>$WSO2_BPS_DB_PASSWORD@g" $WSO2_BPS_DATABASE
sed -i "s@driverClassName>$WSO2_DB_DRIVER_DEFAULT@driverClassName>$WSO2_BPS_DB_DRIVER@g" $WSO2_BPS_DATABASE
sed -i "25s@100@$WSO2_BPS_DB_MAX_ACTIVE@g" $WSO2_BPS_DATABASE
sed -i "26s@20@$WSO2_BPS_DB_MAX_IDLE@g" $WSO2_BPS_DATABASE
sed -i "27s@10000@$WSO2_BPS_DB_MAX_WAIT@g" $WSO2_BPS_DATABASE

if [ ! -z $WSO2_LDAP_URL ]; then 
  # User management configuration file
  WSO2_USERS_MGT=${WSO2_SERVER_HOME}/repository/conf/user-mgt.xml
  
  # Comment default H2 DB UserStore Configuration
  sed -i "41s@<UserStoreManager@<!--UserStoreManager@g" $WSO2_USERS_MGT
  sed -i "64s@</UserStoreManager>@</UserStoreManager-->@g" $WSO2_USERS_MGT

  # Uncomment OpenLDAP UserStore Configuration
  sed -i "70s@<!--UserStoreManager@<UserStoreManager@g" $WSO2_USERS_MGT

  # Change the default configuration values to Docker image ARG values
  sed -i "72s@ldap://localhost:10389@$WSO2_LDAP_URL@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_CONN_NAME ] && sed -i "73s@uid=admin,ou=system@$WSO2_LDAP_CONN_NAME@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_CONN_PASSWORD ] && sed -i "74s@admin@$WSO2_LDAP_CONN_PASSWORD@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_USER_SEARCH_BASE ] && sed -i "76s@ou=system@$WSO2_LDAP_USER_SEARCH_BASE@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_USERNAME_ATTR ] && sed -i "77s@uid@$WSO2_LDAP_USERNAME_ATTR@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_USERNAME_SEARCH_FILTER ] && WSO2_LDAP_USERNAME_SEARCH_FILTER=$(echo $WSO2_LDAP_USERNAME_SEARCH_FILTER | sed "s@\&@\\\&@g") && sed -i "78s@(\&amp;(objectClass=person)(uid=?))@$WSO2_LDAP_USERNAME_SEARCH_FILTER@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_USERNAME_LIST_FILTER ] && sed -i "79s@(objectClass=person)@$WSO2_LDAP_USERNAME_LIST_FILTER@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_GROUP_SEARCH_BASE ] && sed -i "82s@ou=system@$WSO2_LDAP_GROUP_SEARCH_BASE@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_GROUP_NAME_ATTR ] && sed -i "83s@cn@$WSO2_LDAP_GROUP_NAME_ATTR@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_GROUP_NAME_SEARCH_FILTER ] && WSO2_LDAP_GROUP_NAME_SEARCH_FILTER=$(echo $WSO2_LDAP_GROUP_NAME_SEARCH_FILTER | sed "s@\&@\\\&@g") && sed -i "84s@(\&amp;(objectClass=groupOfNames)(cn=?))@$WSO2_LDAP_GROUP_NAME_SEARCH_FILTER@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_GROUP_LIST_FILTER ] && sed -i "85s@(objectClass=groupOfNames)@$WSO2_LDAP_GROUP_LIST_FILTER@g" $WSO2_USERS_MGT
  [ -v WSO2_LDAP_GROUP_MEMBERSHIP_ATTR ] && sed -i "86s@member@$WSO2_LDAP_GROUP_MEMBERSHIP_ATTR@g" $WSO2_USERS_MGT
  
  sed -i "218s@false@true@g" $WSO2_USERS_MGT
  
  # Uncomment OpenLDAP UserStore Configuration
  sed -i "102s@</UserStoreManager-->@</UserStoreManager>@g" $WSO2_USERS_MGT

  sed -i "101i<Property name=\"DomainName\">EXAMPLE</Property>" $WSO2_USERS_MGT

fi

#################################
# Disable OWASP CSRF

# OWASP CSRF configuration file
OWASP_CSRFGUARD_FILE=${WSO2_SERVER_HOME}/repository/conf/security/Owasp.CsrfGuard.Carbon.properties

# Change org.owasp.csrfguard.Enabled to false
sed -i "59s@true@false@g" $OWASP_CSRFGUARD_FILE 

#################################
# Remove all File Appenders

# Log4j configuration file
LOG4J_FILE=${WSO2_SERVER_HOME}/repository/conf/log4j.properties

# Remove AUDIT_LOGFILE output configurations
#sed -i "s@, AUDIT_LOGFILE@@g" $LOG4J_FILE

# Remove CARBON_LOGFILE output configurations
sed -i "s@, CARBON_LOGFILE@@g" $LOG4J_FILE

# Remove CARBON_TRACE_LOGFILE output configurations
sed -i "s@,CARBON_TRACE_LOGFILE@@g" $LOG4J_FILE

