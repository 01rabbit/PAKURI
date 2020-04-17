#!/bin/bash
source pakuri.conf

function help_config()
{
    clear
    echo -e "${YELLOW_b}+---+"
    echo -e "${YELLOW_b}| 3 |  Config"
    echo -e "${YELLOW_b}+---+${NC}"
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
    echo -e "${YELLOW_b}| 3 |  Mode Switching"
    echo -e "${YELLOW_b}+---+"
    echo -e "------------------------------------------------------${NC}"
    echo -e "CUI and GUI are changed."
    echo -e "   ${BLUE_b}[1]${NC} Switch CUI mode"
    echo -e "   ${RED_b}[2]${NC} Switch GUI mode"
    echo -e ""
    echo -e ""
}
case $1 in
    main)
        help_config;;
esac