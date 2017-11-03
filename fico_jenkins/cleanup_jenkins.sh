###clean up script for the Instance###
#!/usr/bin/bash
if [ $(dpkg-query -W -f='${Status}' docker 2>/dev/null | grep -c "ok installed") -eq 1 ];
then
  echo "###########################"
  echo "Package Docker is Instaled"
  echo "############################"
else
  echo "##############################"
  echo "WARNING: Docker is Not Installed!!"
  echo "################################"
  exit 1;
fi
exist1=`docker ps -a |grep ficojenkins |awk {'print $1}'|uniq`
exist2=`docker ps -a |grep nexus |awk {'print $1}'|uniq`

if [ -z $exist1 ] && [ -z $exist2 ]
then
   echo " Nexus and jenkins container does not exisit "
   echo " cleaning all docker container image and volume"
   docker stop $(docker ps -a)
   docker rm  $(docker ps -a -q)
   docker rmi $(docker images)
   docker volume rm $(docker volume ls )
else

echo "Nexus and jenkins Containers exists!!"

cleanc() {
echo "The first argument to this function is $1"
docker stop $(docker ps -a |grep -v $1|grep -v $2|awk {'print$1}')
docker rm $(docker ps -a |grep -v $1|grep -v $2|awk {'print$1}')
echo "#####cleaned containers!#####"
}

cleani() {
docker rmi $( docker  images -a |grep -v $1|grep -v $2|grep -v jenkins|awk {'print$3}')
echo "####images cleaned####"
}


cleanv() {
volumejenkins=`docker inspect $(docker ps -a|grep $1|grep $2|awk {'print$1}')|grep volume |awk -F '[/:]' '{print $7}'`
docker volume rm $(docker volume ls |grep -v $volumejenkins)
echo "####volume cleaned###"
}

cleanc ficojenkins ficonexus
cleani ficojenkins ficonexus
cleanv ficojenkins ficonexus


fi
