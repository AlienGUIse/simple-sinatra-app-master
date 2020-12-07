#!/bin/bash

cd deploy/ecr
./ecr/init.sh
terraform apply -auto-approve
terraform_vars=$(terraform output --json)
REPOSITORY_URL=$(echo $terraform_vars  | jq -r .ecr_url.value)
REPOSITORY_NAME=$(echo $terraform_vars  | jq -r .ecr_name.value)
echo "$REPOSITORY_URL"
echo "$REPOSITORY_NAME"

cd ../..

echo -e "--- Building Docker Image and pushing to ECR"

# Build
docker build -t ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER} .

# Publish
docker push ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER} || \
  ( echo "Login expired. Relogging in..." && \
    eval $(aws ecr get-login --no-include-email --region ap-southeast-2) && \
    docker push ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER} )

# Pass REPOSITORY_URL to downstream buildkite steps
buildkite-agent meta-data set "REPOSITORY_URL" "${REPOSITORY_URL}"
buildkite-agent meta-data set "REPOSITORY_NAME" "${REPOSITORY_NAME}"

echo "Successfully pushed docker image to ${REPOSITORY_URL}:${BUILDKITE_BUILD_NUMBER}"