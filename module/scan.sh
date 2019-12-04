#!/bin/bash

# $1 IP Address or IP list
# $2 1 or 2  1:nmap 2:AutoRecon.py
# $3 Arguments
# $4 S or M S:Sngle Host M:Multi Host

source source.conf
cd $WDIR
DATE=`date '+%Y%m%d%H%M'`

# nmap
if [ $2 = 1 ];then
    if [[ ! -d nmap ]]; then
	mkdir nmap
    fi

    cd nmap
    case $3 in
        Check )
            CHECK="$DATE\_hostup"
            if [ $4 = "S" ];then
                nmap -sn -PE $1 -oN $CHECK\_$1.nmap -oX $CHECK\_$1.xml
            else
                if [ $4 = "M" ];then
                    nmap -sn -PE -iL $1 --exclude $MYIP -oN $CHECK\_multi.nmap -oX $CHECK\_multi.xml
                fi
            fi ;;
        Quick )
            QUICK="$DATE\_Quick"
            if [ $4 = "S" ];then
                nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN $QUICK\_$1.nmap -oX $QUICK\_$1.xml $1 
            else 
                if [ $4 = "M" ];then
                    nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN $QUICK\_multi.nmap -oX $QUICK\_multi.xml -iL $1
                fi
            fi ;;
        Full )
            FULL="$DATE\_Full"
            if [ $4 = "S" ];then
                nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN $FULL\_$1.nmap -oX $FULL\_$1.xml $1 
            else 
                if [ $4 = "M" ];then
                    nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN $FULL\_multi.nmap -oX $FULL\_multi.xml -iL $1 
                fi
            fi ;;
    esac
    # AutoRecon.py
    else
    case $3 in
        Default )
            if [ $4 = "S" ];then
                $AUTORECON $1 -v -o $WDIR --only-scans-dir
            else 
                if [ $4 = "M" ];then
                    cat $1 | while read line
                    do
                        $AUTORECON -t $1 -v -o $WDIR --only-scans-dir
                    done
                fi
            fi ;;
    esac
fi