# The problem

My purpose is to generate an image based on buildroot 2021.11.1 that can be flashed on the internal eMMC of the Intel Stick STK1AW32SC, which is based on Intel Atom x5-Z8300

A vanilla image (using the default buildroot pc_x86_64_efi_defconfig) correctly boots from USB.
However the `/dev/mmcblk*`  related to the eMMC don't appear. That is expected has the vanilla kernel does not have the MMC modules built in.

# Initial attempt

To do it, I used the `BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES` to append a linux.fragment enabling the `CONFIG_MMC` and other related.

- This is the .config used:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/f0abe726d5648499f94bf9d96e4d5eb9745447a4/external_is/configs/intelstick_defconfig

- And this is the linux.fragment file used:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/f0abe726d5648499f94bf9d96e4d5eb9745447a4/external_is/board/pc/intelstick/linux.fragment

Again, booting with the resulting image written on the USB works ok.

Result:
- Still `ls \dev\m*` does not show the expected mmcblk* folders.

# 2nd attempt

I decided to include on the kernel other 'drivers' related to the MMC, as a kernel.

- New linux.fragment file used:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/bb4c7faba4f2b0e45907b544e1762c5b9525ee72/external_is/board/pc/intelstick/linux.fragment

Result:
- No /dev/mmcblk* folders.
- lsmod shows about 4 modules, none of them seem to be related to the MMC drivers.

# 3rd attempt

Based on this [post from a Gentoo forum][getoo_post] I decided to compare the modules loaded from a working distribution against the one I built with buildroot.

Booting from a USB boot created with an image for x86, its `uname -a` reports:

`Linux raspberrypi 4.19.0-13-amd64 #1 SMP Debian 4.19.160-2 (2020-11-28) x86 64 GNU/Linux`

I also happily see that the `ls /dev/mm*` reports the existence of `mmcblk0, mmcblk0boot0, mmcblk0boot1, mmcblk0p1, mmcblk0p2, mmcblk0rpmb`

This being also a 4.19 version of the Kernel makes it a good candidate to me to be compared against mine. However I understand this may be built with code that is 'monolithic' and the modules that report are not the full picture of what a I need. 

Issuing `lsmod` I got the results [on this rasbian_lsmod.txt file][rasbian_lsmod]

Many of them seem to be related to this Intel so I end searching on `linux-menuconfig` all of them. I decided to strip those that seem obviously to me not useful at this time (like Bluetooth)

- The new linux.fragment file used:
https://github.com/MrMauro/buildroot_intel_stick_STK1AW32SC/blob/8474668ebad4042db0ef89a8b476abb506fc24a1/external_is/board/pc/intelstick/linux.fragment

Again, booting with the resulting image written on the USB works ok.

Result:
- Still `ls \dev\m*` does not show the expected mmcblk* folders.
- The `lsmod` on my builtroot image now shows some of the new modules, but none of them seem to be related to the eMMC


[rasbian_lsmod]:rasbian_lsmod.txt
[getoo_post]:https://forums.gentoo.org/viewtopic-t-1097672-start-0.html
