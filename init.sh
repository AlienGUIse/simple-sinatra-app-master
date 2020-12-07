#!/bin/bash

#initialise terraform

key_name="simple-sinatra"
locktable="terraformlocks"
state_bucket="simple-sinatra-state"
region="ap-southeast-2"

if [ -f ./.terraform/terraform.tfstate ];
then
    echo "Removing existing config"
    rm -f ./.terraform/terraform.tfstate
else
    echo "No existing config"
fi

set -x ; terraform init \
    -backend-config="bucket=$state_bucket" \
	#-backend-config="key=$key_name" \
	-backend-config="region=$region" \
	-backend-config="dynamodb_table=$locktable" \
    #-backend-config="kms_key_id=$kms_arn"
set +x
echo "Finished Terraform Init"