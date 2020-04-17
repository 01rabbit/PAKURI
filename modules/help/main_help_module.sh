#!/bin/bash
source pakuri.conf

function help_main()
{
    clear
    echo -e "${BOLD}-------------------Main Menu Assist-------------------${NC}"
    echo -e ""
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Scanning"
    echo -e "${BLUE_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Port Scan and Enumeration"
    echo -e "   ${BLUE_b}[1]${NC} Port Scan"
    echo -e "   ${RED_b}[2]${NC} Enumeration"
    echo -e "   ${YELLOW_b}[3]${NC} OpenVAS"
    echo -e ""
    echo -e ""
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Exploit"
    echo -e "${RED_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Performing simple exploitation."
    echo -e "   ${BLUE_b}[1]${NC} Password Crack"
    echo -e "   ${RED_b}[2]${NC} Metasploit"
    echo -e "   ${YELLOW_b}[3]${NC} Searchsploit"
    echo -e ""
    echo -e ""
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  Config"
    echo -e "${YELLOW_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Configuring PAKURI."
    echo -e "   ${BLUE_b}[1]${NC} Configure Targets"
    echo -e "   ${RED_b}[2]${NC} Configure Service"
    echo -e "   ${YELLOW_b}[3]${NC} Mode Switching"
    echo -e ""
    echo -e ""
}

function quit_message()
{
    clear
    echo -e "////////////////////////////////////////////////////////////////////////"
    echo -e "${YELLOW_b} Caution!       Caution!        Caution!        Caution!        Caution!${NC}"
    echo -e "////////////////////////////////////////////////////////////////////////"
    echo -e "${RED}"
    echo -e " ██╗    ██╗ █████╗ ██████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗ "
    echo -e " ██║    ██║██╔══██╗██╔══██╗████╗  ██║██║████╗  ██║██╔════╝ "
    echo -e " ██║ █╗ ██║███████║██████╔╝██╔██╗ ██║██║██╔██╗ ██║██║  ███╗"
    echo -e " ██║███╗██║██╔══██║██╔══██╗██║╚██╗██║██║██║╚██╗██║██║   ██║"
    echo -e " ╚███╔███╔╝██║  ██║██║  ██║██║ ╚████║██║██║ ╚████║╚██████╔╝"
    echo -e "  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ "
    echo -e " ██████╗     █████╗      ██╗  ██╗     ██╗   ██╗     ██████╗      ██╗"
    echo -e " ██╔══██╗   ██╔══██╗     ██║ ██╔╝     ██║   ██║     ██╔══██╗     ██║"
    echo -e " ██████╔╝   ███████║     █████╔╝      ██║   ██║     ██████╔╝     ██║"
    echo -e " ██╔═══╝    ██╔══██║     ██╔═██╗      ██║   ██║     ██╔══██╗     ██║"
    echo -e " ██║    ██╗ ██║  ██║ ██╗ ██║  ██╗ ██╗ ╚██████╔╝ ██╗ ██║  ██║ ██╗ ██║"
    echo -e " ╚═╝    ╚═╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═════╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝"
    echo -e " ███████╗██╗  ██╗██╗   ██╗████████╗██████╗  ██████╗ ██╗    ██╗███╗   ██╗"
    echo -e " ██╔════╝██║  ██║██║   ██║╚══██╔══╝██╔══██╗██╔═══██╗██║    ██║████╗  ██║"
    echo -e " ███████╗███████║██║   ██║   ██║   ██║  ██║██║   ██║██║ █╗ ██║██╔██╗ ██║"
    echo -e " ╚════██║██╔══██║██║   ██║   ██║   ██║  ██║██║   ██║██║███╗██║██║╚██╗██║"
    echo -e " ███████║██║  ██║╚██████╔╝   ██║   ██████╔╝╚██████╔╝╚███╔███╔╝██║ ╚████║"
    echo -e " ╚══════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝"
    echo -e "${NC}"
    echo -e "////////////////////////////////////////////////////////////////////////"
    echo -e "${YELLOW_b} Caution!       Caution!        Caution!        Caution!        Caution!${NC}"
    echo -e "////////////////////////////////////////////////////////////////////////"
}

case $1 in
    main)
        help_main
    quit)
        quit_message;;
esac