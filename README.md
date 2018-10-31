# Hello

## requirement

* have ./saml.war
* have libs/PsDirectoryLib.jar
* have libs/gson.jar

## build docker image

```
docker build -t ebx-saml:5.8.1-tomcat9.0.11-jre10 .
```

## start app

```
docker run --rm -p 8843:8843 --mount type=volume,src=ebx1,dst=/data/app/ebx -e "CATALINA_OPTS=-DebxLicense=$EBXLICENSE" --name tomcat_ebx_saml ebx-saml:5.8.1-tomcat9.0.11-jre10

open https://localhost:8843/saml
```

## start container and use command-line

```
docker run --rm --name tomcat_ebx_saml -it tomcat-ebx-saml bash
```

## connect to running container

```
docker exec -it tomcat_ebx_saml /bin/bash
```

## EBX SAML integration

append the following to your ebx.properties

```
#############
############# SSO section
#############
########
######## SSO allows you to remove the login screen
######## all you need to do is instruct EBX how to access the current user id value
########

customdirectory.sso=saml

#############
############# SSO-SAML section
#############
########
######## SSO-SAML configuration
########
########

customdirectory.saml.key.userid=UserID
customdirectory.saml.key.user.firstname=FirstName
customdirectory.saml.key.user.lastname=LastName
customdirectory.saml.key.user.email=EmailAddress
```
