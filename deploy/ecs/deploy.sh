#!/bin/bash

export TF_VAR_ECR_URL=$(buildkite-agent meta-data get "REPOSITORY_URL" --job ${TRIGGER_ID})

./init.sh

#deploy ECS
terraform apply --auto-approve