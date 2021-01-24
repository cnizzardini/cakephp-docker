#
# Composer
#
FROM composer:2 AS composer

#
# PHP
#
FROM php:7.4-fpm-alpine

ARG ENVIRONMENT

WORKDIR /var/www/app

# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux

# Required packages
RUN apk add libzip icu
RUN apk add --no-cache --virtual .build-deps curl-dev libxml2-dev icu-dev libedit-dev libzip-dev
RUN docker-php-ext-install intl pdo pdo_mysql curl json opcache readline xml zip
RUN rm -rf app/vendor logs/* tmp/*

# dev
RUN if [[ "$ENVIRONMENT" != "prod" ]]; then \
    apk add --no-cache --virtual .php-deps git file re2c autoconf make zlib zlib-dev g++ \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del -f .php-deps; \
fi

# Cleanup
RUN apk del -f .build-deps && rm -rf /tmp/* /var/cache/apk/*

COPY . .
COPY --from=composer /usr/bin/composer /usr/bin/composer