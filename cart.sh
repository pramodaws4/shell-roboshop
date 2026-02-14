#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/var/log/shell-roboshop"
LOG_FILE="$LOG_FILE/$0.log"
R='\e[31m' #red
G='\e[32m' #green
Y='\e[33m' #yellow
B='\e[34m' ##blue
N='\e[0m' ##default color
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.pramod88s.online"
          

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
if [ $? -ne 0 ]; then 
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
validate $? "adding user  "
else
 echo -e "rosboshop user already exit.. $Y Skipping $N"
fi


mkdir -p /app &>> $LOG_FILE
validate $? "creating app directory"

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>> $LOG_FILE
validate $? "downloading the cart code"

cd /app &>> $LOG_FILE
validate $? "moving to app directory"

rm -rf /app/*
validate $? "Removing existing code"

unzip /tmp/cart.zip &>> $LOG_FILE
validate $? "unzipng the code"

cd /app &>> $LOG_FILE
validate $? "moving to app directory"

npm install &>> $LOG_FILE
validate $? "intalling dependencys"

#cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>> $LOG_FILE
#validate $? "created systemctl service file "

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
validate $? "Created systemctl service"

systemctl daemon-reload
systemctl enable cart &>> $LOG_FILE
systemctl start cart
validate $? "crearestating enable and disable systemctl service cart "



