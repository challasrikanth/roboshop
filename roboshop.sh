#!/bin/bash 

SG_ID="sg-051e7eba9b20c046f"
AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z09279692055UBYT8TIQD"
DOMAIN_NAME="srikanthchalla.online"
for instance in $@
do 
 INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

if [ $instance == "frontend" ]; then
     IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
        )
        RECORD_NAME="$DOMAIN_NAME"
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        )
    echo "Ip Addres: $IP"
fi
done