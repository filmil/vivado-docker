# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

FROM ubuntu:22.04

ARG INSTALL_TARGET_DIR
ARG XSETUP_DIR
ARG HOST_TOOL_ARCHIVE_NAME
ARG VIVADO_VERSION
ARG HOST_TOOL_ARCHIVE_EXTENSION

ENV XILINX_INSTALL_LOCATION=$INSTALL_TARGET_DIR
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

RUN apt-get update

RUN apt-get install -y \
		autoconf \
		build-essential \
		chrpath \
		cpio \
		diffstat \
		expect \
		fakeroot \
		gawk \
		gcc-multilib \
		git \
		gzip \
		less \
		libglib2.0-dev \
		libgtk2.0-0 \
		libgtk2.0-dev \
		libncurses5-dev \
		libsdl1.2-dev \
		libtinfo5 \
		libtool \
		libtool-bin \
		locales \
		locales-all \
		lsb-release \
		make \
		net-tools \
		pax \
		python3-gi \
		rsync \
		screen \
		socat \
		tar \
		xorg \
		xterm \
		xvfb \
		zlib1g-dev \
		zlib1g-dev \
	  	bison \
	  	flex \
	  	gnupg \
	  	iproute2 \
	  	libselinux1 \
	  	libssl-dev \
	  	texinfo \
	  	tftpd \
	  	tofrodos \
	  	unzip \
	  	update-inetd \
	  	wget \
		dos2unix

# libboost-signals-dev
RUN apt-get install -y \
	 	google-perftools \
		default-jre

# TODO: filmil - there is a more canonical way to set the locale.
RUN env LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8 \
	&& echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

RUN mkdir -p $XILINX_INSTALL_LOCATION/tmp

# Copy archive into the container
COPY $HOST_TOOL_ARCHIVE_NAME $XILINX_INSTALL_LOCATION/tmp
COPY install_config.txt $XILINX_INSTALL_LOCATION/tmp

# Unpack the archive locally.
RUN cd $XILINX_INSTALL_LOCATION/tmp \
	&& tar -xf $(basename $HOST_TOOL_ARCHIVE_NAME) \
	&& cd "$XILINX_INSTALL_LOCATION/tmp/`basename --suffix=$HOST_TOOL_ARCHIVE_EXTENSION $HOST_TOOL_ARCHIVE_NAME`"

RUN cd "$XILINX_INSTALL_LOCATION/tmp/`basename --suffix=$HOST_TOOL_ARCHIVE_EXTENSION $HOST_TOOL_ARCHIVE_NAME`" \
    &&./xsetup --config $XILINX_INSTALL_LOCATION/tmp/install_config.txt \
		--batch Install \
		--location /opt/Xilinx \
		--agree XilinxEULA,3rdPartyEULA \
	&& rm -fr $XILINX_INSTALL_LOCATION/tmp/*

VOLUME /src
VOLUME /work

COPY run.sh /
RUN chmod a+x run.sh

WORKDIR /work
