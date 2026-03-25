# syntax=docker/dockerfile:1
# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# hadolint ignore=DL3029
FROM --platform=linux/amd64 ubuntu:22.04

ARG INSTALL_TARGET_DIR=/opt/Xilinx
ARG HOST_TOOL_ARCHIVE_NAME
ARG VIVADO_VERSION=2025.2
ARG HOST_TOOL_ARCHIVE_EXTENSION=.tar

ENV XILINX_INSTALL_LOCATION=$INSTALL_TARGET_DIR
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Use bash instead of dash
RUN echo "dash dash/sh boolean false" | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Single-layer apt-get install to reduce image size.
# Credit: This single-layer optimization was contributed by @gretel in PR #5.
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        build-essential \
        ca-certificates \
        chrpath \
        cpio \
        default-jre \
        diffstat \
        dos2unix \
        expect \
        fakeroot \
        gawk \
        gcc \
        gcc-multilib \
        git \
        gnupg \
        google-perftools \
        gzip \
        iproute2 \
        less \
        libglib2.0-dev \
        libgtk2.0-0 \
        libgtk2.0-dev \
        libncurses5-dev \
        libsdl1.2-dev \
        libselinux1 \
        libssl-dev \
        libtinfo5 \
        libtool \
        libtool-bin \
        locales \
        lsb-release \
        make \
        net-tools \
        pax \
        python3-gi \
        rsync \
        screen \
        socat \
        tar \
        texinfo \
        tofrodos \
        unzip \
        wget \
        xterm \
        xvfb \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN env LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8 \
    && printf 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

# Build libudev stub for Rosetta compatibility.
# Vivado's license manager and WebTalk call udev_enumerate_scan_devices()
# which crashes under Rosetta x86_64 emulation with:
#   "realloc(): invalid pointer" / "mremap_chunk(): invalid pointer"
# This stub provides no-op implementations that return empty device lists.
# Use via: LD_PRELOAD=/opt/udev_stub.so vivado ...
# On native x86_64 hosts this stub is harmless but unnecessary.
COPY docker/udev_stub.c /tmp/udev_stub.c
RUN gcc -shared -fPIC -o /opt/udev_stub.so /tmp/udev_stub.c \
    && rm /tmp/udev_stub.c

RUN mkdir -p $XILINX_INSTALL_LOCATION/tmp

# Copy only the small config file (not the ~96 GB archive!)
COPY install_config.txt /tmp/install_config.txt

# Extract archive and install Vivado in a SINGLE layer using bind mount.
# The archive is mounted read-only from the build context — never copied
# into an image layer. Extraction + install + cleanup happen atomically,
# so only the final installed files persist.
# Credit: This bind-mount optimization was contributed by @gretel in PR #5.
# hadolint ignore=DL3003
RUN --mount=type=bind,source=${HOST_TOOL_ARCHIVE_NAME},target=/tmp/archive.tar \
    mkdir -p /tmp/vivado-extract \
    && echo "Extracting archive (this takes a while)..." \
    && tar -xf /tmp/archive.tar -C /tmp/vivado-extract \
    && echo "Running xsetup batch install..." \
    && cd "/tmp/vivado-extract/$(ls /tmp/vivado-extract)" \
    && ./xsetup \
        --config /tmp/install_config.txt \
        --batch Install \
        --location ${INSTALL_TARGET_DIR} \
        --agree XilinxEULA,3rdPartyEULA \
    && echo "Cleaning up extracted archive..." \
    && rm -rf /tmp/vivado-extract /tmp/install_config.txt

COPY run.sh /
RUN chmod a+x /run.sh

VOLUME /src
VOLUME /work

WORKDIR /work
