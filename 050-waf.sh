#!/bin/bash
 
CHANGESET_OPTION="--no-execute-changeset"

if [ $# = 1 ] && [ $1 = "deploy" ]; then
  echo "deploy mode"
  CHANGESET_OPTION=""
fi

# 指定パラメータ
SYSTEM_NAME=sample
TEMPLATE=050-waf

# テンプレート実行用パラメータ
CFN_STACK_NAME=${SYSTEM_NAME}-${TEMPLATE}
CFN_TEMPLATE=templates/${TEMPLATE}.yml

# テンプレートの実行
aws cloudformation deploy --stack-name ${CFN_STACK_NAME} --template-file ${CFN_TEMPLATE} ${CHANGESET_OPTION} \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
  SystemName=${SYSTEM_NAME}

exit
