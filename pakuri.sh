#!/bin/bash

PAKURI=$0
source pakuri.conf
#source $MODULES/scan_module.sh
#source $MODULES/exploit_module.sh
#source $MODULES/config_module.sh
source $MODULES/misc_module.sh
#declare -a modules=("Main" "Scanning" "Exploit" "Config")

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
                tmux select-window -t "${modules[1]}";;
            2 )
                tmux select-window -t "${modules[2]}" ;;
            3 )
                tmux select-window -t "${modules[3]}" ;;
            4 )
                tmux send-keys -t "${modules[0]}".1 "clear && cat documents/assist_main.txt" C-m 
                tmux select-pane -t "${modules[0]}".0 ;;
            9 ) 
                tmux kill-window -t "${modules[3]}"
                tmux kill-window -t "${modules[2]}"
                tmux kill-window -t "${modules[1]}"
                tmux kill-pane -t "${modules[0]}".1
                tmux kill-pane -t "${modules[0]}".0
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
    #2/13 disable
    # Check Working Directory
    if [[ ! -d $WDIR ]]; then
        mkdir -p $WDIR
    fi
    #boot
    tmux new-session -d -s "$SESSION_NAME" -n "${modules[0]}"
    tmux split-window -t "${modules[0]}".0 -h
    tmux send-keys -t "${modules[0]}".0 "$PAKURI" C-m

    tmux new-window -n "${modules[1]}"
    tmux split-window -t "${modules[1]}".0 -h
    tmux send-keys -t "${modules[1]}".0 "$MODULES/scan_module.sh" C-m
    tmux select-pane -t "${modules[1]}".0

    tmux new-window -n "${modules[2]}"
    tmux split-window -t "${modules[2]}".0 -h
    tmux send-keys -t "${modules[2]}".0 "$MODULES/exploit_module.sh" C-m
    tmux select-pane -t "${modules[2]}".0

    tmux new-window -n "${modules[3]}"
    tmux split-window -t "${modules[3]}".0 -h
    tmux send-keys -t "${modules[3]}".0 "$MODULES/config_module.sh" C-m
    tmux select-pane -t "${modules[3]}".0

    tmux select-window -t "${modules[0]}"
    tmux select-pane -t $SESSION_NAME.0
    tmux set-option -g mouse on
    tmux -2 attach -t $SESSION_NAME
else
    menu
fi
exit 0
