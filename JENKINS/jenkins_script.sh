#!/bin/bash

if [[ ! `whoami` = "root" ]]; then
echo "You must have administrative privileges to run this script"
echo "Login as root and run this script"
exit 1
fi

#Created a function to install java if Java is not installed in the machine.

function INSTALL_JAVA () {

default_location=/apps/software/
download_path=http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-8u92-linux-x64.tar.gz
installation_file=jdk-8u92-linux-x64.tar.gz
java_folder=jdk1.8.0_92

# Before running the script, check the number of java versions installed. Select the below variable as no:of java version + 1.

select_version=3

java -version

mkdir -p $default_location
cd $default_location

#Download JDK 8.92 version from the  installation path. You can chnage the download path by replacing it with the new link in the download_path parameter.

wget $download_path

#To download the latest version of file from official site, comment the above line and uncomment the below line. Before executing the script, you need to change the download path, installation file name and java folder name respectively.

#wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$download_path"

#untar the installation file.

tar -zxvf $installation_file

cd $java_folder

update-alternatives --install /usr/bin/java java $default_location$java_folder/bin/java 100

#Taking backup of /etc/profile before making changes to it.

cp /etc/profile /etc/profile_backup

#Update java path in /etc/profile

echo "export JAVA_HOME=$default_location$java_folder"| xargs -0 -I test sed -i '/unset i/ i test' /etc/profile
echo "export PATH=$PATH:$default_location$java_folder/bin"| xargs -0 -I test sed -i '/unset i/ i test' /etc/profile

#reload /etc/profile

source /etc/profile

#select the java version jdk1.8.0_92

java

update-alternatives --config java <<test
$select_version
test

java -version

export JAVA_HOME=$default_location$java_folder
export PATH=$PATH:$default_location$java_folder/bin


echo $JAVA_HOME


echo "Successfully installed JAVA"

}


java -version

if [[ ! $? = "0" ]] ; then
  INSTALL_JAVA
else
 echo "JAVA already installed"
fi


INSTALLATION_PATH=http://mirrors.jenkins-ci.org/war/latest/jenkins.war
JENKINS_FOLDER=/apps/jenkins/

mkdir -p $JENKINS_FOLDER

mv $JENKINS_FOLDERjenkins.war $JENKINS_FOLDERjenkins.war_old

cd $JENKINS_FOLDER

wget $INSTALLATION_PATH

#Setting Jenkins as a service

SERVICE_PATH=/etc/systemd/system/jenkins.service

echo [Unit] >> $SERVICE_PATH
echo Description=Jenkins Service >> $SERVICE_PATH
echo After=network.target >> $SERVICE_PATH
echo [Service] >> $SERVICE_PATH
echo Type=simple >> $SERVICE_PATH
echo User=root >> $SERVICE_PATH
echo ExecStart=/usr/bin/java -jar /apps/jenkins/jenkins.war >> $SERVICE_PATH
echo Restart=on-abort >> $SERVICE_PATH
echo [Install] >> $SERVICE_PATH
echo WantedBy=multi-user.target >> $SERVICE_PATH


#Install Jenkins in the requested port.

printf "Enter the port number to which Jenkins need to be configured : "
read port 

echo "Please open jenkins in web browser and complete initial login with the key admin key displayed below"

java -jar jenkins.war --httpPort=$port

sleep 3

#To enable and start jenkins service

systemctl daemon-reload
systemctl start jenkins.service
systemctl enable jenkins.service

#To auto start jenkins on every restart

chkconfig jenkins on

INITIALADMINPASSWORD=$(cat /root/.jenkins/secrets/initialAdminPassword)

echo " Initial Admin Password :  $INITIALADMINPASSWORD"

sleep 5
