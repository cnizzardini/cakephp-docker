#
# PHP
#
FROM cnizzardini/php-fpm-alpine:7.4-latest

ARG ENVIRONMENT
ARG USER_ID
ARG USERNAME
ARG APP_DIR

ENV TERM=linux

#
# Dev dependencies
#
RUN if [[ "$ENVIRONMENT" != "prod" ]]; then \
    apk add git \
    && apk add --no-cache --virtual .php-deps file re2c autoconf make zlib zlib-dev g++ \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del -f .php-deps; \
fi

WORKDIR /var/www/$APP_DIR

#
# Composer install
#
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY $APP_DIR/composer.json ./
COPY $APP_DIR/composer.lock ./

RUN if [[ "$ENVIRONMENT" != "prod" ]]; then \
    composer install --no-interaction --no-plugins --no-scripts --prefer-dist; else \
    composer install --no-interaction --no-plugins --no-scripts --prefer-dist --no-dev; \
fi

RUN composer clear-cache
RUN composer dump-autoload
COPY . .

#
# Add user
#
RUN if [[ "$USERNAME" != "root" ]]; then \
    adduser --disabled-password --gecos '' -u $USER_ID --ingroup www-data $USERNAME; \
fi

USER $USERNAME