#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
SHINYPROXY_JAR="shinyproxy-3.1.1.jar"
SHINYPROXY_VERSION="3.0.1"
SHINYPROXY_DIR="/opt/shinyproxy"
APPLICATION_YML="application.yml"

# Update and install dependencies
echo "Updating system and installing dependencies..."
sudo apt-get update
sudo apt-get install -y curl wget openjdk-17-jdk

# Create ShinyProxy directory
echo "Creating ShinyProxy directory at $SHINYPROXY_DIR..."
sudo mkdir -p "$SHINYPROXY_DIR"

# Copy the application.yml file (requires you to have application.yml in the same directory as this script)
if [[ -f "$APPLICATION_YML" ]]; then
    echo "Copying $APPLICATION_YML to $SHINYPROXY_DIR..."
    sudo cp "$APPLICATION_YML" "$SHINYPROXY_DIR/"
else
    echo "Error: $APPLICATION_YML not found. Please ensure it exists in the same directory as this script."
    exit 1
fi

cd "$SHINYPROXY_DIR"

# Download ShinyProxy JAR file
echo "Downloading ShinyProxy JAR version $SHINYPROXY_VERSION..."
sudo wget "https://shinyproxy.io/downloads/${SHINYPROXY_JAR}" -O shinyproxy.jar



# Expose port 8080 (requires user to manage firewall separately)
echo "Port 8080 will be used for ShinyProxy. Ensure it is open in your firewall."

# Final instructions
echo "Installation complete! To run ShinyProxy, use the following command:"
echo "    java -jar $SHINYPROXY_DIR/shinyproxy.jar"
