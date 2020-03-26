#!/bin/bash
source pakuri.conf
source $MODULES/misc_module.sh
WINDOW_NAME="${modules[1]}"

function nmap_scan_menu()
{
    box_1 "nmap scan"
    echo -e "-------- Select Action ---------"
    if ps -ef|grep nmap|grep -v "grep" >/dev/null;then
        echo -e "Scan process is Running!"
    else
        select_2 "Port Scan" "Vulners Scan"
        read -n 1 -s ans
        scan_banner
        box_1 "nmap scan"
        echo -e "-------- Select Action ---------"
        if [ $ans = 1 ];then
            box_1 "Port Scan"
            echo -e "Do you want to perform a process??" 
            yes-no-help
            read -n 1 -s ans
            if [ $ans -eq 1 ];then
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh nscan $TARGETS" C-m
                tmux select-pane -t $WINDOW_NAME.0
            elif [ $ans -eq 3 ];then
                tmux send-keys -t $WINDOW_NAME.1 "cat $DOCUMENTS/learn_well-knownquick.txt" C-m 
                tmux select-pane -t $WINDOW_NAME.0
            fi
        elif [ $ans = 2 ];then
            box_2 "Vulners Scan"
            echo -e "Do you want to perform a process??" 
            yes-no-help
            read -n 1 -s ans
            if [ $ans -eq 1 ];then
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh nvscan $TARGETS" C-m
                tmux select-pane -t $WINDOW_NAME.0
            elif [ $ans -eq 3 ];then
                tmux send-keys -t $WINDOW_NAME.1 "cat $DOCUMENTS/learn_well-knownquick.txt" C-m 
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

    if ls $WDIR/nmap_*.grep >/dev/null 2>&1;then
        tmux send-keys -t $WINDOW_NAME.1 "clear" C-m
        tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh show_serv_port" C-m
        select_7 "ftp" "ssh" "smtp/pop3" "dns" "http/https" "SMB" "DB" 
        read -n 1 -s key
        scan_banner
        box_2 "Enumeration"
        echo -e "-------- Select Action ---------"
        case "$key" in
            1 ) #ftp
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh ftp " C-m
                ;;
            2 ) #ssh
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh ssh " C-m
                ;;
            3 ) #smtp/pop3
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh smtp " C-m
                ;;
            4 ) #dns
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh dns " C-m
                ;;
            5 ) #http
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh http " C-m
                ;;
            6 ) #SMB
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh smb " C-m
                ;;
            7 ) #DB
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh db " C-m
                ;;
            9 )
            ;;
        esac
    else
        nmap_scan_menu
    fi
}

function openvas_menu()
{
    local ans
    local window_name

    window_name=""
    box_3 "OpenVAS"
    echo -e "-------- Select Action ---------"
    echo -e "Do you want to perform a process??" 
    yes-no-help
    read -n 1 -s ans
    if [ $ans -eq 1 ];then
        window_name=$(tmux list-window -a|grep OpenVAS|awk '{print $2}')
        if [[ "$window_name" == "" ]];then
            window_name="OpenVAS"
            tmux new-window -n "$window_name"
            tmux split-window -t "$window_name".0 -v -p 15
            tmux send-keys -t "$window_name".1 "$MODULES/service_act.sh back" C-m
            tmux send-keys -t "$window_name".0 "$MODULES/service_act.sh openvas ;tmux kill-window -t $window_name" C-m
        else
            tmux select-window -t "$window_name"
        fi
    elif [ $ans -eq 3 ];then
        tmux send-keys -t $WINDOW_NAME.1 "less $DOCUMENTS/learn_omp.txt" C-m 
        tmux select-pane -t $WINDOW_NAME.0
    fi
}

function scan_manage()
{
    local key
    local ans
    local status
    local flg_omp

    while :
    do
        flg_omp=""
        scan_banner
        select_4 "nmap scan" "Enumeration" "OpenVAS" "help"
        flg_omp=`tmux list-window -a | grep "OpenVAS"`
        read -n 1 -t 25 -s key
        
        scan_banner
        case "$key" in
            1 )
                nmap_scan_menu ;;
            2 )
                enum_menu ;;
            3 )
                openvas_menu ;;
            4 )
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