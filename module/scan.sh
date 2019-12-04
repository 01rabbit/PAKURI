#!/bin/bash

# $1 IP Address or IP list
# $2 1 or 2  1:nmap 2:AutoRecon.py
# $3 Arguments
# $4 S or M S:Sngle Host M:Multi Host

source source.conf
cd $WDIR
DATE=`date '+%Y%m%d%H%M%S'`

# nmap (portscan only)
if [ $2 = 1 ];then
    if [[ ! -d nmap ]]; then
	mkdir nmap
    fi

    cd nmap
    case $3 in
        Check )
            if [ $4 = "S" ];then
                nmap -sn -PE $1 -oN $DATE\_hostup_$1.nmap -oX $DATE\_hostup_$1.xml |grep report|grep -v kali|cut -d " " -f 5
            else
                if [ $4 = "M" ];then
                    echo $1
                    echo $MYIP
                    pwd
                    nmap -sn -PE -iL $1 --exclude $MYIP -oN $DATE\_hostup_multi_targets.nmap -oX $DATE\_hostup_multi_targets.xml |grep report|grep -v kali|cut -d " " -f 5
                fi
            fi ;;
        Quick )
            if [ $4 = "S" ];then
                nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN $DATE\_quick_$1.nmap -oX $DATE\_quick_$1.xml $1 
            else 
                if [ $4 = "M" ];then
                    nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN $DATE\_quick_targets.nmap -oX $DATE\_quick_targets.xml -iL $1
                fi
            fi ;;
        Full )
            if [ $4 = "S" ];then
                nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN $DATE\_full_$1.nmap -oX $DATE\_full_$1.xml $1 
            else 
                if [ $4 = "M" ];then
                    nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN $DATE\_full_targets.nmap -oX $DATE\_full_targets.xml -iL $1 
                fi
            fi ;;
    esac
    # AutoRecon.py (Port Service Scan)
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