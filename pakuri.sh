#!/bin/bash

PAKURI=$0
source pakuri.conf
source $MODULES_PATH/misc_module.sh
source $MODULES_PATH/config/config_module.sh
source $MODULES_PATH/recon/recon_module.sh
source $MODULES_PATH/check/check_module.sh

function operationScreen() {
    while :; do
        clear
        service_check
        operation_menu
        default
        NUM=""
        read -n 1 -s NUM
        KEY=""
        case "$NUM" in
        0)
            clear
            operation_menu
            num_top
            KEY=0
            ;;
        1)
            clear
            operation_menu
            num_recon
            KEY=1
            ;;
        3)
            clear
            operation_menu
            num_check
            KEY=3
            ;;
        4)
            clear
            operation_menu
            num_attack
            KEY=4
            ;;
        6)
            clear
            operation_menu
            num_config
            KEY=6
            ;;
        # 7)
        #     clear
        #     operation_menu
        #     num_assist
        #     KEY=7
        #     ;;
        9)
            clear
            operation_menu
            num_exit
            KEY=9
            ;;
        esac
        sleep 0.2
        clear
        operation_menu
        default

        case "$KEY" in
        0) mainScreen ;;
        1) recon_manage ;;
        3) check_manage ;;
        4)
            WINDOWNAME="Attack"
            if tmux list-window | grep ${WINDOWNAME} >/dev/null; then
                tmux select-window -t ${WINDOWNAME}
            else
                tmux new-window -n ${WINDOWNAME}
                tmux send-keys -t ${WINDOWNAME} "$MODULES_PATH/attack/attack_module.sh;exit" C-m
            fi
            ;;
        6) config_manage ;;
        7) ;; #assist
        9)
            tmux kill-session -t $SESSION_NAME
            break
            ;;
        esac
    done
    exit 0
}
function mainScreen() {
    while :; do
        clear
        webserviceCheck
        service_check
        main_menu
        top_keyOP
        NUM=""
        read -n 1 -t 30 -s NUM
        if [[ $NUM = 0 ]]; then
            clear
            main_menu
            num_menu
            sleep 0.2
            operationScreen
        fi
    done
}

if [ -z ${TMUX} ]; then
    # Check Working Directory
    if [[ ! -d $WDIR ]]; then
        mkdir -p $WDIR
    fi

    #boot
    tmux new-session -d -s "$SESSION_NAME" -n "${modules[0]}"

    op_banner
    boot_check
    sleep 2
    clear
    tmux set-option -g mouse on
    tmux bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -sel clip > /dev/null"
    tmux bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -i -sel clip > /dev/null"
    tmux send-keys -t "${modules[0]}".0 "$PAKURI" C-m
    tmux -2 attach -t $SESSION_NAME
else
    mainScreen
fi
exit 0
