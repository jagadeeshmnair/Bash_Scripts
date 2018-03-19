#!/bin/bash

if [[ ! `whoami` = "root" ]]; then
echo "You must have administrative privileges to run this script"
echo "Login as root and run this script"
exit 1
fi

#Set default variables

INSTALL_PATH=newrelic/newrelic.jar
NEWRELIC_YML=newrelic/newrelic.yml
NEWRELIC_BACKUP=newrelic/newrelic.yml_backup
DOWNLOAD_PATH=https://download.newrelic.com/newrelic/java-agent/newrelic-agent/3.28.0/newrelic-java-3.28.0.zip

#To make sure that unzip is installed in the machine

yum -y install unzip

#Select the Tomcat instance to which Newrelix has to be deployed

printf "Enter the Tomcat instance: "
read INST

#Set variable as per user input
DEFAULT_PATH=/apps/tomcat$INST

echo "You have selected the instance tomcat$INST"
sleep 1

#Download Newrelic to respective location.

wget -O $DEFAULT_PATH/newrelic-java-3.28.0.zip $DOWNLOAD_PATH

#Unzip the newrelic zip file to the desired location

unzip $DEFAULT_PATH/newrelic-java-3.28.0.zip -d $DEFAULT_PATH/
sleep 1

#Installing  newrelic

java -jar $DEFAULT_PATH/$INSTALL_PATH install

#Taking backup of the newrelic.yml file
cp $DEFAULT_PATH/$NEWRELIC_YML  $DEFAULT_PATH/$NEWRELIC_BACKUP

#Requesting user input to replace the application name in newrelix.yml file.

printf "Enter the app_name to corresponding Center’s name( For eg: For Policy Center instance name it is as PolicyCenter_Test): "
read name

APP_NAME="app_name: '$name'"
sleep 1

#Replacing the application name in newrelic.yml file
sed -i 's/app_name: My Application/#app_name: My Application/g' $DEFAULT_PATH/$NEWRELIC_YML
echo "$APP_NAME"| xargs -0 -I test sed -i '/# To enable high security, set this property to true. When in high/ i test' $DEFAULT_PATH/$NEWRELIC_YML

#Requesting user input to replace the license key in newreli.yml file.
printf "Enter the license key: " 
read LIC
sleep 1
LICENSE_KEY="license_key: '$LIC'"

#Replacing the License key with user input.

sed -i '0,/license_key:/! {0,/license_key:/ s/license_key:/#license_key:/g}' $DEFAULT_PATH/$NEWRELIC_YML
echo "$LICENSE_KEY"| xargs -0 -I test1 sed -i '/# Agent Enabled/ i test1' $DEFAULT_PATH/$NEWRELIC_YML


echo ****Successfully installed Newrelic****
sleep 2
