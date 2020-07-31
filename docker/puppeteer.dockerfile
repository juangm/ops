FROM node:12-slim

# Install Chromium dependencies only
# Chromium will be installed by Puppeteer through yarn
RUN apt-get update && \
  apt-get install -yq libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
  libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
  libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 \
  libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
  libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 \
  libxrender1 libxss1 libxtst6 libnss3 && \
  apt-get clean && apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

# Install the packages
RUN yarn install

ENTRYPOINT ["./bin/entrypoint.sh"]
