#!/bin/bash
source pakuri.conf

function assist_main()
{
    clear
    echo -e "-------------------Main Menu Assist-------------------"
    echo -e ""
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Scanning"
    echo -e "${BLUE_b}+---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e "${BLUE_b}[1]${NC} Port Scan"
    echo -e "${RED_b}[2]${NC} Enumeration"
    echo -e "${YELLOW_b}[3]${NC} OpenVAS"
    echo -e "${GREEN_b}[4]${NC} Assist"
    echo -e ""
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Exploit"
    echo -e "${RED_b}+---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e "${BLUE_b}[1]${NC} Password Crack"
    echo -e "${RED_b}[2]${NC} Metasploit"
    echo -e "${YELLOW_b}[3]${NC} Searchsploit"
    echo -e "${GREEN_b}[4]${NC} Assist"
    echo -e ""
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  Config"
    echo -e "${YELLOW_b}+---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e "${BLUE_b}[1]${NC} Configure Targets"
    echo -e "${RED_b}[2]${NC} Configure Service"
    echo -e "${YELLOW_b}[3]${NC} Import Data into Faraday"
    echo -e "${GREEN_b}[4]${NC} Mode Switching"
}

function assist_scan()
{
    clear
    echo -e "-------------------Scan Menu Assist-------------------"
    echo -e ""
    echo -e "${BLUE_b}+---+"
    echo -e "${BLUE_b}| 1 |  Port Scan"
    echo -e "${BLUE_b}+---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e "${BLUE_b}[1]${NC} Port Scan"
    echo -e "${RED_b}[2]${NC} Vulners Scan"
    echo -e ""
    echo -e "${RED_b}+---+"
    echo -e "${RED_b}| 2 |  Enumeration"
    echo -e "${RED_b}+---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e ""
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  OpenVAS"
    echo -e "${YELLOW_b}+---+${NC}"
    echo -e "------------------------------------------------------"
}

case $1 in
    main)
        assist_main;;
    scan)
        assist_scan;;
esac