# Opening Banner
function op_banner() {
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
function bar() {
    printf "%-40s(%s%%)\r" $1 $2
    sleep 0.2
}

function boot_check() {
    echo -e "SYSTEM LOADING..."
    echo -e "HOST IP: $MYIP"
    sleep 0.3
    echo -e "PROCESS CHECK... "
    declare -a process=("seclists" "brutespray" "xmlstarlet" "xclip" "nikto" "sslyze" "sslscan")
    for proc in ${process[@]}; do
        which $proc >/dev/null
        if [[ $? != 0 ]]; then
            echo -e "${RED_b}Caution!${NC}"
            echo -e "$proc not found."
            echo -e "Execute the setup.sh"
            tmux kill-session -t $SESSION_NAME
            read
            exit 1
        fi
    done

    # systemctl status faraday.service >/dev/null
    # if [[ $? != 0 ]];then
    #     echo -e "${RED_b}Caution!${NC}"
    #     echo -e "Faraday not found."
    #     tmux kill-session -t $SESSION_NAME
    #     read
    #     exit 1
    # fi

    for i in $(seq 10); do
        num=$i*4
        bar $(yes "#" | head -$((i * 4)) | tr -d "\r\n") $((i * 10))
    done

    printf "%-42s" $(yes "#" | head -$((10 * 4)) | tr -d "\r\n")
    printf " OK! \r\n"
    echo -e "PAKURI SYSTEM BOOT-UP COMPLETE!"
}
function webserviceCheck() {
    if ss -nltp | grep 5985 >/dev/null; then
        web_faraday=${BOLD}
    else
        web_faraday=${BLACK_b}
    fi
    if ss -nltp | grep 3000 >/dev/null; then
        web_codimd=${BOLD}
    else
        web_codimd=${BLACK_b}
    fi
    if ss -nltp | grep 9080 >/dev/null; then
        web_mattermost=${BOLD}
    else
        web_mattermost=${BLACK_b}
    fi
}

function operation_menu() {
    printf "${LIGHTBLUE}╔────────────────────────────────────────────────────────────────────────────────────────────╗${NC}\n"
    printf "${LIGHTBLUE}│ \e[38;5;196m ██████   █████  ██   ██ ██    ██ ██████  ██${NC}    ${LIGHTBLUE}╔─────────────────────────────────────────╗│${NC}\n"
    printf "${LIGHTBLUE}│ \e[38;5;196m ██   ██ ██   ██ ██  ██  ██    ██ ██   ██ ██${NC}    ${LIGHTBLUE}│${NC} Version ${LIGHTBLUE}:${NC} %-30s${LIGHTBLUE}││${NC}\n" $VERSION
    printf "${LIGHTBLUE}│ \e[38;5;160m ██████  ███████ █████   ██    ██ ██████  ██${NC}    ${LIGHTBLUE}│${NC} Auther  ${LIGHTBLUE}:${NC} %-30s${LIGHTBLUE}││${NC}\n" "Mr.Rabbit"
    printf "${LIGHTBLUE}│ \e[38;5;124m ██      ██   ██ ██  ██  ██    ██ ██   ██ ██${NC}    ${LIGHTBLUE}│${NC} %8s ${LIGHTBLUE}:${NC} %-29s${LIGHTBLUE}││${NC}\n"
    printf "${LIGHTBLUE}│ \e[38;5;88m ██      ██   ██ ██   ██  ██████  ██   ██ ██${NC}    ${LIGHTBLUE}│%41s││${NC}\n"
    printf "${LIGHTBLUE}│ ${NC}%40s ${GREEN_b}%3s    ${LIGHTBLUE}╚─────────────────────────────────────────╝│${NC}\n" "inspired by" "CDI"
    printf "${LIGHTBLUE}│╔─${NC}─ ${BOLD}Operation${NC} ─${LIGHTBLUE}────────────────────────────────────────────────────────────────────────────╗│${NC}\n"
    printf "${LIGHTBLUE}││${GREEN_b} %-10s${NC}${BOLD} : %-76s${LIGHTBLUE}││${NC}\n" "Recon" "Conduct a reconnaissance mission against the system."
    printf "${LIGHTBLUE}││${GREEN_b} %-10s${NC}${BOLD} : %-76s${LIGHTBLUE}││${NC}\n" "Check" "Check execution results and activity log"
    printf "${LIGHTBLUE}││${GREEN_b} %-10s${NC}${BOLD} : %-76s${LIGHTBLUE}││${NC}\n" "Attack" "Executing a Brute-force Attack and searching for Exploit code."
    printf "${LIGHTBLUE}││${GREEN_b} %-10s${NC}${BOLD} : %-76s${LIGHTBLUE}││${NC}\n" "Config" "Control of various services."
    printf "${LIGHTBLUE}││${BLACK_b} %-10s${NC}${BLACK_b} : %-76s${LIGHTBLUE}││${NC}\n" "Assist" "User assist."
    printf "${LIGHTBLUE}││${GREEN_b} %-10s${NC}${BOLD} : %-76s${LIGHTBLUE}││${NC}\n" "Exit" "Termination PAKURI."
    printf "${LIGHTBLUE}│╚──────────────────────────────────────────────────────────────────────────────────────────╝│${NC}\n"
    printf "${LIGHTBLUE}╚────────────────────────────────────────────────────────────────────────────────────────────╝${NC}\n"
}
function main_menu() {
    printf "${LIGHTBLUE}╔────────────────────────────────────────────────────────────────────────────────────────────╗${NC}\n"
    printf "${LIGHTBLUE}│ \e[38;5;196m ██████   █████  ██   ██ ██    ██ ██████  ██${NC}    ${LIGHTBLUE}╔─────────────────────────────────────────╗│${NC}\n"
    printf "${LIGHTBLUE}│ \e[38;5;196m ██   ██ ██   ██ ██  ██  ██    ██ ██   ██ ██${NC}    ${LIGHTBLUE}│${NC} Version ${LIGHTBLUE}:${NC} %-30s${LIGHTBLUE}││${NC}\n" $VERSION
    printf "${LIGHTBLUE}│ \e[38;5;160m ██████  ███████ █████   ██    ██ ██████  ██${NC}    ${LIGHTBLUE}│${NC} Auther  ${LIGHTBLUE}:${NC} %-30s${LIGHTBLUE}││${NC}\n" "Mr.Rabbit"
    printf "${LIGHTBLUE}│ \e[38;5;124m ██      ██   ██ ██  ██  ██    ██ ██   ██ ██${NC}    ${LIGHTBLUE}│${NC} %8s ${LIGHTBLUE}:${NC} %-29s${LIGHTBLUE}││${NC}\n"
    printf "${LIGHTBLUE}│ \e[38;5;88m ██      ██   ██ ██   ██  ██████  ██   ██ ██${NC}    ${LIGHTBLUE}│%41s││${NC}\n"
    printf "${LIGHTBLUE}│ ${NC}%40s ${GREEN_b}%3s    ${LIGHTBLUE}╚─────────────────────────────────────────╝│${NC}\n" "inspired by" "CDI"
    printf "${LIGHTBLUE}│╔─${NC}─ ${BOLD}Status${NC} ─${LIGHTBLUE}───────────────────────────────────────────────────────────────────────────────╗│${NC}\n"
    printf "${LIGHTBLUE}││   ${GREEN_b}SSH${NC} : ${BOLD}%-6s        ${GREEN_b}PostgreSQL${NC} : ${BOLD}%-6s        ${GREEN_b}Docker${NC} : ${BOLD}%-6s                         ${LIGHTBLUE}││${NC}\n" $_ssh $_postgres $_docker
    printf "${LIGHTBLUE}││   ${GREEN_b}Faraday${NC} : ${BOLD}%-6s                                                                       ${LIGHTBLUE}││${NC}\n" $_faraday
    printf "${LIGHTBLUE}││%90s││${NC}\n"
    printf "${LIGHTBLUE}││  ${GREEN_b} %-10s${NC} : ${web_faraday}%-74s${LIGHTBLUE}││${NC}\n" "Faraday" "http://${MYIP}:5985"
    printf "${LIGHTBLUE}││  ${GREEN_b} %-10s${NC} : ${web_codimd}%-74s${LIGHTBLUE}││${NC}\n" "CodiMD" "http://${MYIP}:3000"
    printf "${LIGHTBLUE}││  ${GREEN_b} %-10s${NC} : ${web_mattermost}%-74s${LIGHTBLUE}││${NC}\n" "Mattermost" "http://${MYIP}:9080"
    printf "${LIGHTBLUE}│╚──────────────────────────────────────────────────────────────────────────────────────────╝│${NC}\n"
    printf "${LIGHTBLUE}╚────────────────────────────────────────────────────────────────────────────────────────────╝${NC}\n"
    printf "${LIGHTBLUE}╔──${NC}─ ${BOLD}Activity Log${NC} ─${LIGHTBLUE}──────────────────────────────────────────────────────────────────────────╗${NC}\n"
    sort -r pakuri.log | head
    printf "${LIGHTBLUE}╚────────────────────────────────────────────────────────────────────────────────────────────╝${NC}\n"
}

function num789() {
    printf "${BLACK_b}%34s ╔───────╗ ╔───────╗ ╔───────╗ %-34s\n"
    printf "%34s │       │ │       │ │       │ %-34s\n"
    printf "%34s │   7   │ │   8   │ │   9   │ %-34s\n"
    printf "%34s │       │ │       │ │       │ %-34s\n"
    printf "%34s ╚───────╝ ╚───────╝ ╚───────╝ %-34s${NC}\n"
}
function num456() {
    printf "${BLACK_b}%34s ╔───────╗ ╔───────╗ ╔───────╗ %-34s\n"
    printf "%34s │       │ │       │ │       │ %-34s\n"
    printf "%34s │   4   │ │   5   │ │   6   │ %-34s\n"
    printf "%34s │       │ │       │ │       │ %-34s\n"
    printf "%34s ╚───────╝ ╚───────╝ ╚───────╝ %-34s${NC}\n"
}
function num123() {
    printf "${BLACK_b}%34s ╔───────╗ ╔───────╗ ╔───────╗ %-34s\n"
    printf "%34s │       │ │       │ │       │ %-34s\n"
    printf "%34s │   1   │ │   2   │ │   3   │ %-34s\n"
    printf "%34s │       │ │       │ │       │ %-34s\n"
    printf "%34s ╚───────╝ ╚───────╝ ╚───────╝ %-34s${NC}\n"
}
function num0() {
    printf "${BLACK_b}%34s ╔─────────────────╗ \n"
    printf "%34s │                 │ \n"
    printf "%34s │        0        │ \n"
    printf "%34s │                 │ \n"
    printf "%34s ╚─────────────────╝ \n${NC}"
}
function top_keyOP() {
    printf "${BOLD}%34s ╔─────────────────╗%-34s${NC} \n" ""
    printf "${BOLD}%34s │                 │%-34s${NC} \n" " _  _ ____ _  _ _  _ "
    printf "${BOLD}%34s │        0        │%-34s${NC} \n" " |\/| |___ |\ | |  | "
    printf "${BOLD}%34s │                 │%-34s${NC} \n" " |  | |___ | \| |__| "
    printf "${BOLD}%34s ╚─────────────────╝%-34s${NC} \n" ""
}
function num_menu() {
    printf "${SELECT}%34s ╔─────────────────╗%-34s${NC} \n" ""
    printf "${SELECT}%34s │                 │%-34s${NC} \n" " _  _ ____ _  _ _  _ "
    printf "${SELECT}%34s │        0        │%-34s${NC} \n" " |\/| |___ |\ | |  | "
    printf "${SELECT}%34s │                 │%-34s${NC} \n" " |  | |___ | \| |__| "
    printf "${SELECT}%34s ╚─────────────────╝%-34s${NC} \n" ""
}
function num_back() {
    num789
    num456
    num123
    printf "${SELECT}%34s ╔─────────────────╗${NC} \n" ""
    printf "${SELECT}%34s │                 │${NC} \n" "___  ____ ____ _  _ "
    printf "${SELECT}%34s │        0        │${NC} \n" "|__] |__| |    |_/  "
    printf "${SELECT}%34s │                 │${NC} \n" "|__] |  | |___ | \_ "
    printf "${SELECT}%34s ╚─────────────────╝${NC} \n" ""
}
function num_top() {
    num789
    num456
    num123
    printf "${SELECT}%34s ╔─────────────────╗${NC} \n" ""
    printf "${SELECT}%34s │                 │${NC} \n" " ___ ____ ___  "
    printf "${SELECT}%34s │        0        │${NC} \n" "  |  |  | |__] "
    printf "${SELECT}%34s │                 │${NC} \n" "  |  |__| |    "
    printf "${SELECT}%34s ╚─────────────────╝${NC} \n" ""
}

function default() {
    printf "${BLACK_b}%34s ╔───────╗ ${BLACK_b}╔───────╗${NC}${BOLD} ╔───────╗ %-34s\n" "" 
    printf "${BLACK_b}%34s │       │ ${BLACK_b}│       │${NC}${BOLD} │       │ %-34s\n" " ____ ____ ____ _ ____ ___ " " ____ _  _ _ ___ "
    printf "${BLACK_b}%34s │   7   │ ${BLACK_b}│   8   │${NC}${BOLD} │   9   │ %-34s\n" " |__| [__  [__  | [__   |  " " |___  \/  |  |  "
    printf "${BLACK_b}%34s │       │ ${BLACK_b}│       │${NC}${BOLD} │       │ %-34s\n" " |  | ___] ___] | ___]  |  " " |___ _/\_ |  |  "
    printf "${BLACK_b}%34s ╚───────╝ ${BLACK_b}╚───────╝${NC}${BOLD} ╚───────╝ %-34s\n" ""
    printf "${BOLD}%34s ╔───────╗ ${BLACK_b}╔───────╗${NC}${BOLD} ╔───────╗ %-34s\n" ""
    printf "${BOLD}%34s │       │ ${BLACK_b}│       │${NC}${BOLD} │       │ %-34s\n" "____ ___ ___ ____ ____ _  _" " ____ ____ _  _ ____ _ ____ "
    printf "${BOLD}%34s │   4   │ ${BLACK_b}│   5   │${NC}${BOLD} │   6   │ %-34s\n" "|__|  |   |  |__| |    |_/ " " |    |  | |\ | |___ | | __ "
    printf "${BOLD}%34s │       │ ${BLACK_b}│       │${NC}${BOLD} │       │ %-34s\n" "|  |  |   |  |  | |___ | \_" " |___ |__| | \| |    | |__] "
    printf "${BOLD}%34s ╚───────╝ ${BLACK_b}╚───────╝${NC}${BOLD} ╚───────╝ %-34s\n" "" 
    printf "${BOLD}%34s ╔───────╗ ${BLACK_b}╔───────╗${NC}${BOLD} ╔───────╗ %-34s\n" "" 
    printf "${BOLD}%34s │       │ ${BLACK_b}│       │${NC}${BOLD} │       │ %-34s\n" "____ ____ ____ ____ _  _" " ____ _  _ ____ ____ _  _ "
    printf "${BOLD}%34s │   1   │ ${BLACK_b}│   2   │${NC}${BOLD} │   3   │ %-34s\n" "|__/ |___ |    |  | |\ |" " |    |__| |___ |    |_/  "
    printf "${BOLD}%34s │       │ ${BLACK_b}│       │${NC}${BOLD} │       │ %-34s\n" "|  \ |___ |___ |__| | \|" " |___ |  | |___ |___ | \_ "
    printf "${BOLD}%34s ╚───────╝ ${BLACK_b}╚───────╝${NC}${BOLD} ╚───────╝ %-34s\n" "" 
    printf "${BOLD}%34s ╔─────────────────╗${NC} \n" ""
    printf "${BOLD}%34s │                 │${NC} \n" " ___ ____ ___  "
    printf "${BOLD}%34s │        0        │${NC} \n" "  |  |  | |__] "
    printf "${BOLD}%34s │                 │${NC} \n" "  |  |__| |    "
    printf "${BOLD}%34s ╚─────────────────╝${NC} \n" ""
}
function num_recon() {
    num789
    num456
    printf "${SELECT}%34s ╔───────╗${NC} ${BLACK_b}╔───────╗ ╔───────╗ %-34s\n" ""
    printf "${SELECT}%34s │       │${NC} ${BLACK_b}│       │ │       │ %-34s\n" "____ ____ ____ ____ _  _"
    printf "${SELECT}%34s │   1   │${NC} ${BLACK_b}│   2   │ │   3   │ %-34s\n" "|__/ |___ |    |  | |\ |"
    printf "${SELECT}%34s │       │${NC} ${BLACK_b}│       │ │       │ %-34s\n" "|  \ |___ |___ |__| | \|"
    printf "${SELECT}%34s ╚───────╝${NC} ${BLACK_b}╚───────╝ ╚───────╝ %-34s\n" ""
    num0
}
function num_check() {
    num789
    num456
    printf "${BLACK_b}%34s ╔───────╗ ╔───────╗ ${SELECT}╔───────╗ %-34s${NC}\n" "" ""
    printf "${BLACK_b}%34s │       │ │       │ ${SELECT}│       │ %-34s${NC}\n" "" " ____ _  _ ____ ____ _  _ "
    printf "${BLACK_b}%34s │   1   │ │   2   │ ${SELECT}│   3   │ %-34s${NC}\n" "" " |    |__| |___ |    |_/  "
    printf "${BLACK_b}%34s │       │ │       │ ${SELECT}│       │ %-34s${NC}\n" "" " |___ |  | |___ |___ | \_ "
    printf "${BLACK_b}%34s ╚───────╝ ╚───────╝ ${SELECT}╚───────╝ %-34s${NC}\n" "" ""
    num0
}
function num_config() {
    num789
    printf "%34s ${BLACK_b}╔───────╗ ╔───────╗ ${SELECT}╔───────╗ %-34s${NC}\n" "" ""
    printf "%34s ${BLACK_b}│       │ │       │ ${SELECT}│       │ %-34s${NC}\n" "" " ____ ____ _  _ ____ _ ____ "
    printf "%34s ${BLACK_b}│   4   │ │   5   │ ${SELECT}│   6   │ %-34s${NC}\n" "" " |    |  | |\ | |___ | | __ "
    printf "%34s ${BLACK_b}│       │ │       │ ${SELECT}│       │ %-34s${NC}\n" "" " |___ |__| | \| |    | |__] "
    printf "%34s ${BLACK_b}╚───────╝ ╚───────╝ ${SELECT}╚───────╝ %-34s${NC}\n" "" ""
    num123
    num0
}
function num_attack(){
    num789
    printf "${SELECT}%34s ╔───────╗ ${BLACK_b}╔───────╗ ╔───────╗ %-34s\n" "" ""
    printf "${SELECT}%34s │       │ ${BLACK_b}│       │ │       │ %-34s\n" "____ ___ ___ ____ ____ _  _" ""
    printf "${SELECT}%34s │   4   │ ${BLACK_b}│   5   │ │   6   │ %-34s\n" "|__|  |   |  |__| |    |_/ " ""
    printf "${SELECT}%34s │       │ ${BLACK_b}│       │ │       │ %-34s\n" "|  |  |   |  |  | |___ | \_" ""
    printf "${SELECT}%34s ╚───────╝ ${BLACK_b}╚───────╝ ╚───────╝ %-34s\n" "" ""
    num123
    num0
}
function num_exit() {
    printf "%34s ${BLACK_b}╔───────╗ ╔───────╗ ${SELECT}╔───────╗ %-34s${NC}\n" "" ""
    printf "%34s ${BLACK_b}│       │ │       │ ${SELECT}│       │ %-34s${NC}\n" "" " ____ _  _ _ ___ "
    printf "%34s ${BLACK_b}│   7   │ │   8   │ ${SELECT}│   9   │ %-34s${NC}\n" "" " |___  \/  |  |  "
    printf "%34s ${BLACK_b}│       │ │       │ ${SELECT}│       │ %-34s${NC}\n" "" " |___ _/\_ |  |  "
    printf "%34s ${BLACK_b}╚───────╝ ╚───────╝ ${SELECT}╚───────╝ %-34s${NC}\n" "" ""
    num456
    num123
    num0
}
function num_assist() {
    printf "${SELECT}%34s ╔───────╗ ${BLACK_b}╔───────╗ ╔───────╗ %-34s${NC}\n" ""
    printf "${SELECT}%34s │       │ ${BLACK_b}│       │ │       │ %-34s${NC}\n" " ____ ____ ____ _ ____ ___ "
    printf "${SELECT}%34s │   7   │ ${BLACK_b}│   8   │ │   9   │ %-34s${NC}\n" " |__| [__  [__  | [__   |  "
    printf "${SELECT}%34s │       │ ${BLACK_b}│       │ │       │ %-34s${NC}\n" " |  | ___] ___] | ___]  |  "
    printf "${SELECT}%34s ╚───────╝ ${BLACK_b}╚───────╝ ╚───────╝ %-34s${NC}\n" ""
    num456
    num123
    num0
}
