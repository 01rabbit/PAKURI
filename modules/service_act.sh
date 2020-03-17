#!/bin/bash
source pakuri.conf

NMAP_FILE=$2
SERV_NAME=$3

function show_open_port_count()
{
    egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
    sed -n -e 's/Ignored.*//p' | \
    awk -F, '{split($0,a," "); printf "Host: %-20s Ports Open: %d\n" , a[1], NF}' \
    | sort -k 5 -g
}
function show_service_port()
{
    echo -e "IP               State    Port/Prot  Service         Info"
    egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
    sed -n -e 's/Ignored.*//p'  | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%-15s  %-5s %7s/%3s   %-15s %s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -i "$1"
}
function get_service_port()
{
    egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
    sed -n -e 's/Ignored.*//p'  | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%s,%s,%s,%s,%s,%s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -w open |grep -i "$1"
}

function http_scan()
{
    count=1
    # http scan
    for i in `get_service_port "http"`
    do
        column1=`echo ${i} | cut -d , -f 1`
        column2=`echo ${i} | cut -d , -f 3`
        if [[ ! -z $(echo "${i}" |grep -w "https") ]];then
            window_name="https_nikto_scan$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "nikto -host https://${column1}:${column2} |tee $WDIR/nikto_${column1}:${column2}.txt; tmux kill-window -t $window_name" C-m

            window_name="sslscan$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "sslscan ${column1}|tee $WDIR/sslscan_${column1}.txt; tmux kill-window -t $window_name" C-m
        else
            window_name="nikto_scan$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "nikto -host http://${column1}:${column2} |tee $WDIR/nikto_${column1}:${column2}.txt; tmux kill-window -t $window_name" C-m
        fi
        count=$((++count))
    done
}

case $1 in
    show_port_count)
    show_open_port_count
    ;;
    show_serv_port)
    show_service_port $SERV_NAME
    ;;
    http_scan)
    http_scan
    ;;
esac
