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
#CREATE TABLE reachability (TESTLOCAL TINYINT, TESTGOOGLE TINYINT, TESTIPF TINYINT, Tmstmp DATETIME);

DSTLIST="TESTLOCAL TESTGOOGLE TESTIPF"
for DST in $DSTLIST; do
 Tmstmp="$(date +'%F %T')"
 echo "INSERT INTO $TBNAME$DST ($DST,Tmstmp) VALUES ('`fping -i 5000 -c 10 -r 0 -t 800 -q $DST 2>&1 | awk -F/ '{print $4 * 10}'`', '$Tmstmp');" | mysql -u $USER -p$PASS $DBNAME &
done
