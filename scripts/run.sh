#!/bin/bash
# Start container and start process inside container.
#
# Example:
#   ./run.sh            Start a sh shell inside container.
#   ./run.sh ls -la     Run `ls -la` inside container.
#
# Calls to `make` are intercepted and the "O=/buildroot_output" is added to
# command. So calling `./run.sh make savedefconfig` will run `make
# savedefconfig O=/buildroot_output` inside the container.
#
# Example:
#   ./run.sh make       Run `make O=/buildroot_output` in container.
#   ./run.sh make docker_python2_defconfig menuconfig
#                       Build config based on docker_python2_defconfig.
#
# When working with Buildroot you probably want to create a config, build
# some products based on that config and save the config for future use.
# Your workflow will look something like this:
#
# ./run.sh make docker_python2_defconfig defconfig
# ./run.sh make menuconfig
# ./run.sh make BR2_DEFCONFIG=/root/buildroot/external/configs/docker_python2_defconfig savedefconfig
# ./run.sh make
set -e

OUTPUT_DIR=/buildroot_output
BUILDROOT_DIR=/root/buildroot

# At least on macOS, exposing the full OUTPUT_DIR to the host, seems to impact
# negatively the speed of the builds and frequent errors building libraries.
# That's why we just expose images and target

DOCKER_RUN="docker run
    --rm
    -ti
    --volumes-from buildroot_output
    -v $(pwd)/.ssh:/root/.ssh
    -v $(pwd)/external:$BUILDROOT_DIR/external
    -v $(pwd)/external_is:$BUILDROOT_DIR/external_is
    -v $(pwd)/external_private:$BUILDROOT_DIR/external_private
    -v $(pwd)/rootfs_overlay:$BUILDROOT_DIR/rootfs_overlay
    -v $(pwd)/images:$OUTPUT_DIR/images
    -v $(pwd)/target:$OUTPUT_DIR/target
    advancedclimatesystems/buildroot"

make() {
    echo "make O=$OUTPUT_DIR"
}

echo $DOCKER_RUN
if [ "$1" == "make" ]; then
    eval $DOCKER_RUN $(make) ${@:2}
else
    eval $DOCKER_RUN $@
fi
