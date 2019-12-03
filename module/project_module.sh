function pj_banner()
{
    echo -e "${BLUE_b}"
    echo -e " ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗"
    echo -e " ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝"
    echo -e " ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║   "
    echo -e " ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║   "
    echo -e " ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║   "
    echo -e " ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   "
    echo -e "${NC}"
}

# Project management main menu
function pj_manage()
{
    #local wdir
    local key
    local name

    while :
    do
        clear
        pj_banner
        date
        echo -e "---------------- Please select an operation. ---------------"
        echo -e "+---+"
        echo -e "| 1 | Configure Targets"
        echo -e "+---+"
        echo -e "+---+"
        echo -e "| 2 | Import data into Faraday"
        echo -e "+---+"
        echo -e "+---+"
        echo -e "| 9 | Back"
        echo -e "+---+"
        read -n 1 -s key
        clear
        pj_banner
        date
        echo -e "---------------- Please select an operation. ---------------"
        case "$key" in
            1)
                tmux send-keys -t $SESSION_NAME.1 "nano $TARGETS" C-m
                tmux select-pane -t $SESSION_NAME.0
                echo -e "Press any key to continue..."
                read ;;
            2)
                echo -e "+---+"
                echo -e "| 2 | Import data into Faraday"
                echo -e "+---+"
                echo -n "Please imput faraday's workspace name :"
                read name
                echo -e "Is the faraday's workspace name is $name? "
                echo -e "${GREEN_b}+---+         ${RED_b}+---+${NC}"
                echo -e "${GREEN_b}| 1 | yes  ${NC}|  ${RED_b}| 2 | no${NC}"
                echo -e "${GREEN_b}+---+         ${RED_b}+---+${NC}"
                read -n 1 -s ans
                case "$ans" in
                    1|y|Y )
                    module/import-faraday.sh $WDIR $name
                    echo -e "Please check Faraday"
                    ;;
                    * )
                    echo -e "Abort." ;;
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