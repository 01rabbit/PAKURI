#!/bin/bash
source pakuri.conf
source $MODULES_PATH/misc_module.sh

# Start Service
function service_start()
{
    sudo systemctl start $1
}

# Stop Service
function service_stop()
{
    sudo systemctl stop $1 
}

# Change CUI/GUI
function modeswitching()
{
    local mode
    local mode_v
    local KEY

    while :
    do
        mode=`systemctl get-default`
        if [ "graphical.target" = $mode ]; then
            mode_v="GUI"
        else
            mode_v="CUI"
        fi
        clear
        config_banner
        box_4 "Mode Switching"
        echo -e "--------- Now mode $mode_v ---------"
        select_2 "Switch CUI mode" "Switch GUI mode"
        read -n 1 -s KEY
        clear
        config_banner
        box_4 "Mode Switching"
        echo -e "--------- Now mode $mode_v ---------"
        case "$KEY" in
            1 )
                box_1 "Switch CUI mode"
                echo -e "CUI mode is enabled after a reboot"
                systemctl set-default -f multi-user.target ;;
            2 )
                box_2 "Switch GUI mode"
                echo -e "GUI mode is enabled after a reboot"
                systemctl set-default -f graphical.target ;;
            9 )
                break ;;
            * ) 
                echo -e "error" ;;
        esac
        read -p "Press Enter to continue..."
    done
}

function service_menu()
{
    local flg_p
    local flg_o
    local KEY
    local Ans

    while :
    do
        if systemctl status postgresql|grep "active (exited)" >/dev/null ;then
            flg_p=1
        else
            flg_p=0
        fi
        if ps -ef|grep [o]penvas > /dev/null; then
            flg_o=1
        else
            flg_o=0
        fi
        clear
        config_banner
        box_2 "Configure Service"
        echo -e "-------- Service Menu ----------"
        if [ $flg_p = 1 ];then
            box_1 "PpstgreSQL ${NC}[${GREEN_b}Running${NC}]"
        else
            box_1 "PostgreSQL ${NC}[${RED_b}DOWN${NC}]"
        fi
        if [ $flg_o = 1 ];then
            box_2 "OpenVAS ${NC}[${GREEN_b}Running${NC}]"
        else
            box_2 "OpenVAS ${NC}[${RED_b}DOWN${NC}]"
        fi
        box_9
        read -n 1 -s KEY
        clear
        config_banner
        box_2 "Configure Service"
        echo -e "-------- Service Menu ----------"
        case "$KEY" in
        1 )
            if [ $flg_p = 1 ];then
                box_1 "PpstgreSQL ${NC}[${GREEN_b}Running${NC}]"
                echo -e "Do you want it to ${RED_b}stop${NC}?"
                yes-no
                read -n 1 -s Ans
                if [ $Ans -eq 1 ];then
                    service_stop postgresql
                fi
            else
                box_1 "PostgreSQL ${NC}[${RED_b}DOWN${NC}]"
                echo -e "Do you want it to ${GREEN_b}start${NC}?"
                yes-no
                read -n 1 -s Ans
                if [ $Ans -eq 1 ];then
                    service_start postgresql
                fi
            fi ;;
        2 )
            if [ $flg_o = 1 ];then
                box_2 "OpenVAS ${NC}[${GREEN_b}Running${NC}]"
                echo -e "Do you want it to ${RED_b}stop${NC}?"
                yes-no
                read -n 1 -s Ans
                if [ $Ans -eq 1 ];then
                    tmux send-keys -t $WINDOW_NAME.1 "sudo openvas-stop" C-m
                    tmux select-pane -t $SESSION_NAME.0
                fi
            else
                box_2 "OpenVAS ${NC}[${RED_b}DOWN${NC}]"
                echo -e "Do you want it to ${GREEN_b}start${NC}?"
                yes-no
                read -n 1 -s Ans
                if [ $Ans -eq 1 ];then
                    tmux send-keys -t $WINDOW_NAME.1 "sudo openvas-start" C-m
                    tmux select-pane -t $SESSION_NAME.0
                fi
            fi ;;
        9 )
            break ;;
        esac
    done
}

# Config main menu
function config_manage()
{
    local KEY

    while :
    do
        clear
        config_banner
        select_4 "Configure Targets" "Configure Service" "Mode Switching" "Help"
        read -n 1 -t 25 -s KEY
        clear
        config_banner
        case "$KEY" in
            1 )
                box_1 "Configure Targets"
                tmux send-keys -t $SESSION_NAME.1 "nano $TARGETS;tmux select-pane -t $SESSION_NAME.0" C-m
                tmux select-pane -t $SESSION_NAME.1
                echo -e "Input your targets."
                echo -e "This is an edit using nano. After editing, press Ctrl+X to save and exit."
                echo -e ""
                read -p "Press Enter to continue..."
                ;;
            2 )
                box_2 "Configure Service"
                echo -e "-------- Service Menu ----------"
                service_menu
                ;;
            3 )
                modeswitching ;;
            4 )
                tmux send-keys -t $WINDOW_NAME.1 "$MODULES_PATH/help/config_help_module.sh main" C-m 
                tmux select-pane -t $WINDOW_NAME.0 ;;
            9 )
                tmux select-window -t "${modules[0]}" ;;
            * )
                ;;
        esac
    done
}
config_manage