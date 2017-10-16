include ../utils/Makefile.help
include ../utils/Makefile.functions

NAME := icinga2
ROOT_DIR := $(shell realpath root)

test: ##@targets Starts docker compose.
	export ROOT_DIR="$(ROOT_DIR)" \
	&& docker-compose -p $(NAME) -f test.yaml up
.PHONY: test

rm:
	export ROOT_DIR="$(ROOT_DIR)" \
	&& docker-compose -p $(NAME) -f test.yaml rm
.PHONY: rm
