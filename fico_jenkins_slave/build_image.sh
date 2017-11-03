#!/usr/bin/env bash
## Image build script##
checkdocker(){
 echo "##### Checking Docker Installed on System!!##"
 if [ $(dpkg-query -W -f='${Status}' docker 2>/dev/null | grep -c "ok installed") -eq 1 ];
 then
   echo "###############################"
   echo "Package Docker is Instaled"
   echo "###############################"
 else
   echo "###############################"
   echo "WARNING: Docker is Not Installed!!"
   echo "###############################"
   exit 1;
 fi
}

checkimage(){
 echo "### Checking for already exisisting Docker Images ###"
 read -r -p "Provide the name of the  image: (example:docker.jenkins.master:1.0):" alphaname
 imagename=`docker images |grep  $alphaname |awk {'print $1}'|uniq `;
 echo $imagename
 if [ $imagename = $alphaname ];
 then
     echo "####################################################"
     echo "The Docker Image Exists with Dockerimagename: $imagename"
     echo "#####################################################"
        tag_deploy=`docker images |grep $alphaname |awk {'print $2}'`;
     echo "####################################"
     echo "The Docker Image Tag is $tag_deploy"
     echo "####################################"
     export status='2'
 else
     echo "################################"
     echo "The Docker Image Does Not Exist"
     echo "################################"
     export status='1'
 fi
}
buildimage(){
 if [ $status = '2' ];
  then
   read  -r -p  "Do you wish to rebuild the docker image?:[Y/N]" response
   case $response in
              [Yy]* ) read -r -p "Provide tag for this image: (example:1.0/1.1):" tagname
                      echo "################################"
                      echo "Building the Docker Image Now"
                      echo "################################"
                      docker build -t docker.jenkins.slave:$tagname .
                      break ;;
              [Nn]* ) exit ;;
                  * )  echo "Answer yes or no" ;;
   esac
 else

  echo "################################"
  echo "Building the Docker Image Now"
  echo "################################"
  docker build -t docker.jenkins.slave:1.0 .

 fi

}

checkdocker
checkimage
buildimage

exit $?

