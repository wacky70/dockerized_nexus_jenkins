#!/usr/bin/bash
##This will backup your jenkins_home  for the contianer##
##Although thin backup is avaiable , this is additional layer##

echo ##### Checking Docker Installed on System!!##
if [ $(dpkg-query -W -f='${Status}' docker 2>/dev/null | grep -c "ok installed") -eq 1 ];
then
  echo "############################"
  echo "Package Docker is Installed"
  echo "############################"
else
  echo "###############################"
  echo "WARNING:Docker is Not Installed"
  echo "###############################"
  exit 1
fi
echo "###################################"
echo "#### Creating Baclup zip now !!####"
echo "###################################"

containerid=`docker ps -a |grep ficojenkins |awk {'print $1}'`
if [ ! -z $containerid ]
then
  echo "############################"
  echo "Containerid exists"
  echo "############################"
  docker cp $containerid:/var/jenkins_home /opt/backup/jenkins/jenkins_home
  cd /opt/backup/jenkins && zip -r "jenkins_home-$(date +"%Y-%m-%d_%H%M%S").zip" jenkins_home
  rm -rf  jenkins_home
  aws s3 sync /opt/backup/jenkins  s3://backupinfra/backup/jenkins --no-verify-ssl --profile default --region eu-central-1 --output text --include "*.zip" --exclude ".*"

else
  echo "############################"
  echo "Container Id doesnot exists"
  echo "############################"
  exit 1
fi
exit $?
