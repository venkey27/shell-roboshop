#! /bin/bash

AMI_ID=ami-0220d79f3f480ecf5
ZONE_ID=Z07587789JER0QOC5489 #REPLACE WITH YOUR ZONE ID
DOMAIN_NAME=exptrack.shop  #REPLACE WITH YOUR DOMAIN NAME

for instance in $@
do
    echo "Launching ec2 instance : $instance"
    INSTANCE_iD=$(aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-groups "roboshop-common" "roboshop-$instance" \
	--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="roboshop-$instance"}]' \
	--query 'Instances[0].InstanceId' \
    --output text)
    echo "instance ID : $INSTANCE_iD"

    if [ $instance == "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_iD --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
        echo "Publice IP is: $IP"

    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_iD --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
        echo "Private IP is: $IP"
    fi
done