FIG=docker-compose
RUN=$(FIG) run --rm
EXEC=$(FIG) exec
CONSOLE=php bin/console
SFCLI=symfony

FIGPROD=docker-compose -f docker-compose-prod.yml
RUNPROD=$(FIGPROD) run --rm
EXECPROD=$(FIGPROD) exec

.PHONY: help start stop build up reset config db-diff db-migrate vendor reload test assets start-web-server

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  reload   clear cache, reload database schema"

##
## Docker
##---------------------------------------------------------------------------

start:          ## Install and start the project
start: build up

start-web-server:
	$(SFCLI) server:start

stop:           ## Remove docker containers
	$(FIG) stop && $(FIG) rm -f

reset:          ## Reset the whole project
reset: stop start

build:
	$(FIG) build

up:
	$(FIG) up -d

vendor:           ## Vendors
	$(RUN) php composer install
	$(RUN) php npm config set unsafe-perm=true
	$(RUN) php npm install

config:        ## Init files required
	cp -n docker-compose.override.yml.dist docker-compose.override.yml

install:          ## Install the whole project
install: config start vendor reload assets

clear:          ## Remove all the cache, the logs, the sessions and the built assets
	$(EXEC) php rm -rf var/cache/*
	$(EXEC) php rm -rf var/logs/*

##
## DB
##---------------------------------------------------------------------------

db-diff:      ## Generation doctrine diff
	$(RUN) php $(CONSOLE) doctrine:migrations:diff

db-migrate:   ## Launch doctrine migrations
	$(RUN) php $(CONSOLE) doctrine:migrations:migrate -n

## Others
reload: clear reload-db

reload-db:
	$(RUN) php $(CONSOLE) doctrine:database:drop --force
	$(RUN) php $(CONSOLE) doctrine:database:create
	$(RUN) php $(CONSOLE) doctrine:migrations:migrate -n

test:
	$(RUN) php bin/phpunit

php-cs-fixer:
	$(RUN) php bin/php-cs-fixer fix

assets:   ## Launch doctrine migrations
	$(RUN) php $(CONSOLE) assets:install --symlink --relative web
	./node_modules/grunt-cli/bin/grunt assetsDocker --force to continue
	./node_modules/bower/bin/bower install
	./node_modules/bower/bin/bower install ./vendor/sonata-project/admin-bundle/bower.json

## Execute symfony command
## use with ACTION=gererseul:lease:generate-rent make command

command:
	$(RUN) php $(CONSOLE) $(ACTION)



## prod only
update-prod: start-prod migrate-prod vendor-prod assets-prod clear-cache-prod

build-prod:
	$(FIGPROD) build

up-prod:
	$(FIGPROD) up -d

start-prod: build-prod up-prod

migrate-prod:
	$(RUNPROD) php $(CONSOLE) doctrine:migrations:migrate -n

vendor-prod:
	$(RUNPROD) php composer install
	$(RUNPROD) php npm config set unsafe-perm=true
	$(RUNPROD) php npm install

assets-prod:
	$(RUNPROD) php $(CONSOLE) assets:install --symlink --relative web
	#need to be changed
	./node_modules/grunt-cli/bin/grunt assetsDocker
	./node_modules/bower/bin/bower install --force
	./node_modules/bower/bin/bower install ./vendor/sonata-project/admin-bundle/bower.json --force

clear-cache-prod:
	$(EXECPROD) php rm -rf var/cache/*

stop-prod:
	$(FIGPROD) stop && $(FIGPROD) rm -f

