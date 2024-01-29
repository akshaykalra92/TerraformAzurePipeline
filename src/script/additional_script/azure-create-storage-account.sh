#!/usr/bin/env bash
set -euo pipefail

LOCATION=uksouth
RG=rg-terraform-lab
# Create unique name for storage account
STORAGE_ACCOUNT=terrafromstatefile235
# Create unique name for container
CONTAINER_NAME=uks-terraform-tfstate

# Create Resource Group for Backend Storage
echo -e "\nCreate Resource Group for Backend Storage..."
az group create \
  --location ${LOCATION} \
  --name ${RG}
echo "***************************************************"

# Create local-Redundant Storage Account
echo -e "\nCreate local-Redundant Storage Account..."
az storage account create \
  --kind StorageV2 \
  --location ${LOCATION} \
  --name "${STORAGE_ACCOUNT}" \
  --resource-group ${RG}  \
  --sku Standard_LRS \
  --allow-blob-public-access false
echo "***************************************************"

# Create storage container
echo -e "\nCreate storage container..."
az storage container create \
  --account-name "${STORAGE_ACCOUNT}" \
  --name "${CONTAINER_NAME}"
echo "***************************************************"

# Enable blob soft-deletes
echo -e "\nEnable blob soft-deletes..."
az storage blob service-properties delete-policy update \
  --account-name "${STORAGE_ACCOUNT}" \
  --days-retained 7 \
  --enable true
echo "***************************************************"