#!/bin/bash

PAKURI=$0
source pakuri.conf
source $MODULES/misc_module.sh

# Main Menu
function menu()
{
    local key
    while : 
    do
        clear
        main_banner
        
        echo -e "Workspace: $WORKSPACE"
        echo -e "---------- Main Menu -----------"
        select_4 "Scanning" "Exploit" "Config" "Assist"

        read -n 1 -t 10 -s key
        echo
        case "$key" in
            1 )
                tmux select-window -t "${modules[1]}"
                tmux select-pane -t "${modules[1]}".0 ;;
            2 )
                tmux select-window -t "${modules[2]}"
                tmux select-pane -t "${modules[2]}".0 ;;
            3 )
                tmux select-window -t "${modules[3]}"
                tmux select-pane -t "${modules[3]}".0 ;;
            4 )
                tmux send-keys -t "${modules[0]}".1 "$MODULES/help/assist_module.sh main" C-m 
                tmux select-pane -t "${modules[0]}".0 ;;
            9 ) 
                tmux kill-window -t "f-client"
                tmux kill-window -t "${modules[3]}"
                tmux kill-window -t "${modules[2]}"
                tmux kill-window -t "${modules[1]}"
                tmux kill-pane -t "${modules[0]}".1
                tmux kill-pane -t "${modules[0]}".0
                tmux kill-session -t $SESSION_NAME
                break ;;
            * ) 
                ;;
        esac
    done
    exit 0
}

if [ -z ${TMUX} ]; then   
    # Check Working Directory
    if [[ ! -d $WDIR ]]; then
        mkdir -p $WDIR
    fi

    #boot
    tmux new-session -d -s "$SESSION_NAME" -n "${modules[0]}"
    tmux split-window -t "${modules[0]}".0 -h -p 80

    tmux new-window -n "f-client"
    tmux send-keys -t "f-client" "faraday-client -n $MYIP --gui=no-gui -w $WORKSPACE" C-m
    op_banner
    boot_check
    # sleep 5
    clear
    tmux new-window -n "${modules[1]}"
    tmux split-window -t "${modules[1]}".0 -h -p 80
    tmux send-keys -t "${modules[1]}".1 "faraday-terminal $MYIP 9977" C-m

    tmux new-window -n "${modules[2]}"
    tmux split-window -t "${modules[2]}".0 -h -p 80
    
    tmux new-window -n "${modules[3]}"
    tmux split-window -t "${modules[3]}".0 -h -p 80
    
    tmux select-window -t "${modules[0]}"
    tmux send-keys -t "${modules[0]}".1 "faraday-terminal $MYIP 9977" C-m

    tmux select-pane -t $SESSION_NAME.0
    tmux set-option -g mouse on
    tmux bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -sel clip > /dev/null"
    tmux bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -i -sel clip > /dev/null"
    tmux send-keys -t "${modules[0]}".0 "$PAKURI" C-m
    tmux send-keys -t "${modules[1]}".0 "$MODULES/scan_module.sh" C-m
    tmux send-keys -t "${modules[2]}".0 "$MODULES/exploit_module.sh" C-m
    tmux send-keys -t "${modules[3]}".0 "$MODULES/config_module.sh" C-m
    tmux -2 attach -t $SESSION_NAME
else
    menu
fi
exit 0
