#! /bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z07587789JER0QOC5489" #REPLACE WITH YOUR ZONE ID
DOMAIN_NAME="exptrack.shop"  #REPLACE WITH YOUR DOMAIN NAME

R='\e[31m'
G='\e[32m'
Y='\e[33m'
N='\e[0m'
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if [ $# -lt 2 ]; then    # $# gives the number of arguments passed to the script
    echo -e "${R}ERROR:: At least 2 arguments are required${N}"
    echo "USAGE: $0 [create/delete] [instance1] [instance2] ..." # $0 gives the name of the script
    exit 1
fi

