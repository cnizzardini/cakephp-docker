#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/cakephp' ]; then

# The first time volumes are mounted, the project needs to be recreated
if [ ! -f composer.json ]; then

    if [ -f .gitkeep ]; then
        rm .gitkeep # create project fails if directory is not empty
    fi

    COMPOSER_MEMORY_LIMIT=-1
    composer create-project --prefer-dist --no-interaction cakephp/app:^4.2 .
    rm -rf .github
	cp config/.env.example config/.env
	cp config/app_local.example.php config/app_local.php
	mv ../.assets/bootstrap.php config/bootstrap.php

    sed -i '/export APP_NAME/c\export APP_NAME="cakephp"' config/.env

    salt=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    sed -i '/export SECURITY_SALT/c\export SECURITY_SALT="'$salt'"' config/.env

    touch .gitkeep

    if [ "$APP_ENV" = 'dev' ]; then
        chown -R cakephp:www-data .
    fi

    setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX logs
    setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX tmp
fi

if [ "$APP_ENV" = 'prod' ]; then
    composer install --prefer-dist --no-interaction --no-dev
else
    composer install --prefer-dist --no-interaction
fi

exec docker-php-entrypoint "$@"
