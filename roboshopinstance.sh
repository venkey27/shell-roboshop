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

ACTION=$1
shift # shift command is used to shift the positional parameters to the left. After this command, $1 will be the second argument, $2 will be the third argument, and so on. This allows us to easily access the instance names in the loop below.           
                                                             # != is used for string comparison. It checks if the value of ACTION is not equal to "create" and also not equal to "delete". If both conditions are true, it means an invalid action was specified.
if [ $ACTION != "create" ] && [ $ACTION != "delete" ]; then  # && is used for logical AND operation. It checks if both conditions are true. this condition checks if the ACTION variable is not equal to "create" and also not equal to "delete". If both conditions are true, it means an invalid action was specified.
    echo -e "${R}ERROR:: first argument must be 'create' or 'delete'. Use 'create' or 'delete'.${N}"
    echo "USAGE: $0 [create/delete] [instance1] [instance2] ..."
    exit 1
fi