#!/bin/bash
source pakuri.conf
source $MODULES/misc_module.sh
WINDOW_NAME="${modules[1]}"


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

function nmap_scan_menu()
{
    box_1 "nmap scan"
    echo -e "-------- Select Action ---------"
    if ps -ef|grep nmap|grep -v "grep" >/dev/null;then
        echo -e "Scan process is Running!"
    else
        select_3 "Quick" "Full" "Vuln" 
        read -n 1 -s ans
        scan_banner
        box_1 "nmap scan"
        echo -e "-------- Select Action ---------"
        if [ $ans = 1 ];then
            box_1 "Quick"
            echo -e "Do you want to start?" 
            yes-no-help
            read -n 1 -s ans
            if [ $ans -eq 1 ];then
                tmux send-keys -t $WINDOW_NAME.1 "nmap -Pn -p- -v -max-retries 1 --max-scan-delay 20 -iL $TARGETS -oN $WDIR/nmap-quick.nmap -oG $WDIR/nmap-quick.grep" C-m
                tmux select-pane -t $WINDOW_NAME.0
            elif [ $ans -eq 3 ];then
                tmux send-keys -t $WINDOW_NAME.1 "cat $DOCUMENTS/learn_well-knownquick.txt" C-m 
                tmux select-pane -t $WINDOW_NAME.0
            fi
        elif [ $ans = 2 ];then
            box_2 "Full"
            echo -e "Do you want to start?" 
            yes-no-help
            read -n 1 -s ans
            if [ $ans -eq 1 ];then
                tmux send-keys -t $WINDOW_NAME.1 "nmap -Pn -p- -v -A --max-retries 1 --max-scan-delay 20 --max-rate 300 -iL $TARGETS -oN $WDIR/nmap-full.nmap -oG $WDIR/nmap-full.grep" C-m
                tmux select-pane -t $WINDOW_NAME.0
            elif [ $ans -eq 3 ];then
                tmux send-keys -t $WINDOW_NAME.1 "cat $DOCUMENTS/learn_well-knowndetails.txt" C-m 
                tmux select-pane -t $WINDOW_NAME.0
            fi
        elif [ $ans = 3 ];then
            box_3 "Vuln"
            echo -e "Do you want to start?"
            yes-no-help
            read -n 1 -s ans
            if [ $ans -eq 1 ];then
                tmux send-keys -t $WINDOW_NAME.1 "nmap -Pn -p- -v -A --max-retries 1 --max-scan-delay 20 --max-rate 300 --script vulners --script-args mincvss=6.0 -iL $TARGETS -oN $WDIR/nmap-vuln.nmap" C-m
                tmux select-pane -t $WINDOW_NAME.0
            elif [ $ans -eq 3 ];then
                tmux send-keys -t $WINDOW_NAME.1 "cat $DOCUMENTS/learn_well-knowndetails.txt" C-m 
                tmux select-pane -t $WINDOW_NAME.0
            fi
        fi
    fi
}

