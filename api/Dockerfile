FROM php:7.4-fpm

# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux

# Ensure apt doesn't ask questions when installing stuff
ENV DEBIAN_FRONTEND=noninteractive

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    curl \
    unzip \
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
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer clear-cache

#CMD ["bin/cake","server","-v","-H","api","-p","8765"]

WORKDIR "/var/www/api"
