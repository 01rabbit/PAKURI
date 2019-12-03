#!/bin/bash

# $1 Working Directory
# $2 Faraday's Workspace name

for i in `find $1 -name \*.xml`
do
	faraday-client --cli --workspace $2 --report $i
done
