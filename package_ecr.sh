#!/bin/bash

cd deploy/ecr
./init.sh
terraform apply -auto-approve -var-file=terraform.tfvars
terraform_vars=$(terraform output --json)
REPOSITORY_URL=$(echo $terraform_vars  | jq -r .ecr_url.value)
REPOSITORY_NAME=$(echo $terraform_vars  | jq -r .ecr_name.value)
echo ""

cd ../..

echo -e "--- Building Docker Image and pushing to ECR"

# Build
sudo docker build -t ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER} .

# Publish
sudo docker push ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER} || \
  ( echo "Login expired. Relogging in..." && \
    eval $(aws ecr get-login --region ap-southeast-2) && \
    sudo docker push ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER} )

# Pass REPOSITORY_URL to downstream buildkite steps
#buildkite-agent meta-data set "REPOSITORY_URL" "${REPOSITORY_URL}"
#buildkite-agent meta-data set "REPOSITORY_NAME" "${REPOSITORY_NAME}"

echo "Successfully pushed docker image to ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER}"