#see https://github.com/docker-library/tomcat/blob/master/9.0/jre10-slim/Dockerfile

FROM tomcat:9.0.11-jre10

# COMMANDS
# docker build -t ebx-saml:5.8.1-tomcat9.0.11-jre10 .
# docker run --rm -p 9090:8080 --mount type=volume,src=ebx1,dst=/data/app/ebx -e "CATALINA_OPTS=-DebxLicense=$EBXLICENSE" --name ebx1 ebx-saml:5.8.1-tomcat9.0.11-jre10

ENV EBX_HOME /data/app/ebx
RUN mkdir -p ${EBX_HOME}

ENV CATALINA_HOME /usr/local/tomcat
WORKDIR $CATALINA_HOME

RUN keytool -genkey -noprompt \
 -alias tomcat \
 -keyalg RSA \
 -dname "CN=helloworld, OU=ID, O=ON, L=OAuthSample, S=WithTomcat, C=US" \
 -keystore /usr/local/tomcat/.keystore \
 -storepass "ebx tomcat password" \
 -keypass "ebx tomcat password"

COPY tomcat_conf/context.xml ${CATALINA_HOME}/conf/
COPY tomcat_conf/logging.properties ${CATALINA_HOME}/conf/
COPY tomcat_conf/server.xml $CATALINA_HOME/conf/
COPY tomcat_conf/catalina.properties $CATALINA_HOME/conf/
COPY tomcat_conf/context/*.xml ${CATALINA_HOME}/conf/Catalina/localhost/

COPY --from=mickaelgermemont/ebx:5.8.1.1067-0027 /data/ebx/libs/*.jar $CATALINA_HOME/lib/
COPY --from=mickaelgermemont/ebx:5.8.1.1067-0027 /data/ebx/ebx.software/lib/ebx.jar $CATALINA_HOME/lib/
COPY --from=mickaelgermemont/ebx:5.8.1.1067-0027 /data/ebx/ebx.software/lib/lib-h2/h2-1.3.170.jar $CATALINA_HOME/lib/
COPY --from=mickaelgermemont/ebx:5.8.1.1067-0027 /data/ebx/ebx.software/webapps/wars-packaging/*.war $CATALINA_HOME/webapps/


###
### PROJECT

COPY ebx.properties /data/app/ebx.properties
ENV EBX_OPTS "-Debx.home=${EBX_HOME} -Debx.properties=/data/app/ebx.properties"

COPY saml.war $CATALINA_HOME/webapps/
COPY samlconf.properties $CATALINA_HOME/saml/

COPY UnlimitedJCEPolicyJDK8/*.jar /docker-java-home/lib/security/

COPY libs/*.jar $CATALINA_HOME/lib/

###
### startup parameters

ENV JAVA_OPTS "${EBX_OPTS} -Dsaml.home=$CATALINA_HOME/saml ${JAVA_OPTS}"
ENV CATALINA_OPTS ""

###
### SECURITY

RUN groupadd -g 1000 user \
   && useradd -u 1000 -g 1000 -m -s /bin/bash user \
   && chown -R 1000 /data /usr/local/tomcat
USER user

VOLUME ["/data/app/ebx"]

EXPOSE 8843
CMD ["catalina.sh", "run"]
