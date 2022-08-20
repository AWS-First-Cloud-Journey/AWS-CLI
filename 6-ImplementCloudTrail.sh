#!/bin/bash

# Setup Parameter - Replace <> with actual values
export TRAIL_NAME=<TrailName>
export S3_BUCKET=<S3BucketName>
export S3_PREFIX=<ObjectPrefix>
export ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

# Create bucket to store log
aws s3 mb s3://$S3_BUCKET

# Create bucket policy json
cat <<'EOT'>> $S3_BUCKET-bucket-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::$S3_BUCKET"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::$S3_BUCKET/$S3_PREFIX/AWSLogs/$ACCOUNT_ID/*",
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        }
    ]
}
EOT

# Assign S3 bucket policy
aws s3api put-bucket-policy --bucket=$S3_BUCKET --policy=file://$(pwd)/$S3_BUCKET-bucket-policy.json

# Create and start trail
aws cloudtrail create-trail --region=$REGION --name=$TRAIL_NAME --s3-bucket-name=$S3_BUCKET --s3-key-prefix=$S3_PREFIX

aws cloudtrail start-logging --region=$REGION --name=$TRAIL_NAME
