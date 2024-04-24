
# Azure Function Deployment and Testing Guide

This guide provides instructions on how to deploy and test the Azure Function `QueueToBlobFunction`, which reads messages from an Azure Queue and writes them to an Azure Blob Storage.

## Prerequisites

Before you start, ensure you have the following:
- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/en-us/free/).
- Azure CLI installed. [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- .NET Core 3.1 or later installed. [Install .NET](https://dotnet.microsoft.com/download).
- Azure Function Core Tools installed. [Install Function Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#v2).
- Visual Studio Code with the Azure Functions extension installed. [Install Visual Studio Code](https://code.visualstudio.com/Download).

## Pre-Setup Steps
* We need to create app in app registrations for client id, tenant id, and client secret.
## App Registration:
### Step 1: Register a New Application
1. **Log in to Azure Portal**
   - Open your web browser.
   - Visit [https://portal.azure.com](https://portal.azure.com).
   - Sign in with your Azure account credentials.
2. Navigate to **Microsoft entra id**
  - from the left-hand navigation plane select app registrations under the manage directory.
3. **Register an Application**
   - Go to **App registrations** in the Azure Active Directory blade.
   - Click on **New registration**.
   - **Name** your application.
   - Choose the **Supported account types**.
   - Click **Register**.
4. **Open the App you have created**
  - Within that  app, select **Certificates and Secrets**.
  - Under CLient secrets click on **New client secret key**.
  - Give it a description and click on **Add**.
  - The code under **Value** is the CLient_secret_key.

### Step 2: Assign a Contributor Role

1. **Navigate to Subscriptions**
   - In the search bar at the top of the Azure Portal, type and select **Subscriptions**.

2. **Select Your Subscription**
   - Click on the subscription where you want to assign the role.

3. **Access Control (IAM)**
   - Click on **Access control (IAM)** in the subscription blade.

4. **Add a Role Assignment**
   - Click on **+ Add > Add role assignment** to open the Add role assignment pane.
   - For **Role**, select **Contributor**.
   - Under **Assign access to**, select **Azure AD user, group, or service principal**.
   - Search for and select the previously registered application.
   - Click **Save** to assign the role.
### Step 3: Retrieve Client and Tenant IDs

1. **Go Back to App Registrations**
   - Navigate back to **Azure Active Directory > App registrations**.

2. **Select Your Application**
   - Click on your registered application to open its overview page.

3. **Copy IDs**
   - From the overview page, copy the **Application (client) ID** and **Directory (tenant) ID**.
 
#### The above three ids client id, tenant id, and client secret key are useful in terraform configuration file

## Installations:
- Install azure-func-tools package
  ```
  npm install -g azure-functions-core-tools@4
  ```

## Setup Steps

1. **Clone the repository:**
```
git clone <repository-url>
cd <repository-directory>
```
2.**Azure Resources Setup:**
*Deploy the necessary Azure resources using Terraform:*

  - *Initialize TerraformNavigate to the directory containing your Terraform files and run:*
  ```
cd azure
terraform init
```
 - *Plan the Terraform deploymentCheck what Terraform plans to deploy:*
```
terraform plan
```
 - *Apply the Terraform configurationDeploy the resources:*
  ```
terraform apply
```
3. **Configure Environment Variables:**
- Rename the `local.settings.json.example` to `local.settings.json`.
- Update the `local.settings.json` with your Azure Storage connection string and queue name:
  ```json
  {
    "IsEncrypted": false,
    "Values": {
      "AzureWebJobsStorage": "<Your_AzureWebJobsStorage_Connection_String>",
      "FUNCTIONS_WORKER_RUNTIME": "dotnet",
      "QUEUE_NAME": "<Your_Queue_Name>",
      "STORAGE_CONTAINER": "<Your_Blob_Container_Name>"
    }
  }
  ```
4. **Update the .csproj File**
Ensure that your QueueToBlobFunction.csproj includes the necessary package references:

```
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net6.0</TargetFramework>
    <AzureFunctionsVersion>v4</AzureFunctionsVersion>
    <OutputType>Library</OutputType>
    <RootNamespace>YourNamespace</RootNamespace>
    <AssemblyName><Your function name></AssemblyName>
    <LangVersion>latest</LangVersion>
  </PropertyGroup>

```
4. **Deploy the Function to Azure:**
- Open your terminal or command prompt.
- Log in to Azure:
  ```
  az login
  ```
- Deploy the function using Azure CLI:
  ```
  cd src
  func azure functionapp publish <Your_Function_App_Name> --csharp     
  ```

## Testing the Function

1. **Add Messages to Your Queue:**
- You can add messages to your Azure Queue through the Azure portal or programmatically.

2. **Monitor the Function:**
- Navigate to your Function App in the Azure portal.
- Go to the "Functions" section and click on your function.
- Click on "Monitor" to view the logs and verify that the function is triggered and processing messages.

3. **Verify Blob Storage:**
- Navigate to your Blob Storage container in the Azure portal.
- Check if the messages are written correctly as JSON files in the Blob container.

## Troubleshooting

- Ensure that the connection strings and container names are correctly configured in your `local.settings.json`.
- Check the function logs for any errors or exceptions.

For further assistance, refer to the [Azure Functions documentation](https://docs.microsoft.com/en-us/azure/azure-functions/).


