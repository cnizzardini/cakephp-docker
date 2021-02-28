SHELL=/bin/bash
include .env
export $(shell sed 's/=.*//' .env)

#
# define standard colors
#
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET        := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

#
# vars
#
DOCKER_COMPOSE  := ".docker/docker-compose.yml"
SALT            := $(shell cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PHP             := $(shell docker-compose -f $(DOCKER_COMPOSE) ps -q php)
USER_ID         := $(shell id -u)

#
# unicode icons
#
DOCKER_ICO      := '\U1F40B '
SHELL_ICO       := '\U1F41A '
MYSQL_ICO       := '\U1F42C '
XDEBUG_ICO      := '\U1F41E '
CANCEL_ICO      := '\U1F515 '
KUBE_ICO        := '\U2699 '

#
# install command
#
init: do.copy
	@cp ${APP_DIR}/config/.env.example ${APP_DIR}/config/.env
	@cp ${APP_DIR}/config/.env.example ${APP_DIR}/config/.env
	@cp ${APP_DIR}/config/app_local.example.php $(APP_DIR)/config/app_local.php
	@sed -i '/export APP_NAME/c\export APP_NAME="${APP_NAME}"' ${APP_DIR}/config/.env
	@sed -i '/export SECURITY_SALT/c\export SECURITY_SALT="$(SALT)"' ${APP_DIR}/config/.env
	@docker-compose -f $(DOCKER_COMPOSE) build --build-arg USER_ID=$(USER_ID) --build-arg USERNAME=${USERNAME} --build-arg APP_DIR=${APP_DIR}
	@docker-compose -f $(DOCKER_COMPOSE) up -d
#
# composer commands
composer.install:
	@docker exec $(PHP) composer install --no-interaction --no-plugins --no-scripts --prefer-dist
	@docker exec $(PHP) composer dump-autoload
composer.test:
	@docker exec $(PHP) composer test
composer.check:
	@docker exec $(PHP) composer check

#
# docker & docker-compose commands
#
up: do.copy
	@printf $(DOCKER_ICO) && echo up
	@docker-compose -f $(DOCKER_COMPOSE) up -d
stop:
	@printf $(DOCKER_ICO) && echo stop
	@docker-compose -f $(DOCKER_COMPOSE) stop
restart: stop
	@printf $(DOCKER_ICO) && echo up
	@docker-compose -f $(DOCKER_COMPOSE) up -d
build.prod:
	@docker build --build-arg ENVIRONMENT=prod -t ${IMAGE_NAME} .docker/
build.dev:
	@docker build -t ${IMAGE_NAME}-dev .docker/
php.restart:
	@printf $(DOCKER_ICO) && echo restart
	@docker-compose -f $(DOCKER_COMPOSE) stop php
	@cp .docker/php.env.development .docker/php.env
	@docker-compose -f $(DOCKER_COMPOSE) up -d php

#
# container shell commands
#
php.sh:
	@printf $(SHELL_ICO) && echo  php shell
	@docker exec -it $(PHP) sh
php.root.sh:
	@printf $(SHELL_ICO) && echo  php shell
	@docker exec -it --user root $(PHP) sh
db.sh:
	@printf $(SHELL_ICO) && echo  db shell
	@docker exec -it $(shell docker-compose -f $(DOCKER_COMPOSE) ps -q db) sh
db.mysql:
	@printf $(MYSQL_ICO) && echo  mysql shell
	@mysql -u root -h 0.0.0.0 -p --port 3307
web.sh:
	@printf $(SHELL_ICO) && echo  web shell
	@docker exec -it $(shell docker-compose -f $(DOCKER_COMPOSE) ps -q web) sh

#
# xdebug
#
xdebug.on:
	@docker container pause $(PHP) > /dev/null
	@sed -i '/xdebug.mode/c\xdebug.mode=coverage,debug' .docker/php/conf.d/20-overrides.ini
	@docker container unpause $(PHP) > /dev/null
	@docker container restart $(PHP) > /dev/null
	@printf $(XDEBUG_ICO) && echo ${GREEN} Xdebug On
xdebug.off:
	@docker container pause $(PHP) > /dev/null
	@sed -i '/xdebug.mode/c\xdebug.mode=off' .docker/php/conf.d/20-overrides.ini
	@docker container unpause $(PHP) > /dev/null
	@docker container restart $(PHP) > /dev/null
	@printf $(CANCEL_ICO) && echo ${YELLOW} Xdebug Off

#
# internal
#
do.copy:
	@cp .docker/php.env.development .docker/php.env
	@cp .docker/mysql.env.development .docker/mysql.env
	@cp .docker/php/conf.d/20-overrides.ini.development .docker/php/conf.d/20-overrides.ini
