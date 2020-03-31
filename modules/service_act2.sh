#!/bin/bash
source pakuri.conf

function get_service_port()
{
    egrep -v "^#|Status: Up" $WDIR/nmap_*.grep | cut -d' ' -f2,4- | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%s,%s,%s,%s,%s,%s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -w open |grep -i "$1"
}

function nmap_enum()
{
    IP=$1
    PORT=$2
    SERV=$3

    nmap -sV -Pn -v --script="*${SERV}-vuln* and not brute or broadcast or dos or external or fuzzer" -p${PORT} -oN $WDIR/${SERV}_${IP}:${PORT}.nmap -oX $WDIR/${SERV}_${IP}:${PORT}.xml ${IP}
    cp -p $WDIR/${SERV}_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE
}

for i in `get_service_port`
do
    IP=`echo ${i} | cut -d , -f 1`
    PORT=`echo ${i} | cut -d , -f 3`
    SERV=`echo ${i} | cut -d , -f 5`

    echo "$IP:$PORT $SERV"
    case $SERV in
        ssh)
            echo "SSH"
            nmap -sV -Pn -v -p ${PORT} --script='banner,ssh2-enum-algos,ssh-hostkey,ssh-auth-methods' -oN $WDIR/ssh_${IP}:${PORT}.nmap -oX $WDIR/ssh_${IP}:${PORT}.xml ${IP}
            if [ -f $WDIR/ssh_${IP}:${PORT}.xml ];then
                cp -p $WDIR/ssh_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE/
            fi
            ;;
        http)
            echo "http"
            nikto -h http://${IP}:${PORT} -output $WDIR/nikto_${IP}:${PORT}.xml -Format XML|tee $WDIR/nikto_${IP}:${PORT}.txt
            if [ -f $WDIR/nikto_${IP}:${PORT}.xml ];then
                cp -p $WDIR/nikto_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE/
            fi
            # skipfish -o $WDIR/skipfish_${IP}:${PORT} http://${ip}:${PORT}
            ;;
        "ssl|http")
            echo "ssl/http"
            nikto -h https://${IP}:${PORT} -output $WDIR/nikto_${IP}:${PORT}.xml -Format XML|tee $WDIR/nikto_${IP}:${PORT}.txt
            if [ -f $WDIR/nikto_${IP}:${PORT}.xml ];then
                cp -p $WDIR/nikto_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE/
            fi
            sslyze --regular ${IP} --xml_out=$WDIR/sslyze_${IP}.xml | tee -a $WDIR/sslyze_${IP}.txt
            sslscan ${IP}|tee -a $WDIR/sslscan_${IP}.txt 
            cp -p $WDIR/sslyze_${IP}.xml ~/.faraday/report/$WORKSPACE
            # skipfish -o $WDIR/skipfish_${IP}:${PORT} https://${ip}:${PORT}
            ;;
        netbios-ssn|microsoft-ds)
            echo "smb"
            nmap -sV -Pn -v --script='*smb-vuln* and not brute or broadcast or dos or external or fuzzer' -p${PORT} -oN $WDIR/smb_${IP}:${PORT}.nmap -oX $WDIR/smb_${IP}:${PORT}.xml ${IP} 
            if [ ${PORT} = "139" ] || [ ${PORT} -eq "389" ] || [ ${PORT} -eq "445" ];then
                enum4linux -a -M -1 -d ${IP} | tee $WDIR/enum4linux_${IP}:${PORT}.txt
                echo "$SERV enum4linux"
            fi
            ;;
        ftp|pop3|smtp|oracle|mysql|ms-sql)
            echo "$SERV"
            nmap_enum $IP $PORT $SERV
            ;;
        *)
            ;;
    esac
done
#skipfish -U -Q -u -t 12 -o OUTPUT http://192.168.171.250