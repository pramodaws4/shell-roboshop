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