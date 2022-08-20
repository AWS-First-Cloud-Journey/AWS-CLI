#!/bin/bash

# Setup Parameter - Replace <> with actual values
export VPC_ID=<VpcId>
export SUBNET_ID_INTERNET=<SubnetId>

# Create Internet Gateway
export IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)

aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=DEV-InternetGateway

# Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --output text

# Create Elastic IP address
export ALLOC_ID=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)

aws ec2 create-tags --resources $ALLOC_ID --tags Key=Name,Value=DEV-Elastic-IP

# Create NAT Gateway
export NATGW_ID=$(aws ec2 create-nat-gateway --allocation-id $ALLOC_ID --subnet-id $SUBNET_ID_INTERNET --query 'NatGateway.NatGatewayId' --output text)

aws ec2 create-tags --resources $NATGW_ID --tags Key=Name,Value=DEV-NAT-GW
