#!/bin/bash

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

# If table does not exist, Create table based on speedtest csv results
# Avoid Timestamp keyword
# CREATE TABLE $PROVIDER (ServerID INT, Sponsor VARCHAR(32), ServerName VARCHAR(32), Tmstmp DATETIME, Distance FLOAT, Ping FLOAT, Download FLOAT, Upload FLOAT, IPv4Addr VARCHAR(15));


#Perform speedtest and store results in variables
IFS=',' read ServerID Sponsor ServerName Tmstmp Distance Ping Download Upload <<< `speedtest-cli --csv`

#determine public IP address
PubIPv4Addr=$(dig +short myip.opendns.com @resolver1.opendns.com)


# Push results into DB
# Public IP missing from the record
echo "INSERT INTO $TBNAME (ServerID,Sponsor,ServerName,Tmstmp,Distance,Ping,Download,Upload,PubIPv4Addr) VALUES ('$ServerID', '$Sponsor', '$ServerName', '$Tmstmp', '$Distance', '$Ping', '$Download', '$Upload', '$PubIPv4Addr');" | mysql -u $USER -p$PASS $DBNAME

#Backup results to master CSV
echo "$ServerID,$Sponsor,$ServerName,$Tmstmp,$Distance,$Ping,$Download,$Upload,$IPv4Addr" >> results_backup.csv
