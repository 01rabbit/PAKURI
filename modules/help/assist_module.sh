#!/bin/bash
source pakuri.conf

function assist_main()
{
    clear
    echo -e "-------------------Main Menu Assist-------------------"
    echo -e ""
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Scanning"
    echo -e "${BLUE_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "${BLUE_b}[1]${NC} Port Scan"
    echo -e "${RED_b}[2]${NC} Enumeration"
    echo -e "${YELLOW_b}[3]${NC} OpenVAS"
    echo -e "${GREEN_b}[4]${NC} Assist"
    echo -e ""
    echo -e ""
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Exploit"
    echo -e "${RED_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "${BLUE_b}[1]${NC} Password Crack"
    echo -e "${RED_b}[2]${NC} Metasploit"
    echo -e "${YELLOW_b}[3]${NC} Searchsploit"
    echo -e "${GREEN_b}[4]${NC} Assist"
    echo -e ""
    echo -e ""
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  Config"
    echo -e "${YELLOW_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "${BLUE_b}[1]${NC} Configure Targets"
    echo -e "${RED_b}[2]${NC} Configure Service"
    echo -e "${YELLOW_b}[3]${NC} Import Data into Faraday"
    echo -e "${GREEN_b}[4]${NC} Mode Switching"
    echo -e ""
    echo -e ""
}

function assist_scan()
{
    clear
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Scanning"
    echo -e "${BLUE_b}+---+${NC}"
    echo -e "${BOLD}-------------------Scan Menu Assist-------------------${NC}"
    echo -e ""
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Port Scan"
    echo -e "${BLUE_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Various scans are performed using Nmap's features."
    echo -e "   ${BLUE_b}[1]${NC} Port Scan"
    echo -e "   ${RED_b}[2]${NC} Vulners Scan"
    echo -e ""
    echo -e ""
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Enumeration"
    echo -e "${RED_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Perform enumeration for services that are open."
    echo -e ""
    echo -e ""
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  OpenVAS"
    echo -e "${YELLOW_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Vulnerability scanning using OpenVAS."
    echo -e ""
    echo -e ""
}

function assist_exploit()
{
    clear
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Exploit"
    echo -e "${RED_b}+---+${NC}"
    echo -e "${BOLD}-----------------Exploit Menu Assist------------------${NC}"
    echo -e ""
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Password Crack"
    echo -e "${BLUE_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Brute force attack using Brutespray."
    echo -e ""
    echo -e ""
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Metasploit"
    echo -e "${RED_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Helping you work with Metasploit."
    echo -e "${RED_b}(We're not going to execute the Exploit code directly.)${NC}"
    echo -e "   ${BLUE_b}[1]${NC} Password Crack"
    echo -e "   ${RED_b}[2]${NC} Metasploit"
    echo -e "   ${YELLOW_b}[3]${NC} Searchsploit"
    echo -e "   ${GREEN_b}[4]${NC} Assist"
    echo -e ""
    echo -e ""
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  Searchsploit"
    echo -e "${YELLOW_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Search the Exploit Database for keywords."
    echo -e ""
    echo -e ""
}

function assist_config()
{
    clear
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  Config"
    echo -e "${YELLOW_b}+---+"
    echo -e "${BOLD}------------------Config Menu Assist------------------${NC}"
    echo -e ""
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Configure Targets"
    echo -e "${BLUE_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Edit the target list."
    echo -e ""
    echo -e ""
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Configure Service"
    echo -e "${RED_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Start and stop the service."
    echo -e ""
    echo -e ""
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  Data import to Faraday"
    echo -e "${YELLOW_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "Manually import the data into Faraday."
    echo -e ""
    echo -e ""
    echo -e "${GREEN_b}+---+"
    echo -e "| 4 |  Mode Switching"
    echo -e "+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "CUI and GUI are changed."
    echo -e "   ${BLUE_b}[1]${NC} Switch CUI mode"
    echo -e "   ${RED_b}[2]${NC} Switch GUI mode"
    echo -e ""
    echo -e ""
}

case $1 in
    main)
        assist_main;;
    scan)
        assist_scan;;
    exploit)
        assist_exploit;;
    config)
        assist_config;;
esac