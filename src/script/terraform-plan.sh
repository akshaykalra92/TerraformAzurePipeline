#!/usr/bin/env bash
set -euo pipefail

WORKING_DIRECTORY=${1}
cd ${WORKING_DIRECTORY}/terraform/

echo "********** Plan ***********"
terraform plan -input=false -out tfplan_${BUILD_BUILDNUMBER}.tfplan