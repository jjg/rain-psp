# RAIN PSP

*Redundant Array of Inexpensive Nodes Mark II - Personal Supercomputer Portable (aka: RAIN PSP)*

A "laptop" version of the RAIN Mark II Personal Supercomputer (also known as [RAIN Mark II Supercomputer Trainer](https://hackaday.io/project/85392-rain-mark-ii-supercomputer-trainer)).

![Assembly screenshot](./images/assembly_screenshot.png)

This work began years ago as a combination of the [OFFGRiD](https://code.jasongullickson.com/jjg/offgrid) project with ongoing work on the RAIN personal supercomputer.  Unfortunately much of the documentation for the RAIN project has been lost, partially due to problems storing all the files in Github.  As such I'm starting a new repository specific to the RAIN PSP project which will hopefully remain small enough to be managed without errors.

![Assembly rear screenshot](./images/assembly_back_screenshot.png)

## TODO:

* Control panel cover (between keyboard and bottom of display)
* Improve display hinge
    + Add something to provide tension, prevent fasteners from loosening
    + Add latch or other form of retention (spring, etc.)
    + Add switch to detect when display is closed
    + Figure out wire routing
* Openings for ports
* Connect fans to Clusterboard 20 pin header
* ~~Mount pi0~~
* ~~Mount Clusterboard~~
* Modify display lid, top cover so maximum opening lines-up
* Order remaining keyboard switches
* Wire keyboard switches
* Order final keykcaps
* Design mount for keyboard switchplate once final height is determined
* Setup autologin on pi0 and automatically connect serial console
* Clone SD card for all cluster nodes (setting MAC, IP, etc.)
* Test node power switch, LED indicator
* Order power switch/indicators for all cluster nodes
* Add power input jack
* Add main power switch
* Expose Clusterboard ethernet port
* Wire keyboard to pi0 gpio connector
* Select gpio pins for keyboard
* Update renderings
* Replace PineA64 with pi0 in renderings
* Design display bezel
* Move fan mounts up (level with bottom of case)
* Create retaining strap for fans and remove grooves from case top
* Add posts for mounting electronics (replace bolts)

# References
* [https://create.arduino.cc/projecthub/ejshea/displaying-key-pressed-on-serial-monitor-98ace1](https://create.arduino.cc/projecthub/ejshea/displaying-key-pressed-on-serial-monitor-98ace1)
* [https://www.thingiverse.com/thing:2822664/files](https://www.thingiverse.com/thing:2822664/files)
