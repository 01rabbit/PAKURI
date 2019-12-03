#!/bin/bash

PAKURI=$0
source source.conf

# Opening Banner
function op_banner()
{
    clear
    echo -e ""
    echo -e "                ${BLACK_b}...(gMMMMMNg,."
    echo -e "             ${BLACK_b}.(MMMMMMMMMMMMMMMMa,"
    echo -e "       ${BLACK_b}..NMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "     ${BLACK_b}.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMa.."
    echo -e "    ${BLACK_b}JMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNJ."
    echo -e "   ${BLACK_b}.MMMMMTMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNg,"
    echo -e "  ${BLACK_b}.MMMM[${GREEN}00.${BLACK_b}MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm."
    echo -e "   ${BLACK_b}MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm."
    echo -e "   ${BLACK_b}(MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMa."
    echo -e "    ${BLACK_b}?MMMMMMM{ 7HMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMF"
    echo -e "       ${BLACK_b},MMMM]    7MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    echo -e "         ${BLACK_b}WMMb      ?WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "         ${YELLOW}J${BLACK_b}dMM${YELLOW}L        ${BLACK_b}?WMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "      ${RED_b}.Jy${YELLOW}yt${BLACK_b}dMb${YELLOW}++.       ${BLACK_b}.WMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "     ${RED_b}?7777uww${BLACK_b}w${RED_b}XXZV!      ${BLACK_b} .TMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "          ${RED_b}.XyyX0Z${YELLOW}>          ${BLACK_b}JMMMM#    ?THMMMMMMMMMMMMMMMMMm,"
    echo -e "           ${RED_b}.UVtZ${YELLOW}>!          ${BLACK_b}(MMMD          -TMMMMMMMMMMMMMMMNx"
    echo -e "          ${RED_b}.JktZ${YELLOW}><         ${BLACK_b}..M@'                ?TMMMMMHMMMMMMMp."
    echo -e "        ${RED_b}.ZVVY=${YELLOW}<!! ${BLACK_b}dMJ,.. gM@'                     -HMMMN, ?TMMMMN,"
    echo -e "                     ${BLACK_b}dMMMML.,                       ?MMMMm.   7WMMM_"
    echo -e "                 ${BLACK_b}.dMNMMM  MMN,                        ?MMMN,     (TF"
    echo -e "                             ${BLACK_b}T                          (HMMN,"
    echo -e "                                                           ${BLACK_b}TMMe"
    echo -e "                                                             ${BLACK_b}.^'${GREEN_b}"
    echo -e " ██▓███        ▄▄▄            ██ ▄█▀      █    ██       ██▀███        ██▓"
    echo -e "▓██░  ██▒     ▒████▄          ██▄█▒       ██  ▓██▒     ▓██ ▒ ██▒     ▓██▒"
    echo -e "▓██░ ██▓▒     ▒██  ▀█▄       ▓███▄░      ▓██  ▒██░     ▓██ ░▄█ ▒     ▒██▒"
    echo -e "▒██▄█▓▒ ▒     ░██▄▄▄▄██      ▓██ █▄      ▓▓█  ░██░     ▒██▀▀█▄       ░██░"
    echo -e "▒██▒ ░  ░ ██▓  ▓█   ▓██▒ ██▓ ▒██▒ █▄ ██▓ ▒▒█████▓  ██▓ ░██▓ ▒██▒ ██▓ ░██░"
    echo -e "▒▓▒░ ░  ░ ▒▓▒  ▒▒   ▓▒█░ ▒▓▒ ▒ ▒▒ ▓▒ ▒▓▒ ░▒▓▒ ▒ ▒  ▒▓▒ ░ ▒▓ ░▒▓░ ▒▓▒ ░▓  "
    echo -e "░▒ ░      ░▒    ▒   ▒▒ ░ ░▒  ░ ░▒ ▒░ ░▒  ░░▒░ ░ ░  ░▒    ░▒ ░ ▒░ ░▒   ▒ ░"
    echo -e "░░        ░     ░   ▒    ░   ░ ░░ ░  ░    ░░░ ░ ░  ░     ░░   ░  ░    ▒ ░"
    echo -e "           ░        ░  ░  ░  ░  ░     ░     ░       ░     ░       ░   ░  "
    echo -e "           ░              ░           ░             ░             ░      "
    sleep 2
}

# Main Banner
function main_banner()
{
    echo -e "${BLACK}"
    echo -e " ██████╗   █████╗    ██╗  ██╗   ██╗   ██╗   ██████╗    ██╗"
    echo -e " ██╔══██╗ ██╔══██╗   ██║ ██╔╝   ██║   ██║   ██╔══██╗   ██║"
    echo -e " ██████╔╝ ███████║   █████╔╝    ██║   ██║   ██████╔╝   ██║"
    echo -e " ██╔═══╝  ██╔══██║   ██╔═██╗    ██║   ██║   ██╔══██╗   ██║"
    echo -e " ██║   ██╗██║  ██║██╗██║  ██╗██╗╚██████╔╝██╗██║  ██║██╗██║"
    echo -e " ╚═╝   ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝╚═╝"
    echo -e "${NC}"
    echo -e "- ${RED_b}P${NC}enetration Test ${RED_b}A${NC}chive ${RED_b}K${NC}nowledge ${RED_b}U${NC}nite ${RED_b}R${NC}apid ${RED_b}I${NC}nterface -"
    echo -e "                    inspired by ${GREEN_b}CDI"
    echo -e "${NC}"
    echo -e "                                               v0.0.1-beta"
    echo -e "                                       Author  : Mr.Rabbit" 
    echo -e ""                                                                                                       
}

# Main Menu
function menu()
{
    local key
    while : 
    do
        clear
        main_banner
        date
        echo -e "Working Directory : $WDIR"
        echo -e "---------------------- Main Menu -----------------------"
        echo -e "+---+"
        echo -e "| 1 | Scanning Targets"
        echo -e "+---+"
        echo -e "+---+"
        echo -e "| 2 | Exploit Mode"
        echo -e "+---+"
        echo -e "+---+"
        echo -e "| 3 | Config"
        echo -e "+---+"
        echo -e "+---+"
        echo -e "| 4 | Project Management"
        echo -e "+---+"
        echo -e "+---+"        
        echo -e "| 9 | Exit"
        echo -e "+---+"

        read -n 1 -t 10 -s key
        echo
        case "$key" in
            1 )
                module/scan_module.sh ;;
            2 )
                module/exploit_module.sh ;;
            3 )
                module/config_module.sh ;;
            4 )
                module/project_module.sh ;;
            9 ) 
                tmux kill-pane -t $SESSION_NAME.1
                tmux kill-pane -t $SESSION_NAME.0
                tmux kill-session -t $SESSION_NAME
                break ;;
            * ) 
                echo "error" ;;
        esac
    done
    exit 0
}

if [ -z ${TMUX} ]; then
    op_banner
    clear
    # Check Working Directory
    if [[ ! -d $WDIR ]]; then
        mkdir -p $WDIR
    fi

    WINDOW_NAME="Main"
    tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_NAME"
    tmux split-window -t $SESSION_NAME.0 -h
    tmux send-keys -t $SESSION_NAME.0 "$PAKURI" C-m
    tmux select-pane -t $SESSION_NAME.0
    tmux -2 attach -t $SESSION_NAME
else
    menu
fi
exit 0
