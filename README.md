# vivado-docker

## Summary

[Docker](https://docker.io) installation of AMD's [Vivado][viv] tooling for FPGA
development. The specific version of the tooling is Vivado 2023.2.

[viv]: https://en.wikipedia.org/wiki/Vivado

## Details

The script builds a Docker container with a ready-to-go installation of the
AMD's (formerly: Xilinx) Vivado tooling for developing for FPGA devices.

By default it installs a limited number of features from the
free-to-develop-with "Vivado ML Standard" software package.

# Contribution

The contribution to the state of the art is that it is able to install Vivado
ML Standard version 2023.2.

This is the latest edition of the Vivado software at the time of this writing.
I am not aware of any other packages that are available publicly which do the
same.

# Prerequisites

* Git
* Docker and buildkit
* A download of the Unified installer.

# Limitations

This not an end-all be-all solution for dockerizing Vivado. At least not yet.
The limitations I encountered are as follows:

* It seems that not all installation options end up with a successful build of
  a docker container. Some require access to a display server (X11), which I
  don't know how to offer while a container is being built.
* It is currently not possible to dockerize "Vivado ML Enterprise", which
  requires a paid license.
* The resulting container is enormous, with over 200GB in total.
* The container takes more than an hour to build. You want to use `docker
  build` with BuildKit to cut down on the build time considerably.
* You must download the installation package yourself from AMD, and make it
  available to the package by placing it inside the repository once you check
  it out. I do not see that changing.
* The correct operation of this repo relies on downloading a missing Vivado
  archive, which makes it very hard to test.

# Prior art

This repo was not built in a vacuum. I consulted a number of resources out
there on the internet.

* [Dockerizing Xilinx tools.][1] discussion on Reddit, which bootstrapped this
  work.
* [Xilinx tools docker][8]: the freshest piece of instruction that I could find.
* [Xilinx Vivado with Docker and Jenkins][2]. Does what it says on the tin.
* [Xilinx Vivado/Vivado HLS][3] from CERN.
* [Xilinx guides about Docker][4], which I'm not sure helped at all.
* [AMD guildes about Vivado on Kubernetes et al.][5].
* [Install Xilinx Vivado using Docker][6], another blog recount of the process.
* [Run GUI applications in Docker or podman containers.][7]

[1]: https://www.reddit.com/r/FPGA/comments/bk8b3n/dockerizing_xilinx_tools/
[2]: https://www.starwaredesign.com/index.php/blog/64-fpga-meets-devops-xilinx-vivado-and-jenkins-with-docker
[3]: https://github.com/aperloff/vivado-docker
[4]: https://xilinx.github.io/Xilinx_Container_Runtime/docker.html
[5]: https://docs.xilinx.com/r/en-US/Xilinx_Kubernetes_Device_Plugin/1.-Install-Docker
[6]: https://blog.p4ck3t0.de/post/xilinx_docker/
[7]: https://github.com/mviereck/x11docker
[8]: https://github.com/esnet/xilinx-tools-docker/tree/main

