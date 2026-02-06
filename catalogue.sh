#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/var/log/shell-roboshop"
LOG_FILE="$LOG_FILE/$0.log"
R='\e[31m' #red
G='\e[32m' #green
Y='\e[33m' #yellow
B='\e[34m' ##blue
D='\e[0m' ##default color

if [ $USERID -ne 0 ]; then
echo "Please run this root user access." | tee -a $LOG_FILE
    exit 1
fi

mkdir -p $LOG_FOLDER

validate(){
if [ $1 -ne 0 ]; then 
    echo "$2 installation ... failed" | tee -a $LOG_FILE
    exit 1
else
    echo "$2 installation .... successfully" | tee -a $LOG_FILE
fi
}

dnf module disable nodejs -y &>> $LOG_FILE
validate $? "disabling nodejs default virsion"

dnf module enable nodejs:20 -y
validate $? "enabling new nodejs virsion"



dnf install nodejs -y
validate $? "installing nodejs "

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "adding user  "


mkdir /app 
validate $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip


cd /app 
npm install 

systemctl daemon-reload

systemctl enable catalogue 
systemctl start catalogue