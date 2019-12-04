function scan_banner()
{
    echo -e "${BLUE}"
    echo -e " ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗██╗███╗   ██╗ ██████╗ "
    echo -e " ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██║████╗  ██║██╔════╝ "
    echo -e " ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗"
    echo -e " ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██║██║╚██╗██║██║   ██║"
    echo -e " ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║██║██║ ╚████║╚██████╔╝"
    echo -e " ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ "
    echo -e "${NC}"
}

function scan_manage()
{
    local key
    local ans
    local flg_ar
    local flg_nm

    while :
    do
        clear
        scan_banner
        date
        echo -e "------------------------ Scan Menu -------------------------"
        if ps -ef|grep nmap|grep -v "grep" > /dev/null;then
            echo -e "${BLUE_b}+---+"
            echo -e "| 1 | Check Host ${RED} Running"
            echo -e "${BLUE_b}+---+"
            echo -e "${RED_b}+---+"
            echo -e "| 2 | PortScan(Quick) ${RED} Running"
            echo -e "${RED_b}+---+"
            echo -e "${YELLOW_b}+---+"
            echo -e "| 3 | PortScan(Full) ${RED} Running"
            echo -e "${YELLOW_b}+---+"
            flg_nm=1
        else
            echo -e "${BLUE_b}+---+"
            echo -e "| 1 | Check Host"
            echo -e "+---+"
            echo -e "${RED_b}+---+"
            echo -e "| 2 | PortScan(Quick)"
            echo -e "+---+"
            echo -e "${YELLOW_b}+---+"
            echo -e "| 3 | PortScan(Full)"
            echo -e "+---+"
            flg_nm=0
        fi
        if ps -ef|grep autorecon.py|grep -v "grep" > /dev/null;then
            echo -e "${GREEN_b}+---+"
            echo -e "| 4 | Service Scan ${RED} Running"
            echo -e "${GREEN_b}+---+"
            flg_ar=1
        else
            echo -e "${GREEN_b}+---+"
            echo -e "| 4 | Service Scan"
            echo -e "+---+"
            flg_ar=0
        fi
        echo -e "${BLACK_b}+---+"
        echo -e "| 9 | Back"
        echo -e "+---+"
        echo -e "${NC}"
        read -n 1 -t 5 -s key
        clear
        scan_banner
        date
        echo -e "------------------------ Scan Menu -------------------------"
        case "$key" in
            1|2|3|4)
                if [ $flg_nm = 1 ] || [ $flg_ar = 1 ];then
                    echo -e "Scan process is Running!"
                    echo -e "Please check your right panel"
                    echo -e "Press any key to continue..."
                    read
                fi ;;
        esac 
        case "$key" in
            1 )
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Check Host"
                echo -e "+---+"
                echo -e "${NC}"
                echo -e "---------------------- Select Action -----------------------"
                echo -e ""
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "${RED_b}+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "${BLACK_b}+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                echo -e "${NC}"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Host Up Checking. Single Host"            
                    tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $addr 1 Check S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read 
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Host Up Checking. Multi Host"             
                        tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $SCRIPT_DIR/$TARGETS 1 Check M" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            2 )
                echo -e "${RED_b}+---+"
                echo -e "| 2 | PortScan(Quick)"
                echo -e "+---+"
                echo -e "${NC}"
                echo -e "---------------------- Select Action -----------------------"
                echo -e ""
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "${RED_b}+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "${BLACK_b}+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                echo -e "${NC}"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Quick Port Scanning. Single Host"            
                    tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $addr 1 Quick S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read 
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Quick Port Scanning. Multi Host"             
                        tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $SCRIPT_DIR/$TARGETS 1 Quick M" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            3 )
                echo -e "${YELLOW_b}+---+"
                echo -e "| 3 | PortScan(Full)"
                echo -e "+---+"
                echo -e "${NC}"
                echo -e "---------------------- Select Action -----------------------"
                echo -e ""
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "${RED_b}+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "${BLACK_b}+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                echo -e "${NC}"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Full Port Scanning. Single Host"            
                    tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $addr 1 Full S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read 
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Full Port Scanning. Multi Host"             
                        tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $SCRIPT_DIR/$TARGETS 1 Full M" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            4 )
                echo -e "${GREEN_b}+---+"
                echo -e "| 4 | Service Scan"
                echo -e "+---+"
                echo -e "${NC}"
                echo -e "---------------------- Select Action -----------------------"
                echo -e ""
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "${RED_b}+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "${BLACK_b}+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                echo -e "${NC}"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Service Scanning. Single Host"             
                    tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $addr 2 Default S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Service Scanning. Multi Host"             
                        tmux send-keys -t $WINDOW_NAME.1 "$SCRIPT_DIR/$SCAN $SCRIPT_DIR/$TARGETS 2 Default M" C-m
                        tmux select-pane -t $WINDOW_NAME.0
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            9 )
                break ;;
            * )
                ;;
        esac
    done
}