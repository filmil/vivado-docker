FROM ubuntu:22.04

ARG INSTALL_TARGET_DIR
ARG XSETUP_DIR
ARG HOST_TOOL_ARCHIVE_NAME

ENV XILINX_INSTALL_LOCATION=$INSTALL_TARGET_DIR
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "dash dash/sh boolean false" | debconf-set-selections 
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

RUN apt-get update

RUN apt-get install -y \
		locales-all \
		locales \
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

RUN env LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8 \
	&& echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

RUN mkdir -p $XILINX_INSTALL_LOCATION/tmp

# Copy archive into the container
COPY $HOST_TOOL_ARCHIVE_NAME $XILINX_INSTALL_LOCATION/tmp
COPY install_config.txt $XILINX_INSTALL_LOCATION/tmp

# Unpack the archive locally.
RUN cd $XILINX_INSTALL_LOCATION/tmp \
	&& tar -xzf $(basename $HOST_TOOL_ARCHIVE_NAME) \
	&& cd "$XILINX_INSTALL_LOCATION/tmp/`basename --suffix=.tar.gz $HOST_TOOL_ARCHIVE_NAME`"

RUN cd "$XILINX_INSTALL_LOCATION/tmp/`basename --suffix=.tar.gz $HOST_TOOL_ARCHIVE_NAME`" \
    &&./xsetup --config $XILINX_INSTALL_LOCATION/tmp/install_config.txt \
		--batch Install \
		--location /opt/Xilinx \
		--agree XilinxEULA,3rdPartyEULA \
	&& rm -fr $XILINX_INSTALL_LOCATION/tmp/*

VOLUME /src

COPY run.sh /
RUN chmod a+x run.sh
