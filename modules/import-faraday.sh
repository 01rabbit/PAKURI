#!/bin/bash
source source.conf
# $1 Working Directory
# $2 Faraday's Workspace name

if [[ ! -d $1/imported ]];then
	mkdir -p $1/imported
fi

for i in `find $1 -name $1/\*.xml -not -path "$1/imported/*"`
do
	faraday-client --cli --workspace $2 --report $i
	mv $i -t $1/imported/
done
