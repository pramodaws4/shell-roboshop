#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/var/log/shell-roboshop"
LOG_FILE="$LOG_FILE/$0.log"
R='\e[31m' #red
G='\e[32m' #green
Y='\e[33m' #yellow
B='\e[34m' ##blue
N='\e[0m' ##default color

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

dnf module enable nodejs:20 -y &>> $LOG_FILE
validate $? "enabling new nodejs virsion"

dnf install nodejs -y &>> $LOG_FILE
validate $? "installing nodejs "

id roboshop &>> $LOG_FILE
if [ $? -ne 0]; then 
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
validate $? "adding user  "
else
 echo -e "rosboshop user already exit.. $Y Skipping $N"
fi


mkdir -p /app &>> $LOG_FILE
validate $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>> $LOG_FILE
validate $? "downloading the catalogue code"

cd /app &>> $LOG_FILE
validate $? "moving to app directory"

unzip /tmp/catalogue.zip &>> $LOG_FILE
validate $? "unzipng the code"

cd /app &>> $LOG_FILE
validate $? "moving to app directory"

npm install &>> $LOG_FILE
validate $? "intalling dependencys"

cp catalogue.service /etc/systemd/system/catalogue.service $LOG_FILE
validate $? "created systemctl service file "

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
validate $? "crearestating enable and disable systemctl service catalogue "

