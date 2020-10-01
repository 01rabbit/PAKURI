#!/bin/bash
source pakuri.conf

function nmap_scan() {
    WINDOWNAME="Recon"

    if tmux list-window | grep ${WINDOWNAME} >/dev/null; then
        tmux select-window -t ${WINDOWNAME}
    else
        tmux new-window -n ${WINDOWNAME}
        tmux send-keys -t ${WINDOWNAME} "$MODULES_PATH/recon/nmapScan.sh -l $TARGETS | tee -a pakuri.log;exit" C-m
        tmux select-window -t "Main"
    fi
}
function extra_scan() {
    WINDOWNAME="Recon"

    if tmux list-window | grep ${WINDOWNAME} >/dev/null; then
        tmux select-window -t ${WINDOWNAME}
    else
        tmux new-window -n ${WINDOWNAME}
        tmux send-keys -t ${WINDOWNAME} "$MODULES_PATH/recon/nmapScan.sh -e -l $TARGETS | tee -a pakuri.log;exit" C-m
        tmux select-window -t "Main"
    fi
}
function udp_scan() {
    WINDOWNAME="Recon"

    if tmux list-window | grep ${WINDOWNAME} >/dev/null; then
        tmux select-window -t ${WINDOWNAME}
    else
        tmux new-window -n ${WINDOWNAME}
        tmux send-keys -t ${WINDOWNAME} "$MODULES_PATH/recon/nmapScan.sh -e -u -l $TARGETS | tee -a pakuri.log;exit" C-m
        tmux select-window -t "Main"
    fi
}
function openvas_scan() {
    WINDOWNAME="OpenVAS"
    if tmux list-window | grep ${WINDOWNAME} >/dev/null; then
        tmux select-window -t ${WINDOWNAME}
    else
        tmux new-window -n ${WINDOWNAME}
        tmux send-keys -t ${WINDOWNAME} "$MODULES_PATH/recon/toolsScan.sh -o -t 4 -l $TARGETS | tee -a pakuri.log;exit" C-m
        tmux select-window -t "Main"
    fi
}
function import_faraday() {
    if [ -d $WDIR/result/xml ]; then
        FILE=$(dialog --backtitle "PAKURI > Recon > Tools > Faraday" \
            --stdout --title "Select a file to import" --fselect ${WDIR}/result/xml/ 20 80)

        if [ ! -z $FILE ]; then
            dialog --backtitle "PAKURI > Recon > Tools > Faraday" \
                --title "Is this file OK?" \
                --extra-button --extra-label "Cancel" --textbox $FILE 22 70

            result=$?

            case $result in
            0)
                faraday-client --cli --workspace $WORKSPACE --report $FILE
                ;;
            *)
                echo "error"
                ;;
            esac
        fi
    else
        dialog --backtitle "PAKURI > Recon > Tools > Faraday" \
            --title "Can't find a workspace" \
            --msgbox "Please specify the workspace from the WebUI." 7 55
    fi
    clear
}
function tools_scan() {
    dialog --backtitle "PAKURI > Recon > Tools " \
        --menu "Select a tool: " 10 30 2 \
        "1" "Faraday" \
        "2" "OpenVAS" 2>temp
    result=$(cat temp)
    case "$result" in
    1)
        import_faraday
        ;;
    2)
        openvas_scan
        ;;
    esac

    rm -f temp
    clear
}
function recon_manage() {
    dialog --backtitle "PAKURI > Recon " \
        --title "Recon Manage" \
        --menu "Use the IP list specified in Target to perform reconnaissance activities." 13 80 4 \
        "1" "Nmap       General port scanning using Nmap." \
        "2" "ExScan     Detailed investigation of TCP ports." \
        "3" "UDP        Detailed investigation of UDP ports." \
        "4" "Tools      Other tools to assist Recon." 2>temp
    result=$(cat temp)
    case "$result" in
    1) nmap_scan ;;
    2) extra_scan ;;
    3) udp_scan ;;
    4) tools_scan ;;
    esac
    rm -f temp
    clear
}
