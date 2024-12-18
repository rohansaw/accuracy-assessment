# Use the official R Shiny image as a base
FROM rocker/shiny:latest

# Install system dependencies for 'terra' and other packages
RUN apt-get update && apt-get install -y \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libudunits2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages by running the load_packages.R script
COPY ./load_packages.R /usr/local/bin/load_packages.R
RUN Rscript /usr/local/bin/load_packages.R

# Copy the app into the container
COPY . /srv/shiny-server/analysis

# Set permissions for the app directory
RUN chown -R shiny:shiny /srv/shiny-server
RUN mkdir -p /srv/shiny-server/uploads && chmod -R 777 /srv/shiny-server/uploads

# Expose the default Shiny port
EXPOSE 3838

# Run Shiny server
CMD ["R", "-q", "-e", "shiny::runApp('/srv/shiny-server/analysis', host='0.0.0.0', port=3838)"]
