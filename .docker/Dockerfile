#
# PHP
#
FROM cnizzardini/php-fpm-alpine:7.4-latest

ARG ENVIRONMENT
ARG USER_ID
ARG USERNAME
ARG APP_DIR

WORKDIR /var/www/$APP_DIR

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

#
# Add user
#
RUN if [[ "$USERNAME" != "root" ]]; then \
    adduser --disabled-password --gecos '' -u $USER_ID --ingroup www-data $USERNAME; \
fi

USER $USERNAME

COPY . .
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer