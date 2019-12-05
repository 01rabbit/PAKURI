function pj_banner()
{
    echo -e "${GREEN}"
    echo -e " ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗"
    echo -e " ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝"
    echo -e " ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║   "
    echo -e " ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║   "
    echo -e " ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║   "
    echo -e " ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   "
    echo -e "${NC}"
}

function check_faraday()
{
    if ps -ef |grep faraday-server|grep -v "grep" > /dev/null;then
        echo "Faraday Server is already running."
    else
        echo "Start Faraday Server."
        faraday-server &
    fi
}

function pj_manage()
{
    local key
    source module/import-faraday.sh
    
    while :
    do
        clear
        pj_banner
        date
        echo -e "---------------- Please select an operation. ---------------"
        echo -e "${BLUE_b}+---+"
        echo -e "| 1 | Configure Targets"
        echo -e "+---+"
        echo -e "${RED_b}+---+"
        echo -e "| 2 | Import data into Faraday"
        echo -e "+---+"
        echo -e "${BLACK_b}+---+"
        echo -e "| 9 | Back"
        echo -e "+---+"
        echo -e "${NC}"
        read -n 1 -s key
        clear
        pj_banner
        date
        echo -e "---------------- Please select an operation. ---------------"
        case "$key" in
            1)
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Configure Targets"
                echo -e "+---+"
                echo -e "${NC}"
                tmux send-keys -t $SESSION_NAME.1 "nano $TARGETS;tmux select-pane -t $SESSION_NAME.0" C-m
                tmux select-pane -t $SESSION_NAME.1
                echo -e "Press any key to continue..."
                read ;;
            2)
                echo -e "${RED_b}+---+"
                echo -e "| 2 | Import data into Faraday"
                echo -e "+---+"
                echo -e "${NC}"
                echo -e "Is the faraday's workspace name is $WORKSPACE? "
                echo -e "${BLUE_b}+---+         ${RED_b}+---+"
                echo -e "${BLUE_b}| 1 | yes  ${NC}|  ${RED_b}| 2 | no"
                echo -e "${BLUE_b}+---+         ${RED_b}+---+"
                echo -e "${NC}"
                read -n 1 -s ans
                case "$ans" in
                    1|y|Y )
                    check_faraday
                    tmux send-keys -t $SESSION_NAME.1 "$SCRIPT_DIR/$IMPORT $WDIR $WORKSPACE" C-m
                    tmux select-pane -t $SESSION_NAME.0
                    echo -e "Please check Faraday."
                    ;;
                    * )
                    echo -e "Please check config file." ;;
                esac
                echo -e "Press any key to continue..."
                read ;;
            9)
                break ;;
            * )
                ;;
        esac
    done
}