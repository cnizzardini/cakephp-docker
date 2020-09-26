FROM composer:1.10 AS composer

COPY composer.json /app
COPY composer.lock /app

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

FROM php:7.4-fpm

WORKDIR "/var/www/api"

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
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    pdo \
    pdo_mysql \
    mbstring \
    sqlite3 \
    curl \
    json \
    opcache \
    readline \
    xml \
    zip \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY --from=composer /app/vendor /var/www/api/vendor
