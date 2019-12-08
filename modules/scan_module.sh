# $1 IP Address or IP list
# $2 Arguments
# $3 S or M S:Sngle Host M:Multi Host
function scan_nmap()
{
    DATE=`date '+%Y%m%d%H%M'`
    cd $WDIR
    if [[ ! -d $WDIR/nmap ]]; then
	mkdir $WDIR/nmap
    fi

    case $2 in
    Check )
        CHECK="$WDIR/nmap/$DATE-hostup"
        if [ $3 = "S" ];then
            tmux send-keys -t $WINDOW_NAME.1 "nmap -sn -PE $1 -oN $CHECK-$1.nmap -oX $CHECK-$1.xml" C-m
        elif [ $3 = "M" ];then
            tmux send-keys -t $WINDOW_NAME.1 "nmap -sn -PE -iL $1 --exclude $MYIP -oN $CHECK-multi.nmap -oX $CHECK-multi.xml" C-m
        fi ;;
    Quick )
        QUICK="$WDIR/nmap/$DATE-Quick"
        tmux send-keys -t $WINDOW_NAME.1 "nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN $QUICK.nmap -oX $QUICK.xml -iL $1" C-m
        ;;
    Full )
        FULL="$WDIR/nmap/$DATE-Full"
        tmux send-keys -t $WINDOW_NAME.1 "nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN $FULL.nmap -oX $FULL.xml -iL $1" C-m
        ;;
    esac
}

# $1 IP Address or IP list
# $2 S or M S:Sngle Host M:Multi Host
function scan_autorecon()
{
    if [ $2 = "S" ];then
        tmux send-keys -t $WINDOW_NAME.1 "$AUTORECON $1 -v -o $WDIR --only-scans-dir" C-m
    elif [ $2 = "M" ];then
        tmux send-keys -t $WINDOW_NAME.1 "$AUTORECON -t $1 -v -o $WDIR --only-scans-dir" C-m
    fi
}

function omp_create_target()
{
    TARGET_ID=`omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|cut -d " " -f1`
    if [ -z $TARGET_ID ];then
        echo "Create Targets"
        tmux send-keys -t $WINDOW_NAME.1 "omp -X '<create_target><name>$TARGET_NAME</name><hosts>$1</hosts></create_target>' -u $OMPUSER -w $OMPPASS" C-m
    else
        echo "Target has already been created."
    fi
}

function omp_start()
{
    TARGET_ID=`omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|cut -d " " -f1`
    if [ ! -z $TARGET_ID ];then
        echo "Create Task"
        TASK_ID=`omp -C -c daba56c8-73ec-11df-a475-002264764cea --name $TASK_NAME --target $TARGET_ID -u $OMPUSER -w $OMPPASS`
        echo "TASK_ID: $TASK_ID"
        echo "Start Task"
        REPORT_ID=`omp -S $TASK_ID -u $OMPUSER -w $OMPPASS`
        echo "REPORT_ID: $REPORT_ID"
    fi
}

# $1 Report_ID
function omp_output()
{
    DATE=`date '+%Y%m%d%H%M'`
    REPORT_ID=$1
    if [ ! -z $REPORT_ID ];then
        # pdf format
        tmux send-keys -t $WINDOW_NAME.1 "omp --get-report $REPORT_ID --format c402cc3e-b531-11e1-9163-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/OpenVAS/$DATE-report.pdf"  C-m
        # html format
        tmux send-keys -t $WINDOW_NAME.1 "omp --get-report $REPORT_ID --format 6c248850-1f62-11e1-b082-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/OpenVAS/$DATE-report.html" C-m
        # xml format
        tmux send-keys -t $WINDOW_NAME.1 "omp --get-report $REPORT_ID --format a994b278-1f62-11e1-96ac-406186ea4fc5 -u $OMPUSER -w $OMPPASS > $WDIR/OpenVAS/$DATE-report.xml" C-m
    fi
}

function omp_delete()
{
    TASK_ID=`omp --get-tasks -u $OMPUSER -w $OMPPASS|grep $TASK_NAME|cut -d " " -f1`
    if [ ! -z $TASK_ID ];then
        tmux send-keys -t $WINDOW_NAME.1 "omp -X '<delete_task task_id=\"$TASK_ID\" />' -u $OMPUSER -w $OMPPASS" C-m
    fi

    TARGET_ID=`omp -T -u $OMPUSER -w $OMPPASS|grep $TARGET_NAME|cut -d " " -f1`
    if [ ! -z $TARGET_ID ];then
        tmux send-keys -t $WINDOW_NAME.1 "omp -X '<delete_target target_id=\"$TARGET_ID\" />' -u $OMPUSER -w $OMPPASS" C-m
    fi
}

