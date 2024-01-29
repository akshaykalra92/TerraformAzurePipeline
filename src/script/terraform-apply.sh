#!/usr/bin/env bash
set -euo pipefail

WORKING_DIRECTORY=${1}
cd ${WORKING_DIRECTORY}/terraform/

echo "********** Apply ***********"
terraform apply -input=false tfplan_${BUILD_BUILDNUMBER}.tfplan