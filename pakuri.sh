#!/bin/bash

PAKURI=$0
source pakuri.conf
source $MODULES/scan_module.sh
source $MODULES/exploit_module.sh
source $MODULES/config_module.sh
source $MODULES/misc_module.sh

# boot
function boot()
{
    if ! ps -ef|grep [o]penvas > /dev/null; then
        tmux send-keys -t $WINDOW_NAME.1 "openvas-start" C-m
    fi

    if ! ps -ef |grep [f]araday-server > /dev/null;then
        tmux send-keys -t $WINDOW_NAME.1 "faraday-server &" C-m
    fi
}
# Main Menu

function menu()
{
    local key
    while : 
    do
        clear
        main_banner
        date
        echo -e "Working Directory : $WDIR"
        echo -e "---------------------- Main Menu -----------------------"
        select_4 "Scanning" "Exploit" "Config" "Assist"

        read -n 1 -t 10 -s key
        echo
        case "$key" in
            1 )
                scan_manage ;;
            2 )
                exploit_manage ;;
            3 )
                config_manage ;;
            4 )
                tmux send-keys -t $WINDOW_NAME.1 "clear && cat documents/assist_main.txt" C-m 
                tmux select-pane -t $WINDOW_NAME.0 ;;
            9 ) 
                tmux kill-pane -t $SESSION_NAME.1
                tmux kill-pane -t $SESSION_NAME.0
                tmux kill-session -t $SESSION_NAME
                break ;;
            * ) 
                echo "error" ;;
        esac
    done
    exit 0
}

if [ -z ${TMUX} ]; then
    op_banner
    clear
    # Check Working Directory
    if [[ ! -d $WDIR ]]; then
        mkdir -p $WDIR
    fi
    boot
    WINDOW_NAME="Main"
    tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_NAME"
    tmux split-window -t $SESSION_NAME.0 -h
    tmux send-keys -t $SESSION_NAME.0 "$PAKURI" C-m
    tmux select-pane -t $SESSION_NAME.0
    tmux set-option -g mouse on
    tmux -2 attach -t $SESSION_NAME
else
    menu
fi
exit 0
