#!/bin/bash

SG_ID="sg-00014de2d5b7245ea"    
AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z07833774KRBYAM5PAXD"
DOMAIN_NAME="pramod88s.online"

for instance in $@
do
    instance_id=$( aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [ $instance == "frontend" ]; then
       IP=$(
        aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query 'Reservations[*].Instances[*].PublicIpAddress' \
            --output text
    )
      RECORD_NAME=$DOMAIN_NAME    
    else
       IP=$(
        aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query 'Reservations[*].Instances[*].PrivateIpAddress' \
            --output text
    )
    RECORD_NAME=$instance.$DOMAIN_NAME
    fi

    echo "ip adress : " $IP

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
                {
                "Comment": "Updating a record",
                "Changes": [
                    {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "'$RECORD_NAME'",
                        "Type": "CNAME",
                        "TTL": 1,
                        "ResourceRecords": [
                        {
                            "Value": "'$IP'"
                        }
                        ]
                    }
                    }
                ]
                }' 

    echo "records update and creasted for  $instace"
        

done
