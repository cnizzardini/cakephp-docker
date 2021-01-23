# CakePHP Docker

[![CakePHP](https://img.shields.io/badge/cakephp-4.2-red?logo=cakephp)](https://book.cakephp.org/4/en/index.html)
[![Docker](https://img.shields.io/badge/docker-0db7ed.svg?logo=docker)](https://www.docker.com)
[![PHP](https://img.shields.io/badge/php-7.4-8892BF.svg?logo=php)](https://php.net/)
[![NGINX](https://img.shields.io/badge/nginx-latest-009639.svg?logo=nginx)](https://www.nginx.com/)
[![MySQL](https://img.shields.io/badge/mysql-latest-00758F.svg?logo=mysql)](https://www.mysql.com/)

A simple [cakephp/app 4.2](https://github.com/cakephp/app/releases/tag/4.2.1) docker setup.

| Service      | Host:Port | Docker Host | Container Name | 
| ----------- | ----------- | ----------- | ----------- |
| PHP7.4-FPM w/ Xdebug 3    | -                 | php | cakephp-php |
| NGINX                     | localhost:8080    | web |cakephp-web |
| MySQL                     | localhost:3607    | db | cakephp-db |

A [Makefile](Makefile) is provided with some optional commands for your convenience.

## Installation

After cloning this repository run:

```console
make init
```

If you want to manually do things then run the commands below and update your APP and SALT values.

```console
docker-compose up --build
cp .docker/php/php.ini.development .docker/php/php.ini
cp .docker/php/conf.d/20-overrides.ini.development .docker/php/conf.d/20-overrides.ini
cp app/config/.env.example app/config/.env
```

Change `APP_NAME` and `SECURITY_SALT` in your `app/config/.env` file.

## Usage

After install browse to [http://localhost:8080](http://localhost:8080) to see the CakePHP welcome page. You may 
run `make up`, `make stop`, and `make restart` instead of the `docker-compose` equivalents. 

### PHP 

To access your application's bash shell:

```console
make bash
```

### MySQL

You can quickly drop into the mysql shell as root by running 

```console
make mysql
```

See [docker-compose.yml](docker-compose.yml]) for accounts and passwords. See `app/config/.env` for DSN settings.

### XDebug

Xdebug is disabled by default. Both these commands handle modifying the `xdebug.ini` config and restarting the container.

To enable: 

```console
make xdebug-on
```

To disable:

```console
make xdebug-off
```

### PHPStorm + XDebug

Go to `File > Settings > Languages & Frameworks > PHP > Servers`

- Name: `localhost`
- Host: `localhost`
- Port: `8080`
- Debugger: `Xdebug`
- Use path mappings: `Enable`

Map your projects app directory to the absolute path on the docker container `/var/www/app`

XDebug settings may be modified through `.docker/php/xdebug.ini.example`