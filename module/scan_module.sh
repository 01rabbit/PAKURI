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

# $1 IP Address or IP list
# $2 Arguments
# $3 S or M S:Sngle Host M:Multi Host
function scan_nmap()
{
    DATE=`date '+%Y%m%d%H%M'`
    cd $WDIR
    if [[ ! -d $WDIR/nmap ]]; then
	mkdir $WDIR/nmap
    fi

    case $2 in
    Check )
        CHECK="$WDIR/nmap/$DATE-hostup"
        if [ $3 = "S" ];then
            tmux send-keys -t $WINDOW_NAME.1 "nmap -sn -PE $1 -oN $CHECK-$1.nmap -oX $CHECK-$1.xml" C-m
        elif [ $3 = "M" ];then
            tmux send-keys -t $WINDOW_NAME.1 "nmap -sn -PE -iL $1 --exclude $MYIP -oN $CHECK-multi.nmap -oX $CHECK-multi.xml" C-m
        fi ;;
    Quick )
        QUICK="$WDIR/nmap/$DATE-Quick"
        tmux send-keys -t $WINDOW_NAME.1 "nmap -T4 -p- --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --open -oN $QUICK.nmap -oX $QUICK.xml -iL $1" C-m
        ;;
    Full )
        FULL="$WDIR/nmap/$DATE-Full"
        tmux send-keys -t $WINDOW_NAME.1 "nmap -T4 -p- -v --max-retries 1 --max-scan-delay 20 --max-rate 300 -oN $FULL.nmap -oX $FULL.xml -iL $1" C-m
        ;;
    esac
}

# $1 IP Address or IP list
# $2 S or M S:Sngle Host M:Multi Host
function scan_autorecon()
{
    if [ $2 = "S" ];then
        tmux send-keys -t $WINDOW_NAME.1 "$AUTORECON $1 -v -o $WDIR --only-scans-dir" C-m
    elif [ $2 = "M" ];then
        tmux send-keys -t $WINDOW_NAME.1 "$AUTORECON -t $1 -v -o $WDIR --only-scans-dir" C-m
    fi
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
            echo -e "| 1 | Host Scan ${RED} Running"
            echo -e "${BLUE_b}+---+"
            echo -e "${RED_b}+---+"
            echo -e "| 2 | Port Scan ${RED} Running"
            echo -e "${RED_b}+---+"
            flg_nm=1
        else
            echo -e "${BLUE_b}+---+"
            echo -e "| 1 | Host Scan"
            echo -e "+---+"
            echo -e "${RED_b}+---+"
            echo -e "| 2 | Port Scan"
            echo -e "+---+"
            flg_nm=0
        fi
        if ps -ef|grep autorecon.py|grep -v "grep" > /dev/null;then
            echo -e "${YELLOW_b}+---+"
            echo -e "| 3 | Service Scan ${RED} Running"
            echo -e "${YELLOW_b}+---+"
            flg_ar=1
        else
            echo -e "${YELLOW_b}+---+"
            echo -e "| 3 | Service Scan"
            echo -e "+---+"
            flg_ar=0
        fi
        echo -e "${GREEN_b}+---+"
        echo -e "| 4 | Vulnerability Scan"
        echo -e "+---+"
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
                echo -e "| 1 | Host Scan"
                echo -e "+---+${NC}"
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
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Host Scan"
                echo -e "+---+${NC}"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    echo -e "${BLUE_b}+---+"
                    echo -e "| 1 | Single"
                    echo -e "+---+${NC}"
                    read -p "IP Address :" addr
                    echo -e "Start Host Up Checking. Single Host"            
                    scan_nmap $addr Check S
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                elif [ $ans = 2 ];then
                    echo -e "${RED_b}+---+"
                    echo -e "| 2 | Multi"
                    echo -e "+---+${NC}"
                    echo -e "Start Host Up Checking. Multi Host"             
                    scan_nmap $SCRIPT_DIR/$TARGETS Check M
                    tmux select-pane -t $WINDOW_NAME.0
                    echo -e "Press any key to continue..."
                    read
                fi ;;
            2 )
                echo -e "${RED_b}+---+"
                echo -e "| 2 | PortScan"
                echo -e "+---+${NC}"
                echo -e "---------------------- Select Action -----------------------"
                echo -e ""
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 | Quick"
                echo -e "+---+"
                echo -e "${RED_b}+---+"
                echo -e "| 2 | Full"
                echo -e "+---+"
                echo -e "${BLACK_b}+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                echo -e "${NC}"
                read -n 1 -s ans
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                echo -e "${RED_b}+---+"
                echo -e "| 2 | PortScan"
                echo -e "+---+${NC}"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    echo -e "${BLUE_b}+---+"
                    echo -e "| 1 | Quick"
                    echo -e "+---+${NC}"
                    echo -e "Start Quick Port Scanning." 
                    scan_nmap $SCRIPT_DIR/$TARGETS Quick
                elif [ $ans = 2 ];then
                    echo -e "${RED_b}+---+"
                    echo -e "| 2 | Full"
                    echo -e "+---+${NC}"
                    echo -e "Start Full Port Scanning." 
                    scan_nmap $SCRIPT_DIR/$TARGETS Full            
                fi
                tmux select-pane -t $WINDOW_NAME.0
                echo -e "Press any key to continue..."
                read ;;
            3 )
                echo -e "${YELLOW_b}+---+"
                echo -e "| 3 | Service Scan"
                echo -e "+---+${NC}"
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
                clear
                scan_banner
                date
                echo -e "------------------------ Scan Menu -------------------------"
                echo -e "${YELLOW_b}+---+"
                echo -e "| 3 | Service Scan"
                echo -e "+---+${NC}"
                echo -e "---------------------- Select Action -----------------------"
                if [ $ans = 1 ];then
                    echo -e "${BLUE_b}+---+"
                    echo -e "| 1 | Single"
                    echo -e "+---+${NC}"
                    read -p "IP Address :" addr
                    echo -e "Start Service Scanning. Single Host"             
                    scan_autorecon $addr S
                elif [ $ans = 2 ];then
                    echo -e "${RED_b}+---+"
                    echo -e "| 2 | Multi"
                    echo -e "+---+${NC}"
                    echo -e "Start Service Scanning. Multi Host"             
                    scan_autorecon $SCRIPT_DIR/$TARGETS M
                fi
                tmux select-pane -t $WINDOW_NAME.0
                echo -e "Press any key to continue..."
                read ;;
            9 )
                break ;;
            * )
                ;;
        esac
    done
}