include ../utils/Makefile.help
include ../utils/Makefile.functions

NAME := icinga2

test: setup ##@targets Starts docker compose.
	docker-compose -p $(NAME) -f test.yaml up
.PHONY: test

rm:
	docker-compose -p $(NAME) -f test.yaml stop
.PHONY: rm

clean: rm
	docker-compose -p $(NAME) -f test.yaml rm -f
	sudo rm -rf root
.PHONY: clean

rm-icinga:
	docker-compose -p $(NAME) -f test.yaml stop icinga-a
	docker-compose -p $(NAME) -f test.yaml rm -f icinga-a
	docker-compose -p $(NAME) -f test.yaml stop icinga-b
	docker-compose -p $(NAME) -f test.yaml rm -f icinga-b
.PHONY: rm-icinga

clean-icingaweb:
	docker-compose -p $(NAME) -f test.yaml stop icingaweb
	docker-compose -p $(NAME) -f test.yaml rm -f icingaweb
	sudo rm -rf root/icingaweb2
.PHONY: clean-icingaweb

setup:
	mkdir -p root/icinga2-a
	mkdir -p root/icinga2-b
	mkdir -p root/icingaweb2
	mkdir -p root/icingadb
	mkdir -p root/icingawebdb
	mkdir -p root/html
	sudo chown o+rwX -R root/icinga2-a
	sudo chown o+rwX -R root/icinga2-b
	sudo chown o+rwX -R root/icingaweb2
	sudo chmod o+rwX root/icingadb
	sudo chmod o+rwX root/icingawebdb
	sudo chown o+rwX -R root/html
.PHONY: setup

setup-icinga-mysql:
	docker exec icinga2_icinga_1 /setup-mysql-tables.sh
.PHONY: setup-icinga-mysql

setup-icingaweb-mysql:
	docker exec icinga2_icingaweb_1 /setup-mysql-tables.sh
.PHONY: setup-icingaweb-mysql
