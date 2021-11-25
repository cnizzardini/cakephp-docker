# &#127856; CakePHP Docker

[![Build](https://github.com/cnizzardini/cakephp-docker/workflows/Build/badge.svg?branch=master)](https://github.com/cnizzardini/cakephp-docker/actions)
[![CakePHP](https://img.shields.io/badge/cakephp-4-red?logo=cakephp)](https://book.cakephp.org/4/en/index.html)
[![Docker](https://img.shields.io/badge/docker-ffffff.svg?logo=docker)](.docker)
[![Kubernetes](https://img.shields.io/badge/kubernetes-D3D3D3.svg?logo=kubernetes)](.kube)
[![PHP](https://img.shields.io/badge/php-8.0-8892BF.svg?logo=php)](https://hub.docker.com/_/php)
[![NGINX](https://img.shields.io/badge/nginx-1.19-009639.svg?logo=nginx)](https://hub.docker.com/_/nginx)
[![MySQL](https://img.shields.io/badge/mysql-8-00758F.svg?logo=mysql)](https://hub.docker.com/_/mysql)

A [cakephp/app](https://github.com/cakephp/app) template for Docker Compose and Kubernetes. You might also be
interested in [CakePHP Galley](https://gitlab.com/amayer5125/galley) which is similar to Laravel Sail
or [DevilBox](https://devilbox.readthedocs.io/en/latest/examples/setup-cakephp.html).

#### Dependencies:

- [Docker 20](https://docs.docker.com/engine/release-notes/) or higher
- Make

| Service                   | Host:Port         | Docker Host   | Image   |
| -----------               | -----------       | -----------   | -----------   |
| PHP8.0-FPM w/ Xdebug 3    | -                 | php           | [cnizzardini/php-fpm-alpine:8.0-latest](https://hub.docker.com/r/cnizzardini/php-fpm-alpine) |
| NGINX 1.19                | localhost:8080    | web           | [nginx:1.19-alpine](https://hub.docker.com/_/nginx) |
| MySQL 8                   | localhost:3607    | db            | [library/mysql:8](https://hub.docker.com/_/mysql) |


- [Installation](#installation)
- [MacOS Notes](#mac-notes)
- [Usage](#usage)
  - [PHP](#php)
  - [MySQL](#mysql)
  - [NGINX](#nginx)
  - [Xdebug](#xdebug)
- [Reinstall](#reinstall)

## Installation

Fork and clone this repository then run:

```console
make init
```

That's it! Now just remove `app/*` from [.gitignore](.gitignore). You may also want to remove
[.assets](.assets) and adjust defaults in [.github](.github), [.docker](.docker), and [.kube](.kube).

> Note: `make init` and `make init.nocache` output interactively, while `make start` and `make up` do not.

## Mac Notes

1. Change your `SHELL` in the Makefile to `/bin/zsh`. This improves various output from the Makefile such as emoji's.

3. Mac ships with an older version of `sed` so install `gnu-sed` for some targets in the Makefile:

```console
brew install gnu-sed
```

Then update `sed` to `gsed` in the Makefile.

## Usage

After install browse to [http://localhost:8080](http://localhost:8080) to see the CakePHP welcome page.

A [Makefile](Makefile) is provided with some optional commands for your convenience. Please review the Makefile as
these commands are not exact aliases of docker-compose commands.

| Make Command              | Description       |
| -----------               | -----------       |
| `make`                    | Shows all make target commands |
| `make init`               | Runs docker build, docker-compose up, and copies over env files |
| `make init.nocache`       | Same as make.init but builds with --no-cache |
| `make start`              | Starts services `docker-compose -f .docker/docker-compose.yml start` |
| `make stop`               | Stops services `docker-compose -f .docker/docker-compose.yml stop` |
| `make up`                 | Create and start containers `docker-compose -f .docker/docker-compose.yml up -d` |
| `make down`               | Take down and remove all containers `docker-compose -f .docker/docker-compose.yml down` |
| `make restart`            | Restarts services `docker-compose -f .docker/docker-compose.yml restart` |
| `make php.sh`             | PHP terminal `docker exec -it --user cakephp <PHP_CONTAINER> sh` |
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

Map your project's app directory to the absolute path on the docker container `/srv/app`

## Reinstall

To completely reinstall delete existing containers and images, then remove the `app/` directory and run `make init`
again.
