#!/bin/bash

# $1 IP Address or IP list
# $2 1 or 2  1:nmap 2:AutoRecon.py
# $3 Arguments
# $4 S or M S:Sngle Host M:Multi Host

source source.conf
cd $WDIR

# nmap (portscan only)
if [ $2 = 1 ];then
    if [[ ! -d nmap ]]; then
	mkdir nmap
    fi

    cd nmap
    case $3 in
        Quick )
            if [ $4 = "S" ];then
                nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN quick_$1.nmap -oX quick_$1.xml $1 
            else 
                if [ $4 = "M" ];then
                    cat $1 | while read line
                    do
                        nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN quick_$line.nmap -oX quick_$line.xml $line
                    done
                fi
            fi ;;
        Full )
            if [ $4 = "S" ];then
                nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN full_$1.nmap -oX full_$1.xml $1 
            else 
                if [ $4 = "M" ];then
                    cat $1 | while read line
                    do
                        nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN full_$line.nmap -oX full_$line.xml $line 
                    done
                fi
            fi ;;
    esac
    # AutoRecon.py (Port Service Scan)
    else
    case $3 in
        Quick )
            if [ $4 = "S" ];then
                $AUTORECON $1 --profile quicK
            else 
                if [ $4 = "M" ];then
                    cat $1 | while read line
                    do
                        $AUTORECON $line --profile quicK
                    done
                fi
            fi ;;
        Default )
            if [ $4 = "S" ];then
                $AUTORECON $1 
            else 
                if [ $4 = "M" ];then
                    cat $1 | while read line
                    do
                        $AUTORECON $line
                    done
                fi
            fi ;;
    esac
fi

