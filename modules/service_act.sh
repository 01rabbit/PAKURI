#!/bin/bash
source pakuri.conf

function show_open_port_count()
{
    egrep -v "^#|Status: Up" $WDIR/nmap_*.grep | cut -d' ' -f2,4- | \
    # sed -n -e 's/Ignored.*//p' | \
    awk -F, '{split($0,a," "); printf "Host: %-20s Ports Open: %d\n" , a[1], NF}' \
    | sort -k 5 -g
}
function show_service_port()
{
    echo -e "IP               State    Port/Prot  Service         Info"
    egrep -v "^#|Status: Up" $WDIR/nmap_*.grep | cut -d' ' -f2,4- | \
    # sed -n -e 's/Ignored.*//p'  | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%-15s  %-5s %7s/%3s   %-15s %s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -i "$1"
}
function get_service_port()
{
    egrep -v "^#|Status: Up" $WDIR/nmap_*.grep | cut -d' ' -f2,4- | \
    # sed -n -e 's/Ignored.*//p'  | \
    awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");
     printf "%s,%s,%s,%s,%s,%s\n" ,ip, v[2], v[1], v[3], v[5], v[7]}; a="" }'|grep -w open |grep -i "$1"
}

function nmap_scan()
{
    local ports
    local count
    count=1
    while read ip
    do
        if [[ $ip != "" ]];then
            window_name="Portscan_$count"
            tmux new-window -n "$window_name"
            tmux select-window -t "${modules[1]}"
            tmux send-keys -t "$window_name" "faraday-terminal $MYIP 9977" C-m
            echo -e "[${GREEN}Nmap Scan${NC}] $ip -- Check open port"
            ports=$(nmap -Pn -p- -v --min-rate=1000 -T4 $ip | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
            echo -e "[${GREEN}Nmap Scan${NC}] $ip -- Port Scan -> Window[$window_name]"
            tmux send-keys -t "$window_name" "nmap -sC -sV -v -p$ports $ip -oN $WDIR/nmap_$ip.nmap -oG $WDIR/nmap_$ip.grep; tmux kill-window -t $window_name" C-m
            
            count=$((++count))
        fi
    done < $TARGETS
    tmux select-window -t "${modules[1]}"
}

function nmap_vulners_scan()
{
    local ports
    local count
    count=1
    while read ip
    do
        if [[ $ip != "" ]];then
            window_name="vulnerscan_$count"
            tmux new-window -n "$window_name"
            tmux select-window -t "${modules[1]}"
            tmux send-keys -t "$window_name" "faraday-terminal $MYIP 9977" C-m
            echo -e "[${GREEN}Vulners Scan${NC}] $ip -- Check open port"
            ports=$(nmap -Pn -p- -v --min-rate=1000 -T4 $ip | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
            echo -e "[${GREEN}Vulners Scan${NC}] $ip -- Vulners Scan -> Window[$window_name]"
            tmux send-keys -t "$window_name" "nmap -Pn -v -sV --max-retries 1 --max-scan-delay 20 --script vulners --script-args mincvss=6.0 -p$ports $ip -oN $WDIR/nmap_vuln_$ip.nmap ;tmux kill-window -t $window_name" C-m
            
            count=$((++count))
        fi
    done < $TARGETS
    tmux select-window -t "${modules[1]}"
}

function enum_ctrl()
{
    count=1
    while read TARGET
    do
        if [[ $TARGET != "" ]];then
            window_name="Target_$count"
            tmux new-window -n "$window_name"
            tmux select-window -t "${modules[1]}"
            echo -e "[${GREEN}Enumeration${NC}] $TARGET -> Window[$window_name]"
            tmux send-keys -t "$window_name" "$MODULES/service_act.sh enumscan $TARGET" C-m
            count=$((++count))
        fi
    done < $TARGETS
}

function nmap_enum()
{
    IP=$1
    PORT=$2
    SERV=$3

    nmap -sV -Pn -v --script="*vuln* and not brute or broadcast or dos or external or fuzzer" -p${PORT} -oN $WDIR/${SERV}_${IP}:${PORT}.nmap -oX $WDIR/${SERV}_${IP}:${PORT}.xml ${IP}
    if [ -f $WDIR/${SERV}_${IP}:${PORT}.xml ];then
        cp -p $WDIR/${SERV}_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE
    fi
}

function enum_scan()
{
    for i in `get_service_port $1`
    do
        IP=`echo ${i} | cut -d , -f 1`
        PORT=`echo ${i} | cut -d , -f 3`
        SERV=`echo ${i} | cut -d , -f 5`

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
                skipfish -U -u -Q -t 12 -W- -o $WDIR/skipfish_${IP}_${PORT} http://${IP}:${PORT} 
                ;;
            "ssl|https")
                nikto -h https://${IP}:${PORT} -output $WDIR/nikto_${IP}:${PORT}.xml -Format XML|tee $WDIR/nikto_${IP}:${PORT}.txt
                if [ -f $WDIR/nikto_${IP}:${PORT}.xml ];then
                    cp -p $WDIR/nikto_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE/
                fi
                sslyze --regular ${IP} --xml_out=$WDIR/sslyze_${IP}.xml | tee -a $WDIR/sslyze_${IP}.txt
                sslscan ${IP}|tee -a $WDIR/sslscan_${IP}.txt
                if  [ -f $WDIR/sslscan_${IP}.txt ];then 
                    cp -p $WDIR/sslyze_${IP}.xml ~/.faraday/report/$WORKSPACE
                fi
                skipfish -U -u -Q -t 12 -W- -o $WDIR/skipfish_${IP}:${PORT} https://${IP}:${PORT}
                ;;
            netbios-ssn|microsoft-ds)
                nmap -sV -Pn -v --script='*smb-vuln* and not brute or broadcast or dos or external or fuzzer' -p${PORT} -oN $WDIR/smb_${IP}:${PORT}.nmap -oX $WDIR/smb_${IP}:${PORT}.xml ${IP} 
                if [ -f $WDIR/smb_${IP}:${PORT}.xml ];then
                    cp -p $WDIR/smb_${IP}:${PORT}.xml ~/.faraday/report/$WORKSPACE/
                fi
                if [ ${PORT} = "139" ] || [ ${PORT} -eq "389" ] || [ ${PORT} -eq "445" ];then
                    enum4linux -a -M -1 -d ${IP} | tee $WDIR/enum4linux_${IP}:${PORT}.txt
                    echo "$SERV enum4linux"
                fi
                ;;
            # ftp|pop3|smtp|oracle|mysql|ms-sql)
            #     nmap_enum $IP $PORT $SERV
            #     ;;
            *)
                nmap_enum $IP $PORT $SERV
                ;;
        esac
    done
}

