#!/bin/bash
source source.conf
# $1 Working Directory
# $2 Faraday's Workspace name

if [[ ! -d $WDIR/imported ]];then
	mkdir -p $WDIR/imported
fi

for i in `find $1 -name \*.xml -not -path "$WDIR/imported*"`
do
	faraday-client --cli --workspace $2 --report $i
	mv $i $WDIR/imported
done
