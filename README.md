# Notice:

The sole purpose of this repository is to generate an image based on `buildroot 2021.11.1` that can be flashed on the internal eMMC of the Intel Stick STK1AW32SC, which is based on [Intel Atom x5-Z8300][is_spec]

The source of this fork implements Docker containers to speed up the setup for this task.

# Quick setup:

1. Get a clone of this repo:
``` shell
git clone https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC
```

2. Build the Docker image:

``` shell
docker build -t "advancedclimatesystems/buildroot" .
```

3. Create a [data-only container][data-only]:

``` shell
docker run -i --name buildroot_output advancedclimatesystems/buildroot /bin/echo "Data only."
```

This container has 2 volumes at `/root/buildroot/dl` and `/buildroot_output`.
Buildroot downloads all data to the first volume, the last volume is used as build cache, cross compiler and build results.

4. Setup the new external folder and load the default configuration:

``` shell
./scripts/run.sh make BR2_EXTERNAL=/root/buildroot/external_is menuconfig
./scripts/run.sh make intelstick_defconfig
```

As a result, in your host, those are the two relevant folders to be working on:

- `external_is`: the new external folder with the configs and other related files for this Intel Stick board.
- `images`: with your valuable results.

Also, the `target` folder is provided just to ease checking the building process.

# Usage

A small script has been provided to make using the container a little easier.
It's located at [scripts/run.sh][run.sh].

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

This software is licensed under Mozilla Public License.
It is based on the original work by: 
&copy; 2017 Auke Willem Oosterhoff and [Advanced Climate Systems][acs].
It has been modified and extended by Mauricio Vidal from [VIDAL & ASTUDILLO Ltda][va].

[va]:https://www.vidalastudillo.com
[acs]:http://advancedclimate.nl
[buildroot]:http://buildroot.uclibc.org/
[data-only]:https://docs.docker.com/userguide/dockervolumes/
[hub]:https://hub.docker.com/r/advancedclimatesystems/docker-buildroot/builds/
[run.sh]:scripts/run.sh
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
