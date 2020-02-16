#!/bin/bash
source pakuri.conf
source $MODULES/misc_module.sh

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
    local key

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
        date
        echo -e "------------------- Config Menu --------------------"
        box_4 "Mode Switching"
        echo -e "-------------------- Now mode $mode_v -------------------"
        select_2 "Switch CUI mode" "Switch GUI mode"
        read -n 1 -s key
        clear
        config_banner
        date
        echo -e "-------------------- Now mode $mode_v -------------------"
        case "$key" in
            1 )
                box_1 "Switch CUI mode"
                echo -e "CUI mode enabled after reboot"
                systemctl set-default -f multi-user.target ;;
            2 )
                box_2 "Switch GUI mode"
                echo -e "GUI mode enabled after reboot"
                systemctl set-default -f graphical.target ;;
            9 )
                break ;;
            * ) 
                echo -e "error" ;;
        esac
        echo -e "Press any key to continue..."
        read
    done
}

function service_menu()
{
    while :
    do
        if systemctl status postgresql|grep "active (exited)" >/dev/null ;then
            flg_p=1
        else
            flg_p=0
        fi
        if systemctl status faraday-server.service |grep "active (running)" >/dev/null ;then
            flg_f=1
        else
            flg_f=0
        fi
        if ps -ef|grep [o]penvas > /dev/null; then
            flg_o=1
        else
            flg_o=0
        fi
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        box_2 "Configure Service"
        echo -e "------------------- Service Menu -------------------"
        if [ $flg_p = 1 ];then
            box_1 "PpstgreSQL ${NC}[${GREEN_b}Running${NC}]"
        else
            box_1 "PostgreSQL ${NC}[${RED_b}DOWN${NC}]"
        fi
        if [ $flg_f = 1 ];then
            box_2 "Faraday ${NC}[${GREEN_b}Running${NC}]"
        else
            box_2 "Faraday ${NC}[${RED_b}DOWN${NC}]"
        fi
        if [ $flg_o = 1 ];then
            box_3 "OpenVAS ${NC}[${GREEN_b}Running${NC}]"
        else
            box_3 "OpenVAS ${NC}[${RED_b}DOWN${NC}]"
        fi
        box_9
        read -n 1 -t 5 -s key
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        box_2 "Configure Service"
        echo -e "------------------- Service Menu -------------------"
        case "$key" in
        1 )
            if [ $flg_p = 1 ];then
                box_1 "PpstgreSQL ${NC}[${GREEN_b}Running${NC}]"
                echo -e "Do you really want to ${RED_b}stop${NC}?"
                yes-no
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
                    service_stop postgresql
                fi
            else
                box_1 "PostgreSQL ${NC}[${RED_b}DOWN${NC}]"
                echo -e "Do you really want to ${GREEN_b}start${NC}?"
                yes-no
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
                    service_start postgresql
                fi
            fi ;;
        2 )
            if [ $flg_f = 1 ];then
                box_2 "Faraday ${NC}[${GREEN_b}Running${NC}]"
                echo -e "Do you really want to ${RED_b}stop${NC}?"
                yes-no
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
                    service_stop faraday-server.service
                fi
            else
                box_2 "Faraday ${NC}[${RED_b}DOWN${NC}]"
                if [ $flg_p = 0 ];then
                    echo -e "Please Start PostgreSQL."
                    echo -e ""
                    echo -e "Press any key to continue..."
                    read
                else
                    echo -e "Do you really want to ${GREEN_b}start${NC}?"
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        service_start faraday-server.service
                    fi
                fi
            fi ;;
        3 )
            if [ $flg_o = 1 ];then
                box_3 "OpenVAS ${NC}[${GREEN_b}Running${NC}]"
                echo -e "Do you really want to ${RED_b}stop${NC}?"
                yes-no
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
                    tmux send-keys -t $WINDOW_NAME.1 "sudo openvas-stop" C-m
                    tmux select-pane -t $SESSION_NAME.0
                fi
            else
                box_3 "OpenVAS ${NC}[${RED_b}DOWN${NC}]"
                echo -e "Do you really want to ${GREEN_b}start${NC}?"
                yes-no
                read -n 1 -s ans
                if [ $ans -eq 1 ];then
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
    local key
    local flg_f

    while :
    do
        if systemctl status faraday-server.service |grep "active (running)" >/dev/null ;then
            flg_f=1
        else
            flg_f=0
        fi
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        select_4 "Configure Targets" "Configure Service" "Import data into Faraday" "Mode Switching"
        read -n 1 -t 5 -s key
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        case "$key" in
            1 )
                box_1 "Configure Targets"
                tmux send-keys -t $SESSION_NAME.1 "nano $INSTALL_DIR/$TARGETS;tmux select-pane -t $SESSION_NAME.0" C-m
                tmux select-pane -t $SESSION_NAME.1
                echo -e "Input your targets."
                echo -e "This is edited with nano. Enter with Ctrl + x to exit."
                echo -e ""
                echo -e "Press any key to continue..."
                read ;;
            2 )
                box_2 "Configure Service"
                echo -e "------------------- Service Menu -------------------"
                service_menu
                ;;
            3 )
                box_3 "Import data into Faraday"
                if [ $flg_f = 0 ];then
                    echo -e "Please Start Faraday."
                    echo -e ""
                    echo -e "Press any key to continue..."
                    read
                else
                    echo -e "Is the faraday's workspace name is $WORKSPACE? "
                    yes-no
                    read -n 1 -s ans
                    if [ $ans = 1 ];then
                        tmux send-keys -t $SESSION_NAME.1 "$INSTALL_DIR/$IMPORT $WDIR $WORKSPACE" C-m
                        tmux select-pane -t $SESSION_NAME.0
                        echo -e "Please check Faraday."
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            4 )
                modeswitching ;;
            9 )
                tmux select-window -t "${modules[0]}" ;;
            * )
                echo -e "error" ;;
        esac
    done
}
config_manage