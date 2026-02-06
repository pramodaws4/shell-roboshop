#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/ver/log/shell-roboshop"
LOG_FILE="$LOG_FILE/$0.log"
R='\e[31m' #red
G='\e[32m' #green
Y='\e[33m' #yellow
B='\e[34m' ##blue
D='\e[0m' ##default color

if [ $USERID -ne 0 ]; then
echo "Please run this root user access." | tee -a $LOG_FILE
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

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Copying Mongo Repo" 

dnf install mongodb-org -y 
validate $? "installing mongodb server"

systemctl enable mongod 
validate $? "enable mongodb "

systemctl start mongod 
validate $? "starts the mongodb "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "allowing remote connections "

systemctl restrt mongod
validate $? "restarted mongod"
