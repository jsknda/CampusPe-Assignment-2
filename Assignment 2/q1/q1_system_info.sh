#!/bin/bash

USERNAME=$(whoami)
HOSTNAME=$(hostname)
DATETIME=$(date "+%Y-%m-%d %H:%M:%S")
OS=$(uname -s)
CURRENT_DIR=$(pwd)
HOME_DIR=$HOME
USERS_ONLINE=$(who | wc -l)
UPTIME_INFO=$(uptime -p)

DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 " used / " $2 " total"}')
MEM_USAGE=$(free -h | awk 'NR==2 {print $3 " used / " $2 " total"}')

# \e[36m = cyan, \e[0m = reset color

CYAN="\e[36m"
RESET="\e[0m"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║         SYSTEM INFORMATION DISPLAY             ║${RESET}"
echo -e "${CYAN}╠════════════════════════════════════════════════╣${RESET}"
echo -e "${CYAN}║${RESET}  Username     : $USERNAME"
echo -e "${CYAN}║${RESET}  Hostname     : $HOSTNAME"
echo -e "${CYAN}║${RESET}  Date & Time  : $DATETIME"
echo -e "${CYAN}║${RESET}  OS           : $OS"
echo -e "${CYAN}║${RESET}  Current Dir  : $CURRENT_DIR"
echo -e "${CYAN}║${RESET}  Home Dir     : $HOME_DIR"
echo -e "${CYAN}║${RESET}  Users Online : $USERS_ONLINE"
echo -e "${CYAN}║${RESET}  Uptime       : $UPTIME_INFO"
echo -e "${CYAN}╠════════════════════════════════════════════════╣${RESET}"
echo -e "${CYAN}║${RESET}  Disk Usage   : $DISK_USAGE"
echo -e "${CYAN}║${RESET}  Memory Usage : $MEM_USAGE"
echo -e "${CYAN}╚════════════════════════════════════════════════╝${RESET}"
echo ""
