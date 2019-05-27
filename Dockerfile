FROM node:9-alpine

WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/chromium-browser

RUN apk update && \
    apk upgrade && \
    echo @latest-stable http://nl.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories && \
    echo @latest-stable http://nl.alpinelinux.org/alpine/latest-stable/main >> /etc/apk/repositories && \
        apk add --no-cache \
        freetype@latest-stable \
        harfbuzz@latest-stable \
        chromium@latest-stable \
        nss@latest-stable

# Installs latest Chromium package.
RUN apk update && apk upgrade && \
    echo @latest-stable http://nl.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories && \
    echo @latest-stable http://nl.alpinelinux.org/alpine/latest-stable/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@latest-stable \
      nss@latest-stable

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /usr/src/app

# Run everything after as non-privileged user.
USER pptruser
