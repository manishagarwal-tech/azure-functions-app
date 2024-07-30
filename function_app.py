#  Title: Serverless API endpoint using azure function app for IV-Dashboard
#  Author: Mr. Manish Agarwal
#  Version: v1
#  Date: 30th July, 2024

import logging
import os
import pyodbc
import azure.functions as func
from dotenv import load_dotenv
import json
from azure.storage.blob import BlobServiceClient

# Load environment variables from .env file
load_dotenv()

# Fetch environment variables
SERVER_NAME = os.getenv("SERVER_NAME")
DATABASE_NAME = os.getenv("DB_NAME")
USER_NAME = os.getenv("DB_USERNAME")
PASSWORD = os.getenv("DB_PASSWORD")
STORAGE_ACCOUNT_URL = os.getenv('STORAGE_ACCOUNT_URL')
CONTAINER_NAME = os.getenv('ARCHIVE_CONTAINER_NAME')
STORAGE_ACCOUNT_NAME = os.getenv('STORAGE_ACCOUNT_NAME')
SAS_TOKEN = os.getenv('SAS_TOKEN')

driver = '{ODBC Driver 18 for SQL Server}'
conn_str = f'Driver={driver};Server={SERVER_NAME};Database={DATABASE_NAME};Uid={USER_NAME};Pwd={PASSWORD};'
# print(conn_str)
# Initialize the FunctionApp
app = func.FunctionApp()

# Function to execute SQL queries against Synapse Serverless SQL pool
def execute_sql(query):
    try:
        conn = pyodbc.connect(conn_str)
        if conn is None:
            logging.error("Error: No connection to the database")
            return None
        cursor = conn.cursor()
        cursor.execute(query)
        rows = cursor.fetchall()
        conn.close()
        return rows
    except Exception as e:
        logging.error(f"An error occurred: {str(e)}")
        raise e

# read file from the ADLSGen2
def read_sql_template(sas_token, file_name):
    folder_path = 'sql-templates'
    try:
        blob_service_client = BlobServiceClient(account_url=STORAGE_ACCOUNT_URL, credential=sas_token)
        container_client = blob_service_client.get_container_client(CONTAINER_NAME)
        # get the blob client
        blob_client = container_client.get_blob_client(f"{folder_path}/{file_name}")
        
        with open("sql/downloaded_sql_template.sql", "wb") as download_file:
            download_file.write(blob_client.download_blob().readall())

        # Read the downloaded SQL template
        with open("sql/downloaded_sql_template.sql", "r") as file:
            sql_template = file.read()
            
        return sql_template
            
    except Exception as ex:
        print('Exception:', ex)
    

# function to get data by query passed by user
@app.function_name(name="get_data_function")
@app.route(route="data", methods=['POST'], auth_level=func.AuthLevel.ANONYMOUS)
def get_data(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    try:
        req_body = req.get_json()
    except ValueError:
        return func.HttpResponse(
            "Invalid JSON in request body.",
            status_code=400
        )

    sql_query = req_body.get('query')
    if not sql_query:
        return func.HttpResponse(
            "SQL query not provided in request body.",
            status_code=400
        )

    logging.info(f"Executing SQL query: {sql_query}")

    try:
        data = execute_sql(sql_query)
        if data is None:
            return func.HttpResponse(
                "Failed to execute SQL query.",
                status_code=500
            )

        # Convert the data to a list of dictionaries
        records_list = [list(record) for record in data]

        # Return the result as JSON
        return func.HttpResponse(
            body=json.dumps(records_list),
            mimetype='application/json',
            status_code=200
        )
    except Exception as e:
        error_message = f"An error occurred while executing SQL query: {str(e)}"
        logging.error(error_message)
        return func.HttpResponse(
            body=json.dumps({"error": error_message}),
            mimetype='application/json',
            status_code=500
        )

# Endpoint to create external table from parquet files
@app.function_name(name="create_external_table_function")
@app.route(route="create_external_table", auth_level=func.AuthLevel.ANONYMOUS)
def create_external_table(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Creating external table from parquet files.')

    table_name = 're_distribute_v2'
    location = 'redistribute/current/redistribute_data.parquet/**'
    sql_template_name = '3_create_external_table_redistribute_data.sql'

    # Read the SQL template from the file
    sql_template = read_sql_template(SAS_TOKEN, sql_template_name)
    
    # Replace placeholders with actual values
    try:
        sql_script = sql_template.format(
            storage_account_name=STORAGE_ACCOUNT_NAME,
            container_name=CONTAINER_NAME,
            table_name=table_name,
            location=location
        )
    except Exception as e:
        logging.error(f"An error occurred while formatting the SQL script: {str(e)}")
        return func.HttpResponse(
            "Internal Server Error: Unable to format SQL script",
            status_code=500
        )

    sql_commands = sql_script.split('GO')

    try:
        # Connect to the database and execute SQL commands
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        for command in sql_commands:
            if command.strip():
                cursor.execute(command)
                conn.commit()
        conn.close()
    except Exception as e:
        logging.error(f"An error occurred while creating external table: {str(e)}")
        return func.HttpResponse(
            f"An error occurred while creating external table: {str(e)}",
            status_code=500
        )

    return func.HttpResponse(
        f"External table '{table_name}' created successfully.",
        status_code=200
    )
    

# Default route to check if the server is running
@app.function_name(name="home_function")
@app.route(route="home", auth_level=func.AuthLevel.ANONYMOUS)
def home(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse(
        "Server is up and running!",
        status_code=200
    )
