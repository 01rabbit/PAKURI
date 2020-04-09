#!/bin/bash
source pakuri.conf
source $MODULES/misc_module.sh
WINDOW_NAME="${modules[1]}"

function port_scan_menu()
{
    box_1 "Port Scan"
    echo -e "-------- Select Action ---------"
    if ps -ef|grep nmap|grep -v "grep" >/dev/null;then
        echo -e "Scan process is Running!"
    else
        select_2 "Port Scan" "Vulners Scan"
        read -n 1 -s KEY
        scan_banner
        box_1 "Port Scan"
        echo -e "-------- Select Action ---------"
        if [ $KEY = 1 ];then
            box_1 "Port Scan"
            echo -e "Do you want to perform a process??" 
            yes-no-help
            read -n 1 -s KEY
            if [ $KEY -eq 1 ];then
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh nscan $TARGETS" C-m
                tmux select-pane -t $WINDOW_NAME.0
            elif [ $KEY -eq 3 ];then
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/help/scan_help_module.sh 111" C-m 
                tmux select-pane -t $WINDOW_NAME.0
            fi
        elif [ $KEY = 2 ];then
            box_2 "Vulners Scan"
            echo -e "Do you want to perform a process??" 
            yes-no-help
            read -n 1 -s KEY
            if [ $KEY -eq 1 ];then
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh nvscan $TARGETS" C-m
                tmux select-pane -t $WINDOW_NAME.0
            elif [ $KEY -eq 3 ];then
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/help/scan_help_module.sh 112" C-m 
                tmux select-pane -t $WINDOW_NAME.0
            fi
        fi
    fi
}

function enum_menu()
{
    local KEY

    box_2 "Enumeration"
    echo -e "-------- Select Action ---------"
    if [ -f $WDIR/nmap_*.grep ];then
        echo -e "Do you want to perform a process??" 
        yes-no-help
        read -n 1 -s KEY
        if [ $KEY -eq 1 ];then
            tmux send-keys -t $WINDOW_NAME.1 "$MODULES/service_act.sh enumctrl" C-m
            tmux select-pane -t $WINDOW_NAME.0
        elif [ $KEY -eq 3 ];then
            tmux send-keys -t $WINDOW_NAME.1 "$MODULES/help/scan_help_module.sh 12" C-m 
            tmux select-pane -t $WINDOW_NAME.0
        fi
    else
        echo -e "A port scan has not been performed."
        echo -e "Press enter key to continue..."
        read
    fi
}
function openvas_menu()
{
    local KEY
    local NEW_WINDOW

    NEW_WINDOW=""
    box_3 "OpenVAS"
    echo -e "-------- Select Action ---------"
    echo -e "Do you want to perform a process??" 
    yes-no-help
    read -n 1 -s KEY
    if [ $KEY -eq 1 ];then
        NEW_WINDOW=$(tmux list-window -a|grep OpenVAS|awk '{print $2}')
        if [[ "$NEW_WINDOW" == "" ]];then
            NEW_WINDOW="OpenVAS"
            tmux new-window -n "$NEW_WINDOW"
            tmux split-window -t "$NEW_WINDOW".0 -v -p 15
            tmux send-keys -t "$NEW_WINDOW".1 "$MODULES/service_act.sh back" C-m
            tmux send-keys -t "$NEW_WINDOW".0 "$MODULES/service_act.sh openvas ;tmux kill-window -t $NEW_WINDOW" C-m
            tmux select-pane -t $NEW_WINDOW.0
        else
            tmux select-window -t "OpenVAS"
        fi
    elif [ $KEY -eq 3 ];then
        tmux send-keys -t $WINDOW_NAME.1 "$MODULES/help/scan_help_module.sh 13" C-m 
        tmux select-pane -t $WINDOW_NAME.0
    fi
}

function scan_manage()
{
    local KEY
    local flg_omp

    while :
    do
        flg_omp=""
        scan_banner
        select_4 "Port Scan" "Enumeration" "OpenVAS" "Assist"
        flg_omp=`tmux list-window -a | grep "OpenVAS"`
        read -n 1 -t 25 -s KEY
        
        scan_banner
        case "$KEY" in
            1 )
                port_scan_menu ;;
            2 )
                enum_menu ;;
            3 )
                openvas_menu ;;
            4 )
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES/help/assist_module.sh scan" C-m 
                tmux select-pane -t $WINDOW_NAME.0 ;;
            9 )
                tmux select-window -t "${modules[0]}" ;;
            * )
                ;;
        esac
    done
}
scan_manage