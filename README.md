# WSO2 Governance Registry Docker Image
This is a suggestion, considering my scenario, for the WSO2 Governance Registry version 5.4.0 Docker image.

In this installation of the GREG I was create LDAP, MYSQL and some product customizations using Docker ARGs as parameter.

## Features
- [x] Server hostname configuration
- [x] MySQL connection configuration
- [x] LDAP User Store configuration
- [x] Disable OSCR security

### Server hostname
To change the default hostname 'localhost' to another hostname run:

```bash
docker run -it \ 
-e WSO2_HOSTNAME=[hostname] \
   : \
jhmjesus/wso2greg
```

# Using docker 

The basic command suggested to initialize a container is:

```bash
docker run -it -p 9443:9443 \ 
-e "WSO2_DB_DRIVER=com.mysql.jdbc.Driver" \
-e "WSO2_DB_URL=jdbc:mysql://mysql:3306/WSO2CARBON_DB" \
jhmjesus/wso2greg
```


## Database
In the current Docker Imagem version it is possible to use only the MySQL database configuration.

It is **IMPORTANT** to run the SQL database scripts before to run a GREG container instance. This scripts are located in ```<SERVER_HOME>/repository/dbscripts``` into [wso2greg-5.4.0](https://svn.wso2.org/repos/wso2/scratch/G-Reg/5.4.0/$wso2greg-5.4.0.zip) distribution or in [initdb.d](./mysql/initdb.d) directory on this repository.

### Credentials

The database credentials are **REQUIRED** to initialize the container and can be setted by:

Docker ENV Variable    | Description  | Default value
 ---                   | ---          | ---
```WSO2_DB_USERNAME``` | DB username  | ```wso2carbon```
```WSO2_DB_PASSWORD``` | DB password  | ```wso2carbon```

### JDBC Driver
To set the JDBC Driver to use in database configuration is necessary to define java class in ```WSO2_DB_DRIVER``` docker Env variable.

```bash
docker run -it \ 
-e "WSO2_DB_DRIVER=com.mysql.jdbc.Driver" \
   : \
jhmjesus/wso2greg
```

### Single database
There are 4 databases in GREG, but we can configure only one URL to single database in ```WSO2_DB_URL``` docker ENV variable.

We can create an instance running:

```bash
docker run -it \ 
-e "WSO2_DB_DRIVER=com.mysql.jdbc.Driver" \
-e "WSO2_DB_URL=jdbc:mysql://mysql:3306/WSO2CARBON_DB" \
   : \
jhmjesus/wso2greg
```

### Multiple databases

There are 4 databases in GREG and it is possible to configure each URL independenttly, using the respective  URL docker Env variable (```WSO2_DB_URL```, ```WSO2_METRICS_DB_URL```, ```WSO2_SOCIAL_DB_URL``` and ```WSO2_BPS_DB_URL```).

Using different database URL´s described below:

 Docker ENV variable       | Description | DB Name
 ---                       | ---         | ---
 ```WSO2_DB_URL```         | Carbon DB   | WSO2CARBON_DB
 ```WSO2_METRICS_DB_URL``` | Metrics DB  | WSO2METRICS_DB
 ```WSO2_SOCIAL_DB_URL```  | Social DB   | WSO2SOCIAL_DB
 ```WSO2_BPS_DB_URL```     | BPEL DB     | WSO2BPS_DB

We can create an instance running:

```bash
docker run -it \ 
-e "WSO2_DB_DRIVER=com.mysql.jdbc.Driver" \
-e "WSO2_DB_URL=jdbc:mysql://mysql:3306/WSO2CARBON_DB" \
-e "WSO2_METRICS_DB_URL=jdbc:mysql://mysql:3306/WSO2METRICS_DB" \
-e "WSO2_SOCIAL_DB_URL=jdbc:mysql://mysql:3306/WSO2SOCIAL_DB" \
-e "WSO2_BPS_DB_URL=jdbc:mysql://mysql:3306/WSO2BPS_DB" \
   : \
jhmjesus/wso2greg
```

## LDAP

To configure the User Store to use LDAP it is possible to pass a lot of docker ENV variables.

It is **IMPORTANT** to know that all these variables are conditioned to the use of the ```WSO2_LDAP_URL``` variable, that is, if the ```WSO2_LDAP_URL``` is not passed on, the others will be ignored.

Docker ENV variable                      | Description                 | Default value
 ---                                     | ---                         | ---    
```WSO2_LDAP_URL```                      | LDAP connection URL         | ldap://localhost:10389
```WSO2_LDAP_CONN_NAME```                | admin bind DN               | uid=admin,ou=system
```WSO2_LDAP_CONN_PASSWORD```            | admin password              | admin
```WSO2_LDAP_USER_SEARCH_BASE```         | users base DN               | ou=system
```WSO2_LDAP_USERNAME_ATTR```            | username attribute          | uid
```WSO2_LDAP_USERNAME_SEARCH_FILTER```   | user search ny name filter  | (&amp;(objectClass=person)(uid=?))
```WSO2_LDAP_USERNAME_LIST_FILTER```     | user list search filter     | (objectClass=person)
```WSO2_LDAP_GROUP_SEARCH_BASE```        | groups base DN              | ou=system
```WSO2_LDAP_GROUP_NAME_ATTR```          | group name attribute        | cn
```WSO2_LDAP_GROUP_NAME_SEARCH_FILTER``` | group search by name filter | (&amp;(objectClass=groupOfNames)(cn=?))
```WSO2_LDAP_GROUP_LIST_FILTER```        | group list search filter    | (objectClass=groupOfNames)
```WSO2_LDAP_GROUP_MEMBERSHIP_ATTR```    | group membership attribute  | member

# Using docker compose

TBD...