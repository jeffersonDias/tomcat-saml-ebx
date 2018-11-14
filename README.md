# Hello

## requirement

* have ./saml.war, see https://github.com/mickaelgermemont/ebx-javaweb-saml
* have libs/PsDirectoryLib.jar, see https://s3.amazonaws.com/on-ps-custom-directory/PsDirectoryLib/PsDirectoryLib-2.18.8-SNAPSHOT.jar
* have libs/gson-2.8.5.jar
* have UnlimitedJCEPolicyJDK8 folder, see https://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html

## build docker image

```
docker build --build-arg EBXVERSION=5.8.1.1067-0029 --build-arg EBXADDONSVERSION=5.8.1.1067-0029_addons_3.20.6.0036-0022 -t ebx-saml:5.8.1-tomcat9.0.11-jre10 .
```

## start app

```
docker run --rm -p 8843:8843 -p 8080:8080 --mount type=volume,src=ebx11,dst=/data/app/ebx -e "CATALINA_OPTS=-DebxLicense=$EBXLICENSE" --name tomcat_ebx_saml ebx-saml:5.8.1-tomcat9.0.11-jre10

open https://localhost:8843/saml
open http://localhost:8080/saml
```

## SAML Configuration

see file samlconf.properties

see https://s3.amazonaws.com/on-ps-custom-directory/saml/template/EBX+SSO+with+SAML.pdf

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
