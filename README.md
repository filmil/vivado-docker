# Latest: 2025.1

# vivado-docker

## Table of Contents
* [Summary](#summary)
* [Why?](#why)
* [Prerequisites](#prerequisites)
* [Limitations](#limitations)
* [Maintenance](#maintenance)
* [Troubleshooting/FAQ](#troubleshootingfaq)
* [Contribution](#contribution)
* [Prior art](#prior-art)

## Summary

This repository provides a [Docker](https://docker.io) setup for AMD's [Vivado][viv]
FPGA development tools, specifically version 2025.1.

[viv]: https://en.wikipedia.org/wiki/Vivado

**Important:** This repository does not contain any Vivado software. Instead, it
offers a recipe to build your own Docker container using a Vivado installer that
you download from AMD. Due to its size and licensing restrictions, the built
Docker image is not available for download from Docker Hub or other public
registries.

The script builds a Docker container with a pre-configured installation of
AMD's (formerly Xilinx) Vivado tools. Building the container is a
time-consuming process (multiple hours), as is loading the image into Docker or
saving it as an archive. Please allocate sufficient time.

By default, the script installs a selection of features from the "Vivado ML
Standard" edition, which is free to use for development.

## Why?

This project aims to provide a repeatable, hermetic, and self-maintaining
development environment using Docker containers. This ensures a consistent Vivado
setup across different machines. If this is not a concern for you, a standard
Vivado installation may be sufficient.

[bzl]: https://www.hdlfactory.com/tags/bazel/

## Prerequisites

*   Git
*   Docker (with BuildKit enabled for faster builds)
*   A downloaded Vivado Unified Installer archive (for which you hold a valid
    license).

## Limitations

This solution for dockerizing Vivado has the following known limitations:

*   **Supported Vivado Edition:** This project currently only supports
    dockerizing the "Vivado ML Standard" edition. "Vivado ML Enterprise" (which
    requires a paid license and may have different installation mechanisms) is
    not supported. The repository https://github.com/esnet/xilinx-tools-docker seems
    to do the same, but for Vivado ML Enterprise. I have not tested this.
*   **Installer Availability:** You must download the Vivado installer archive
    yourself directly from AMD. This repository cannot and will not provide the
    installer due to licensing and distribution restrictions.
*   **Testing Constraints:** Thoroughly testing all possible configurations and
    Vivado versions is challenging due to the dependency on specific, large
    installer archives from AMD and the lengthy build times.

## Maintenance

### Preparing for the Build

1.  **Download Vivado Installer:** Obtain the Vivado Unified Installer archive
    from AMD. You are responsible for complying with all software licensing
    terms.
2.  **Place Installer in Repo:** Copy the downloaded archive into the top-level
    directory of this repository. For Vivado 2025.1, the archive name is
    typically `FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145.tar`.
3.  **Generate `install_config.txt`:**
    *   Use the Xilinx setup program to generate the installation configuration
        file: `` `xsetup -b SetupGen` ``.
    *   During the generation process, select the "Vivado ML Standard" edition.
    *   The setup program will create `install_config.txt` in
        `$HOME/.Xilinx/`. Copy this file into the root directory of this
        repository.
    *   Edit the `Modules=` section within `install_config.txt` to enable the
        specific Vivado components you require. Change the `0` to a `1` for
        each desired module (e.g., `Vivado Simulator:1`).

### Building the Container

Navigate to the repository's root directory and run:

```bash
make HOST_TOOL_ARCHIVE_NAME=FPGAs_AdaptiveSoCs_Unified_SDI_2025.1_0530_0145.tar build
```

The build process is lengthy. See the FAQ section for more details on build
times and optimizations.

Approximate durations for key steps:

*   Loading archive into build context: ~30 min
*   Copying archive into container: ~30 min
*   Unpacking archive: ~30 min
*   Vivado installation: ~30 min
*   Exporting Docker image layers: ~90 min

### Saving the Image

After a successful build, you can save the Docker image to a `.tar` archive:

```bash
make save
```

This archive (e.g., `xilinx-vivado.docker.tgz`) can be transferred to other
machines. The image is too large for Docker Hub and is not hosted there.

### Loading the Image

To load the image from an archive:

```bash
docker load -i xilinx-vivado.docker.tgz
```

Note: Loading very large Docker images can sometimes be unreliable. See the FAQ
section for more details.

### Running Vivado from the Image

Once the image is loaded into Docker, start Vivado using:

```bash
make run
```

If you are on a system with a graphical interface (X11 forwarding configured),
the Vivado GUI should launch.

## Troubleshooting/FAQ

**Q: Why does the Docker build take so long (several hours)?**

A: The Vivado installer is very large, and the installation process itself is
complex. Several steps contribute to the long duration: loading the
multi-gigabyte archive into the build context, copying it within the container,
unpacking it, running the Vivado installer, and finally exporting the numerous
layers of the resulting Docker image. Using Docker BuildKit (often enabled by
default with `make build` or explicitly with `` `DOCKER_BUILDKIT=1 docker build ...` ``)
is highly recommended as it can optimize some of these steps, but the overall
process will still be lengthy.

**Q: The Docker image is over 200GB. Is this normal?**

A: Yes, this is unfortunately normal. Vivado is a comprehensive tool suite, and
a full installation contains a very large number of files and libraries, leading
to a massive Docker image.

**Q: My Docker build fails with errors related to X11 or display servers. What can I do?**

A: This script builds Vivado in a headless environment (without a graphical
display). Some Vivado installation options or components might require an X11
display server during the installation itself. This script does not support such
options. Ensure your `install_config.txt` only selects components compatible
with a headless installation. The default "Vivado ML Standard" components are
generally compatible.

**Q: How do I choose which Vivado components are installed?**

A: You can customize the installation by editing the `install_config.txt` file
*before* starting the build. This file is generated by the Xilinx setup program
(`` `xsetup -b SetupGen` ``). In the `Modules=` section of this file, you can enable
or disable specific components by changing their value from `:0` (disabled) to
`:1` (enabled). For example, to enable the Vivado Simulator, ensure the line
reads `Vivado Simulator:1`.

**Q: `` `docker load -i xilinx-vivado.docker.tgz` `` fails or takes many attempts. Any advice?**

A: Loading extremely large Docker image archives can be unreliable with some
versions or configurations of Docker. Ensure you have sufficient disk space in
your Docker daemon's storage location (check Docker settings). Trying the command
again sometimes helps. If persistent issues occur, consider checking Docker
daemon logs for more specific errors or consulting Docker community forums for
advice on handling large images.

## Contribution

Contributions are welcome! Please feel free to submit pull requests or open
issues.

## Prior art

This repo was not built in a vacuum. I consulted a number of resources out
there on the internet.

* [Dockerizing Xilinx tools.][1] discussion on Reddit, which bootstrapped this
  work.
* [Xilinx tools docker][8]: the freshest piece of instruction that I could find.
* [Xilinx Vivado with Docker and Jenkins][2]. Does what it says on the tin.
* [Xilinx Vivado/Vivado HLS][3] from CERN.
* [Xilinx guides about Docker][4], which I'm not sure helped at all.
* [AMD guides about Vivado on Kubernetes et al.][5].
* [Install Xilinx Vivado using Docker][6] [link broken?], another blog recount of the process.
* [Run GUI applications in Docker or podman containers.][7]
* [Dockerized Vivado ML Enterprise by esnet][esnet].

[1]: https://www.reddit.com/r/FPGA/comments/bk8b3n/dockerizing_xilinx_tools/
[2]: https://www.starwaredesign.com/index.php/blog/64-fpga-meets-devops-xilinx-vivado-and-jenkins-with-docker
[3]: https://github.com/aperloff/vivado-docker
[4]: https://xilinx.github.io/Xilinx_Container_Runtime/docker.html
[5]: https://docs.xilinx.com/r/en-US/Xilinx_Kubernetes_Device_Plugin/1.-Install-Docker
[6]: https://blog.p4ck3t0.de/post/xilinx_docker/
[esnet]: https://github.com/esnet/xilinx-tools-docker
[7]: https://github.com/mviereck/x11docker
[8]: https://github.com/esnet/xilinx-tools-docker/tree/main
