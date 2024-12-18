#!/bin/bash

# Exit on errors
set -e

# Variables
SHINYPROXY_JAR="shinyproxy-3.1.1.jar"

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Java, Docker, and R..."
# Install Java
sudo apt install -y openjdk-17-jdk

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce

# Enable Docker for the current user
sudo usermod -aG docker $USER
echo "Please log out and log back in to activate Docker group changes, or use 'sudo' for Docker commands."

echo "Building Docker images for Shiny apps..."
# Build Docker images with sudo
sudo docker build -t shinyapp1 ./aa_analysis
sudo docker build -t shinyapp2 ./aa_design

# Install ShinyProxy
echo "Downloading ShinyProxy..."
wget https://shinyproxy.io/downloads/$SHINYPROXY_JAR -O shinyproxy.jar

# Move configuration file
echo "Configuring ShinyProxy..."
sudo mkdir -p /etc/shinyproxy
sudo cp application.yml /etc/shinyproxy/application.yml

# Start ShinyProxy
echo "Starting ShinyProxy..."
nohup java -jar shinyproxy.jar > shinyproxy.log 2>&1 &

echo "ShinyProxy setup complete!"
echo "Access ShinyProxy at http://<EC2-Public-IP>:8080"
