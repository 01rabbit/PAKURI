declare -a modules=("Main" "Scanning" "Exploit" "Config")

# Opening Banner
function op_banner()
{
    clear
    echo -e "${BLACK_b}"
    echo -e "                ...(gMMMMMNg,."
    echo -e "             .(MMMMMMMMMMMMMMMMa,"
    echo -e "       ..NMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "     .dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMa.."
    echo -e "    JMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNJ."
    echo -e "   .MMMMMTMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNg,"
    echo -e "  .MMMM[${GREEN}00.${BLACK_b}MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm."
    echo -e "   MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm."
    echo -e "   (MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMa."
    echo -e "    ?MMMMMMM{ 7HMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMF"
    echo -e "       ,MMMM]    7MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    echo -e "         WMMb      ?WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "         ${YELLOW}J${BLACK_b}dMM${YELLOW}L        ${BLACK_b}?WMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "      ${RED_b}.Jy${YELLOW}yt${BLACK_b}dMb${YELLOW}++.       ${BLACK_b}.WMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "     ${RED_b}?7777uww${BLACK_b}w${RED_b}XXZV!      ${BLACK_b} .TMMMMMMMMMMMMMMMMMMMMMMMMMMMMN,"
    echo -e "          ${RED_b}.XyyX0Z${YELLOW}>          ${BLACK_b}JMMMM#    ?THMMMMMMMMMMMMMMMMMm,"
    echo -e "           ${RED_b}.UVtZ${YELLOW}>!          ${BLACK_b}(MMMD          -TMMMMMMMMMMMMMMMNx"
    echo -e "          ${RED_b}.JktZ${YELLOW}><         ${BLACK_b}..M@'                ?TMMMMMHMMMMMMMp."
    echo -e "        ${RED_b}.ZVVY=${YELLOW}<!! ${BLACK_b}dMJ,.. gM@'                     -HMMMN, ?TMMMMN,"
    echo -e "                     dMMMML.,                       ?MMMMm.   7WMMM_"
    echo -e "                 .dMNMMM  MMN,                        ?MMMN,     (TF"
    echo -e "                             T                          (HMMN,"
    echo -e "                                                           TMMe"
    echo -e "                                                             .^'"
    echo -e " ██████╗     █████╗      ██╗  ██╗     ██╗   ██╗     ██████╗      ██╗"
    echo -e " ██╔══██╗   ██╔══██╗     ██║ ██╔╝     ██║   ██║     ██╔══██╗     ██║"
    echo -e " ██████╔╝   ███████║     █████╔╝      ██║   ██║     ██████╔╝     ██║"
    echo -e " ██╔═══╝    ██╔══██║     ██╔═██╗      ██║   ██║     ██╔══██╗     ██║"
    echo -e " ██║    ██╗ ██║  ██║ ██╗ ██║  ██╗ ██╗ ╚██████╔╝ ██╗ ██║  ██║ ██╗ ██║"
    echo -e " ╚═╝    ╚═╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═════╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝"
    echo -e "${NC}"
    echo -e "- ${RED_b}P${NC}enetration Test ${RED_b}A${NC}chive ${RED_b}K${NC}nowledge ${RED_b}U${NC}nite ${RED_b}R${NC}apid ${RED_b}I${NC}nterface -"
    echo -e "                    inspired by ${GREEN_b}CDI${NC}"
    echo -e "                                                    v$VERSION"
    echo -e "                                       Author  : Mr.Rabbit" 
    echo -e ""                                                                                                       
}

function boot_check()
{
    declare -a process=("seclists" "brutespray" "xmlstarlet" "xclip" "openvas-start" "skipfish" "nikto" "sslyze" "sslscan")
    echo -n "0 "
    i=0
    for proc in ${process[@]};
    do
        echo -n "#"
        sleep 0.5
        which $proc >/dev/null
        if [ $? ];then
            echo -n "#"
        fi
        sleep 0.5
    done

    systemctl status faraday-server.service >/dev/null
    if [ $? ];then
        echo -n "# OK"
    fi
    # read
}

# Main Banner
function main_banner()
{
    echo -e "${BLACK_b}  ____ ____ ____ ____ ____ ____ "
    echo -e " ||P |||A |||K |||U |||R |||I ||"
    echo -e " ||__|||__|||__|||__|||__|||__||"
    echo -e " |/__\|/__\|/__\|/__\|/__\|/__\|${NC}"
    echo -e "                          v$VERSION"
    echo -e "             Author  : Mr.Rabbit" 
    echo -e "                 inspired by ${GREEN_b}CDI${NC}"
    echo -e ""                                                                                                       
}

# Scanning banner
function scan_banner()
{
    clear
    main_banner
    echo -e "Workspace: $WORKSPACE"
    echo -e "---------- Main Menu -----------"
    box_1 "Scanning"
    echo -e "---------- Scan Menu -----------"
}

# Exploit banner
function exploit_banner()
{
    clear
    main_banner
    echo -e "Workspace: $WORKSPACE"
    echo -e "---------- Main Menu -----------"
    box_2 "Exploit"
    echo -e "--------- Exploit Menu ---------"
}

# Config banner
function config_banner()
{
    clear
    main_banner
    echo -e "Workspace: $WORKSPACE"
    echo -e "---------- Main Menu -----------"
    box_3 "Config"
    echo -e "--------- Config Menu ----------"
}

function yes-no()
{
    echo -e "${BLUE_b}+---+        ${RED_b}+---+"
    echo -e "${BLUE_b}| 1 | yes    ${RED_b}| 2 | no"
    echo -e "${BLUE_b}+---+        ${RED_b}+---+"
    echo -e "${NC}"
}

