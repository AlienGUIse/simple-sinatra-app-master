#!/bin/bash

export TF_VAR_BUILD_NUMBER=$BUILD_NUMBER
export TF_VAR_ECR_URL=$(buildkite-agent meta-data get "REPOSITORY_URL" --job ${TRIGGER_ID})

echo "$TF_VAR_ECR_URL"
echo "$TF_VAR_BUILD_NUMBER"

cd deploy/ecs
./init.sh

#deploy ECS
terraform apply --auto-approve