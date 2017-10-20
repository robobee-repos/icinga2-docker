include ../utils/Makefile.help
include ../utils/Makefile.functions

NAME := icinga2

test: setup ##@targets Starts docker compose.
	docker-compose -p $(NAME) -f test.yaml up
.PHONY: test

rm:
	docker-compose -p $(NAME) -f test.yaml rm
.PHONY: rm

clean: rm
	sudo rm -rf root
.PHONY: clean

rm-icinga:
	docker-compose -p $(NAME) -f test.yaml stop icinga
	docker-compose -p $(NAME) -f test.yaml rm -f icinga
.PHONY: rm-icinga

clean-icingaweb:
	docker-compose -p $(NAME) -f test.yaml stop icingaweb
	docker-compose -p $(NAME) -f test.yaml rm -f icingaweb
	sudo rm -rf root/icingaweb2
.PHONY: clean-icingaweb

setup:
	mkdir -p root/icinga2
	mkdir -p root/icingaweb2
	mkdir -p root/icingadb
	mkdir -p root/icingawebdb
	mkdir -p root/html
	sudo chown 102.103 -R root/icinga2
	sudo chown 33.33 -R root/icingaweb2
	sudo chmod o+rwX root/icingadb
	sudo chmod o+rwX root/icingawebdb
	sudo chown 33.33 -R root/html
.PHONY: setup
