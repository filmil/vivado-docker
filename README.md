# vivado-docker

[Docker](https://docker.io) installation of AMD's Vivado tooling for FPGA development.

The script builds a Docker container with a ready-to-go installation of the AMD's (formerly: Xilinx) Vivado
tooling for developing for FPGA devices.

By default it installs a limited number of features from the free-to-develop-with "Vivado ML Standard" software
package.

The contribution to the state of the art is that it is able to install Vivado ML Standard version 2023.2, which
is the latest edition of the Vivado software at the time of this writing. I am not aware of any other packages
that are available publicly which do the same.

# Limitations

This not an end-all be-all solution for dockerizing Vivado. At least not yet. The limitations I encountered
are as follows:

* It seems that not all installation options end up with a successful build of a docker container. Some require
access to a display server (X11), which I don't know how to offer while a container is being built.
* It is currently not possible to dockerize "Vivado ML Enterprise", which requires a paid license.
* The resulting container is enormous, with over 200GB in total.
* The container takes more than an hour to build. You want to use `docker build` with BuildKit
* You must download the installation package yourself from AMD, and make it available to the package by placing
  it inside the repository once you check it out. I do not see that changing.

# Prior art

This repo was not built in a vacuum. I consulted a number of resources out there on the internet

* [Dockerizing Xilinx tools.][1] discussion on Reddit.

[1]: https://www.reddit.com/r/FPGA/comments/bk8b3n/dockerizing_xilinx_tools/
