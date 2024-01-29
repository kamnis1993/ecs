#!/bin/bash

REGION=ap-northeast-1
ACCOUNT_ID=643575754776
ACCESS_KEY=AKIAZLWA2WAMLKET3IU6
SECRET_KEY=3LGgYgQVKQ7PVwDKIGWpVFgIPgNK7TVColh2psMJ
COMMIT_HASH=default
ECS_SERVICE_ARN=arn:aws:ecs:ap-northeast-1:643575754776:cluster/example

# Your ECS deployment commands here

# Example ECS Update Service Command
aws ecs update-service \
  --region $REGION \
  --cluster your-cluster-name \
  --service $ECS_SERVICE_ARN \
  --task-definition your-task-definition:latest

# Tag ECS tasks with the commit hash
aws ecs tag-resource \
  --region $REGION \
  --resource-arn $ECS_SERVICE_ARN \
  --tags Key=CommitHash,Value=$COMMIT_HASH

