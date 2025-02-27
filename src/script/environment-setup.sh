#!/usr/bin/env bash
set -euo pipefail

echo "##vso[task.setvariable variable=AZURE_CLIENT_ID;issecret=true]${servicePrincipalId}"
echo "##vso[task.setvariable variable=AZURE_CLIENT_SECRET;issecret=true]${servicePrincipalKey}"
echo "##vso[task.setvariable variable=AZURE_SUBSCRIPTION_ID;issecret=true]$(az account show --query 'id' -o tsv)"
echo "##vso[task.setvariable variable=AZURE_TENANT_ID;issecret=true]$(az account show --query tenantId -o tsv)"