function yes-no-help()
{
    echo -e "${BLUE_b}+---+        ${RED_b}+---+       ${YELLOW_b}+---+"
    echo -e "${BLUE_b}| 1 | yes    ${RED_b}| 2 | no    ${YELLOW_b}| 3 | help"
    echo -e "${BLUE_b}+---+        ${RED_b}+---+       ${YELLOW_b}+---+"
    echo -e "${NC}"
}

function select_7()
{
    echo -e "${BLUE_b}+---+"
    echo -e "| 1 | $1"
    echo -e "+---+"
    echo -e "${RED_b}+---+"
    echo -e "| 2 | $2"
    echo -e "+---+"
    echo -e "${YELLOW_b}+---+"
    echo -e "| 3 | $3"
    echo -e "+---+"
    echo -e "${GREEN_b}+---+"
    echo -e "| 4 | $4"
    echo -e "+---+"
    echo -e "${PURPLE_b}+---+"
    echo -e "| 5 | $5"
    echo -e "+---+"
    echo -e "${LIGHTBLUE_b}+---+"
    echo -e "| 6 | $6"
    echo -e "+---+"
    echo -e "${NC}+---+"
    echo -e "| 7 | $7"
    echo -e "+---+"
    echo -e "${BLACK_b}+---+"
    echo -e "| 9 | Back"
    echo -e "+---+${NC}"
}

function select_6()
{
    echo -e "${BLUE_b}+---+"
    echo -e "| 1 | $1"
    echo -e "+---+"
    echo -e "${RED_b}+---+"
    echo -e "| 2 | $2"
    echo -e "+---+"
    echo -e "${YELLOW_b}+---+"
    echo -e "| 3 | $3"
    echo -e "+---+"
    echo -e "${GREEN_b}+---+"
    echo -e "| 4 | $4"
    echo -e "+---+"
    echo -e "${PURPLE_b}+---+"
    echo -e "| 5 | $5"
    echo -e "+---+"
    echo -e "${LIGHTBLUE_b}+---+"
    echo -e "| 6 | $6"
    echo -e "+---+"
    echo -e "${BLACK_b}+---+"
    echo -e "| 9 | Back"
    echo -e "+---+${NC}"
}

function select_5()
{
    echo -e "${BLUE_b}+---+"
    echo -e "| 1 | $1"
    echo -e "+---+"
    echo -e "${RED_b}+---+"
    echo -e "| 2 | $2"
    echo -e "+---+"
    echo -e "${YELLOW_b}+---+"
    echo -e "| 3 | $3"
    echo -e "+---+"
    echo -e "${GREEN_b}+---+"
    echo -e "| 4 | $4"
    echo -e "+---+"
    echo -e "${PURPLE_b}+---+"
    echo -e "| 5 | $5"
    echo -e "+---+"
    echo -e "${BLACK_b}+---+"
    echo -e "| 9 | Back"
    echo -e "+---+${NC}"
}

function select_4()
{
    echo -e "${BLUE_b}+---+"
    echo -e "| 1 | $1"
    echo -e "+---+"
    echo -e "${RED_b}+---+"
    echo -e "| 2 | $2"
    echo -e "+---+"
    echo -e "${YELLOW_b}+---+"
    echo -e "| 3 | $3"
    echo -e "+---+"
    echo -e "${GREEN_b}+---+"
    echo -e "| 4 | $4"
    echo -e "+---+"
    echo -e "${BLACK_b}+---+"
    echo -e "| 9 | Back"
    echo -e "+---+${NC}"
}

function select_3()
{
    echo -e "${BLUE_b}+---+"
    echo -e "| 1 | $1"
    echo -e "+---+"
    echo -e "${RED_b}+---+"
    echo -e "| 2 | $2"
    echo -e "+---+"
    echo -e "${YELLOW_b}+---+"
    echo -e "| 3 | $3"
    echo -e "+---+"
    echo -e "${BLACK_b}+---+"
    echo -e "| 9 | Back"
    echo -e "+---+${NC}"
}

function select_2()
{
    echo -e "${BLUE_b}+---+"
    echo -e "| 1 | $1"
    echo -e "+---+"
    echo -e "${RED_b}+---+"
    echo -e "| 2 | $2"
    echo -e "+---+"
    echo -e "${BLACK_b}+---+"
    echo -e "| 9 | Back"
    echo -e "+---+${NC}"
}

function box_1()
{
    echo -e "${BLUE_b}+---+"
    echo -e "| 1 | $1"
    echo -e "${BLUE_b}+---+${NC}"
}

function box_2()
{
    echo -e "${RED_b}+---+"
    echo -e "| 2 | $1"
    echo -e "${RED_b}+---+${NC}"
}

function box_3()
{
    echo -e "${YELLOW_b}+---+"
    echo -e "| 3 | $1"
    echo -e "${YELLOW_b}+---+${NC}"
}

function box_4()
{
    echo -e "${GREEN_b}+---+"
    echo -e "| 4 | $1"
    echo -e "${GREEN_b}+---+${NC}"
}

function box_5()
{
    echo -e "${PURPLE_b}+---+"
    echo -e "| 5 | $1"
    echo -e "${PURPLE_b}+---+${NC}"
}

function box_6()
{
    echo -e "${LIGHTBLUE_b}+---+"
    echo -e "| 6 | $1"
    echo -e "+---+${NC}"

}

function box_9()
{
    echo -e "${BLACK_b}+---+"
    echo -e "| 9 | Back"
    echo -e "${BLACK_b}+---+${NC}"

}

