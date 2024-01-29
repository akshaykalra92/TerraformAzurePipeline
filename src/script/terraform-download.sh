#!/usr/bin/env bash
set -euo pipefail

echo "********** Download Terraform ***********"

if [ "terraform --version | grep ${TERRAFORM_VERSION}" ]; then
  echo "terraform already installed"
  terraform --version
else
  curl -SL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" --output terraform.zip
  echo "${TERRAFORM_DOWNLOAD_SHA} terraform.zip" | sha256sum -c -
  unzip terraform.zip
  mv -f terraform /usr/local/bin
  terraform --version
  rm terraform.zip
fi