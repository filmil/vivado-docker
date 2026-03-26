#!/bin/bash
# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Runs Vivado inside the Docker container. Supports both interactive (GUI/TCL)
# and batch modes.
#
# Environment variables:
#   VIVADO_VERSION  Vivado version (default: 2025.2)
#   SRC_DIR         Host directory to mount at /src (default: current dir)
#   WORK_DIR        Host directory to mount at /work (default: current dir)
#   VIVADO_CMD      Command to run (default: interactive Vivado GUI)
#                   Example for batch: VIVADO_CMD="vivado -mode batch -source /src/build.tcl"
#   ROSETTA         Set to "1" to enable libudev stub for Apple Silicon
#                   (default: auto-detect via uname -m)

set -euo pipefail
set -x

INTERACTIVE=()
if sh -c ": >/dev/tty" >/dev/null 2>/dev/null; then
	INTERACTIVE=(--interactive --tty)
fi

VIVADO_VERSION="${VIVADO_VERSION:-2025.2}"
VIVADO_PATH="/opt/Xilinx/${VIVADO_VERSION}/Vivado"

# Paths — override via environment if needed
SRC_DIR="${SRC_DIR:-$(pwd)}"
WORK_DIR="${WORK_DIR:-$(pwd)}"

mkdir -p "${WORK_DIR}"

# Auto-detect Rosetta (Apple Silicon running x86_64 container)
if [[ -z "${ROSETTA:-}" ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    ROSETTA=1
  else
    ROSETTA=0
  fi
fi

# Build the preload string for Rosetta workaround
PRELOAD_CMD=""
if [[ "${ROSETTA}" == "1" ]]; then
  PRELOAD_CMD="export LD_PRELOAD=/opt/udev_stub.so && "
fi

# Default: interactive Vivado. Override VIVADO_CMD for batch mode.
# For batch synthesis: VIVADO_CMD="vivado -mode batch -source /src/build.tcl"
VIVADO_CMD="${VIVADO_CMD:-vivado}"

# Conditional docker flags for platform differences
DOCKER_ARGS=()
if [[ -d /tmp/.X11-unix ]]; then
  DOCKER_ARGS+=(-v /tmp/.X11-unix:/tmp/.X11-unix:ro)
fi
if [[ "$(uname -s)" == "Linux" ]]; then
  DOCKER_ARGS+=(--net=host)
fi

docker run \
  --platform linux/amd64 \
  "${INTERACTIVE[@]}" \
  --rm \
  -u "$(id -u):$(id -g)" \
  "${DOCKER_ARGS[@]}" \
  -v "${SRC_DIR}:/src:rw" \
  -v "${WORK_DIR}:/work:rw" \
  -e HOME="/work" \
  -e DISPLAY="${DISPLAY:-}" \
  -e _JAVA_AWT_WM_NONREPARENTING=1 \
  -e XILINX_LOCAL_USER_DATA=no \
  "xilinx-vivado:${VIVADO_VERSION}" \
  /bin/bash -c \
    "${PRELOAD_CMD}source ${VIVADO_PATH}/settings64.sh && cd /work && ${VIVADO_CMD}"
