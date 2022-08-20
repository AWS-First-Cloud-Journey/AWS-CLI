#!/bin/bash

# Setup Parameter - Replace <> with actual values
export REGION=<Region>
export VPC_ID=<VpcId>
export ROUTE_TABLE_ID=<RouteTableId>
export S3_BUCKET=<S3BucketName>

#Create VPC Endpoint
export VPC_ENDPOINT_ID=$(aws ec2 create-vpc-endpoint --region=$REGION --vpc-id $VPC_ID --service-name com.amazonaws.$REGION.s3 --route-table-ids $ROUTE_TABLE_ID --query 'VpcEndpoint.VpcEndpointId' --output text)

#Update Bucket Policy to allow access from the VPC Endpoint

cat <<'EOT'>> $S3_BUCKET-bucket-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Access-to-specific-VPCE-only",
            "Principal": "*",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": ["arn:aws:s3:::$S3_BUCKET/*"],
            "Condition": {
                "StringEquals": {
                    "aws:sourceVpce": "$VPC_ENDPOINT_ID"
                }
            }
        }
   ]
}
EOT

aws s3api put-bucket-policy --bucket=$S3_BUCKET --policy=file://$(pwd)/$S3_BUCKET-bucket-policy.json
