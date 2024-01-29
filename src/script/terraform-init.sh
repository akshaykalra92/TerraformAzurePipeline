#!/usr/bin/env bash
set -euo pipefail

WORKING_DIRECTORY=${1}

Environment=${2}
cd ${WORKING_DIRECTORY}/terraform/

echo "********** Initialize ********"
terraform init  -backend-config="key=terraform"$Environment".tfstate"  -input=false
terraform workspace select $Environment || terraform workspace new $Environment


echo -e "\n********** Code Check/Validate ********"
terraform validate