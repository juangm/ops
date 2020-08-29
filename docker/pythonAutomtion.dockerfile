FROM ubuntu:18.04

# Base system.
RUN apt update && apt install -y software-properties-common curl apt-transport-https unzip

RUN \
   # Chrome repo
   curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
   echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
   # Microsoft repo
   curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
   curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install ChromeDriver.
RUN \
   CHROMEDRIVER_VERSION=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
   curl https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip --output chromedriver_linux64.zip && \
   unzip chromedriver_linux64.zip && \
   rm chromedriver_linux64.zip && \
   mv -f chromedriver /usr/bin/chromedriver && \
   chmod 0755 /usr/bin/chromedriver

# Install chrome, mysql odbc driver and dependencies
RUN apt-get update && ACCEPT_EULA=Y apt-get install -yq python-pip python3-pip gcc smbclient \
   unixodbc-dev msodbcsql17 build-essential git locales locales-all \
   google-chrome-stable && \
   apt-get clean && apt-get autoremove -y

# Download and install driver for AWS Redshift
RUN \
   curl https://redshift-downloads.s3.amazonaws.com/drivers/odbc/1.4.8.1000/AmazonRedshiftODBC-64-bit-1.4.8.1000-1.x86_64.deb --output amazon.deb && \
   apt install ./amazon.deb && \
   rm -rf amazon.deb

WORKDIR /app
COPY . /app

# Copy configuration for ODBC Drivers
COPY ./resources/settings/odbcinst.ini /etc/odbcinst.ini

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN \
   pip3 install --upgrade setuptools && \
   pip3 install -r requirements.txt
