#!/usr/bin/env bash
#   1. Azure CLI is installed on the machine when this script is runnning
#   2. Current account has sufficient privileges to create AAD application and service principal
#
#   This script will return clientID, tenantID, client-secret that can be used further

set +e
echo "Check if Azure CLI has been installed..."
VERSION_CHECK=`az -v | grep '[^0-9\.rc]'`
if [ -z "$VERSION_CHECK" ]; then
    echo "Azure CLI is not installed. Please install Azure CLI by following tutorial at https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/."
    exit 1
else
  echo "Azure CLI exist..."
  echo "***************************************************"
fi

# check if user needs to login
echo "Check if Azure CLI has been login..."
LOGIN_CHECK=`az resource list 2>&1 | grep error`
if [ -n "$LOGIN_CHECK" ]; then
    echo "You need login to continue..."
    az login
else
    echo "Already logged in..."
    echo "***************************************************"
fi


# get subscription count, let user choose one if there're multiple subcriptions
SUBSCRIPTION_COUNT=`az account list | grep Enabled | awk '{print NR}' | tail -1`

if [ "$SUBSCRIPTION_COUNT" -gt 1 ]; then
  echo "There are $SUBSCRIPTION_COUNT subscriptions in your account:"
  az account list --output table
  read -p "Enter the Id of the subscription that you want to create Service Principal with: " INPUT_ID
# Getting subscription ID
  SUBSCRIPTION_ID=`az account set "$INPUT_ID"`
  echo "Use subscription $SUBSCRIPTION_ID..."
else
   SUBSCRIPTION_ID=`az account show --query id -o tsv`
   echo "Subscription ID fetched successfully $SUBSCRIPTION_ID..."
fi

# Getting tenant ID
TENANT_ID=`az account show --query tenantId -o tsv`
echo "Tenant ID fetched successfully $TENANT_ID..."
echo "***************************************************"


# create Service Principal
echo -e " \nCreate Active Directory application..."
read -p "Enter the application name that you want to create Service Principal with: " SPNAME
if [ $(az ad app list --display-name "$SPNAME" --query "[]".appId  -o tsv) ]; then
    # Getting client ID
    CLIENT_ID=`az ad app list --display-name "$SPNAME" --query "[]".appId  -o tsv`
    echo "client secret ID successfully $CLIENT_ID..."
else
    CLIENT_ID=`az ad app create --display-name "$SPNAME" --query appId --output tsv`
    az ad sp create --id $CLIENT_ID
    echo "client secret ID successfully $CLIENT_ID..."
    echo "***************************************************"
fi

if [ -z "$CLIENT_ID" ]; then
   echo "Client id is empty, Cant create Client Secret"
else
    # create Service Principal secret
    echo -e "\nCreate application client secret..."
    read -p "Enter the name of the secret for the application: " SECRET
    CLIENT_SECRET=`az ad app credential reset --id "$CLIENT_ID" --append --display-name "$SECRET" --years 2 --query password --output tsv`
    echo "client secret created successfully $CLIENT_SECRET..."
    echo "***************************************************"
fi

# let user choose what kind of role they need
echo -e "\nChecking Role assignment..."
Role=`az role assignment list --assignee $CLIENT_ID --query "[]".name -o tsv`
if [ -n "$Role"  ]; then
    echo -e "\nRole assignment exist"
    echo "***************************************************"
else
    echo -e "\nWhat kind of privileges do you want to assign to Service Principal?"
    echo "1) Least privileges, only virtualMachines"
    echo "2) Full privileges on subcription, includes Contributor"
    read -p "Please choose by entering 1 or 2: " PRIVILEGE

    echo "Assign roles to Service Principal..."
    if [ "$PRIVILEGE" -eq 2 ]; then
        az role assignment create  --role "Contributor" --scope subscriptions/"$SUBSCRIPTION_ID"  --assignee "$CLIENT_ID"
        echo "Role assignment done successfully..."
        echo "***************************************************"
    elif [ "$PRIVILEGE" -eq 1 ]; then
        read -p "Please provide the resourceGroups name where you want to create virtualMachines : " ResourceGroup
        az role assignment create --role "Virtual Machine Contributor" --scope subscriptions/"$SUBSCRIPTION_ID"/resourceGroups/"$ResourceGroup"/providers/Microsoft.Compute/virtualMachines  --assignee "$CLIENT_ID"
        echo "Role assignment done successfully..."
        echo "***************************************************"
    else
      echo "Not a valid option"
      exit 1
    fi
fi

# Create Resource Group for key vault
# location : Uksouth
echo -e "\nCreate Resource Group for key vault..."
read -p "Please provide the resourceGroups name which you want to create : " RESOURCEGROUPNAME
RESOURCEGROUP=`az group create --name "$RESOURCEGROUPNAME" --location uksouth --query name -o tsv`
echo "Resource Group created successfully $RESOURCEGROUP..."
echo "***************************************************"

# Create key vault
# location : Uksouth
echo -e "\nCreate key vault..."
Random=$(shuf -i0-9 -n1)  # for multiple principal secret name in key vault.
read -p "Please provide the KeyVault name which you want to create : " KeyVault
if [ $(az keyvault list --resource-group "$RESOURCEGROUP" --resource-type vault --query "contains([].name, '$KeyVault')") = false ]; then
    while true; do
      az keyvault create --name "$KeyVault" --resource-group "$RESOURCEGROUP" --location "Uksouth" --enable-rbac-authorization false
        if [ $? -eq 1 ]; then
            break
            echo "KeyVault creation failed..."
        fi
      sleep 10
      echo "KeyVault created successfully..."
      echo "***************************************************"
    done
    az keyvault set-policy --name "$KeyVault" --object-id "$CLIENT_ID" --secret-permissions all
    echo "KeyVault policy set successfully..."
    echo "***************************************************"
    az keyvault secret set --vault-name "$KeyVault" --name servicePrincipalKey"$Random" --value "$CLIENT_SECRET"
    echo "KeyVault secret set successfully..."
    echo "***************************************************"
else
    echo "KeyVault already exist.."
    echo "***************************************************"
fi

# check if secret exist in key vault
echo -e "\ncheck if secret exist in key vault..."
secret_exists=`az keyvault secret list --vault-name "$KeyVault" --query "contains([].id, 'https://$KeyVault.vault.azure.net/secrets/servicePrincipalKey"$Random"')"`

if [ $secret_exists == true ]; then
    echo "Secret exists! fetching..."
    CLIENT_SECRET_FROM_KEYVAULT=`az keyvault secret show --name servicePrincipalKey"$Random" --vault-name "$KeyVault" --query value`
    echo "client secret fetched"
    echo "***************************************************"
else
    echo "client secret doesn't exist"
    echo "***************************************************"
fi

# output service principal
echo -e "\n==============Created Serivce Principal=============="
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "TENANT_ID:       $TENANT_ID"
echo "CLIENT_ID:       $CLIENT_ID"
echo "CLIENT_SECRET: $CLIENT_SECRET_FROM_KEYVAULT"
echo "Successfully created Service Principal."