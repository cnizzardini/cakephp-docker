#
# Composer
#
FROM composer:latest AS composer

RUN composer self-update

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

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    curl \
    zlib1g-dev \
    libicu-dev \
    g++ \
    git \
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

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

COPY . .
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN pecl install xdebug \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && docker-php-ext-enable xdebug

RUN chmod 774 -R tmp logs