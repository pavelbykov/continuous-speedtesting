#!/bin/bash

if [ -z "$4" ]
 then
  echo "Usage: $0 <user> <pass> <dbname> <tablename>"
  exit 1
fi


IFS=,

USER=$1
PASS=$2
DBNAME=$3
TBNAME=$4

#Perform speed test and store results temporarily on disk
speedtest-cli --csv > temp_speedtest_result.csv

#determine public IP address
IPv4Addr=$(dig +short myip.opendns.com @resolver1.opendns.com)

#loop through CSV and push fields to db
while read ServerID Sponsor ServerName Timestamp Distance Ping Download Upload
      do
        echo "INSERT INTO $TBNAME (ServerID,Sponsor,ServerName,Timestamp,Distance,Ping,Download,Upload) VALUES ('ServerID', '$Sponsor', '$ServerName', '$Timestamp', '$Distance', '$Ping', '$Download', '$Upload', '$IPv4Addr');"

done < temp_speedtest_result.csv | mysql -u $USER -p$PASS $DBNAME;


#Backup results to master CSV and delete previous results
cat temp_speedtest_result.csv >> results_backup.csv
rm temp_speedtest_result.csv
