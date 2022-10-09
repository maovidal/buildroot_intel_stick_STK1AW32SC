# Notice

The sole purpose of this repository is to generate an image tested on `buildroot 2022.08.1` that can be flashed on the internal eMMC of the `Intel Stick STK1AW32SC`, which is based on [Intel Atom x5-Z8300][is_spec]

Originally this repo started as a fork from this [Buildroot running in Docker repo][original_docker_buildroot_repo]. However, later it was stripped to contain only the relevant files of the external directory allowing it to be used with different developments setups.


# Quick setup

Besides using this repo in your existing Buildroot installation using the [external mechanism][br2_external], there is also the option to use this [docker-buildroot repo][docker_buildroot] that provides a fast and convenient way to start working right away and keep multiple and independent instances for different targets at the same time.

Those are the instructions for the later case, as the ones to use your existing Buildroot installation are contained in Buildroot's documentation:

1. Get a clone of [docker-buildroot][docker_buildroot]:

``` shell
git clone https://github.com/vidalastudillo/docker-buildroot
```

2. Get a clone of this repo to be placed at the folder `externals/STK1AW32SC`:

``` shell
git clone https://github.com/maovidal/buildroot_intel_stick_STK1AW32SC externals/STK1AW32SC
```

3. Build the Docker image:

``` shell
docker build -t "advancedclimatesystems/buildroot" .
```

4. Create a [data-only container][data-only]. The name will be used on the scripts to refer to this spacific build:

``` shell
docker run -i --name br_output_STK1AW32SC advancedclimatesystems/buildroot /bin/echo "Data only for STK1AW32SC."
```

This container has 2 volumes at `/root/buildroot/dl` and `/buildroot_output`.
Buildroot downloads all data to the first volume, the last volume is used as build cache, cross compiler and build results.

5. Setup the new external folder and load the default configuration:

``` shell
./externals/STK1AW32SC/run.sh make BR2_EXTERNAL=/root/buildroot/externals/STK1AW32SC menuconfig
./externals/STK1AW32SC/run.sh make intelstick_defconfig
```

These are the two relevant folders on your host:

- `externals/STK1AW32SC`: the new external folder with the configs and other related files for this Intel Stick board.
- `images/STK1AW32SC`: with your valuable results.

Also, the `target/STK1AW32SC` folder is provided just to ease checking the building process.


# Usage

A small script has been provided to make using the container a little easier.
It's located at the folder `./externals/STK1AW32SC/run.sh` which is a modified version of the one at `./scripts/run.sh`.

This modified script uses the `data only` container defined exclusively for this `STK1AW32SC` and produces the output separated in the `STK1AW32SC` folders.

Then you can use usual commands like this:

``` shell
./externals/STK1AW32SC/run.sh make menuconfig
./externals/STK1AW32SC/run.sh make linux-rebuild
./externals/STK1AW32SC/run.sh make linux-menuconfig
./externals/STK1AW32SC/run.sh make all
```


# Journey

Read about the steps I took to achieve the purpose of this fork on the file [the_journey.md][journey].


# License

This software is licensed under MIT License.

&copy; 2022 Mauricio Vidal.

[docker_buildroot]:https://github.com/vidalastudillo/docker-buildroot
[original_docker_buildroot_repo]:https://github.com/AdvancedClimateSystems/docker-buildroot
[buildroot]:http://buildroot.uclibc.org/
[data-only]:https://docs.docker.com/userguide/dockervolumes/
[journey]:the_journey.md
[br2_external]:http://buildroot.uclibc.org/downloads/manual/manual.html#outside-br-custom
[is_spec]:https://ark.intel.com/content/www/us/en/ark/products/91065/intel-compute-stick-stk1aw32sc.html
