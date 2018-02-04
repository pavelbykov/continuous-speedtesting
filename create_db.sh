#!/bin/bash

if [ -z "$1" ]
then
    echo "Usage: $0 <mysqlrootpwd> [dbname] [user] [pass]"
	echo "Random values generated for empty parameters"
fi

if [ -z "$2" ]
then
      DBNAME="$(openssl rand -base64 12)"
else
      DBNAME=$2
fi

if [ -z "$3" ]
then
      USER="$(openssl rand -base64 12)"
else
      USER=$3
fi

if [ -z "$4" ]
then
      PASS="$(openssl rand -base64 12)"
else
      PASS=$4
fi


mysql -uroot -p$1
CREATE DATABASE $DBNAME;
CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $DBNAME.* TO '$USER'@'localhost';
FLUSH PRIVILEGES;


# Create table based on speedtest csv results
# Avoid Timestamp keyword
# CREATE TABLE $PROVIDER (ServerID INT, Sponsor VARCHAR(32), ServerName VARCHAR(32), Tmstmp DATETIME, Distance FLOAT, Ping FLOAT, Download FLOAT, Upload FLOAT, IPv4Addr VARCHAR(15));
