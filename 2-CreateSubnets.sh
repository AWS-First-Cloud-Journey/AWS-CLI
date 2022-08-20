#!/bin/bash

# Setup Parameter - Replace <> with actual values
export VPC_ID=<VpcId>
export REGION=<Region>
export AZ1=<AvailabilityZone1>
export AZ2=<AvailabilityZone2>
export NAT_SUBNET_CIDR=<CidrBlock>
export WEB_SUBNET_CIDR1=<CidrBlock>
export WEB_SUBNET_CIDR2=<CidrBlock>
export APP_SUBNET_CIDR1=<CidrBlock>
export APP_SUBNET_CIDR2=<CidrBlock>
export DB_SUBNET_CIDR1=<CidrBlock>
export DB_SUBNET_CIDR2=<CidrBlock>

# NAT Internet subnet
export SUBNET_ID_INTERNET=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $NAT_SUBNET_CIDR --availability-zone $AZ1 --query 'Subnet.SubnetId' --output text)

aws ec2 create-tags --resources $SUBNET_ID_INTERNET --tags Key=Name,Value=DEV-InternetSubnet-$NAT_SUBNET_CIDR --output text

# Web subnet
export SUBNET_ID_WEB1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $WEB_SUBNET_CIDR1 --availability-zone $AZ1 --query 'Subnet.SubnetId' --output text)

aws ec2 create-tags --resources $SUBNET_ID_WEB1 --tags Key=Name,Value=DEV-Web-PublicSubnet-$AZ1-$WEB_SUBNET_CIDR1 --output text

export SUBNET_ID_WEB2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $WEB_SUBNET_CIDR2 --availability-zone $AZ2 --query 'Subnet.SubnetId' --output text)

aws ec2 create-tags --resources $SUBNET_ID_WEB2 --tags Key=Name,Value=DEV-Web-PublicSubnet-$AZ2-$WEB_SUBNET_CIDR2 --output text

# Application subnet
export SUBNET_ID_APP1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $APP_SUBNET_CIDR1 --availability-zone $AZ1 --query 'Subnet.SubnetId' --output text)

aws ec2 create-tags --resources $SUBNET_ID_APP1 --tags Key=Name,Value=DEV-APP-PrivateSubnet-$AZ1-$APP_SUBNET_CIDR1 --output text

export SUBNET_ID_APP2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $APP_SUBNET_CIDR2 --availability-zone $AZ2 --query 'Subnet.SubnetId' --output text)

aws ec2 create-tags --resources $SUBNET_ID_APP2 --tags Key=Name,Value=DEV-APP-PrivateSubnet-$AZ2-$APP_SUBNET_CIDR2 --output text

# Database subnet
export SUBNET_ID_DB1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $DB_SUBNET_CIDR1 --availability-zone $AZ1 --query 'Subnet.SubnetId' --output text)

aws ec2 create-tags --resources $SUBNET_ID_DB1 --tags Key=Name,Value=DEV-DB-PrivateSubnet-$AZ1-$DB_SUBNET_CIDR1 --output text

export SUBNET_ID_DB2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $DB_SUBNET_CIDR2 --availability-zone $AZ2 --query 'Subnet.SubnetId' --output text)

aws ec2 create-tags --resources $SUBNET_ID_DB2 --tags Key=Name,Value=DEV-DB-PrivateSubnet-$AZ2-$DB_SUBNET_CIDR2 --output text
