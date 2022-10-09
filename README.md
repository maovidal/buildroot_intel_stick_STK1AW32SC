# Notice

The sole purpose of this repository is to generate an image based on `buildroot 2021.11.1` that can be flashed on the internal eMMC of the `Intel Stick STK1AW32SC`, which is based on [Intel Atom x5-Z8300][is_spec]


# Quick setup

Besides using this repo in your existing Buildroot installation using the [external mechanism][br2_external], there is also the option to use this [docker-buildroot repo][docker_buildroot] that provides a fast and convenient way to start working right away.

Those are the instructions for the later case:

1. Get a clone of [docker-buildroot][docker_buildroot]:

``` shell
git clone https://github.com/vidalastudillo/docker-buildroot
```

2. Get a clone of this repo to be placed at the folder `externals/STK1AW32SC`:

``` shell
git clone https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC externals/STK1AW32SC
```

3. Build the Docker image:

``` shell
docker build -t "advancedclimatesystems/buildroot" .
```

4. Create a [data-only container][data-only]:

``` shell
docker run -i --name buildroot_output advancedclimatesystems/buildroot /bin/echo "Data only."
```

This container has 2 volumes at `/root/buildroot/dl` and `/buildroot_output`.
Buildroot downloads all data to the first volume, the last volume is used as build cache, cross compiler and build results.

5. Setup the new external folder and load the default configuration:

``` shell
./scripts/run.sh make BR2_EXTERNAL=/root/buildroot/externals/STK1AW32SC menuconfig
./scripts/run.sh make intelstick_defconfig
```

These are the two relevant folders on your host:

- `external/STK1AW32SC`: the new external folder with the configs and other related files for this Intel Stick board.
- `images`: with your valuable results.

Also, the `target` folder is provided just to ease checking the building process.


# Usage

A small script has been provided to make using the container a little easier.
It's located at the folder `scripts/run.sh`.

Then you can use usual commands like this:

``` shell
./scripts/run.sh make menuconfig
./scripts/run.sh make linux-rebuild
./scripts/run.sh make linux-menuconfig
./scripts/run.sh make all
```


# Journey

Read about the steps I took to achieve the purpose of this fork on the file [the_journey.md][journey].


# License

This software is licensed under MIT License.

&copy; 2022 Mauricio Vidal.

[docker_buildroot]:https://github.com/vidalastudillo/docker-buildroot
[acs]:http://advancedclimate.nl
[buildroot]:http://buildroot.uclibc.org/
[data-only]:https://docs.docker.com/userguide/dockervolumes/
[hub]:https://hub.docker.com/r/advancedclimatesystems/docker-buildroot/builds/
[docker_python3_defconfig]:external/configs/docker_python3_defconfig
[external_tree]:external
[external_tree_doc]:external/README.md
[journey]:the_journey.md
[br2_external]:http://buildroot.uclibc.org/downloads/manual/manual.html#outside-br-custom
[docker_blog]:https://blog.docker.com/2013/06/create-light-weight-docker-containers-buildroot/
[migrating_buildroot]:http://buildroot.uclibc.org/downloads/manual/manual.html#migrating-from-ol-versions
[evgueni]:https://forums.raspberrypi.com/memberlist.php?mode=viewprofile&u=208985&sid=be8a772e5aef87a4991576d69e510cce
[evgueni_post]:https://forums.raspberrypi.com/viewtopic.php?t=307052&sid=b8bbc7d25cf2b58cb6d4a35edd716d6a
[github_ssh]:https://docs.github.com/en/authentication/connecting-to-github-with-ssh
[buildroot_generic_package]:https://buildroot.org/downloads/manual/manual.html#generic-package-reference
[is_spec]:https://ark.intel.com/content/www/us/en/ark/products/91065/intel-compute-stick-stk1aw32sc.html
