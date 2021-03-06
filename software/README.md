# RAIN PSP Software

This is where the base operating system image will live.  I'm still trying to figure out exactly how to put that together as there will be distinct images for cluster nodes vs. the front-end, and ideally the cluster node images will require zero configuration.

In addition to the base O/S, the front-end image will include development and management tools for the system.

Firmware for custom hardware may live here as well, but I'm not 100% sure about that yet.

## Operating System

The operating system currently consists of Debian-based distros (Raspbian for the Rpi0W front-end, Armbian for the rest of the cluster).  Right now it looks like the user environment will be based on [IPython](http://ipython.org/documentation.html) as this provides both a rich terminal-based user interface as well as tooling for parallel computing.

### New node setup

1. Burn Amrbian image to SD
2. Boot and locate pine64so's IP address using DHCP server
3. `ssh root@new.node.ip.addr` (password: 1234)
4. Complete Armbian setup (root password, new user, etc.)
5. Use `armbian-config` to configure
    + Personal -> Hostname -> set hostname (i.e. rain-psp-0.local)
    + System -> Avahi -> enable
    + System -> CPU -> set min to min, max to max and mode to `ondemand`
    + Set static IP (do this **last** because it will break the ssh connection)
6. `ssh-copy-id -i ~/.ssh/id_rsa.pub user@new-host-name.local`
7. `ssh new-host-name.local`
8. Edit `/etc/default/armbian-ramlog` and increase `SIZE=50` to `SIZE=100`
8. Install packages
    + `sudo apt update`
    + `sudo apt install -y libnss-mdns libnss-mymachines openmpi-bin openmpi-common libopenmpi-dev libatlas-base-dev gfortran`
9. Install HPL
    + From new node:
        + `mkdir -p ~/hpl/bin/aarch64-linux`
    + From head node:
        + `cd ~/hpl/bin/aarch64-linux``
        + `scp * new-host-name.local:/home/jason/hpl/bin/aarch64-linux/`
10. Add new node to `machinefile`



### References

* http://emavap.ddns.net/emavap/sopine-clusterboard-nfs
* http://ipython.org/documentation.html
* https://ipython.readthedocs.io/en/stable/interactive/reference.html
* https://ipyparallel.readthedocs.io/en/latest/tutorial/intro.html


## Keyboard

RAIN-PSP uses a custom keyboard with a [PLANCK]() layout.  The keyboard is constructed from CHERRY-MX Blue switches wired into a matrix and connected directly to the Raspberry Pi ZeroW head node (connection details are covered in the [hardware README](../hardware/README.md)).  


### QMK Kernel Module

The current implmentation uses a modified version of the [QMK Kernel Module](https://github.com/qmk/qmk_kernel_module) project.  This code lives in the [qmk_kernel_module](./keyboard/qmk_kernel_module) directory.  This consists primarilly of a modified Makefile and a keyboard overlay specific to the RAIN-PSP keyboard.

#### Layer 1

![keyboard layer 1](../images/keyboard-layout-layer-1.png)

#### Layer 2

![keyboard layer 2](../images/keyboard-layout-layer-2.png)

Building this is currently somewhat complicated and discussed at length in [the journal](https://code.jasongullickson.com/jjg/rain-psp/src/branch/main/journal.md#11262021).  It involves rebuilding the Linux kernel among other things so I'm hoping to avoid making people do this but I haven't decided on the best way to go about that.


### matrix-keyboard kernel driver

Originally, the keyboard was driven by the `matrix-keyboard` kernel driver using a custom device tree overlay.  This code can be found in the [matrix-keyboard](./keyboard/matrix-keyboard) directory.

#### Building and installing the matrix-keyboard driver keyboard overlay

* `cd keyboard\matrix-keyboard`
* `dtc -W no-unit_address_vs_reg -I dts -O dtb -o rainpspkbd.dtbo rainpspkbd.dts`
* `sudo cp rainpspkbd.dtbo /boot/overlays/`
* `sudo dtoverlay rainpspkbd`

At this point you should see the keyboard listed by using the `sudo lsinput` command.
