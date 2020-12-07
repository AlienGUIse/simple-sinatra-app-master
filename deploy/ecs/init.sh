#!/bin/bash

if [ -f ./.terraform/terraform.tfstate ];
then
    echo "Removing existing config"
    rm -f ./.terraform/terraform.tfstate
else
    echo "No existing config"
fi

set -x ; terraform init \
    #-backend-config="kms_key_id=$kms_arn"
set +x
echo "Finished Terraform Init"
