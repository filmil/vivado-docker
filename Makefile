XSETUP_DIR := ""
INSTALL_TARGET_DIR := /opt/Xilinx

SHELL := /bin/bash

all:
	@echo "XSETUP_DIR: ${XSETUP_DIR}"
	@echo "SHELL     : ${SHELL}"
.PHONY: all

build: build.stamp
.PHONY: build

build.stamp: docker/Dockerfile Makefile
	@if [[ ${XSETUP_DIR} == "" ]]; then \
		echo "Needs env XSETUP_DIR"; \
		exit 1; \
	fi
	docker build \
		--build-arg XSETUP_DIR=${XSETUP_DIR} \
		--build-arg INSTALL_TARGET_DIR=${INSTALL_TARGET_DIR} \
		-f $< .
	touch $@

clean:
	rm *.stamp

