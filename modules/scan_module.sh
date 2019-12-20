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
        DISCOVERY="$WDIR/nmap/$DATE-DiscoveryHost"
        if [[ -f ./$WIDR/hostup.txt ]];then
            rm $WDIR/hostup.txt
        fi
        tmux send-keys -t $WINDOW_NAME.1 "nmap -sn -PE -iL $1 --exclude $MYIP -oN $DISCOVERY.nmap -oX $DISCOVERY.xml;cat $DISCOVERY.nmap |grep report|cut -d \" \" -f5 > $WDIR/hostup.txt" C-m
        ;;
    Quick )
        QUICK="$WDIR/nmap/$DATE-Quick"
        tmux send-keys -t $WINDOW_NAME.1 "nmap -T4 -p1-1023 -v --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN $QUICK.nmap -oX $QUICK.xml -iL $1" C-m-
        ;;
    Details )
        DETAILS="$WDIR/nmap/$DATE-Details"
        tmux send-keys -t $WINDOW_NAME.1 "nmap -T4 -p1-1023 -v -A --max-retries 1 --max-scan-delay 20 --max-rate 300 --open -oN $DETAILS.nmap -oX $DETAILS.xml -iL $1" C-m
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
            box_1 "Discovery Host ${RED} Running"
            box_2 "Well-known ports Scan ${RED} Running"
            flg_nm=1
        else
            box_1 "Discovery Host"
            box_2 "Well-known ports Scan"
            flg_nm=0
        fi
        TASK_ID=`omp --get-tasks -u $OMPUSER -w $OMPPASS|grep $TASK_NAME|cut -d " " -f1`
        if [ ! -z $TASK_ID ];then
            status=`omp --get-tasks -u $OMPUSER -w $OMPPASS|grep $TASK_NAME|cut -d " " -f3`
            if [ $status = "Done" ];then
                box_3 "Vulnerability Scan [Task Complete]"
                flg_omp=0
                if [[ ! -d $WDIR/OpenVAS ]]; then
	                mkdir -p $WDIR/OpenVAS
                fi
                REPORT_ID=`omp --get-tasks $TASK_ID -u $OMPUSER -w $OMPPASS|grep -v $TASK_ID|cut -d " " -f3`
                omp_output $REPORT_ID
                sleep 2
                omp_delete
            else
                box_3 "Vulnerability Scan ${RED} Running"
                flg_omp=1
            fi
        else
            box_3 "Vulnerability Scan"
            flg_omp=0
        fi
        if ps -ef|grep autorecon.py|grep -v "grep" > /dev/null;then
            box_4 "AutoRecon ${RED} Running"
            flg_ar=1
        else
            box_4 "AutoRecon"
            flg_ar=0
        fi
        box_5 "Assist"
        box_9
        read -n 1 -t 25 -s key
        clear
        scan_banner
        date
        echo -e "------------------------ Scan Menu -------------------------"
        case "$key" in
            1 )
                box_1 "Discovery Host"
                echo -e "---------------------- Select Action -----------------------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                echo -e "Do you want to start ${BLUE}Discovery Host${NC}?" 
                yes-no
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
                    scan_nmap $SCRIPT_DIR/$TARGETS Check
                    tmux select-pane -t $WINDOW_NAME.0
                elif [ $ans -eq 3 ];then
                pwd
                    tmux send-keys -t $WINDOW_NAME.1 "less $DOCUMENTS/learn_discoveryhost.txt" C-m 
                    tmux select-pane -t $WINDOW_NAME.0
                fi
                echo -e "Press any key to continue..."
                read
                tmux kill-pane -t $SESSION_NAME.1
                tmux split-window -t $SESSION_NAME.0 -h
                tmux select-pane -t $WINDOW_NAME.0
                ;;
            2 )
                box_2 "Well-known ports Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                if [ ! -f ./$WIDR/hostup.txt ];then
                    echo -e "First, run \"${BLUE_b}Discovery Host${NC}\""
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                select_2 "Quick" "Details" 
                read -n 1 -s ans
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                box_2 "Well-known ports Scan"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    box_1 "Quick"
                    echo -e "Do you want to start ${RED}Well-known ports Scan(Quick)${NC}?" 
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        scan_nmap $WDIR/hostup.txt Quick
                        tmux select-pane -t $WINDOW_NAME.0
                    elif [ $ans -eq 3 ];then
                        tmux send-keys -t $WINDOW_NAME.1 "less documents/learn_well-knownquick.txt" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                    fi
                    echo -e "Press any key to continue..."
                    read
                    tmux kill-pane -t $SESSION_NAME.1
                    tmux split-window -t $SESSION_NAME.0 -h
                    tmux select-pane -t $WINDOW_NAME.0
                elif [ $ans = 2 ];then
                    box_2 "Details"
                    echo -e "Do you want to start ${RED}Well-known ports Scan(Details)${NC}?" 
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        scan_nmap $WDIR/hostup.txt Details
                        tmux select-pane -t $WINDOW_NAME.0
                    elif [ $ans -eq 3 ];then
                        tmux send-keys -t $WINDOW_NAME.1 "less documents/learn_well-knowndetails.txt" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                    fi
                    echo -e "Press any key to continue..."
                    read
                    tmux kill-pane -t $SESSION_NAME.1
                    tmux split-window -t $SESSION_NAME.0 -h
                    tmux select-pane -t $WINDOW_NAME.0
                fi ;;
            3 )
                box_3 "Vulnerability Scan"
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
                box_3 "Vulnerability Scan"
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
            4 )
                box_4 "AutoRecon"
                echo -e "---------------------- Select Action -----------------------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                echo -e "Do you want to start ${YELLOW}AutoRecon${NC}?" 
                yes-no
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
                    scan_autorecon $SCRIPT_DIR/$TARGETS M
                    tmux select-pane -t $WINDOW_NAME.0
                elif [ $ans -eq 3 ];then
                    tmux send-keys -t $WINDOW_NAME.1 "less documents/learn_autorecon.txt" C-m 
                    tmux select-pane -t $WINDOW_NAME.0
                fi
                echo -e "Press any key to continue..."
                read
                tmux kill-pane -t $SESSION_NAME.1
                tmux split-window -t $SESSION_NAME.0 -h
                tmux select-pane -t $WINDOW_NAME.0
                ;;
            5 )
                tmux send-keys -t $WINDOW_NAME.1 "clear && cat documents/assist_scanning.txt" C-m 
                tmux select-pane -t $WINDOW_NAME.0 ;;
            9 )
                break ;;
            * )
                ;;
        esac
    done
}