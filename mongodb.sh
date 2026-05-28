#! /bin/bash

LOGS_FOLDER="/var/log/roboshop"
sudo mkdir -p $LOGS_FOLDER
sudo chown -R ec2-user:ec2-user $LOGS_FOLDER
sudo chmod -R 755 $LOGS_FOLDER
LOGS_FILE="$LOGS_FOLDER/$0.log"


USERID=$(id -u)
R='\e[31m'
G='\e[32m'
Y='\e[33m'
N='\e[0m'
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")


if [ $USERID -ne 0 ]; then
    echo -e " $TIMESTAMP [ERROR] $R RUN T HE MONGODB SCRIPT WITH ROOT ACCESS $N " | tee -a $LOGS_FILE
    exit 1
fi  

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e " $TIMESTAMP [ERROR] $2 ... $R failure $N " | tee -a $LOGS_FILE
        exit 1
    else
        echo -e " $TIMESTAMP [INFO]  $2 ... $G is successfully completed $N " | tee -a $LOGS_FILE
    fi
}
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "adding mongo repo file"                       #$? -> this is the exit code of the last command

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "installing mongodb"

systemctl enable --now mongod
VALIDATE $? "starting and enabling mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allowing remote connections to mongodb"

systemctl restart mongod
VALIDATE $? "restarting mongodb"