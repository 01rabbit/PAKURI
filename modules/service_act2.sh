#!/bin/bash
source pakuri.conf

function get_service_port()
{
    egrep -v "^#|Status: Up" $WDIR/nmap_*.grep | cut -d' ' -f2,4- | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%s,%s,%s,%s,%s,%s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -w open |grep -i "$1"
}

for i in `get_service_port`
do
    IP=`echo ${i} | cut -d , -f 1`
    PORT=`echo ${i} | cut -d , -f 3`
    SERV=`echo ${i} | cut -d , -f 5`

    echo "$IP:$PORT $SERV"
    case $SERV in
        ssh)
            nmap -sV -Pn -v -p ${PORT} --script='banner,ssh2-enum-algos,ssh-hostkey,ssh-auth-methods' -oN $WDIR/ssh_${IP}:${PORT}.nmap -oX $WDIR/ssh_${IP}:${PORT}.xml ${IP}
            if [ -f $WDIR/ssh_${IP}:${PORT}.xml ];then
                cp -p $WDIR/ssh_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE/
            fi
            ;;
        http)
            nikto -h http://${IP}:${PORT} -output $WDIR/nikto_${IP}:${PORT}.xml -Format XML|tee $WDIR/nikto_${IP}:${PORT}.txt
            if [ -f $WDIR/nikto_${IP}:${PORT}.xml ];then
                cp -p $WDIR/nikto_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE/
            fi
            ;;
        
    esac
done