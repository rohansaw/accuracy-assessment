# Base image for Java
FROM openjdk:17-jdk-slim

ENV SHINYPROXY_JAR="shinyproxy-3.1.1.jar"

# Set working directory
WORKDIR /opt/shinyproxy

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download ShinyProxy JAR file
RUN wget https://shinyproxy.io/downloads/${SHINYPROXY_JAR} \
    -O shinyproxy.jar

# Copy configuration file
COPY application.yml /opt/shinyproxy/application.yml

# Expose port for ShinyProxy
EXPOSE 8080

# Run ShinyProxy
CMD ["java", "-jar", "shinyproxy.jar"]
