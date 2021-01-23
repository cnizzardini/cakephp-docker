#
# Composer
#
FROM composer:2 AS composer

#
# PHP
#
FROM php:7.4-fpm

WORKDIR /var/www/app

# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux

# Ensure apt doesn't ask questions when installing stuff
ENV DEBIAN_FRONTEND=noninteractive

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    curl \
    zlib1g-dev \
    libicu-dev \
    g++ \
    zip \
    unzip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    pdo \
    pdo_mysql \
    curl \
    json \
    opcache \
    readline \
    xml \
    zip \
    sqlite3 \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN pecl install xdebug \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && docker-php-ext-enable xdebug

COPY . .
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get remove -y zlib1g-dev libicu-dev g++ && apt-get clean && apt-get autoremove -y