SHELL=/bin/bash

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET := $(shell tput -Txterm sgr0)
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

SALT    := $(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PHP     := $(shell docker-compose ps -q php)

init:
	cp .docker/php/php.ini.development .docker/php/php.ini \
	&& cp .docker/php/conf.d/20-overrides.ini.development .docker/php/conf.d/20-overrides.ini \
	&& cp app/config/.env.example app/config/.env \
	&& sed -i '/export APP_NAME/c\export APP_NAME="APP"' app/config/.env \
	&& sed -i '/export SECURITY_SALT/c\export SECURITY_SALT="$(SALT)"' app/config/.env \
	&& docker-compose up -d --build \
	&& docker exec $(shell docker-compose ps -q php) composer install
up:
	@printf '\U1F40B ' && echo up \
	&& docker-compose up -d
down:
	@printf '\U1F40B ' && echo down \
	&& docker-compose down
stop:
	@printf '\U1F40B ' && echo stop \
	&& docker-compose stop
restart:
	@printf '\U1F40B ' && echo restart \
	&& docker-compose restart
bash:
	@printf '\U1F41A ' && echo Bash Shell \
	&& docker exec -it $(PHP) bash
mysql:
	@printf '\U1F42C ' && echo MySQL Shell \
	&& mysql -u root -h 0.0.0.0 -p --port 3307
xdebug-off:
	@docker container pause $(PHP) > /dev/null \
	&& cd .docker/php/conf.d \
	&& sed -i '/xdebug.mode/c\xdebug.mode=off' 20-overrides.ini \
	&& docker container unpause $(PHP) > /dev/null \
	&& docker container restart $(PHP) > /dev/null \
	&& printf '\U1F515' && echo ${YELLOW} Xdebug Off
xdebug-on:
	@docker container pause $(PHP) > /dev/null \
	&& cd .docker/php/conf.d \
	&& sed -i '/xdebug.mode/c\xdebug.mode=coverage,debug' 20-overrides.ini \
	&& docker container unpause $(PHP) > /dev/null \
	&& docker container restart $(PHP) > /dev/null \
	&& printf '\U1F41E' && echo ${GREEN} Xdebug On