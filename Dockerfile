# Use the official Azure Functions Python base image
FROM mcr.microsoft.com/azure-functions/python:3.0-python3.9

# Install curl and gnupg2 for ODBC driver installation
RUN apt-get update && apt-get install -y curl gnupg2

# Add the Microsoft repository key
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Register the Microsoft Ubuntu repository
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Update the package list and install the ODBC driver
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Set the working directory
WORKDIR /home/site/wwwroot

# Copy the function app code and configuration files into the container
COPY . .

# Install the required Python packages
RUN pip install -r requirements.txt

# The Azure Functions runtime will automatically start your function app