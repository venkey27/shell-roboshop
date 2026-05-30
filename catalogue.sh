#! /bin/bash

LOGS_FOLDER="/var/log/roboshop"
sudo mkdir -p $LOGS_FOLDER
sudo chown -R ec2-user:ec2-user $LOGS_FOLDER
sudo chmod -R 755 $LOGS_FOLDER
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD

USERID=$(id -u)
R='\e[31m'
G='\e[32m'
Y='\e[33m'
N='\e[0m'
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")


if [ $USERID -ne 0 ]; then
    echo -e " $TIMESTAMP [ERROR] $R RUN the SCRIPT WITH ROOT ACCESS $N " | tee -a $LOGS_FILE
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

dnf module disable nodejs -y &>> $LOGS_FILE
dnf module enable nodejs:20 -y &>> $LOGS_FILE
dnf install nodejs -y &>> $LOGS_FILE
VALIDATE $? "installing nodejs"

id roboshop &>> $LOGS_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
    VALIDATE $? "creating roboshop user"
else
    echo -e " $TIMESTAMP [INFO]  roboshop user already exists ... $G skipping user creation $N " | tee -a $LOGS_FILE        
fi

rm -rf /app &>> $LOGS_FILE
VALIDATE $? "removing existing application code"

rm -rf /tmp/catalogue.zip &>> $LOGS_FILE
VALIDATE $? "removing existing catalogue zip"

mkdir -p /app &>> $LOGS_FILE
VALIDATE $? "creating application directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>> $LOGS_FILE
cd /app 
unzip /tmp/catalogue.zip
VALIDATE $? "downloading and extracting catalogue code"
 

npm install &>> $LOGS_FILE
VALIDATE $? "installing nodejs dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service # this is the service file which we have created in our local and we are copying it to the systemd directory to avoid any issues with the path of the service file
VALIDATE $? "copying catalogue systemd service file"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "adding mongo repo file"

dnf install mongodb-mongosh -y &>> $LOGS_FILE
VALIDATE $? "installing mongodb client"

