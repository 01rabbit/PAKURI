#!/bin/bash
source source.conf

function scan_banner()
{
    echo -e "${RED}"
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
            echo -e "+---+"
            echo -e "| 1 | PortScan(Quick) ${RED} Running${NC}"
            echo -e "+---+"
            echo -e "+---+"
            echo -e "| 2 | PortScan(Full) ${RED} Running${NC}"
            echo -e "+---+"
            flg_nm=1
        else
            echo -e "+---+"
            echo -e "| 1 | PortScan(Quick)"
            echo -e "+---+"
            echo -e "+---+"
            echo -e "| 2 | PortScan(Full)"
            echo -e "+---+"
            flg_nm=0
        fi
        if ps -ef|grep autorecon.py|grep -v "grep" > /dev/null;then
            echo -e "+---+"
            echo -e "| 3 | Quick Service Scan ${RED} Running${NC}"
            echo -e "+---+"
            echo -e "+---+"
            echo -e "| 4 | Default Service Scan ${RED} Running${NC}"
            echo -e "+---+"
            flg_ar=1
        else
            echo -e "+---+"
            echo -e "| 3 | Quick Service Scan"
            echo -e "+---+"
            echo -e "+---+"
            echo -e "| 4 | Default Service Scan"
            echo -e "+---+"
            flg_ar=0
        fi
        echo -e "+---+"
        echo -e "| 9 | Back"
        echo -e "+---+"
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
                    break
                fi ;;
        esac 
        case "$key" in
            1 )
                echo -e "PortScan(Quick)"
                echo -e "+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Quick Port Scanning. Single Host"
                    echo -e "Press any key to continue..."
                    read             
                    tmux send-keys -t $WINDOW_NAME.1 "$SCAN $addr 1 Quick S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Quick Port Scanning. Multi Host"
                        echo -e "Press any key to continue..."
                        read             
                        tmux send-keys -t $WINDOW_NAME "$SCAN $TARGETS 1 Quick M" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                    else
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            2 )
                echo -e "PortScan(Full)"
                echo -e "+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Full Port Scanning. Single Host"
                    echo -e "Press any key to continue..."
                    read             
                    tmux send-keys -t $WINDOW_NAME.1 "$SCAN $addr 1 Full S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Full Port Scanning. Multi Host"
                        echo -e "Press any key to continue..."
                        read             
                        tmux send-keys -t $WINDOW_NAME "$SCAN $TARGETS 1 Full M" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                    else
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            3 )
                echo -e "Quick Service Scan"
                echo -e "+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Quick Scanning. Single Host"
                    echo -e "Press any key to continue..."
                    read             
                    tmux send-keys -t $WINDOW_NAME "$SCAN $addr 2 Quick S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Quick Scanning. Multi Host"
                        echo -e "Press any key to continue..."
                        read             
                        tmux send-keys -t $WINDOW_NAME "$SCAN $TARGETS 2 Quick M" C-m 
                        tmux select-pane -t $WINDOW_NAME.0
                    else
                        echo -e "Press any key to continue..."
                        read
                    fi
                fi ;;
            4 )
                echo -e "Default Service Scan"
                echo -e "+---+"
                echo -e "| 1 | Single"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 2 | Multi"
                echo -e "+---+"
                echo -e "+---+"
                echo -e "| 9 | Back"
                echo -e "+---+"
                read -n 1 -s ans
                if [ $ans = 1 ];then
                    read -p "IP Address :" addr
                    echo -e "Start Quick Scanning. Single Host"
                    echo -e "Press any key to continue..."
                    read             
                    tmux send-keys -t $WINDOW_NAME "$SCAN $addr 2 Default S" C-m
                    tmux select-pane -t $WINDOW_NAME.0
                else 
                    if [ $ans = 2 ];then
                        echo -e "Start Quick Scanning. Multi Host"
                        echo -e "Press any key to continue..."
                        read             
                        tmux send-keys -t $WINDOW_NAME "$SCAN $TARGETS 2 Default M" C-m
                        tmux select-pane -t $WINDOW_NAME.0
                    else
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

scan_manage