#!/bin/bash

OMPUSER="admin"
OMPPASS="admin"
TARGET_NAME="PAKURI_Target"

function create_target()
{
    TARGET_ID=`omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|cut -d " " -f1`
    if [ -z $TARGET_ID ];then
        echo "Create Targets"
        omp -X "<create_target><name>$TARGET_NAME</name><hosts>192.168.171.10,192.168.171.250</hosts></create_target>" -u $OMPUSER -w $OMPPASS
    else
        echo "Already Created"
        echo $TARGET_ID
    fi
}

create_target
echo ""
omp -T -u $OMPUSER -w $OMPPASS

function modify_target()
{
    TARGET_ID=`omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|cut -d " " -f1`
    if [ ! -z $TARGET_ID ];then
        echo "Modify Targets"
        omp -X "<modify_target target_id='$TARGET_ID'><hosts>8.8.8.8</hosts><EXCLUDE_HOSTS></EXCLUDE_HOSTS></modify_target>" -u $OMPUSER -w $OMPPASS
    else
        echo "Target is none"
    fi
}

function delete_target()
{
    TARGET_ID=`omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|cut -d " " -f1`
    if [ ! -z $TARGET_ID ];then
        echo "Delete Targets"
        omp -X "<delete_target target_id='$TARGET_ID'/>" -u $OMPUSER -w $OMPPASS
    else
        echo "Already Deleted"
        echo $TARGET_ID
    fi
}
delete_target
omp -T -u $OMPUSER -w $OMPPASS
