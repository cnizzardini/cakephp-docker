# &#128011; Docker

It's expected that you will use your own Dockerfile for production.

## NGINX

See [nginx](nginx) directory for configurations. These get loaded as a docker-compose volume.

## MySQL

Environment variables are loaded by docker-compose from [mysql.env.development](mysql.env.development).

## PHP

See [php](php) for PHP related configuration files, healthcheck, and entrypoint.

The [php/development/conf.d/20-overrides.ini.development](php/development/conf.d/20-overrides.ini.development) file is
used a base config to populate the git ignored
[php/development/conf.d/20-overrides.ini](php/development/conf.d/20-overrides.ini). The latter is actually loaded
by PHP. This is to allow for easily toggling xdebug on and off via the Makefile.

Environment variables are loaded by docker-compose from [php.env.development](php.env.development).
