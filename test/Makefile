include ../utils/Makefile.help
include ../utils/Makefile.functions

NAME := icinga2

test: setup ##@targets Starts docker compose.
	export ROOT_DIR="$(ROOT_DIR)" \
	&& docker-compose -p $(NAME) -f test.yaml up
.PHONY: test

rm:
	export ROOT_DIR="$(ROOT_DIR)" \
	&& docker-compose -p $(NAME) -f test.yaml rm
.PHONY: rm

clean: rm
	sudo rm -rf root
.PHONY: clean

setup:
	mkdir -p root/icinga2
	mkdir -p root/db
	sudo chown 102.103 -R root/icinga2
	sudo chmod o+rwX root/db
.PHONY: setup
