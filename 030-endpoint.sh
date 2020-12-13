#!/bin/bash
 
CHANGESET_OPTION="--no-execute-changeset"

if [ $# = 1 ] && [ $1 = "deploy" ]; then
  echo "deploy mode"
  CHANGESET_OPTION=""
fi

# 指定パラメータ
SYSTEM_NAME=sample
TEMPLATE=030-endpoint

# テンプレート実行用パラメータ
CFN_STACK_NAME=${SYSTEM_NAME}-${TEMPLATE}
CFN_TEMPLATE=templates/${TEMPLATE}.yml
AWS_REGION=ap-northeast-1

# テンプレートの実行
aws cloudformation deploy --stack-name ${CFN_STACK_NAME} --template-file ${CFN_TEMPLATE} ${CHANGESET_OPTION} \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
  SystemName=${SYSTEM_NAME}

# タグの生成
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${SYSTEM_NAME}-vpc" | \
  jq '.Vpcs[].VpcId' | \
  xargs -I@ aws ec2 describe-vpc-endpoints --filters "Name=service-name,Values=com.amazonaws.${AWS_REGION}.s3" "Name=vpc-id,Values=@" | \
  jq '.VpcEndpoints[].VpcEndpointId' | \
  xargs -I@ aws ec2 create-tags --resources @ --tags Key=Name,Value=${SYSTEM_NAME}-endpoint-s3
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${SYSTEM_NAME}-vpc" | \
  jq '.Vpcs[].VpcId' | \
  xargs -I@ aws ec2 describe-vpc-endpoints --filters "Name=service-name,Values=com.amazonaws.${AWS_REGION}.ecr.dkr" "Name=vpc-id,Values=@" | \
  jq '.VpcEndpoints[].VpcEndpointId' | \
  xargs -I@ aws ec2 create-tags --resources @ --tags Key=Name,Value=${SYSTEM_NAME}-endpoint-ecr-dkr
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${SYSTEM_NAME}-vpc" | \
  jq '.Vpcs[].VpcId' | \
  xargs -I@ aws ec2 describe-vpc-endpoints --filters "Name=service-name,Values=com.amazonaws.${AWS_REGION}.ecr.api" "Name=vpc-id,Values=@" | \
  jq '.VpcEndpoints[].VpcEndpointId' | \
  xargs -I@ aws ec2 create-tags --resources @ --tags Key=Name,Value=${SYSTEM_NAME}-endpoint-ecr-api

exit
