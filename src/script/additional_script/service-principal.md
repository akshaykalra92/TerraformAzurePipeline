# Create a Service Principal - Azure CLI

This topic shows you how to permit a service principal (such as an automated process, application, or service) to access other resources in your subscription.

A service principal contains the following credentials which will be mentioned in this page. Storing them in a key vault because they are sensitive credentials.

- **TENANT_ID**
- **CLIENT_ID**
- **CLIENT_SECRET**

>**NOTE:** A service principal have two types: password-based and certificate-based. This topic only covers the password-based service principal.

# Create a Service Principal using Azure CLI 2.0

The easiest way to create the Service Principal is with the Azure Cloud Shell in the Azure portal which provides a pre-installed, pre-configured Azure CLI 2.0. If you can't use Azure Cloud Shell, you may [install Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) in the system of your preference.

You can then create the service principal by simply typing `az ad sp create-for-rbac`. You can get more information from the [doc](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?toc=%2fazure%2fazure-resource-manager%2ftoc.json&view=azure-cli-latest).

The default role is `Contributor` and the default scope is the current subscription.

The output, in JSON format, contains the `appId`, `password` and `tenant` parameters that correspond to `CLIENT_ID`, `CLIENT_SECRET` and `TENANT_ID` in the rest of this document. You can optionally use `--output table` or even `--output tsv` as an additional option to `az`.


# Create a Service Principal using Azure CLI 2.0

## 1.1 Install Azure CLI 2.0

Install and configure Azure CLI following the documentation [**HERE**](http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/).

The following commands in this topic are based on Azure CLI version `2.56.0`.

>**NOTE:**
* It is suggested to run Azure CLI using Ubuntu Server 14.04 LTS or Windows 10.
* If you are using Windows, it is suggested that you use **command line** but not PowerShell to run Azure CLI.
* If you hit the error `/usr/bin/env: node: No such file or directory` when running `az` commands, you need to run `sudo ln -s /usr/bin/nodejs /usr/bin/node`.

<a name="configure_azure_cli"></a>
## 1.2 Configure Azure CLI 2.0


### 1.2.1 Login

```
#Enter your Microsoft account credentials when prompted.
az login 
```

>**NOTE:**
* `az login` requires a work or school account. Never login with your personal account. If you do not have a work or school account currently, you can easily create a work or school account with the [**guide**](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-connect/).

# 2 Create a Service Principal

Azure CLI provisions resources in Azure using the Azure Resource Manager (ARM) APIs. We use a Service Principal account to give Azure cli the access to proper resources.

## 2.1 Via Script (RECOMMENDED)

1. Download [azure-create-service-principal.sh](https://raw.githubusercontent.com/akshaykalra92/TerraformAzurePipeline/main/src/script/additional_script/azure-create-service-principal.sh)
2. Run the script to generate your Service Principal.

Sample output:
  ```
  ==============Created Serivce Principal==============
  SUBSCRIPTION_ID: 123456-5678-1234-67845678
  TENANT_ID:       111115678-1234-678945678
  CLIEND_ID:       8765-5678-1234-67895678
  CLIENT_SECRET:   RANDOM-STRING
  ```
## 3 Key Vault

I am storing only CLIENT_SECRET in the key vault, If you want to store the CLIENT_ID in key store then do it manually.


>**NOTE:**
1. Verify that the subscription which the service principal belongs to is the same subscription that is used to create your resource group. (This may happen when you have multiple subscriptions.)

1. Verify that your service principal has been assigned the correct roles according to your usage. For example, verify whether you can use the service principal to create the service which you want.

1. Recreate a service principal on your tenant if the service principal is invalid.

> **NOTE:** In some cases, if the service principal is invalid, then the deployment  will fail. Errors in `~/run.log` will show `get_token - http error`.