#!/bin/bash

#Regex command
getTillSpace="^\S*"

calc() { awk "BEGIN { print $*}"; }
removeFromString() { echo "${1/$2/}"; }

function getKernel() { echo $(uname -msr); }

function getCurrentUsername() { echo $(whoami); }

function getUptime() { echo $(uptime -p | grep -Po 'up\s\K.*'); }

function getHostname() { echo $(hostnamectl | grep -Po 'Static hostname:\s\K.*'); }

function getOperatingSystem() { echo $(lsb_release -d | grep -Po 'Description:\s\K.*'); }

function getRam() {
    local RAMINFO=$(free --mega | grep -Po '\d+' | head -2 | paste -s -d "_")
    local ALLRAM=$(echo $RAMINFO | grep -Eo "^[0-9]*4")
    USEDRAM="$(removeFromString "$(echo $RAMINFO | grep -Eo "_.*$")" "_")"
    echo $USEDRAM"MB /" $ALLRAM"MB"
}

function getDiskSpace() {
    local DISKINFO=$(df -H | grep "/$")
    DISKINFO="$(removeFromString "$DISKINFO" "$(echo $DISKINFO | grep -Eo "$getTillSpace")")"
    DISKINFO="$(removeFromString "$DISKINFO" "$(echo $DISKINFO | grep -Eo "$getTillSpace")")"
    
    local USEDSIZE=$(echo $DISKINFO | grep -Eo "$getTillSpace")
    DISKINFO="$(removeFromString "$DISKINFO" "$USEDSIZE")"

    local AVAILABLESIZE=$(echo $DISKINFO | grep -Eo "$getTillSpace")

    local USEDINT=$(echo $USEDSIZE | grep -Eo "[0-9]{1,}")
    local AVAILINT=$(echo $AVAILABLESIZE | grep -Eo "[0-9]{1,}") 
    local FULLINT=$(($AVAILINT+$USEDINT))
    local USEDPERCENT=$(calc "(($FULLINT/$AVAILINT)*100)-100")
    local SIZECHAR=$(echo $AVAILABLESIZE | grep -Eo "[a-zA-Z]")

    echo "(/) Full: $FULLINT$SIZECHAR | Avail: $AVAILABLESIZE | Used: $USEDSIZE(${USEDPERCENT:0:3}%)"
}

function getCpu() {
    local CPUINFO=$(cat /proc/cpuinfo  | grep 'name'| uniq | grep -Eo ':.*$')
    echo "$(removeFromString "$CPUINFO" ":")"
}

function getCpuTemps() {
    local TEMPINFO=$(cat /sys/class/thermal/thermal_zone*/temp | awk '{printf "%5.2f+", $1/1000}')
    TEMPINFO="${TEMPINFO//,/.}"
    TEMPCALC=$(echo "${TEMPINFO//,/.}" | sed 's/\(.*\)+.*/\1/')
    local TEMP=$(calc "(52.50+51.00+42.00)/3")
    echo "${TEMP:0:4}C"
}

HOSTNAME="$(getHostname)"
USERNAME="$(getCurrentUsername)"
UPTIME="$(getUptime)"
KERNEL="$(getKernel)"
OS="$(getOperatingSystem)"
RAM="$(getRam)"
DISK="$(getDiskSpace)"
CPU="$(getCpu)"
CPUTEMP="$(getCpuTemps)"

TAB="   "
DOUBLETAB=$TAB$TAB

echo
echo "$TAB $USERNAME@$HOSTNAME"
echo "$TAB ––––––––––––––––––––––––––––––––––––––––––"
echo "$TAB OS:  $DOUBLETAB $OS"
echo "$TAB KERNEL: $TAB $KERNEL"
echo "$TAB CPU:$DOUBLETAB $CPU"
echo "$TAB CPU TEMP:   $CPUTEMP"
echo "$TAB RAM: $DOUBLETAB $RAM"
echo "$TAB DISK: $TAB   $DISK"
echo "$TAB UPTIME: $TAB $UPTIME"
echo
