# &#127856; CakePHP Docker

[![Build](https://github.com/cnizzardini/cakephp-docker/workflows/Build/badge.svg?branch=master)](https://github.com/cnizzardini/cakephp-docker/actions)
[![CakePHP](https://img.shields.io/badge/cakephp-4.2-red?logo=cakephp)](https://book.cakephp.org/4/en/index.html)
[![Docker](https://img.shields.io/badge/docker-ffffff.svg?logo=docker)](https://www.docker.com)
[![Kubernetes](https://img.shields.io/badge/kubernetes-D3D3D3.svg?logo=kubernetes)](https://kubernetes.io/)
[![PHP](https://img.shields.io/badge/php-7.4-8892BF.svg?logo=php)](https://php.net/)
[![NGINX](https://img.shields.io/badge/nginx-1.19-009639.svg?logo=nginx)](https://www.nginx.com/)
[![MySQL](https://img.shields.io/badge/mysql-8-00758F.svg?logo=mysql)](https://www.mysql.com/)

A [cakephp/app 4.2](https://github.com/cakephp/app) template for Docker Compose and Kubernetes.

| Service                   | Host:Port         | Docker Host   | Image   |
| -----------               | -----------       | -----------   | -----------   |
| PHP7.4-FPM w/ Xdebug 3    | -                 | php           | [cnizzardini/php-fpm-alpine:7.4-latest](https://hub.docker.com/r/cnizzardini/php-fpm-alpine) |
| NGINX 1.19                | localhost:8080    | web           | [nginx:1.19-alpine](https://hub.docker.com/_/nginx) |
| MySQL 8                   | localhost:3607    | db            | [library/mysql:8](https://hub.docker.com/_/mysql) |

- [Installation](#installation)
- [Usage](#usage)
  - [PHP](#php)
  - [MySQL](#mysql)
  - [NGINX](#nginx)
  - [Xdebug](#xdebug)

## Installation

Fork and clone this repository then run:

```console
make init
```

That's it! Now just remove `app/*` from [.gitignore](.gitignore). You may also want to remove
[.assets](.assets) and adjust defaults in [.github](.github), [.docker](.docker), and [.kube](.kube).

> Note: `make init` and `make init.nocache` output interactively, while `make start` and `make up` do not.

## Usage

After install browse to [http://localhost:8080](http://localhost:8080) to see the CakePHP welcome page.

A [Makefile](Makefile) is provided with some optional commands for your convenience. Please review the Makefile as
these commands are not exact aliases of docker-compose commands.

| Make Command              | Description       |
| -----------               | -----------       |
| `make`                    | Shows all make target commands |
| `make init`               | Runs docker build, docker-compose up -d, and copies over env files |
| `make init.nocache`       | Same as make.init but builds with --no-cache |
| `make start`              | Starts services `docker-compose start` |
| `make stop`               | Stops services `docker-compose stop` |
| `make up`                 | Create and start containers `docker-compose up -d` |
| `make down`               | Take down and remove all containers `docker-compose stop` |
| `make restart`            | Restarts services `docker-compose -f .docker/docker-compose.yml restart` |
| `make php.sh`             | PHP terminal `docker exec -it <PHP_CONTAINER> sh` |
| `make php.restart`        | Restarts the PHP container |
| `make db.sh`              | DB terminal `docker exec -it <DB_CONTAINER> sh` |
| `make db.mysql`           | MySQL terminal `mysql -u root -h 0.0.0.0 -p --port 3307` |
| `make web.sh`             | Web terminal `docker exec -it <WEB_CONTAINER> sh` |
| `make xdebug.on`          | Restarts PHP container with xdebug.mode set to debug,coverage |
| `make xdebug.off`         | Restarts PHP container with xdebug.mode set to off |
| `make composer.install`   | `docker exec <PHP_CONTAINER> composer install --no-interaction` |
| `make composer.test`      | `docker exec <PHP_CONTAINER> composer test` |
| `make composer.check`     | `docker exec <PHP_CONTAINER> composer check` |

### PHP

See [.docker/README.md](.docker/README.md) for details.

Shell:

```console
make php.sh
```

Helper commands:

```console
make composer.install
make composer.test
make composer.check
```

### MySQL

See [.docker/README.md](.docker/README.md) for details.

Shell:

```console
make db.sh
```

MySQL shell (requires mysql client on your localhost):

```console
make db.mysql
```

### NGINX

See [.docker/README.md](.docker/README.md) for details.

Shell:

```console
make web.sh
```

### Xdebug

Xdebug is disabled by default. To toggle:

```console
make xdebug.on
make xdebug.off
```

### PHPStorm + Xdebug

Xdebug 3's default port is `9003`.

Go to `File > Settings > Languages & Frameworks > PHP > Servers`

- Name: `localhost`
- Host: `localhost`
- Port: `8080`
- Debugger: `Xdebug`
- Use path mappings: `Enable`

Map your projects app directory to the absolute path on the docker container `/srv/app`
