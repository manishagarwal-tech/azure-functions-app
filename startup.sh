#!/bin/bash

# Update package lists
sudo apt-get update

# Install the necessary packages
sudo apt-get install -y curl gnupg

# Download and install the Microsoft repository GPG keys
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft SQL Server Ubuntu repository
sudo curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Update the package lists
sudo apt-get update

# Install the ODBC driver
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Optional: install mssql-tools and unixODBC developer packages
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Add the tools to the PATH
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc