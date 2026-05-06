# Notice

The sole purpose of this repository is to generate an image that can be
flashed on the internal eMMC of the `Intel Stick STK1AW32SC`, which is based
on [Intel Atom x5-Z8300][is_spec].

Originally this repo started as a fork from this
[Buildroot running in Docker repo][original_docker_buildroot_repo]. However,
later it was stripped to contain only the relevant files of the external
directory allowing it to be used with different development setups.


# Quick setup

Besides using this repo in your existing Buildroot installation using the
[external mechanism][br2_external], there is also the option to use this
[docker-buildroot repo][docker_buildroot] that provides a fast and convenient
way to start working right away and keep multiple and independent instances for
different targets at the same time.

Those are the instructions for the latter case:

1. Clone [docker-buildroot][docker_buildroot], if not already present:

```shell
git clone https://github.com/vidalastudillo/docker-buildroot
cd docker-buildroot
```

2. Clone a Buildroot source:

```shell
git clone https://git.buildroot.net/buildroot --branch=<version> ./buildroot
```

3. Clone this repo into `externals/STK1AW32SC`:

```shell
git clone https://github.com/maovidal/buildroot_intel_stick_STK1AW32SC externals/STK1AW32SC
```

4. Build the shared Docker image (once):

```shell
docker buildx build -t va_buildroot .
```

These are the relevant folders on your host:

- `externals/STK1AW32SC/`: the external tree with configs and related files.
- `images/STK1AW32SC/`: build outputs.
- `target/STK1AW32SC/`: unpacked root filesystem for inspection.


# Usage

A run script is provided at `externals/STK1AW32SC/run.sh`. It must always be
called from the root of the `docker-buildroot` project:

```shell
./externals/STK1AW32SC/run.sh make intelstick_defconfig
./externals/STK1AW32SC/run.sh make menuconfig
./externals/STK1AW32SC/run.sh make linux-menuconfig
./externals/STK1AW32SC/run.sh make all
```


# Journey

Read about the steps I took to achieve the purpose of this fork on the file
[the_journey.md][journey].


# License

This software is licensed under MIT License.

&copy; 2022 Mauricio Vidal.

[docker_buildroot]: https://github.com/vidalastudillo/docker-buildroot
[original_docker_buildroot_repo]: https://github.com/AdvancedClimateSystems/docker-buildroot
[buildroot]: https://buildroot.org/
[br2_external]: https://buildroot.org/downloads/manual/manual.html#outside-br-custom
[journey]: the_journey.md
[is_spec]: https://ark.intel.com/content/www/us/en/ark/products/91065/intel-compute-stick-stk1aw32sc.html
