#!/bin/bash


if [ -f ./.terraform/terraform.tfstate ];
then
    echo "Removing existing config"
    rm -f ./.terraform/terraform.tfstate
else
    echo "No existing config"
fi

echo "Building ECR"
set -x ; terraform init 
set +x
echo "Finished Terraform Init"
