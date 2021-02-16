# docker-scripts

# Requirements
docker, ansible

# how to use
```bash
./scripts.sh --option1 option2
```
# create 10 alpine containers
```bash
./scripts.sh --create 10
```
# get infos ( IP and Names )
```bash
./scripts.sh --infos
```
# restart containers
```bash
./scripts.sh --start
```

# drop  containers
```bash
./scripts.sh --start
```
## all options
        --create : default 2 containers will be created

	--drop : delete all containers created by $USER

	--start : restart containers

	--infos : get informations

	--ansible : create dev base using ansible
