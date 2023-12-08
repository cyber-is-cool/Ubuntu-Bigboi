#! /bin/bash

apt list --installed

declare list=$(apt list --installed);
#clear

for package in $(echo $list | tr "/" "\n" )
do
   pack= echo "$package" | cut -d "/" -f 2
   echo $package
   apt remove $package -y

done


















