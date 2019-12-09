#!/bin/bash

PAKURI=$0
source source.conf
source modules/scan_module.sh
source modules/exploit_module.sh
source modules/config_module.sh
source modules/misc_module.sh


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
        select_3 "Scanning" "Exploit" "Config"

        read -n 1 -t 10 -s key
        echo
        case "$key" in
            1 )
                scan_manage ;;
            2 )
                exploit_manage ;;
            3 )
                config_manage ;;
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

    WINDOW_NAME="Main"
    tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_NAME"
    tmux split-window -t $SESSION_NAME.0 -h
    tmux send-keys -t $SESSION_NAME.0 "$PAKURI" C-m
    tmux select-pane -t $SESSION_NAME.0
    tmux -2 attach -t $SESSION_NAME
else
    menu
fi
exit 0
