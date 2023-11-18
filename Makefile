# The name of the host tool archive.
# Must be set as an env variable before make is invoked.
HOST_TOOL_ARCHIVE_NAME := ""


CONTAINER_INSTALL_TARGET_DIR := /opt/Xilinx

SHELL := /bin/bash

all:
	@echo "HOST_TOOL_ARCHIVE_NAME       : ${HOST_TOOL_ARCHIVE_NAME} (must be nonempty!)"
	@echo "CONTAINER_INSTALL_TARGET_DIR : ${CONTAINER_INSTALL_TARGET_DIR}"
	@echo "SHELL                        : ${SHELL}"
	@echo
	@echo "build container by using"
	@echo "		make HOST_TOOL_ARCHIVE_NAME=<path_to_archive> build"
.PHONY: all

build: build.stamp
.PHONY: build

build.stamp: docker/Dockerfile Makefile install_config.txt
	@if [[ ${HOST_TOOL_ARCHIVE_NAME} == "" ]]; then \
		 "Needs env HOST_TOOL_ARCHIVE_NAME"; \
		exit 1; \
	fi
	@if [[ ! -f ${HOST_TOOL_ARCHIVE_NAME} ]]; then \
		 "The file pointed to by ${HOST_TOOL_ARCHIVE_NAME} does not seem to exist"; \
		exit 1; \
	fi
	env DOCKER_BUILDKIT=1 docker build \
		--build-arg HOST_TOOL_ARCHIVE_NAME=${HOST_TOOL_ARCHIVE_NAME} \
		--build-arg INSTALL_TARGET_DIR=${CONTAINER_INSTALL_TARGET_DIR} \
		-f $< .
	touch $@

clean:
	rm *.stamp