function openvas_scan()
{
    local Target_list
    local Target_ID
    local Task_ID
    local Report_ID
    local Error_msg
    local scan_status

    clear
    sudo openvas-start 2> /dev/null > /dev/null
    echo -e "${GREEN_b}"
    echo -e "######################################################################"
    echo -e "Vulnerability Scan"
    echo -n -e "OpenVAS "
    omp -O -u $OMPUSER -w $OMPPASS
    echo -e "######################################################################"
    echo -e "${NC}"
    echo -e "${YELLOW}Scanning target...${NC}"
    cat $TARGETS
    while IFS= read -r line;do
        str+="$line,"
    done < $TARGETS
    if [ ${str: -1} = "," ];then
        Target_list=${str/%?/}
    fi    
    echo -e ""
    echo -e "${YELLOW}Creating target...${NC}"
    
    # Create Target
    Target_ID=$(omp -u $OMPUSER -w $OMPPASS --xml="<create_target><name>$TARGET_NAME</name><hosts>$Target_list</hosts></create_target>" | xmlstarlet sel -t -v /create_target_response/@id) && echo -e "Target ID: $Target_ID"
    if [[ "$Target_ID" == "" ]];then
        Error_msg=$(omp -u $OMPUSER -w $OMPPASS --xml="<create_target><name>$TARGET_NAME</name><hosts>$Target_list</hosts></create_target>")
        if [[ "$Error_msg" == *"Target exists already"* ]];then
            echo -e "${RED_b}The target already exists."
            echo -e "Delete an existing target and create a new one.${NC}"
            echo -e ""
            omp -X "<delete_target target_id=\"$Target_ID\"/>" -u $OMPUSER -w $OMPPASS >/dev/null 2>/dev/null
            Target_ID=$(omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|awk '{print $1}') && echo -e "Target ID: $Target_ID"
        fi
    fi
    echo -e ""
    echo -e "${YELLOW}Creating task...${NC}"

    # Create Task
        # 8715c877-47a0-438d-98a3-27c7a6ab2196  Discovery *
        # 085569ce-73ed-11df-83c3-002264764cea  empty
        # daba56c8-73ec-11df-a475-002264764cea  Full and fast
        # 698f691e-7489-11df-9d8c-002264764cea  Full and fast ultimate
        # 708f25c4-7489-11df-8094-002264764cea  Full and very deep
        # 74db13d6-7489-11df-91b9-002264764cea  Full and very deep ultimate
        # 2d3f051c-55ba-11e3-bf43-406186ea4fc5  Host Discovery
        # bbca7412-a950-11e3-9109-406186ea4fc5  System Discovery
    Task_ID=$(omp -C -c 8715c877-47a0-438d-98a3-27c7a6ab2196 --name $TASK_NAME --target $Target_ID -u $OMPUSER -w $OMPPASS) && echo -e "Task ID: $Task_ID"
    
    echo -e ""
    echo -e "${YELLOW}Task Start${NC}"
    # Task Start
    Report_ID=$(omp -S $Task_ID -u $OMPUSER -w $OMPPASS) && echo -e "Report ID: $Report_ID"
    echo -e ""
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
    echo -e "${YELLOW}Output report...${NC}"

    # Output Report
    DATE=`date '+%Y%m%d%H%M'`
    if [[ $Report_ID != "" ]];then
        # pdf format
        omp --get-report $Report_ID --format c402cc3e-b531-11e1-9163-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/Openvas-report_$DATE.pdf
        echo -e "$WDIR/Openvas-report_$DATE.pdf"
        # html format
        omp --get-report $Report_ID --format 6c248850-1f62-11e1-b082-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/Openvas-report_$DATE.html
        echo -e "$WDIR/Openvas-report_$DATE.html"
        # xml format
        omp --get-report $Report_ID --format a994b278-1f62-11e1-96ac-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/Openvas-report_$DATE.xml
        echo -e "$WDIR/Openvas-report_$DATE.xml"
    fi

    # Delete job
    echo -e ""
    echo -e "${YELLOW}Job clean up${NC}"
    status=""
    echo -e "Deleting Tasks...  Task ID: $Task_ID"
    if [[ $Task_ID != "" ]];then
        status=$(omp -X "<delete_task task_id=\"$Task_ID\" />" -u $OMPUSER -w $OMPPASS | xmlstarlet sel -t -v /delete_task_response/@status_text)
        if [[ $status == "OK" ]];then
            echo -e "${GREEN_b}Successfully deleted a task.${NC}"
        else
            echo -e "${RED_b}Failure to delete a task.${NC}"
        fi
    fi

    echo -e "Deleting Targets... Target ID: $Target_ID"
    status=""
    if [[ $Target_ID != "" ]];then
        status=$(omp -X "<delete_target target_id=\"$Target_ID\" />" -u $OMPUSER -w $OMPPASS | xmlstarlet sel -t -v /delete_target_response/@status_text)
        if [[ $status == "OK" ]];then
            echo -e "${GREEN_b}Successfully deleted a target.${NC}"
        else
            echo -e "${RED_b}Failure to delete a target.${NC}"
        fi
    fi

    # Import faraday
    echo -e ""
    echo -e "${YELLOW}Import to faraday...${NC}"
    cp $WDIR/Openvas-report_$DATE.xml ~/.faraday/report/demo/

    echo -e ""
    echo -e "${YELLOW}All processes are compleate!${NC}"
    echo -e "Press enter key to continue..."
    read
    tmux select-window -t "${modules[1]}"
}

function window_back()
{
    local ans

    while :
    do
        clear
        echo -e "${BLACK_b}+---+"
        echo -e "| 9 | Back"
        echo -e "+---+${NC}"
        read -n 1 -s ans
        if [ $ans -eq 9 ];then
            tmux select-window -t "${modules[1]}"
        fi
    done
}

case $1 in
    show_port_count)
        show_open_port_count
        ;;
    show_serv_port)
        show_service_port 
        ;;
    nscan)
        nmap_scan
        ;;
    nvscan)
        nmap_vulners_scan
        ;;
    openvas)
        openvas_scan 
        ;;
    back)
        window_back
        ;;
    enumctrl)
        enum_ctrl
        ;;
    enumscan)
        enum_scan $2
        ;;
esac
