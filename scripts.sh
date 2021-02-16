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
    docker run -tid --cap-add NET_ADMIN --cap-add SYS_ADMIN --publish-all=true -v /srv/data:/srv/html -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name $USER-debian-$i -h $USER-debian-$i  armelab/debian-systemd:V1                       
    docker exec -ti $USER-debian-$i /bin/sh -c "useradd -m -p sa3tHJ3/KuYvI $USER"
	docker exec -ti $USER-debian-$i /bin/sh -c "mkdir  ${HOME}/.ssh && chmod 700 ${HOME}/.ssh && chown $USER:$USER $HOME/.ssh"
    docker cp $HOME/.ssh/id_rsa.pub $USER-debian-$i:$HOME/.ssh/authorized_keys
    docker exec -ti $USER-debian-$i /bin/sh -c "chmod 600 ${HOME}/.ssh/authorized_keys && chown $USER:$USER $HOME/.ssh/authorized_keys"
	docker exec -ti $USER-debian-$i /bin/sh -c "echo '$USER   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
	docker exec -ti $USER-debian-$i /bin/sh -c "service ssh start"
	echo "Conteneur $USER-debian-$i créé"
  
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

# container informations 

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