function enum_menu()
{
    local ans
    local key

    NMAP_FILE=""
    box_2 "Enumeration"
    echo -e "-------- Select Action ---------"
    if [ -f $WDIR/nmap-full.grep ];then
        NMAP_FILE=$WDIR/nmap-full.grep
    elif [ -f $WDIR/nmap-quick.grep ];then
        NMAP_FILE=$WDIR/nmap-quick.grep
    fi

    if [ ! -z $NMAP_FILE ];then
        tmux send-keys -t $WINDOW_NAME.1 "clear" C-m
        tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh show_serv_port $NMAP_FILE" C-m
        select_3 "http/https" "SMB" "DB" 
        read -n 1 -s key
        scan_banner
        box_2 "Enumeration"
        echo -e "-------- Select Action ---------"
        case "$key" in
            1 ) #http
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh http_scan $NMAP_FILE" C-m
                ;;
            2 ) #SMB
                # nmap -sV -Pn -vv -p 445 --script='(smb*) and not (brute or broadcast or dos or external or fuzzer)' --script-args=unsafe=1 $ip
                # nmblookup -A $ip
                ;;
            3 ) #DB
                # tmux new-window -n "MSSQL"
                # tmux send-keys -t "MSSQL".0 "
                # nmap -p 1433 --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,
                # ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes 
                # --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER $ip" C-m
                ;;
            9 )
            ;;
        esac
    else
        echo -e "error"
        read
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

    while :
    do
        
        scan_banner
        select_4 "nmap scan" "Enumeration" "OpenVAS" "help"
        read -n 1 -t 25 -s key
        
        scan_banner
        case "$key" in
            1 )
                nmap_scan_menu
                ;;
            2 )
                enum_menu
                ;;
            3 )
                box_3 "Vulnerability Scan"
                echo -e "-------- Select Action ---------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                select_4 "Single" "Multi" "Delete" "learn to"
                read -n 1 -s ans
                
                scan_banner
                box_3 "Vulnerability Scan"
                echo -e "-------- Select Action ---------"
                if [ $ans = 1 ];then
                    box_1 "Single"
                    read -p "IP Address :" addr
                    echo -e "Do you want to start ${YELLO}Vulnerability Scan(Single)${NC} IP:$addr?"
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        echo -e "Start Vulnerability Scanning. Single Host"
                        omp_create_target $addr
                        sleep 2
                        omp_start
                        tmux select-pane -t $WINDOW_NAME.0
                    fi
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 2 ];then
                    box_2 "Multi"
                    echo -e "Do you want to start ${YELLO}Vulnerability Scan(Multi)${NC}?"
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        echo -e "Start Vulnerability Scanning. Multi Host"
                        while IFS= read -r line;do
                            str+="$line,"
                        done < $SCRIPT_DIR/$TARGETS
                        if [ ${str: -1} = "," ];then
                            addr=${str/%?/}
                        fi
                        omp_create_target $addr
                        sleep 2
                        omp_start
                        tmux select-pane -t $WINDOW_NAME.0
                    fi
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 3 ];then
                    box_3 "Delete"
                    echo -e "Do you want to Delete task?"
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        omp_delete
                    fi
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 4 ];then
                    box_4 "learn to"
                    tmux send-keys -t $WINDOW_NAME.1 "less $DOCUMENTS/learn_omp.txt" C-m 
                    tmux select-pane -t $WINDOW_NAME.0
                fi 
                echo -e "Press any key to continue..."
                read
                tmux kill-pane -t $SESSION_NAME.1
                tmux split-window -t $SESSION_NAME.0 -h
                tmux select-pane -t $WINDOW_NAME.0
                ;;
            4 )
                box_4 "AutoRecon"
                echo -e "-------- Select Action ---------"
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ] || [ $flg_omp = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Press any key to continue..."
                    read
                    break
                fi
                echo -e "Do you want to start ${YELLOW}AutoRecon${NC}?" 
                yes-no-help
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
                    scan_autorecon $SCRIPT_DIR/$TARGETS M
                    tmux select-pane -t $WINDOW_NAME.0
                elif [ $ans -eq 3 ];then
                    tmux send-keys -t $WINDOW_NAME.1 "less $DOCUMENTS/learn_autorecon.txt" C-m 
                    tmux select-pane -t $WINDOW_NAME.0
                fi
                echo -e "Press any key to continue..."
                read
                tmux kill-pane -t $SESSION_NAME.1
                tmux split-window -t $SESSION_NAME.0 -h
                tmux select-pane -t $WINDOW_NAME.0
                ;;
            5 )
                tmux send-keys -t $WINDOW_NAME.1 "clear && cat $DOCUMENTS/assist_scanning.txt" C-m 
                tmux select-pane -t $WINDOW_NAME.0 ;;
            9 )
                tmux select-window -t "${modules[0]}" ;;
            * )
                ;;
        esac
    done
}
scan_manage