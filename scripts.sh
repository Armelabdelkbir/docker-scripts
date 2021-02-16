#!/bin/bash

######################################################
# Description: this scripts deploy docker containers
#################################

#check first option

if [ "$1" == "--create" ];then
  
  
#number of container
  nb_machine=1
  [ "$2" != "" ] && nb_machine=$2

#get max container id  

idmax=$(docker ps -a --format '{{.Names}}' | awk -F "-" -v user=$USER '$0 ~ user"-alpine" {print $3}' | sort -r | head -1 )

min=$(($idmax + 1 ))
max=$(($idmax + $nb_machine ))
#create containers
    
  for i in $(seq $min $max );do
    docker run -tid --name $USER-alpine-$i alpine:3.7
    echo "j'ai créer $USER-alpine-$i"
  done

#check drop option

elif [ "$1" == "--drop" ];then 
docker rm -f $(docker ps -a | grep $USER-alpine | awk '{ print $1}')

  #for i in $(seq 1 $nb_machine);do
  #docker rm -f $USER-alpine-$i
#check start option
#done

elif [ "$1" == "--start" ];then 

  echo "**"
  echo "our option start"
  echo "**"
docker start $(docker ps -a | grep $USER-alpine | awk '{print $1}' )
#check ansible option

elif [ "$1" == "--ansible" ];then 

  echo "**"
  echo "our option ansible"
  echo "**"
#check info option

elif [ "$1" == "--infos" ];then 

echo "**"
  echo "our option infos"
echo "**"

for c in $(docker ps -a | grep $USER-alpine | awk '{print $1}' );do
docker inspect -f '    {{.Name}} - {{.NetworkSettings.IPAddress}}' $c
done
# if no option passed echo

else

echo "

Options :

	--create : default 2 containers will be created

	--drop : delete all containers created by $USER

	--start : restart containers

	--infos : get informations

	--ansible : create dev base using ansible

"
fi
