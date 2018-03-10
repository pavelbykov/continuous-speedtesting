#!/bin/bash

# Script reads CPU/MEM/HDD system parameters and pushes them into db


if [ -z "$4" ]
then
    echo "Usage: $0 <user> <pass> <dbname> <tbname>"
	exit 1
else
      USER=$1
      PASS=$2
      DBNAME=$3
      TBNAME=$4
fi


# If table does not exist, create a table.
# You can use hostname as name.
#CREATE TABLE $HOSTNAME (Hostnm VARCHAR(32), PrivIPv4Addr VARCHAR(15), PubIPv4Addr VARCHAR(15), CPU1M FLOAT, CPU5M FLOAT, CPU15M FLOAT, MTOTAL BIGINT, MUSED BIGINT, MFREE BIGINT, HDDTOTAL BIGINT, HDDUSED BIGINT, HDDFREE BIGINT, Tmstmp DATETIME);

Hostnm="$(hostname)"
PrivIPv4Addr="$(hostname -I | awk '{print $1}')"
PubIPv4Addr="$(dig +short myip.opendns.com @resolver1.opendns.com)"
Tmstmp="$(date +'%F %T')"

IFS=',' read CPU1M CPU5M CPU15M <<< `cat /proc/loadavg | awk '{print $1","$2","$3}'`
IFS=',' read UPTIM <<< `cat /proc/uptime | awk '{print $1/60}'`

IFS=',' read MTOTAL MUSED MFREE <<< `free -b | awk '/^Mem/{print $2","$3","$4}'`
IFS=',' read  HDDTOTAL HDDUSED HDDFREE <<< `df --block-size=1 | grep /$ | awk '{print $2","$3","$4}'`

echo "INSERT INTO $TBNAME (Hostnm,PrivIPv4Addr,PubIPv4Addr,UPTIM,CPU1M,CPU5M,CPU15M,MTOTAL,MUSED,MFREE,HDDTOTAL,HDDUSED,HDDFREE,Tmstmp) VALUES ('$Hostnm', '$PrivIPv4Addr', '$PubIPv4Addr', '$UPTIM', '$CPU1M', '$CPU5M', '$CPU15M', '$MTOTAL', '$MUSED', '$MFREE', '$HDDTOTAL', '$HDDUSED', '$HDDFREE', '$Tmstmp');" | mysql -u $USER -p$PASS $DBNAME
