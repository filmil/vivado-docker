# Latest: 2025.1

# vivado-docker

## Summary

[Docker](https://docker.io) installation of AMD's [Vivado][viv] tooling for FPGA
development. The specific version of the tooling is Vivado 2025.1.

[viv]: https://en.wikipedia.org/wiki/Vivado

To clarify: this repo contains nothing of the Vivado tooling. It contains a
recipe that allows you to build your own Docker container from a free Vivado
installation that you download. The built image is *not* available for download
from the Docker Hub due to its size and to prevent any licensing issues.

## Details

The script builds a Docker container with a ready-to-go installation of the
AMD's (formerly: Xilinx) Vivado tooling for developing for FPGA devices.

If you want to undertake a docker container build, arm yourself with patience.
Even when nothing blows up, it takes multiple hours to complete the build. It
then also takes multiple hours to load the image into Docker and/or save it
into an image archive. It's not a job for the faint of the heart and for the
lacking of the time.

By default the script installs a limited number of features from the
free-to-develop-with "Vivado ML Standard" software package.

# Contribution

# Prerequisites

* Git
* Docker and buildkit
* A download of the Vivado Unified installer that you own a license to.

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

# Why?

I am a fan of [repeatable, hermetic, and self-maintaining][bzl] dev
environments. While Docker itself isn't any of the above by default, the
containers you build kind of are. This allows me to build a dev environment
that I know is identical across possible multiple installations.

If you don't care about that you might as well install Vivado the usual way. I
understand that not everyone does and that you aren't required to care.

# Maintenance

## Preparing for the build

* Download the archive from AMD. This ensures doing right by the software
  license.
* Place the archive (which for 2025.1 is a `.tar` archive for some reason, not
  a `.tar.gz`) in the top level directory of this repo.
  * The archive name this time around is
    `FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145.tar`.
* Generate `install_config.txt`. The file `install_config.txt` is generated
  from the Xilinx setup program as: `xsetup -b SetupGen`, and selecting the
  Vivado ML Standard edition.

  This is likely the only Vivado specific bit of info needed to create the
  docker container. When you generate the configuration, it will automatically
  be placed in `$HOME/.Xilinx/install_config.txt`, so it needs to be rescued
  from there. Also make sure to edit the `Modules=` section, and turn on the
  elements from `...:0` to `...:1` for those elements that you want installed.

## Building

From the repository's top directory, do:

```
make HOST_TOOL_ARCHIVE_NAME=FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145.tar build
```

From here, be prepared to wait for a *long* time.  Container building can take
hours, even with buildkit optimizations.

The approximate durations of the long operations is as follows:

* 30min: Loading the archive into the build context.
* 30min: Copying the archive into the container.
* 30min: Unpacking the archive.
* 30min: Installation.
* 90min: Exporting layers.

## Saving the image

Once it has been built, you can save the image into an archive:

```
make save
```

This archive can be moved between computers if you need to do that.
Unfortunately the image is too large to be hosted reliably on Docker Hub, so it
is not hosted there.

## Loading the image

The command line below assumes that you have a docker image stored in the file
named `xilinx-vivado.docker.tgz`

```
docker load -i xilinx-vivado.docker.tgz
```

I noticed that loading an image this large is fraught with issues, and it may
take you several tries to manage to do it. This seems to be inevitable.

## Running Vivado from the image

Once you have a built Vivado docker image loaded into Docker, you can now do:

```
make run
```

to try it out. If you are running under a windowing system, you should eventually
see the Vivado GUI open up.

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
[bzl]: https://www.hdlfactory.com/tags/bazel/

