#
# Composer
#
FROM composer:2 AS composer

#
# PHP
#
FROM php:7.4-fpm

ARG ENVIRONMENT

WORKDIR /var/www/app

# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux

# Ensure apt doesn't ask questions when installing stuff
ENV DEBIAN_FRONTEND=noninteractive

# Required packages
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    curl \
    zlib1g-dev \
    libicu-dev \
    g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    pdo \
    pdo_mysql \
    curl \
    json \
    opcache \
    readline \
    xml \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY . .
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Development packages
RUN if [["$ENVIRONMENT" != "production"]]; then \
    apt-get -y --no-install-recommends install \
    zip \
    unzip \
    pecl install xdebug \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && docker-php-ext-enable \
    xdebug \
    zip \
    sqlite3; \
fi

# Cleanup
RUN apt-get remove -y zlib1g-dev libicu-dev g++ && apt-get clean && apt-get autoremove -y