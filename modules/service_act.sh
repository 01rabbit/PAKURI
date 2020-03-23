#!/bin/bash
source pakuri.conf
# $1 command
# $2 NMAP_FILE
# $3 Service name

NMAP_FILE=$2
SERV_NAME=$3

function show_open_port_count()
{
    egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
    # sed -n -e 's/Ignored.*//p' | \
    awk -F, '{split($0,a," "); printf "Host: %-20s Ports Open: %d\n" , a[1], NF}' \
    | sort -k 5 -g
}
function show_service_port()
{
    echo -e "IP               State    Port/Prot  Service         Info"
    egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
    # sed -n -e 's/Ignored.*//p'  | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%-15s  %-5s %7s/%3s   %-15s %s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -i "$1"
}
function get_service_port()
{
    egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
    # sed -n -e 's/Ignored.*//p'  | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%s,%s,%s,%s,%s,%s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -w open |grep -i "$1"
}

function ssh_scan()
{
    local count
    local column1
    local column2
    local window_name

    count=1
    for i in ` get_service_port "ssh"`
    do
        column1=`echo ${i} | cut -d , -f 1`
        column2=`echo ${i} | cut -d , -f 3`

        window_name="ssh_scan_$count"
        tmux new-window -n "$window_name"
        tmux send-keys -t "$window_name" "faraday-terminal" C-m
        tmux send-keys -t "$window_name" "nmap -sV -Pn -v -p ${column2} --script='banner,ssh2-enum-algos,ssh-hostkey,ssh-auth-methods' -oN $WDIR/ssh:${column1}:${column2}.nmap ${column1} ;tmux kill-window -t $window_name" C-m
        count=$((++count))
    done
    tmux select-window -t "${modules[1]}"
}

function http_scan()
{
    local count
    local column1
    local column2
    local window_name

    count=1
    # http scan
    for i in `get_service_port "http"`
    do
        column1=`echo ${i} | cut -d , -f 1`
        column2=`echo ${i} | cut -d , -f 3`

        if [[ ! -z $(echo "${i}" |grep -w "https") ]];then
        ## https
            # nikto
            window_name="https_nikto_$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "nikto -ask=no -h https://${column1}:${column2} | tee $WDIR/nikto_${column1}:${column2}.txt; tmux kill-window -t ${window_name}" C-m
            # dirb
            window_name="https_dirb_$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "dirb https://${column1}:${column2} /usr/share/wordlists/dirb/common.txt -o $WDIR/dirb_${column1}:${column2}.txt; tmux kill-window -t ${window_name}" C-m
            # sslyze
            window_name="sslyze_$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "sslyze --regular ${column1} | tee $WDIR/sslyze_${column1}.txt; tmux kill-window -t ${window_name}" C-m
        else
        ## http
            # nikto
            window_name="http_nikto_$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "nikto -ask=no -h http://${column1}:${column2} | tee $WDIR/nikto_${column1}:${column2}.txt; tmux kill-window -t ${window_name}" C-m
            # dirb
            window_name="http_dirb_$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "dirb http://${column1}:${column2} /usr/share/wordlists/dirb/common.txt -o $WDIR/dirb_${column1}:${column2}.txt; tmux kill-window -t ${window_name}" C-m
        fi
        count=$((++count))
    done
    tmux select-window -t "${modules[1]}"
}

function smb_scan()
{
    local count
    local column1
    local column2
    local window_name

    count=1
    for i in ` get_service_port "$1"`
    do
        column1=`echo ${i} | cut -d , -f 1`
        column2=`echo ${i} | cut -d , -f 3`
        # nmap scan
        window_name="smb_P${column2}_scan_$count"
        tmux new-window -n "$window_name"
        tmux send-keys -t "$window_name" "faraday-terminal" C-m
        tmux send-keys -t "$window_name" "nmap -sV -Pn -v --script='*smb-vuln* and not brute or broadcast or dos or external or fuzzer' -p${column2} -oN $WDIR/$1:${column1}:${column2}.nmap ${column1} ;tmux kill-window -t $window_name" C-m
        # enum4linux
        if [ ${column2} = "139" ] || [ ${column2} -eq "389" ] || [ ${column2} -eq "445" ];then
            window_name="enum4linux_P$1_$count"
            tmux new-window -n "$window_name"
            tmux send-keys -t "$window_name" "faraday-terminal" C-m
            tmux send-keys -t "$window_name" "enum4linux -a -M -1 -d ${column1} | tee $WDIR/enum4linux_${column1}:${column2}.txt ;tmux kill-window -t $window_name" C-m
        fi
        count=$((++count))
    done
    tmux select-window -t "${modules[1]}"
}

function nmap_enum()
{
    local count
    local column1
    local column2
    local window_name

    count=1
    for i in ` get_service_port "$1"`
    do
        column1=`echo ${i} | cut -d , -f 1`
        column2=`echo ${i} | cut -d , -f 3`

        window_name="$1_scan_$count"
        tmux new-window -n "$window_name"
        tmux send-keys -t "$window_name" "faraday-terminal" C-m
        tmux send-keys -t "$window_name" "nmap -sV -Pn -v --script='*$1-vuln* and not brute or broadcast or dos or external or fuzzer' -p${column2} -oN $WDIR/$1_${column1}:${column2}.nmap ${column1} ;tmux kill-window -t $window_name" C-m
        count=$((++count))
    done
    tmux select-window -t "${modules[1]}"
}