function scan_manage()
{
    local key
    local ans
    local flg_ar
    local flg_nm
    local status
    local flg_omp

    if ! ps -ef|grep [o]penvas > /dev/null; then
        tmux send-keys -t $WINDOW_NAME.1 "openvas-start" C-m
    fi

    while :
    do
        clear
        scan_banner
        date
        echo -e "------------------------ Scan Menu -------------------------"
        if ps -ef|grep nmap|grep -v "grep" > /dev/null;then
            box_1 "Host Scan ${RED} Running"
            box_2 "Port Scan ${RED} Running"
            flg_nm=1
        else
            box_1 "Host Scan"
            box_2 "Port Scan"
            flg_nm=0
        fi
        if ps -ef|grep autorecon.py|grep -v "grep" > /dev/null;then
            box_3 "Service Scan ${RED} Running"
            flg_ar=1
        else
            box_3 "Service Scan"
            flg_ar=0
        fi
        TASK_ID=`omp --get-tasks -u $OMPUSER -w $OMPPASS|grep $TASK_NAME|cut -d " " -f1`
        if [ ! -z $TASK_ID ];then
            status=`omp --get-tasks -u $OMPUSER -w $OMPPASS|grep $TASK_NAME|cut -d " " -f3`
            if [ $status = "Done" ];then
                box_4 "Vulnerability Scan [Task Complete]"
                flg_omp=0
                if [[ ! -d $WDIR/OpenVAS ]]; then
	                mkdir -p $WDIR/OpenVAS
                fi
                REPORT_ID=`omp --get-tasks $TASK_ID -u $OMPUSER -w $OMPPASS|grep -v $TASK_ID|cut -d " " -f3`
                omp_output $REPORT_ID
                sleep 2
                omp_delete
            else
                box_4 "Vulnerability Scan ${RED} Running"
                flg_omp=1
            fi
        else
            box_4 "Vulnerability Scan"
            flg_omp=0
        fi
        box_9
        read -n 1 -t 25 -s key
        clear
        scan_banner
        date
        echo -e "------------------------ Scan Menu -------------------------"
        case "$key" in
            1 )
                box_1 "Host Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                select_2 "Single" "Multi"
                read -n 1 -s ans
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                box_1 "Host Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    box_1 "Single"
                    read -p "IP Address :" addr
                    echo -e "Start Host Up Checking. Single Host"            
                    scan_nmap $addr Check S
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 2 ];then
                    box_2 "Multi"
                    echo -e "Start Host Up Checking. Multi Host"             
                    scan_nmap $SCRIPT_DIR/$TARGETS Check M
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                fi ;;
            2 )
                box_2 "PortScan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                select_2 "Quick" "Full" 
                read -n 1 -s ans
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                box_2 "PortScan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    box_1 "Quick"
                    echo -e "Start Quick Port Scanning." 
                    scan_nmap $SCRIPT_DIR/$TARGETS Quick
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 2 ];then
                    box_2 "Full"
                    echo -e "Start Full Port Scanning." 
                    scan_nmap $SCRIPT_DIR/$TARGETS Full
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                fi ;;
            3 )
                box_3 "Service Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                select_2 "Single" "Multi"
                read -n 1 -s ans
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                box_3 "Service Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    box_1 "Single"
                    read -p "IP Address :" addr
                    echo -e "Start Service Scanning. Single Host"             
                    scan_autorecon $addr S
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 2 ];then
                    box_2 "Multi"
                    echo -e "Start Service Scanning. Multi Host"             
                    scan_autorecon $SCRIPT_DIR/$TARGETS M
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                fi ;;
            4 )
                box_4 "Vulnerability Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                select_3 "Single" "Multi" "Delete"
                read -n 1 -s ans
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                box_4 "Vulnerability Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    box_1 "Single"
                    read -p "IP Address :" addr
                    echo -e "Start Vulnerability Scanning. Single Host"             
                    omp_create_target $addr
                    omp_start
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 2 ];then
                    box_2 "Multi"
                    echo -e "Start Vulnerability Scanning. Multi Host"
                    while IFS= read -r line;do
                        str+="$line,"
                    done < $SCRIPT_DIR/$TARGETS
                    if [ ${str: -1} = "," ];then
                        addr=${str/%?/}
                    fi
                    omp_create_target $addr
                    omp_start
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 3 ];then
                    box_3 "Delete"
                    omp_delete
                    echo -e "Press any key to continue..."
                    read
                fi ;;
            9 )
                break ;;
            * )
                ;;
        esac
    done
}