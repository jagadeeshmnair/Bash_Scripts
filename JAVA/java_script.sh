#!/bin/bash


default_location=/apps/software/
download_path=http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
installation_file=jdk-8u131-linux-x64.tar.gz
java_folder=jdk1.8.0_131

java -version

mkdir -p $default_location
cd $default_location


#wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$download_path"

tar -zxvf $installation_file

cd $java_folder

update-alternatives --install /usr/bin/java java $default_location$java_folder/bin/java 100

cat /etc/profile > /etc/profile_backup

#Update java path in /etc/profile

echo "export JAVA_HOME=$default_location$java_folder"| xargs -0 -I test sed -i '/unset i/ i test' /etc/profile
echo "export PATH=$PATH:$default_location$java_folder/bin"| xargs -0 -I test sed -i '/unset i/ i test' /etc/profile

#reload /etc/profile
source /etc/profile

#select the java version jdk1.8.0_131

java

update-alternatives --config java <<test
3
test
source /etc/profile
java -version
echo $JAVA_HOME



