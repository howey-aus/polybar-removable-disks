#!/usr/bin/env bash

set -o errexit

LSBLK_COLS="NAME,RM,TYPE,MOUNTPOINT,LABEL" 
UNMOUNTED_COLOR=`xrdb -query | grep "*color9" | cut -f 2`
MOUNTED_COLOR=`xrdb -query | grep "*color10" | cut -f 2`
DEVICES="lsblk -pJlo $OUT_COLS"
JQ_SCR='.blockdevices[] |
    select(.rm != false and .type == "part") |
    if .mountpoint != null then "%{F'$MOUNTED_COLOR'}%{A3:udisksctl unmount -b " + .name + ":}" else "%{F'$UNMOUNTED_COLOR'}%{A1:udisksctl mount -b " + .name + ":}" end + " " + .name + "%{A}  "'

lsblk -pJlo $LSBLK_COLS |
jq "$JQ_SCR" |
sed 's/\/dev\///2' |
xargs -L1 echo -n
