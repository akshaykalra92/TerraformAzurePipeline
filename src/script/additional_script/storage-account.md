<properties
pageTitle="Using the Azure CLI with Azure Storage | Microsoft Azure"
description="Learn how to use the Azure Command-Line Interface (Azure CLI) with Azure Storage to create and manage storage accounts and work with Azure blobs and files."
services="storage"
documentationCenter="na"
authors="akshay"/>

# Using the Azure CLI with Azure Storage

## Overview
The Azure CLI provides a set of open source, cross-platform commands for working with the Azure Platform. It provides much of the same functionality found in the [Azure Portal](https://portal.azure.com) as well as rich data access functionality.

This guide assumes that you understand the basic concepts of Azure Storage. The guide provides a number of scripts to demonstrate the usage of the Azure CLI with Azure Storage. Be sure to update the script variables based on your configuration before running each script.


## Get started with Azure Storage and the Azure CLI in 5 minutes

This guide uses Ubuntu for examples, but other OS platforms should perform similarly.

**New to Azure:** Get a Microsoft Azure subscription and a Microsoft account associated with that subscription. For information on Azure purchase options, see [Free Trial](http://azure.microsoft.com/pricing/free-trial/)

See [Manage Accounts, Subscriptions, and Administrative Roles](https://msdn.microsoft.com/library/azure/hh531793.aspx) for more information about Azure subscriptions.

**After creating a Microsoft Azure subscription and account:**

1. Download and install the Azure CLI.
2. Once the Azure CLI has been installed, you will be able to use the azure command from your command-line interface (Bash, Terminal, Command prompt) to access the Azure CLI commands. Type `az` command and you should see the following output.
3. In the command line interface, type `az storage` to list out all the azure storage commands and get a first impression of the functionalities the Azure CLI provides.
4. Now, you need to update the script variables based on your configuration settings.

   - **<storage_account_name>** Use the given name in the script or enter a new name for your storage account. **Important:** The name of the storage account must be unique in Azure. It must be lowercase, too!

   - **<storage_Location>** Location of the storage account.

   - **<container_name>** Use the given name in the script or enter a new name for your container.
   - **<storage_resource_group>** Name of the RG for the storage account.


5. After you’ve updated the necessary variables in vim, press key combinations “Esc, : , wq!” to save the script.

6. To run this script, simply type the script file name in the bash console. After this script runs, y

