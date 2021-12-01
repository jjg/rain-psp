# RAIN PSP Software

This is where the base operating system image will live.  I'm still trying to figure out exactly how to put that together as there will be distinct images for cluster nodes vs. the front-end, and ideally the cluster node images will require zero configuration.

In addition to the base O/S, the front-end image will include development and management tools for the system.

Firmware for custom hardware may live here as well, but I'm not 100% sure about that yet.

## Operating System

The operating system currently consists of Debian-based distros (Raspbian for the Rpi0W front-end, Armbian for the rest of the cluster).  Right now it looks like the user environment will be based on [IPython](http://ipython.org/documentation.html) as this provides both a rich terminal-based user interface as well as tooling for parallel computing.


### References

* http://emavap.ddns.net/emavap/sopine-clusterboard-nfs
* http://ipython.org/documentation.html
* https://ipython.readthedocs.io/en/stable/interactive/reference.html
* https://ipyparallel.readthedocs.io/en/latest/tutorial/intro.html


## Keyboard

RAIN-PSP uses a custom keyboard with a [PLANCK]() layout.  The keyboard is constructed from CHERRY-MX Blue switches wired into a matrix and connected directly to the Raspberry Pi ZeroW head node (connection details are covered in the [hardware README](../hardware/README.md)).  


### QMK Kernel Module

The current implmentation uses a modified version of the [QMK Kernel Module](https://github.com/qmk/qmk_kernel_module) project.  This code lives in the [qmk_kernel_module](./keyboard/qmk_kernel_module) directory.  This consists primarilly of a modified Makefile and a keyboard overlay specific to the RAIN-PSP keyboard.

Building this is currently somewhat complicated and discussed at length in [the journal](https://code.jasongullickson.com/jjg/rain-psp/src/branch/main/journal.md#11262021).  It involves rebuilding the Linux kernel among other things so I'm hoping to avoid making people do this but I haven't decided on the best way to go about that.


### matrix-keyboard kernel driver

Originally, the keyboard was driven by the `matrix-keyboard` kernel driver using a custom device tree overlay.  This code can be found in the [matrix-keyboard](./keyboard/matrix-keyboard) directory.

#### Building and installing the matrix-keyboard driver keyboard overlay

* `cd keyboard\matrix-keyboard`
* `dtc -W no-unit_address_vs_reg -I dts -O dtb -o rainpspkbd.dtbo rainpspkbd.dts`
* `sudo cp rainpspkbd.dtbo /boot/overlays/`
* `sudo dtoverlay rainpspkbd`

At this point you should see the keyboard listed by using the `sudo lsinput` command.
