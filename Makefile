# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# The name of the host tool archive.
# Must be set as an env variable before make is invoked.
HOST_TOOL_ARCHIVE_NAME := ""
HOST_TOOL_ARCHIVE_EXTENSION := ".tar" # Huh?!
VIVADO_VERSION := "2025.1"


CONTAINER_INSTALL_TARGET_DIR := /opt/Xilinx

SHELL := /bin/bash

all:
	@echo "HOST_TOOL_ARCHIVE_NAME       : ${HOST_TOOL_ARCHIVE_NAME} (must be nonempty!)"
	@echo "CONTAINER_INSTALL_TARGET_DIR : ${CONTAINER_INSTALL_TARGET_DIR}"
	@echo "SHELL                        : ${SHELL}"
	@echo "VIVADO_VERSION               : ${VIVADO_VERSION}"
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
		-t xilinx-vivado:${VIVADO_VERSION} \
		--build-arg HOST_TOOL_ARCHIVE_NAME=${HOST_TOOL_ARCHIVE_NAME} \
		--build-arg HOST_TOOL_ARCHIVE_EXTENSION=${HOST_TOOL_ARCHIVE_EXTENSION} \
		--build-arg INSTALL_TARGET_DIR=${CONTAINER_INSTALL_TARGET_DIR} \
		--build-arg VIVADO_VERSION=${VIVADO_VERSION} \
		-f $< .
	touch $@

xilinx-vivado.${VIVADO_VERSION}.docker.tgz: docker/Dockerfile Makefile install_config.txt
	docker save > xilinx-vivado.${VIVADO_VERSION}.docker.tgz

save: xilinx-vivado.docker.${VIVADO_VERSION}.tgz
.PHONY: save

clean:
	rm *.stamp

run:
	./run.vivado.sh

