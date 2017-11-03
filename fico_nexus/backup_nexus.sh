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
echo "#### Creating Backup zip now !!####"
echo "###################################"

containerid=`docker ps -a |grep ficonexus |awk {'print $1}'`
if [ ! -z $containerid ]
then
  echo "############################"
  echo "Containerid exists"
  echo "############################"
  docker cp $containerid:/opt/sonatype-work /opt/backup/nexus/sonatype-work
  cd /opt/backup/nexus && zip -r "sonatype-work-$(date +"%Y-%m-%d_%H%M%S").zip"  sonatype-work
  docker cp  $containerid:/opt/sonatype-nexus /opt/backup/nexus/sonatype-nexus
  cd /opt/backup/nexus && zip -r "sonatype-nexus-$(date +"%Y-%m-%d_%H%M%S").zip" sonatype-nexus
  rm -rf  sonatype-nexus  sonatype-work
  aws s3 sync /opt/backup/nexus  s3://backupinfra/backup/nexus --no-verify-ssl --profile default --region eu-central-1 --output text --include "*.zip" --exclude ".*"
else
  echo "############################"
  echo "Container Id doesnot exists"
  echo "############################"
  exit 1
fi
exit $?