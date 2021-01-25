# CakePHP Docker

[![Build](https://github.com/cnizzardini/cakephp-docker/workflows/Build/badge.svg?branch=master)](https://github.com/cnizzardini/cakephp-docker/actions)
[![CakePHP](https://img.shields.io/badge/cakephp-4.2-red?logo=cakephp)](https://book.cakephp.org/4/en/index.html)
[![Docker](https://img.shields.io/badge/docker-0db7ed.svg?logo=docker)](https://www.docker.com)
[![PHP](https://img.shields.io/badge/php-7.4-8892BF.svg?logo=php)](https://php.net/)
[![NGINX](https://img.shields.io/badge/nginx-1.19-009639.svg?logo=nginx)](https://www.nginx.com/)
[![MySQL](https://img.shields.io/badge/mysql-8-00758F.svg?logo=mysql)](https://www.mysql.com/)

A simple [cakephp/app 4.2](https://github.com/cakephp/app/releases/tag/4.2.1) docker setup.

| Service                   | Host:Port         | Docker Host   |
| -----------               | -----------       | -----------   |
| PHP7.4-FPM w/ Xdebug 3    | -                 | php           |
| NGINX 1.19                | localhost:8080    | web           |
| MySQL 8                   | localhost:3607    | db            |

A [Makefile](Makefile) is provided with some optional commands for your convenience.

## Installation

Fork and clone this repository then run:

```console
make init
make composer.install
```

## Usage

After install browse to [http://localhost:8080](http://localhost:8080) to see the CakePHP welcome page. You may 
run `make up`, `make stop`, and `make restart` instead of the `docker-compose` equivalents.

### PHP 

To access your application's bash shell:

```console
make php.sh
```

See `.docker/php` for PHP INI settings. During `make init` the `php.ini.development` is copied to`php.ini`. The former 
is then mounted as a volume in the php container. The `20-overrides.ini.development` is used for turning xdebug on 
and off (see below) and is copy/mounted like `php.ini`.

### MySQL

Login via the mysql client (requires mysql client on your localhost):

```console
make db.mysql
```

To access the shell `make db.sh`

See [docker-compose.yml](docker-compose.yml) for accounts and passwords. See `app/config/.env` for DSN settings.

### XDebug

Xdebug is disabled by default. Both these commands handle modifying the `xdebug.ini` config and restarting the container.

To enable: 

```console
make xdebug.on
```

To disable:

```console
make xdebug.off
```

### PHPStorm + XDebug

Go to `File > Settings > Languages & Frameworks > PHP > Servers`

- Name: `localhost`
- Host: `localhost`
- Port: `8080`
- Debugger: `Xdebug`
- Use path mappings: `Enable`

Map your projects app directory to the absolute path on the docker container `/var/www/app`

### Docker Builds

Production: 

```console
make build.prod
```

Development:

```console
make build.dev
```