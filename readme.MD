# Azure Function App for Synapse Serverless Endpoint

This repository contains an Azure Function App that works with Azure Synapse Serverless to create external tables using SQL templates. It also provides an API endpoint to query data from the created external tables using SQL queries provided in the request body.

## Features

- **Create External Table:** An API endpoint to create an external table from Parquet files stored in Azure Storage.
- **Query External Table:** An API endpoint to query data from the created external tables using SQL queries provided in the request body.

## Prerequisites

- Azure subscription
- Azure Synapse Analytics workspace
- Azure Storage account
- Python 3.7 or later
- Azure Functions Core Tools

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/manishagarwal-tech/azure-functions-app.git
cd azure-functions-app
```

### 2.  Install dependencies
```bash
pip install -r requirements.txt
```

### 3. Configure environment variables
Create a `.env` file in the root directory of the project and add the following environment variables:
```bash
SERVER_NAME=your_synapse_serverless_ondemand_endpoint
DB_NAME=database_name
DB_USERNAME=database_username
DB_PASSWORD=database_password
STORAGE_ACCOUNT_URL=storage_http_url
STORAGE_ACCOUNT_NAME=your_storage_account_name
ARCHIVE_CONTAINER_NAME=your_container_name
```
### 4. Deploy to Azure
You can deploy the function app to Azure using the Azure Functions Core Tools or using Function extesion in VS Code.
