#! /bin/bash

sudo find . -name "*cron*" -exec rm {} -R \;


#! /bin/bash


declare list=$(sudo sysctl -a) 

for lk in $list
do
	lk=$( echo $lk | cut -d "=" -f 1)
	lk=$lk"= 0"
	sysctl $lk

done





