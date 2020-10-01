#!/bin/bash
source pakuri.conf

function service_check() {
    if systemctl status ssh | grep "active (running)" >/dev/null; then
        _ssh="Active"
        _serv_ssh="\Zb\Z2Running"
    else
        _ssh="Down"
        _serv_ssh="\Zb\Z1Stop"
    fi
    if systemctl status postgresql | grep "active (exited)" >/dev/null; then
        _postgres="Active"
        _serv_postgres="\Zb\Z2Running"
    else
        _postgres="Down"
        _serv_postgres="\Zb\Z1Stop"
    fi
    if systemctl status docker | grep "active (running)" >/dev/null; then
        _docker="Active"
        _serv_docker="\Zb\Z2Running"
    else
        _docker="Down"
        _serv_docker="\Zb\Z1Stop"
    fi
    # if ps -ef|grep [f]araday >/dev/null; then
    if systemctl status faraday.service | grep "active (running)" >/dev/null; then
        _faraday="Active"
        _serv_faraday="\Zb\Z2Running"
    else
        _faraday="Down"
        _serv_faraday="\Zb\Z1Stop"
    fi
}
function service_switching() {
    dialog --backtitle "PAKURI > Config > Service " \
        --colors --title "Service Control" \
        --menu "Select a Service: " 13 50 4 \
        "1" "SSH            $_serv_ssh" \
        "2" "PostgreSQL     $_serv_postgres" \
        "3" "Docker         $_serv_docker" \
        "4" "Faraday        $_serv_faraday" 2>temp
    result=$(cat temp)
    case "$result" in
    1) service_control "ssh" $_ssh ;;
    2) service_control "postgresql.service" $_postgres ;;
    3) service_control "docker.service" $_docker ;;
    # 4) faraday_control "faraday" $_faraday ;;
    4) service_control "faraday.service" $_faraday ;;
    esac

    rm -f temp
    clear
}
function service_control() {
    if [[ $2 = "Active" ]]; then
        dialog --backtitle "PAKURI > Config > Service " \
            --title "Service Control" --defaultno --yesno "Stop the $1." 5 50
        if [ $? = 0 ]; then
            sudo systemctl stop $1
            sleep 1
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "$1 Stop." >>pakuri.log
        fi
    else
        dialog --backtitle "PAKURI > Config > Service " \
            --title "Service Control" --yesno "Start the $1." 5 50
        if [ $? = 0 ]; then
            sudo systemctl start $1
            sleep 1
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "$1 Start." >>pakuri.log
        fi
    fi
}
# function faraday_control(){
#     if [[ $2 = "Active" ]]; then
#         dialog --backtitle "PAKURI > Config > Service " \
#             --title "Service Control" --defaultno --yesno "Stop the $1." 5 50
#         if [ $? = 0 ]; then
#             sudo faraday-server --stop
#             sleep 1
#             printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "$1 Servise Stop." >>pakuri.log
#         fi
#     else
#         dialog --backtitle "PAKURI > Config > Service " \
#             --title "Service Control" --yesno "Start the $1." 5 50
#         if [ $? = 0 ]; then
#             sudo faraday-server --start
#             sleep 1
#             printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "$1 Servise Start." >>pakuri.log
#         fi
#     fi
# }
function mode_check() {
    mode=$(systemctl get-default)
    _gui=" "
    _cui=" "
    if [ "graphical.target" = $mode ]; then _gui="Active"; else _cui="Active"; fi
}
# Change CUI/GUI
function mode_switching() {
    MODE=$(systemctl get-default)
    if [[ ${MODE} = "graphical.target" ]]; then
        _gui="1"
        msg="Currently running in GUI, do you want to change to CUI?"
    else
        _gui="0"
        msg="Currently running in CUI, do you want to change to GUI?"
    fi
    dialog --title "CUI/GUI" --backtitle "PAKURI > Config > CUI/GUI" --yesno "$msg" 8 50
    res=$?
    case $res in
    0) # Yes
        if [[ ${_gui} = "1" ]]; then
            sudo systemctl set-default -f multi-user.target
            sleep 1
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "Change to CUI mode." >>pakuri.log
        else
            sudo systemctl set-default -f graphical.target
            sleep 1
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "Change to GUI mode." >>pakuri.log
        fi
        dialog --title "CUI/GUI" --backtitle "PAKURI > Config > CUI/GUI" --msgbox "You'll need to reboot after changing the settings." 8 50
        break
        ;;
    1) # No
        break ;;
    255) # ESC
        break ;;
    esac
}
function setIP_input() {
    OUTPUT="tmp.txt"

    function setIP() {
        local n=${@-"127.0.0.1"}
        IP_CHECK=$(echo ${n} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")
        if [[ ! ${IP_CHECK} ]]; then
            dialog --title "Set a target" --clear --msgbox "It's not an IP address." 6 45
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "ERROR" "${n} is not IP Address." >>pakuri.log
        else
            dialog --title "Set a target" --clear --msgbox "The target was set to  ${n}" 6 45
            echo ${n} >$TARGETS
            printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Info" "The target was set to  ${n}" >>pakuri.log
        fi
    }
    dialog --title "Set a target" \
        --backtitle "PAKURI > Config > Project > Target" \
        --inputbox "Enter the target ip" 8 60 2>$OUTPUT
    respose=$?
    IP=$(cat $OUTPUT)

    case $respose in
    0)
        setIP ${IP}
        ;;
    *)
        printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "ERROR" "No IP Address was set." >>pakuri.log
        ;;
    esac
    rm $OUTPUT
}
function setIP_file() {
    FILE=$(dialog --backtitle "PAKURI > Config > Project > Target" \
        --stdout --title "Select a target file" --fselect $(pwd) 20 80)

    if [ ! -z $FILE ]; then
        dialog --title "Is this file OK?" --backtitle "PAKURI > Config > Project > Target" \
            --extra-button --extra-label "Cancel" --textbox $FILE 22 70
    fi
    respose=$?
    case $respose in
    0) cp $FILE $TARGETE ;;
    *) echo "error" ;;
    esac
}
function project_config() {
    dialog --backtitle "PAKURI > Config > Project " \
        --title "Project Manage" \
        --menu "Select a action: " 13 50 2 \
        "1" "Set IP address" \
        "2" "Set IP list" 2>temp
    result=$(cat temp)
    case "${result}" in
    1) setIP_input ;;
    2) setIP_file ;;
    esac
    rm -f temp
}
function docker_switching() {
    if systemctl status docker.service | grep "active (running)" >/dev/null; then
        if sudo docker-compose -f $CODIMDPATH ps | grep Exit >/dev/null; then
            _codimd="\Zb\Z1Stoped"
        else
            _codimd="\Zb\Z2Running"
        fi
        if sudo docker-compose -f $MATTERMOSTPATH ps | grep Exit >/dev/null; then
            _matter="\Zb\Z1Stoped"
        else
            _matter="\Zb\Z2Running"
        fi

        dialog --backtitle "PAKURI > Config > Docker" \
            --colors --title "Docker Control" \
            --clear \
            --menu "Please select:" 10 60 2 \
            "1" "CodiMD         $_codimd" \
            "2" "Mattermost     $_matter" 2>temp

        selection=$(cat temp)
        case $selection in
        0) ;;

        1)
            if [[ $_codimd = "\Zb\Z2Running" ]]; then
                dialog --backtitle "PAKURI > Config > Docker " \
                    --title "Docker Control" --defaultno --yesno "Stop the CodiMD docker service." 5 50
                if [ $? = 0 ]; then
                    sudo docker-compose -f $CODIMDPATH stop
                    printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "Docker CodiMD Stop." >>pakuri.log
                fi
            else
                dialog --backtitle "PAKURI > Config > Docker " \
                    --title "Docker Control" --yesno "Start the CodiMD docker service." 5 50
                if [ $? = 0 ]; then
                    sudo docker-compose -f $CODIMDPATH start
                    printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "Docker CodiMD Start." >>pakuri.log
                fi
            fi
            ;;
        2)
            if [[ $_matter = "\Zb\Z2Running" ]]; then
                dialog --backtitle "PAKURI > Config > Docker " \
                    --title "Docker Control" --defaultno --yesno "Stop the Mattermost docker service." 5 50
                if [ $? = 0 ]; then
                    sudo docker-compose -f $MATTERMOSTPATH stop
                    printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "Docker Mattermost Stop." >>pakuri.log
                fi
            else
                dialog --backtitle "PAKURI > Config > Docker " \
                    --title "Docker Control" --yesno "Start the Mattermost docker service." 5 50
                if [ $? = 0 ]; then
                    sudo docker-compose -f $MATTERMOSTPATH start
                    printf "%(%F %T)T [%s] [%s] %s\n" -1 "Config" "Warning" "Docker Mattermost Start." >>pakuri.log
                fi
            fi
            ;;

        esac
    else
        dialog --backtitle "PAKURI > Config > Docker" \
            --colors --title "\Zb\Z1Error" \
            --msgbox "Docker service is not running." 5 40
    fi
    rm -f temp
    clear
}

# Config main menu
function config_manage() {
    dialog --backtitle "PAKURI > Config " \
        --title "Config Manage" \
        --menu "Select a action: " 13 50 4 \
        "1" "Service" \
        "2" "Target" \
        "3" "Docker" \
        "4" "CUI/GUI" 2>temp
    result=$(cat temp)
    case "${result}" in
    1) service_switching ;;
    2) project_config ;;
    3) docker_switching ;;
    4) mode_switching ;;
    esac
    rm -f temp
    clear
}
#config_manage
