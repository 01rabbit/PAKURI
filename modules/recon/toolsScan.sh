#!/bin/bash
source pakuri.conf
YMDHM=$(date +%F-%H-%M)
outDir="${WDIR}/result"
FLAG_O=""
FLAG_T=""
FLAG_L=""

function usage_exit() {
    cat <<EOM
    Usage:
        $(basename "$0") [-o] [-t Task] [-l IPlist] IP
    
    Options:
        -o  OpenVAS
        -t  OpenVAS Task
            1  Discovery
            2  empty
            3  Full and fast
            4  Full and fast ultimate
            5  Full and very deep
            6  Full and very deep ultimate
            7  Host Discovery
            8  System Discovery
        -l  IP Address List

    Exsample:
        OpenVAS Scan
            $(basename "$0") -o -t 3 <Target IP>

EOM
    exit 1
}

function openvas_scan() {
    local Target_list
    local Target_ID
    local Task_ID
    local Report_ID
    local Error_msg
    local Scan_Status

    clear
    sudo openvas-start 2>/dev/null >/dev/null
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Starting OpenVAS."
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Checking targets."
    if [[ ${FLAG_L} ]]; then
        while IFS= read -r line; do
            str+="$line,"
        done <$IP
        if [ ${str: -1} = "," ]; then
            Target_list=${str/%?/}
        fi
        thisFileName="ipList_Openvas-report-${YMDHM}"
    else
        Target_list=${IP}
        thisFileName="${IP}_Openvas-report-${YMDHM}"
    fi
    # echo -e ""
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Creating OpenVAS target..."

    # Create Target
    Target_ID=$(omp -u $OMPUSER -w $OMPPASS --xml="<create_target><name>$TARGET_NAME</name><hosts>$Target_list</hosts></create_target>" | xmlstarlet sel -t -v /create_target_response/@id) && echo -e "Target ID: $Target_ID"

    if [[ "$Target_ID" == "" ]]; then
        Error_msg=$(omp -u $OMPUSER -w $OMPPASS --xml="<create_target><name>$TARGET_NAME</name><hosts>$Target_list</hosts></create_target>")
        if [[ "$Error_msg" == *"Target exists already"* ]]; then
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Caution" "The target already exists."
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Caution" "Delete an existing target and create a new one."
            omp -X "<delete_target target_id=\"$Target_ID\"/>" -u $OMPUSER -w $OMPPASS >/dev/null 2>/dev/null
            Target_ID=$(omp -T -u $OMPUSER -w $OMPPASS | grep $TARGET_NAME | awk '{print $1}') && echo -e "Target ID: $Target_ID"
        fi
    fi

    # Create Task
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Creating task..."
    Task_ID=$(omp -C -c $TASK --name $TASK_NAME --target $Target_ID -u $OMPUSER -w $OMPPASS) && echo -e "Task ID: $Task_ID"

    # Task Start
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Task Start"
    Report_ID=$(omp -S $Task_ID -u $OMPUSER -w $OMPPASS) && echo -e "Report ID: $Report_ID"
    if [[ "$Report_ID" == "" ]]; then
        omp -S $Task_ID -u $OMPUSER -w $OMPPASS
    fi

    while [[ $Scan_Status != "Done" && $Report_ID != "" ]]; do
        date
        omp -G -u $OMPUSER -w $OMPPASS | grep $Task_ID
        Scan_Status=$(omp -G -u $OMPUSER -w $OMPPASS | grep "$Task_ID" | awk '{print $2}')
        sleep 60
    done

    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Output report..."

    # Output Report
    if [[ $Report_ID != "" ]]; then
        # pdf format
        omp --get-report $Report_ID --format c402cc3e-b531-11e1-9163-406186ea4fc5 -u $OMPUSER -w $OMPPASS >$WDIR/${thisFileName}.pdf
        printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "$WDIR/${thisFileName}.pdf"
        # html format
        omp --get-report $Report_ID --format 6c248850-1f62-11e1-b082-406186ea4fc5 -u $OMPUSER -w $OMPPASS >$WDIR/${thisFileName}.html
        printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "$WDIR/${thisFileName}.html"
        # xml format
        omp --get-report $Report_ID --format a994b278-1f62-11e1-96ac-406186ea4fc5 -u $OMPUSER -w $OMPPASS >$WDIR/${thisFileName}.xml
        printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "$WDIR/${thisFileName}.xml"
    fi

    # Delete job
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Job clean up"
    status=""
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Deleting Tasks...  Task ID: $Task_ID"
    if [[ $Task_ID != "" ]]; then
        status=$(omp -X "<delete_task task_id=\"$Task_ID\" />" -u $OMPUSER -w $OMPPASS | xmlstarlet sel -t -v /delete_task_response/@status_text)
        if [[ $status == "OK" ]]; then
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "OK" "Successfully deleted a task."
        else
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Error" "Failure to delete a task."
        fi
    fi

    echo -e "Deleting Targets... Target ID: $Target_ID"
    status=""
    if [[ $Target_ID != "" ]]; then
        status=$(omp -X "<delete_target target_id=\"$Target_ID\" />" -u $OMPUSER -w $OMPPASS | xmlstarlet sel -t -v /delete_target_response/@status_text)
        if [[ $status == "OK" ]]; then
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "OK" "Successfully deleted a target."
        else
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Error" "Failure to delete a target."
        fi
    fi

    # Import faraday
    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "Import to faraday..."
    faraday-client --cli --workspace $WORKSPACE --report $WDIR/Openvas-report_$DATE.xml

    printf "%(%F %T)T [%s] [%s] %s\n" -1 "OpenVAS" "Info" "All processes are compleate!"
}

