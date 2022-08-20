#!/bin/bash

# List Transit Gateway in system - Run first to select the right Transit Gateway ID

aws ec2 describe-transit-gateways --output text

# Setup Parameter - Replace <> with actual values
export TGW_ID=<TransitGatewayId>
export VPC_ID=<VpcId>
export SUBNET_ID_WEB1=<SubnetId>
export SUBNET_ID_WEB2=<SubnetId>

# Create Transit Gateway attachment ( Require to list at least 1 subnet per availability zone )
export TGW_ATTACHMENT=$(aws ec2 create-transit-gateway-vpc-attachment --transit-gateway-id $TGW_ID --vpc-id $VPC_ID --subnet-ids $SUBNET_ID_WEB1 $SUBNET_ID_WEB2 --query 'TransitGatewayVpcAttachment.TransitGatewayAttachmentId' --output text)

aws ec2 create-tags --resources $TGW_ATTACHMENT --tags Key=Name,Value=DEV-Transitgateway-attachment
