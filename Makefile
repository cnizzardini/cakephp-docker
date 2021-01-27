SHELL=/bin/bash

#
# project vars
#
IMAGE_NAME      := docker-cakephp
APP_NAME        := App
USERNAME        := cakephp
APP_DIR         := app

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
SALT            := $(shell cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PHP             := $(shell docker-compose ps -q php)
USER_ID         := $(shell id -u)

init: do.copy
	@cp $(APP_DIR)/config/.env.example $(APP_DIR)/config/.env
	@sed -i '/export APP_NAME/c\export APP_NAME="$(APP_NAME)"' $(APP_DIR)/config/.env
	@sed -i '/export SECURITY_SALT/c\export SECURITY_SALT="$(SALT)"' $(APP_DIR)/config/.env
	@docker-compose build --build-arg USER_ID=$(USER_ID) --build-arg USERNAME=$(USERNAME)
	@docker-compose up -d

#
# composer commands
#
composer.install:
	@docker exec $(PHP) composer install --no-interaction
composer.test:
	@docker exec -it $(PHP) composer test
composer.check:
	@docker exec -it $(PHP) composer check

#
# docker & docker-compose commands
#
up: do.copy
	@printf '\U1F40B ' && echo up
	@docker-compose up -d
stop:
	@printf '\U1F40B ' && echo stop
	@docker-compose stop
build.prod:
	@docker build --build-arg ENVIRONMENT=prod -t $(IMAGE_NAME) .docker/
build.dev:
	@docker build -t $(IMAGE_NAME)-dev .docker/

#
# container shell commands
#
php.sh:
	@printf '\U1F41A ' && echo  php shell
	@docker exec -it $(PHP) sh
php.root.sh:
	@printf '\U1F41A ' && echo  php shell
	@docker exec -it --user root $(PHP) sh
db.sh:
	@printf '\U1F41A ' && echo  db shell
	@docker exec -it $(shell docker-compose ps -q db) sh
db.mysql:
	@printf '\U1F42C ' && echo  mysql shell
	@mysql -u root -h 0.0.0.0 -p --port 3307
web.sh:
	@printf '\U1F41A ' && echo  web shell
	@docker exec -it $(shell docker-compose ps -q web) sh

#
# xdebug
#
xdebug.on:
	@docker container pause $(PHP) > /dev/null
	@sed -i '/xdebug.mode/c\xdebug.mode=coverage,debug' .docker/php/conf.d/20-overrides.ini
	@docker container unpause $(PHP) > /dev/null
	@docker container restart $(PHP) > /dev/null
	@printf '\U1F41E' && echo ${GREEN} Xdebug On
xdebug.off:
	@docker container pause $(PHP) > /dev/null
	@sed -i '/xdebug.mode/c\xdebug.mode=off' .docker/php/conf.d/20-overrides.ini
	@docker container unpause $(PHP) > /dev/null
	@docker container restart $(PHP) > /dev/null
	@printf '\U1F515' && echo ${YELLOW} Xdebug Off

#
# internal
#
do.copy:
	@cp .docker/php.env.development .docker/php.env
	@cp .docker/mysql.env.development .docker/mysql.env
	@cp .docker/php/conf.d/20-overrides.ini.development .docker/php/conf.d/20-overrides.ini