function openvas_scan()
{
    local Target_list
    local Target_ID
    local Task_ID
    local Report_ID
    local Error_msg
    local scan_status

    sudo openvas-start 2> /dev/null > /dev/null
    echo -e "######################################################################"
    echo -n -e "OpenVAS "
    omp -O -u $OMPUSER -w $OMPPASS
    echo -e "Vulnerability Scan Start"
    echo -e "######################################################################"
    echo -e ""
    echo -e "Scanning target..."
    cat $TARGETS
    while IFS= read -r line;do
        str+="$line,"
    done < $TARGETS
    if [ ${str: -1} = "," ];then
        Target_list=${str/%?/}
    fi    
    echo -e ""
    echo -e "Creating target..."
    
    # Create Target
    Target_ID=$(omp -u $OMPUSER -w $OMPPASS --xml="<create_target><name>$TARGET_NAME</name><hosts>$Target_list</hosts></create_target>" | xmlstarlet sel -t -v /create_target_response/@id) && echo -e "Target ID: $Target_ID"
    if [[ "$Target_ID" == "" ]];then
        Error_msg=$(omp -u $OMPUSER -w $OMPPASS --xml="<create_target><name>$TARGET_NAME</name><hosts>$Target_list</hosts></create_target>")
        if [[ "$Error_msg" == *"Target exists already"* ]];then
            omp -X "<delete_target target_id=\"$Target_ID\"/>" -u $OMPUSER -w $OMPPASS >/dev/null 2>/dev/null
            Target_ID=$(omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|awk '{print $1}') && echo -e "Target ID=$Target_ID"
        fi
    fi
    echo -e ""
    echo -e "Creating task..."

    # Create Task
        # 8715c877-47a0-438d-98a3-27c7a6ab2196  Discovery *
        # 085569ce-73ed-11df-83c3-002264764cea  empty
        # daba56c8-73ec-11df-a475-002264764cea  Full and fast
        # 698f691e-7489-11df-9d8c-002264764cea  Full and fast ultimate
        # 708f25c4-7489-11df-8094-002264764cea  Full and very deep
        # 74db13d6-7489-11df-91b9-002264764cea  Full and very deep ultimate
        # 2d3f051c-55ba-11e3-bf43-406186ea4fc5  Host Discovery
        # bbca7412-a950-11e3-9109-406186ea4fc5  System Discovery
    Task_ID=$(omp -C -c 8715c877-47a0-438d-98a3-27c7a6ab2196 --name $TASK_NAME --target $Target_ID -u $OMPUSER -w $OMPPASS) && echo -e "Task ID=$Task_ID"
    
    echo -e ""
    echo -e "Task Start"
    # Task Start
    Report_ID=$(omp -S $Task_ID -u $OMPUSER -w $OMPPASS) && echo -e "Report ID: $Report_ID"
    
    if [[ "$Report_ID" == "" ]];then
        omp -S $Task_ID -u $OMPUSER -w $OMPPASS
    fi

    while [[ $scan_status != "Done" && $Report_ID != "" ]]
    do
        date
        omp -G -u $OMPUSER -w $OMPPASS | grep $Task_ID
        scan_status=$(omp -G -u $OMPUSER -w $OMPPASS | grep "$Task_ID" | awk '{print $2}')
        sleep 60
    done

    echo -e ""
    echo -e "Output report..."

    # Output Report
    DATE=`date '+%Y%m%d%H%M'`
    if [[ $Report_ID != "" ]];then
        # pdf format
        omp --get-report $Report_ID --format c402cc3e-b531-11e1-9163-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/Openvas-report_$DATE.pdf
        # html format
        omp --get-report $Report_ID --format 6c248850-1f62-11e1-b082-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/Openvas-report_$DATE.html
        # xml format
        omp --get-report $Report_ID --format a994b278-1f62-11e1-96ac-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/Openvas-report_$DATE.xml
    fi

    # Delete job
    if [[ $Task_ID != "" ]];then
        omp -X '<delete_task task_id=\"$Task_ID\" />' -u $OMPUSER -w $OMPPASS
    fi

    if [[ $Target_ID != "" ]];then
        omp -X '<delete_target target_id=\"$Target_ID\" />' -u $OMPUSER -w $OMPPASS
    fi

    # Import faraday
    echo -e "Import to faraday..."
    cp $WDIR/Openvas-report_$DATE.xml ~/.faraday/report/demo/

    echo -e "Compleate!"
    echo -e "Press enter key to continue..."
    read
    tmux select-window -t "${modules[1]}"
}

case $1 in
    show_port_count)
        show_open_port_count
        ;;
    show_serv_port)
        show_service_port $SERV_NAME
        ;;
    http)
        http_scan
        ;;
    smb)
        smb_scan smb
        smb_scan netbios-ssn
        ;;
    ftp)
        nmap_enum ftp
        ;;
    ssh)
        ssh_scan
        ;;
    dns)
        nmap_enum domain
        ;;
    smtp)
        nmap_enum smtp
        nmap_enum pop3
        ;;
    db)
        nmap_enum oracle
        nmap_enum ms-sql
        nmap_enum mysql
        ;;
    openvas)
        openvas_scan 
        ;;
esac
