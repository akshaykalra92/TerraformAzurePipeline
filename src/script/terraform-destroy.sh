#!/usr/bin/env bash
set -euo pipefail

WORKING_DIRECTORY=${1}
cd ${WORKING_DIRECTORY}/terraform/

echo "********** Destroy ***********"
terraform apply -destroy -input=false -auto-approve