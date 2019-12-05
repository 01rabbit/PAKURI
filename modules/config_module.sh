# Start Service
function service_start()
{
    systemctl start $1
}

# Stop Service
function service_stop()
{
    systemctl stop $1 
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
        box_3 "Mode Switching"
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

function check_faraday()
{
    if ps -ef |grep faraday-server|grep -v "grep" > /dev/null;then
        echo "Faraday Server is already running."
    else
        echo "Start Faraday Server."
        tmux send-keys -t $WINDOW_NAME.1 "faraday-server &" C-m
    fi
}

# Config main menu
function config_manage()
{
    local key
    local flg_p

    while :
    do
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        if systemctl status postgresql|grep exited >/dev/null ;then
            box_1 "PpstgreSQL ${NC}[${GREEN_b}Running${NC}]"
            flg_p=1
        else
            box_1 "PostgreSQL ${NC}[${RED_b}DOWN${NC}]"
            flg_p=0
        fi
        echo -e "${RED_b}+---+"
        echo -e "| 2 | Import data into Faraday"
        echo -e "+---+"
        echo -e "${YELLOW_b}+---+"
        echo -e "| 3 | Mode Switching"
        echo -e "+---+"
        echo -e "${GREEN_b}+---+"
        echo -e "| 4 | Configure Targets"
        echo -e "+---+"
        echo -e "${BLACK_b}+---+"
        echo -e "| 9 | Back"
        echo -e "+---+"
        echo -e "${NC}"
        read -n 1 -t 5 -s key
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        case "$key" in
            1 )
                if [ $flg_p = 1 ];then
                    echo -e "${BLUE_b}+---+"
                    echo -e "| 1 | PpstgreSQL [${GREEN_b}Running${NC}]"
                    echo -e "${BLUE_b}+---+${NC}"
                    echo -e "Do you really want to ${RED_b}stop${NC}?"
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        service_stop postgresql
                    fi
                else
                    echo -e "${BLUE_b}+---+"
                    echo -e "| 1 | PostgreSQL [${RED_b}DOWN${NC}]"
                    echo -e "${BLUE_b}+---+${NC}"
                    echo -e "Do you really want to ${GREEN_b}start${NC}?"
                    yes-no
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        service_start postgresql
                    fi
                fi ;;
            2 )
                echo -e "${RED_b}+---+"
                echo -e "| 2 | Import data into Faraday"
                echo -e "+---+"
                echo -e "${NC}"
                echo -e "Is the faraday's workspace name is $WORKSPACE? "
                yes-no
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    check_faraday
                    tmux send-keys -t $SESSION_NAME.1 "$SCRIPT_DIR/$IMPORT $WDIR $WORKSPACE" C-m
                    tmux select-pane -t $SESSION_NAME.0
                    echo -e "Please check Faraday."
                    echo -e "Press any key to continue..."
                    read
                fi ;;
            3 )
                modeswitching ;;
            4 )
                echo -e "${GREEN_b}+---+"
                echo -e "| 4 | Configure Targets"
                echo -e "+---+"
                echo -e "${NC}"
                tmux send-keys -t $SESSION_NAME.1 "nano $TARGETS;tmux select-pane -t $SESSION_NAME.0" C-m
                tmux select-pane -t $SESSION_NAME.1
                echo -e "Press any key to continue..."
                read ;;
            9 )
                break ;;
            * )
                echo -e "error" ;;
        esac
    done
}