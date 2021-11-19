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

RAIN-PSP uses a custom keyboard with a [PLANCK]() layout.  The keyboard is constructed from CHERRY-MX Blue switches wired into a matrix and connected directly to the Raspberry Pi ZeroW head node.  The keyboard is driven by the `matrix-keyboard` kernel driver using a custom device tree overlay.


### Connections

```
Keyboard Row    Cable Color     Rpi GPIO Pin
1               red             12
Keyboard Column                 
1               blue            20
```

 
### Building and installing the keyboard overlay

* `cd keyboard`
* `dtc -W no-unit_address_vs_reg -I dts -O dtb -o rainpspkbd.dtbo rainpspkbd.dts`
* `sudo cp rainpspkbd.dtbo /boot/overlays/`
* `sudo dtoverlay rainpspkbd`

At this point you should see the keyboard listed by using the `sudo lsinput` command.
