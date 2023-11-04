FROM ubuntu:22.04

ARG INSTALL_TARGET_DIR
ARG XSETUP_DIR

ENV XLNX_INSTALL_LOCATION=$INSTALL_TARGET_DIR
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "dash dash/sh boolean false" | debconf-set-selections 
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

RUN apt-get update

RUN apt-get install -y \
	  	tofrodos \
	  	iproute2 \
		gawk \
		xvfb \
		git \
		make \
		net-tools \
		libncurses5-dev \
	  	update-inetd \
	  	tftpd \
		zlib1g-dev \
	  	libssl-dev \
	  	flex \
	  	bison \
	  	libselinux1 \
	  	gnupg \
	  	wget \
		diffstat \
		chrpath \
		socat \
		xterm \
		autoconf \
		libtool \
		libtool-bin \
		tar \
	  	unzip \
	  	texinfo \
		zlib1g-dev \
		gcc-multilib \
		build-essential \
		libsdl1.2-dev \
		libglib2.0-dev \
		screen \
		pax \
		gzip \
		python3-gi \
		less \
		lsb-release \
		fakeroot \
		libgtk2.0-0 \
		libgtk2.0-dev \
		cpio \
		rsync \
		xorg \
		expect \
		dos2unix

RUN apt-get install -y \
	 	# libboost-signals-dev \
	 	google-perftools \
		default-jre
