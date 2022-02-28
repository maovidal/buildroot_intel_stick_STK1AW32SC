# The problem

My purpose is to generate an image based on buildroot 2021.11.1 that can be flashed on the internal eMMC of the Intel Stick STK1AW32SC, which is based on Intel Atom x5-Z8300

A vanilla image (using the default buildroot pc_x86_64_efi_defconfig) correctly boots from USB.
However issuing `ls \dev\m*` does not report any `/dev/mmcblk*` folders related to the eMMC. That is expected as the vanilla Kernel does not have the MMC modules built in.

# Initial attempt

I used the `BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES` to append a `linux.fragment` file enabling the `CONFIG_MMC` and other related.

- This is the .config used:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/f0abe726d5648499f94bf9d96e4d5eb9745447a4/external_is/configs/intelstick_defconfig

- And this is the `linux.fragment` file used:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/f0abe726d5648499f94bf9d96e4d5eb9745447a4/external_is/board/pc/intelstick/linux.fragment

Again, the device boots from the USB with that image, but still `ls \dev\m*` does not show the expected `mmcblk*` folders on it.

# 2nd attempt

I decided to include on the Kernel other 'drivers' related to the MMC, as a Kernel.

- New `linux.fragment` file used:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/bb4c7faba4f2b0e45907b544e1762c5b9525ee72/external_is/board/pc/intelstick/linux.fragment

Results:
- No `/dev/mmcblk*` folders yet.
- `lsmod` shows about 4 modules, none of them seem to be related to the eMMC drivers.

# 3rd attempt

Based on this [post from a Gentoo forum][getoo_post] I decided to compare the modules loaded from a working distribution against the one I built with buildroot.

Booting from a USB boot created with an image for x86, its `uname -a` reports:

`Linux raspberrypi 4.19.0-13-amd64 #1 SMP Debian 4.19.160-2 (2020-11-28) x86 64 GNU/Linux`

I also happily see that the `ls /dev/mm*` reports the existence of `mmcblk0, mmcblk0boot0, mmcblk0boot1, mmcblk0p1, mmcblk0p2, mmcblk0rpmb`

This being also a 4.19 version of the Kernel makes it a good candidate to me to be compared against mine. However I understand this may be built with code that is 'monolithic' and the modules that it reports may not be the full picture of what a I need. I decide to proceed, as it has a chance to help me discover the issue.

On that distro, `lsmod` gives this result that represent the modules its Kernel loads: [rasbian_lsmod.txt][rasbian_lsmod]

Many of them seem to be related to this Intel so I end searching all of them on my buildroot `linux-menuconfig`. I decided to strip those that seem not useful at this time (like Bluetooth)

- The new `linux.fragment` file used is here:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/8474668ebad4042db0ef89a8b476abb506fc24a1/external_is/board/pc/intelstick/linux.fragment

Again, booting with the resulting image written on the USB works ok.

However still I have this results:
-`ls \dev\m*` does not show the expected `mmcblk*` folders.
- The `lsmod` on my buildroot image [now shows some of the new modules][buildroot_a3_lsmod], but none of them seem to be related to the eMMC.

# SSH

To ease further and access the device from my development computer, I decided to include support for SSH connecting the device to my network. Password is `hi`

# 4th attempt: success!

I thought about comparing against another project that could be familiar to me. `Home Assistant OS` is built with buildroot, which supports generic x86 and also likely support eMCC on their boards.

After taking a look at their Kernel config, [I found this line][ha_kernel_line] grouped around the MMC section. I feel that's quite a find!

A search on the net about `CONFIG_X86_INTEL_LPSS` and `MMC` showed articles that seem to confirm their relation:

- https://www.udoo.org/forum/threads/kernel-config-for-mmc.7243/
- https://unix.stackexchange.com/questions/251376/no-dev-mmcblk0-during-boot

So, here is the new `linux.fragment` file with that module:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/commit/398c06e7eb0319ac039292b058183d90f2d17d75

And that is it! booting an image generated with that kernel and issuing `ls \dev\m*` reports the `mmcblk0, mmcblk0boot0, mmcblk0boot1, mmcblk0p1, mmcblk0p2, mmcblk0rpmb` folders from my device's eMMC.

# Transfer the image to the internal eMMC

While I suspect it must be better not to use 'live' USB as source of the image (who knows if there is a sudden activity that leads to data corruption), I don't refrain from trying it, as it has taken me quite a while to reach to this point. Anyway, the image can be transferred to the internal eMMC like this:

``` shell
dd bs=4M if=./disk.img of=/dev/mmcblk0 conv=fsync oflag=direct
```

However, this a better way to do it.

The Kernel generated in the 4th attempt still lacks USB mass storage support. Here it is the change on the `linux.fragment` file:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/commit/1cc0df7bcd0237914d25da751c215ac915447eec

Once built, the resulting image can be transferred to the USB boot drive and also copied to a different USB drive so we get a bootable one, and another to be the source that we will copy to the eMMC.

After booting, assuming the source of the image is on `/dev/sdb2` we issue the following to mount the USB with the image to transfer:

``` shell
mount /dev/sdb2 /mnt
cd /mnt
```

Confirm the content has the `drive.img` file, and then transfer the image like this:

``` shell
dd bs=4M if=./disk.img of=/dev/mmcblk0 conv=fsync oflag=direct
```

Shutdown, remove all the USB drives, and power-on. The Intel Stick should load the image from its own eMMC.


[buildroot_a3_lsmod]:results/buildroot_a3_lsmod.txt
[rasbian_lsmod]:results/rasbian_lsmod.txt
[getoo_post]:https://forums.gentoo.org/viewtopic-t-1097672-start-0.html
[ha_kernel_line]:https://github.com/home-assistant/operating-system/blob/fc0f1e20d5bea04606d0ea0b5dc51caa1aecff7f/buildroot-external/board/pc/generic-x86-64/Kernel.config#L40
