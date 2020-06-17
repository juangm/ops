#!/bin/bash

# Get the latest version from the API
CHROMEDRIVER_VERSION=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE`

# Dowload the package (linux version)
curl https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip --output chromedriver_linux64.zip

# Unzip the package and configure
unzip chromedriver_linux64.zip
rm chromedriver_linux64.zip
mv -f chromedriver /usr/bin/chromedriver
chmod 0777 /usr/bin/chromedriver
