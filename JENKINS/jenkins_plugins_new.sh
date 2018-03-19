#!/bin/bash

DEFAULT_LOCATION=/apps/jenkins/
PASSWORD=$(cat /root/.jenkins/secrets/initialAdminPassword)

cd $DEFAULT_LOCATION

echo "The list of plugins to be installed using this script"

echo Active-Directory Ant bouncycastle-API Conditional-BuildStep build-name-setter CopyArtifact Credentials CVS deploy-websphere Display-URL-API Durable-Task EnvInject-API build-environment Extended-Choice-Parameter Extensible-Choice-Parameter external-monitor-job Git-client Git GIT-server Groovy Icon-Shim Javadoc jQuery JUnit Last-Changes LDAP Mailer MapDB-API matrix-groovy-execution-strategy Matrix-Project Publish-Over-SSH Resource-Disposer Run-Condition SCM-API Script-Security SSH-Credentials SSH SSH-Slaves Structs Subversion Token-Macro Windows-Slaves | xargs -n 1

wget http://localhost:8080/jnlpJars/jenkins-cli.jar


for plugin in Active-Directory Ant bouncycastle-API Conditional-BuildStep build-name-setter CopyArtifact Credentials CVS deploy-websphere Display-URL-API Durable-Task EnvInject-API build-environment Extended-Choice-Parameter Extensible-Choice-Parameter external-monitor-job Git-client Git GIT-server Groovy Icon-Shim Javadoc jQuery JUnit Last-Changes LDAP Mailer MapDB-API matrix-groovy-execution-strategy Matrix-Project Publish-Over-SSH Resource-Disposer Run-Condition SCM-API Script-Security SSH-Credentials SSH SSH-Slaves Structs Subversion Token-Macro Windows-Slaves

do
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin $plugin --username admin --password $PASSWORD -deploy
done

systemctl daemon-reload
systemctl start jenkins.service
systemctl enable jenkins.service

chkconfig jenkins on

echo "All requested plugins installed"
