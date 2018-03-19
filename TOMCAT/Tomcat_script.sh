#!/bin/bash


source file.config

JAVA_HOME=$(readlink -f $(dirname $(readlink -f $(which java) ))/../)


###download, untar of apache tomacat file

download_untar_tomcat ()
{
        
        rm $apache  ###remove if download already exist
	
        wget $apache_link 
        if [ $? -eq 0 ]
           then
           echo "Download of apache tar file successful"
           else
           echo "Failure... download failed" >&2
        fi
          
	tar -zxf $apache.tar.gz -C $untar_path
	echo "untar done"
}

### tomcat instance creation, copy folders , config change in server.xml

create_tomcat_instance ()
{
   mkdir $tomcats_home   

   for (( count=1; count<=$instance; count++ ))
   do  
   
     	echo "starting instance creation,copy folders,config changes for tomcat_$count" 
   
        
     	mkdir $tomcats_home/tomcat"$count"
      
     	cd $untar_path/$apache/ 
     	cp -R {bin,lib,conf,logs,temp,webapps,work} $tomcats_home/tomcat"$count"/

###config file change in server.xml

     	sed -i 's/<Connector port=\"8009\" protocol=\"AJP/<Connector port=\"8'"${count}"'09\" protocol=\"AJP/g' $tomcats_home/tomcat"$count"/conf/server.xml
     	sed -i 's/<Connector port=\"8080\" protocol=\"HTTP/<Connector port=\"808'"${count}"'\" protocol=\"HTTP/g' $tomcats_home/tomcat"$count"/conf/server.xml
     	sed -i 's/<Server port=\"8005\"/<Server port=\"8'"${count}"'05\"/g' $tomcats_home/tomcat"$count"/conf/server.xml
     
     	echo "Completed instance creation,copy folders,config changes for tomcat$count"
     
   done
}


### init script to start/stop/restart tomcat instances 

create_init_instance ()
{
   for (( count=1; count<=$instance; count++ ))
   do  
   

	cp $init_script_source/init_script $init_script_destination/tomcat$count
	echo "init script for tomcat$count created... pending config updates" 
     	

	###config file change in init_script which is known as tomact1,tomat2 etc 

	sed -i 's|JAVA_HOME=|JAVA_HOME='"${JAVA_HOME}"'|g' $init_script_destination/tomcat$count
	sed -i 's|CATALINA_HOME=|CATALINA_HOME='"${tomcats_home}"'/tomcat'"${count}"'/bin|g' $init_script_destination/tomcat$count
	###sed -i 's|tomcatx|tomcat'"${count}"'|g' $init_script_destination/tomcat$count

	echo "Config update to tomcat$count init script completed"
     
   done
}

###remove unwanted files

remove_files ()
{
   for (( count=1; count<=$instance; count++ ))
   do  
   
                echo "removing unwanted files from $tomcats_home/tomcat$count"
                   
		for line in `cat $remove_files_path`
		do
 
                    rm -rf $tomcats_home/tomcat$count/$line
		    
		done
     
   done
}


###setenv script copy and config update for each instance 

create_setenv ()
{
  
   for (( count=1; count<=$instance; count++ ))
   do  
   
     	cp $setenv_script $tomcats_home/tomcat"$count"/bin/
        echo "copied setenv script to $tomcats_home/tomcat"$count"/bin/ location"

        sed -i 's|JAVA_HOME=.*|JAVA_HOME="'"${JAVA_HOME}"'"|g' $tomcats_home/tomcat"$count"/bin/setenv.sh
	sed -i 's|Dgw[.]bc[.]env=.*|Dgw.bc.env='${Dgw_bc_env}'"|g' $tomcats_home/tomcat"$count"/bin/setenv.sh
        sed -i 's|Dgw[.]server[.]mode=.*|Dgw.server.mode='${Dgw_server_mode}'"|g' $tomcats_home/tomcat"$count"/bin/setenv.sh
        
        echo "Updated configs in tomcat"$count" setenv script"
   done
}

tomcat_user ()
{
    useradd -d /home/tomcat tomcat   ###create user tomcat with home and /home/tomcat
    echo "tomcat user created"
    
   for (( count=1; count<=$instance; count++ ))
   do
     echo "Setting permissions for tomcat user to tomcat$count instance"   
     chown -R tomcat.tomcat $tomcats_home/tomcat$count
     chmod g-w,o-rwx $tomcats_home/tomcat$count
     chmod g-w,o-rwx $tomcats_home/tomcat$count/conf
     chmod o-rwx $tomcats_home/tomcat$count/logs
     chmod o-rwx $tomcats_home/tomcat$count/temp
     chmod g-w,o-rwx $tomcats_home/tomcat$count/bin
     chmod g-w,o-rwx $tomcats_home/tomcat$count/webapps
     chmod 770 $tomcats_home/tomcat$count/conf/catalina.policy
     chmod g-w,o-rwx $tomcats_home/tomcat$count/conf/catalina.properties
     chmod g-w,o-rwx $tomcats_home/tomcat$count/conf/context.xml
     chmod g-w,o-rwx $tomcats_home/tomcat$count/conf/logging.properties
     chmod g-w,o-rwx $tomcats_home/tomcat$count/conf/server.xml
     chmod g-w,o-rwx $tomcats_home/tomcat$count/conf/tomcat-users.xml
     chmod g-w,o-rwx $tomcats_home/tomcat$count/conf/web.xml

   done

####delete user and home dir userdel --remove tomcat

}

download_untar_tomcat
create_tomcat_instance
create_init_instance
remove_files
create_setenv
tomcat_user