if [ $# = 0 ]; then usage_exit; fi

while getopts :ot:l:h OPT; do
    case $OPT in
    o) # OpenVAS
        FLAG_O=1
        ;;
    t) # Task
        FLAG_T=1
        num=$OPTARG
        case $num in
        1) # Discovery
            TASK="8715c877-47a0-438d-98a3-27c7a6ab2196"
            ;;
        2) # empty
            TASK="085569ce-73ed-11df-83c3-002264764cea"
            ;;
        3) # Full and fast
            TASK="daba56c8-73ec-11df-a475-002264764cea"
            ;;
        4) # Full and fast ultimate
            TASK="698f691e-7489-11df-9d8c-002264764cea"
            ;;
        5) # Full and very deep
            TASK="708f25c4-7489-11df-8094-002264764cea"
            ;;
        6) # Full and very deep ultimate
            TASK="74db13d6-7489-11df-91b9-002264764cea"
            ;;
        7) # Host Discovery
            TASK="2d3f051c-55ba-11e3-bf43-406186ea4fc5"
            ;;
        8) #System Discovery
            TASK="bbca7412-a950-11e3-9109-406186ea4fc5"
            ;;
        esac
        ;;
    l) # List
        FLAG_L=1
        IPLIST=$OPTARG
        ;;
    h) # Help
        usage_exit
        ;;
    \?)
        echo "option error"
        usage_exit
        ;;
    esac
done

shift $((OPTIND - 1))

if [ $# = 1 ]; then
    IP=$1
    IP_CHECK=$(echo ${IP} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")
    if [[ ! ${IP_CHECK} ]]; then
        printf "%(%F %T)T [%s] [%s] %s\n" -1 "exScan" "ERROR" "${IP} is not IP Address."
        exit 1
    fi
else
    if [[ ${FLAG_L} ]]; then
        IP="${IPLIST}"
    else
        printf "%(%F %T)T [%s] [%s] %s\n" -1 "exScan" "ERROR" "Not Target."
        exit 1
    fi
fi

if [[ $FLAG_O ]]; then openvas_scan; fi
