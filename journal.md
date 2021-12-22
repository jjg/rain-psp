# RAIN PSP Development Journal

## 10022021

Initial creation of new repository specific to the PSP project.  I'm still going to try and recover the original documentation, but I don't want to waste time hunting for that which I could spend working on something new.

Now that I have a printer large enough to print the entire case I've been imagining, let's take a whack at that.

What parts?

* Case bottom
* Case top
* Display bottom
* Display top
* Keyboard 

It might make sense to model the parts that go inside the thing:

* Clusterboard
* PINE A64
* Fans
* Power supply/battery


## 10032021

Made a lot of progress already.  Got basic initial models for most of the parts and this morning found a Planck keyboard template that should serve as a starting point for the keyboard.

It is a bit wider than the current design (which is based on an A4 sheet) so the next step will be to widen everytihing to make it fit.

That went well.  

Now that I can see where the keyboard switches will fall, it may be necissary to move things around a bit.  I'm not sure that they keyboard is going to clear the A64 sufficiently so I may need to either move the board or increase the overall height of the machine.  Additional points of interference are now becoming apparent where the keycaps may intersect with the display/lid when closed.  I could try adding models for the switches and keycaps to try and sort this out on-screen, but it might just be easier to print some samples and do some test fitting.

While the printer runs I'm thinking about what's next.  I need to make room for the cooling fans, and I need to find an LCD module for the display (something that can use the DSI interface on the A64).  I also need to figure out the hinge for the display and a part that will fit between the top of the keyboard and the bottom of the display where I can put some additional controls (right now I'm thinking momentary DPDT toggles to power-on/off & reset each SOPINE module).


## 10052021

Keyswitches came in the mail today and they fit nicely into the current frame.  I found a sample key to print to see if I could print a working key and it worked fine.  Found a [library for generating keys](https://github.com/rsheldiii/keyv2) and I'm printing a few now to use for interference tests.

Ran into some snags printing the bottom case (broke the printer) so I'll have to re-print that and the display top before I can test the fit for interference with the keys.


## 10072021

Started printing the base last night, but ran out of filament by morning.  Was able to re-start the print with another scrap spool and it seems to be working so far.  Hopefully there's enough on there to make it all the way through this time.

I also ran a set of 10 keys off and got a chance to try and fit them.  They don't work as well right-off-the-printer as the first key I tried, but with a little trimming seem to do the trick.  The bottom of the stem is just a hair too wide to fit into the keyswitch (there is a little pocket where the stem goes into when the key is pressed), I'm not sure if that's a printing defect or a design problem, but it's something I'll have to sort-out before I try printing a full set.

For now they should be good enough to get the interference testing done.

I should add more photos of the progress...

I was able to create they very cool Cray-tribute vents!  The implementation is a bit messy and I need to do work on the case bottom to integrate them in a way that makes sense, but still pretty cool.

I might cut them out of the case top as-is just to see how they come out (even though in the long run they will come completely out of the case bottom.)


## 10112021

Reworked the case a bit over the weekend and I think the parts I have now will accomodate most of the problems I found earlier.  I still have some things to sort-out, but making progress.

I settled on a different LCD, it costs more and uses HDMI which is not what I wanted (I wanted to use the built-in display hardware and leave HDMI for secondary purposes), but it's nice and should work.

I also started trying to find a way to connect the keyboard that doesn't require USB.  I can't remember if I explained why I don't want to use USB before but it's mostly because the USB ports will be outside of the machine, and also the cables are a pain in the ass.  What I'm leaning toward now is using a 3.3v microcontroller to do the matrix scanning and then output the codes (ASCII?) via UART into one of the serial ports on the A64 head node.  From there it's a software trick to map that tty into the system console and maybe something will work?

Here's the most concise example I could find:

https://create.arduino.cc/projecthub/ejshea/displaying-key-pressed-on-serial-monitor-98ace1

I have a lot of soldering to do (and ordering more parts) before I even need to worry about the keyboard programming, and in the meantime I can use an external keyboard to get things going.


## 10152021

Made a lot of progress with the printed parts and decided to start wiring-things up to figure out where it all fits.  After a few tries I got the head node booting Armbian (power problems of course).  I also got the LCD mounted, but it had to go in upside-down to put the connectors in a reasonable place.

I haven't figured out how to flip the screen at the kernel level so the text console is still upside down, but I did find a command that will flip the GUI:

`sudo xrandr -o inverted`

This is good enough for now.


## 10202120

Last night I started thinking about using something else for the head node.  If I could cram both the keyboard controller and a video terminal into one board, that would save me from having to add a second mcu to decode the keyboard, and if it were smaller than the Pine64 head node, might save me some space and power too.

So I'm experimenting with using a Raspberry Pi Zero W.  This is kind of overkill, but it can drive the HDMI LCD, and I think it has enough GPIO to handle the keyboard matrix scanning.  It will be connected to the clusterboard via serial, so essentially a dumb terminal, and it has wifi if that is still needed

The other upside of this serial connection is that it leaves the clusterboard's ethernet port open, so the machine could be tethered to a larger network with a high-speed connection.

Semi-related I found a way to configure the display by editing the config.txt file on the Pi's SD card.  Just add this to the end:

```
max_usb_current=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt 1024 600 60 6 0 0 0
hdmi_drive=1
display_rotate=1 #1：90；2: 180； 3: 270
```

There's still the problem of the digitizer being wrong, but there's a fix for that too from the Waveshare wiki:

https://www.waveshare.com/wiki/7inch_HDMI_LCD_(C)

So how many GPIO's do we need and do we have enough?

Hot damn: https://github.com/qmk/qmk_kernel_module

If this works, it's pretty much exactly what I'm looking for...


## 10222021

I found a sturdier planck keyboard tray and after printing it found that it fits perfection *inside* the case.  After thinking about this for awhile I decided to print the bottom of this keyboard a well and see where things fall if I just set the whole thing inside the case.  If nothing else it will serve as a placeholder for now, and maybe in the long-run I can do something crazy like make the keyboard removable?

This is only possible because I can now cram all the electronics into the back-end of the case.  The Raspberry Pi ZeroW "head node" is working well, and fits in the space left next to the Clusterboard.  I'm not sure how this will play-out in the long run (this is where I planned to put batteries) but for now it's fine.


## 10242021

Rebuilt the Pi's SD card so I could login (forgot the password) and have temporarilly mounted the Pi enough to get the screen working with an external USB.

I think the next thing to do is to hook up a serial connection between the pi0 and one of the nodes on the clusterboard.  I think this should do:

```
pi          clusterboard (20-pin header)
7   (TX)    ->  7   (RX)
9   (RX)    ->  8   (TX)
5   (GND)   ->  6   (GND)
```

Right now I'm pulling 5v for the pi0 from the ATX connector, but now that I'm looking at the 20-pin header on the Clusterboard I'm wondering if it would make more sense to get it from there?  If I'm going to be connecting to it for the serial console anyway, why not?

```
pi
4   (5VDC)      ->  1   (VCC5V)
6   (GND)       ->  6   (GND)
8   (UART0_TXD) ->  7   (UART0-RX)
10  (UART0_RXD) ->  8   (UART0-TX)
```

This works great for power but no luck so far getting a serial connection.

It's not clear if the problem is the wiring or software, and it's not clear which end the problem is on (pi or clusterboard).  I've had trouble figuring out how to get the serial console on the clusterboard working before so that's my first suspeciion.



## 10252021

Turns out it wasn't a hardware issue, and it wasn't a configuration issue; it was a simple mistake in the command.  The following command works:

`picocom /dev/serial0 -b115200`

Turns out there were a number of changes to the Raspberry Pi that resulted in confusion about what serial devices is which.  The others (/dev/ttys0 and /dev/ttyAMA0) are tangled-up with the Bluetooth hardware.  

Things are getting to a point where I should really make a list of what's left...

Added a long, unorganized list of todos to the readme.

Bolted the Clusterboard and rpi0 into place and cobbled one of the fans into the 5v and GND connections of one of the 20 pin headers.  Works well and the whole package is a lot more stable now.  If these locations work-out I'll replace the bolts with printed stand-offs in the next model of the case.

Going to try and add a button and LED to indicate the power state of one of the nodes as well as provide a way to turn it off and on.

Well, the power off/on part works well, but the "heartbeat" (pin 2) doesn't appear to put out enough voltage to light the LEDs I have.  Hooking a meter up to the pin, I only get ~1.8vdc.  Based on the docs I would expect at least 3.3vdc, but maybe there's some software control over the pins voltage or duty cycle (maybe it's using PWM to set a low brightness?).  Dunno.  After scouring the docs I'm still not sure, so I'm going to ask around.

Talked to someone on the Pine64 IRC and found out that this pin (#2) belongs to the "L GPIO bank", which is powered by ALD02, which is set in the device tree to variable voltage between 1.8 and 3.3v.

So... I *should* be able to change that, but there may be side-effects if other things in that bank are expecting 1.8v.

After chatting some more it looks like there may be other options.  I didn't completely understand them, but I'm going to experiment a bit and see what I can figure out using this as a starting point:

https://www.ics.com/blog/gpio-programming-using-sysfs-interface

OK, this took a little figuring but pin #2 on the header maps to pin 24 on the SOPINE connector, which in turn is connected to... looks like GPIO 359 on the Allwinner chip?

So let's try this:

```
echo 359 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio359/direction
echo 1 > /sys/class/gpio/gpio359/value
```

Well this turns it on, but it's still 1.8v....


## 10262021

Going to pause getting the heartbeat to work with the SOPINE, but before I wrap that up I want to get some notes about the LED setup for whenever I figure out how to get 3.3v out of that pin.

I connected the button/LED combo I have to the 3.3v supply of the rpi0 to figure out the pinout.  It has a small red dot to the left of the anode, and lights nicely when driven directly from the 3.3v supply.  It's always a good idea to throw a resistor in there to prevent the LED from gobbling too much current, and after some experimentation it looks like 10 ohms is a good fit.

```
3.3v -> LED -> 10ohm -> gnd
```

Ideally I'd combine this with the button to minimize the wiring.  

OK, I crammed the resistor into the base of the switch (this will be easier with more appropriately-rated resistors).  Looks like this will fit, and the power-on/off functionality works, so I think we're done here.

Now to crimp...

That went OK.  The single button/led I have now has Dupont ends as well as the three fans.  The fans are loud, which I hope means they are effective (hard to confirm until I get SD cards made for the remaining nodes).  

I also threw-together a quick "control panel" model (the part between the top of the keyboard and the bottom of the display) so I had something to mount the button to.


## 11022021

Remaining keyboard switches and diodes came today, got the them installed in the switchplate and soldered the diode layer (rows) of the matrix.  Need to do the columns next, but haven't settled on exactly how I want to wire them, so that may wait until tomorrow.


## 11032021

Soldering-up the columns today.  Found a pattern that works, although I'm not sure what to do with the "space" key that straddles two columns?

Maybe it doesn't matter, but if it does I'd prefer to get it right the first time...

After looking at a photo of the wiring of the keyboard mine is based on it looks like the shift key is just added to the column on the left of it, so we'll go that way for now.

Next-up is wiring the matrix to the Pi.  I know I want to use some header sockets on the Pi end for sure, but I'm not sure if I want to use something detachable on the keyboard end as well?  Doing so will create more work, and it might cramp the space we have a bit but it also would allow me to connect the keyboard matrix to something other than the Pi easily, which might be useful for troubleshooting.

It would also open-up the possibility of a detachable keyboard...

Let's think about what pins we're going to connect to on the pi.


## 11082021

Thinking about the hinge, I came up with an idea for how the whole case might be held together with two bolts.

I've been planning to replace the two bolts that hold the display lid to the base with black printed "thumbscrews" which are remenicent of the platen knobs on the Valentine.  It occurred to me that these could not only fasten the display cover to the base, but also the rear top cover as well.  

The rear top could have an additional interleving "finger" on each side which sandwiches the bottom case portion of the hinge between the part of the display lid where the current bolt passes through on both sides (this will be easier to explain with a picture).  Additionally, the back cover could extend further into the keyboard area and "pin" the control panel piece down when the rear cover is slid into place.  The control oanel part could be extended to provide the base of the keyboard, locking into the bottom case using pins or teeth at the edge where the bottom (space key side) of the keyboard rests, and a similar set of teeth could be used at the opposite end to lock the top rear cover to the base when the cover is slid into place.

I think this would allow all of the major parts of the case to be held together by only the two bolts embedded in the "platen knobs".  This solves a number of outstanding problems with holding the case together and does so in a way that is both elegant and makes servicing the machine easier.


## 11132021

Modeling the platen-knob-style thumbscrews.


## 11142021

I may have found the perfect operating environment for RAIN-PSP.  I found out that there is a console interface for what I've used as [Jupyter notebooks](https://jupyter.org/), and in fact it is the ancestor of Jupyter: [IPython](https://jupyter.org/).  Not only this, but one of it's primary uses is [parallel computing](https://ipyparallel.readthedocs.io/en/latest/), which makes it a very natural fit for RAIN-class computers.

I'm only just beginning to learn about this so there may be some issues with using it that I'm not aware of, but so far it seems like a perfect fit.

I'm going to spend  some time tonight installing IPython on my regular laptop to see how hard it is to get it going.  If that goes well I'll try installing it on RAIN-PSP the next time I boot it up.


## 11162021

Hex bolts for the the thumbscrews (platen knobs) came and after a few quick measurements I was able to print a couple pieces that work pretty good.  I wish I could have found black bolts (instead of plain stainless) but I think it doesn't mess-up the look too bad, and it's going to be brilliant when I re-design the other parts to all be pinned in place by these.


## 11182021

Spent a lot of time soldering and crimping the wires that will connect the keyboard matrix to the pi0.  Next step is to actually connect the two and see if we can make the keys work.  I'm thinking about trying something simple first (maybe just one key?) and then go from there.

```
row 1       ->  red     ->  GPIO12
column 1    ->  blue    ->  GPIO20
```

Now that some of the wires are connected it's time to get the software in order.

* Install [prerequisites](https://code.jasongullickson.com/jjg/qmk_kernel_module#building)
* Clone ssh://git@code.jasongullickson.com:22022/jjg/qmk_kernel_module.git
* Build & install kernel module
* Build device tree overlay
* Tweak various configs

Turns out there is a hidden dependency on another repository named `libqmk`.  I pulled a copy of this over to my repository server and then created a symlink to a local clone.  This got us a little further.

After messing-around it looks like there are unmet dependencies in this code.  I think I'm going to switch to this approach instead (even thought it doesn't support all the features I need):

https://blog.gegg.us/2017/08/a-matrix-keypad-on-a-raspberry-pi-done-right/

Once I get somewhere with this, I can go back and see if I can figure out how to get the more sophisticated firmware to work..

Learning a lot about device tree overlays... here's a quick summary of commands for when I forget later:

```
dtc -W no-unit_address_vs_reg -I dts -O dtb -o 4x5matrix.dtbo 4x5matrix.dts
sudo dtoverlay 4x5matrix
sudo lsinput
```

Overall I'm getting the hang of it.  I need to write a proper overlay for my custom keyboard, I tried, but something is wrong with it and it doesn't load right.

When it works correctly, you should be able to run `sudo lsinput` and see the device listed regardless of whether or not the electronics are hooked-up right.

Holy shit, it's working!

With a minor mod to the 4x5 example overlay, I was able to get input from the custom keyboard.  I don't know why the overlay I wrote didn't work, but clearly there's some detail about writing these I'm missing.  Now that I have something that works, I can work backward from there and see if I can get more than one key going.

Huzzah!


## 11192021

Now it's time to refine the keyboard firmare.

Some reference information:

* [matrix-keymap.yaml](https://github.com/torvalds/linux/blob/master/Documentation/devicetree/bindings/input/matrix-keymap.yaml) - The fundamental definitions for the `matrix-keyboard` kernel driver
* [Enabling new hardware on the Raspberry Pi with Device Tree Overlays](https://bootlin.com/blog/enabling-new-hardware-on-raspberry-pi-with-device-tree-overlays/)
* [Raspberry Pi 4 - Device Tree](https://blog.stabel.family/raspberry-pi-4-device-tree/) - information on compiling device tree overlays for the Raspberry Pi.
* [How to Manage Kernel Modules Using modprobe Command](https://www.tecmint.com/load-and-unload-kernel-modules-in-linux/)
* [QMK Hand-Wiring Guide](https://beta.docs.qmk.fm/using-qmk/guides/keyboard-building/hand_wire)
* [How to hand wire a Planck](https://blog.roastpotatoes.co/guide/2015/11/04/how-to-handwire-a-planck/)
* [A Matrix Keypad on a Raspberry Pi done right](https://blog.gegg.us/2017/08/a-matrix-keypad-on-a-raspberry-pi-done-right/) - How to use the kernel to drive a keyboard via GPIO
* [QMK How a matrix works](https://docs.qmk.fm/#/how_a_matrix_works)

Steps:

1. ~~Try customizing the [4x5matrix.dts](https://code.jasongullickson.com/jjg/rain-psp/src/branch/main/software/keyboard/4x5matrix.dts) overlay to rename the device without breaking it~~
2. ~~Continue to customize the overlay until it matches the current 1 row, 1 column keyboard wiring and emits the correct character (or some other character if the one on the selected key is invisible)~~
3. Select GPIO pins for the remaining rows and columns
4. Connect the keyboard cable to the selected GPIO pins
5. Customize the overlay to add the remaining rows and columns and add values for all of the (unmodified) keys matching the key caps

Once we get this far we'll need to find the best way to implement the "modifier" keymappings (shift, raise, lower, etc.).  This is a lot of what the QMK kernel module gave us and I'm afraid that without it, this is going to be tough but since I couldn't get that module to compile I think we're just going to have to figure it out.

```
pi@rain-psp:~/rain-psp/software/keyboard $ dtc -W no-unit_address_vs_reg -I dts -O dtb -o rainpspkbd.dtbo rainpspkbd.dts 
pi@rain-psp:~/rain-psp/software/keyboard $ ls -l
total 12
-rw-r--r-- 1 pi pi 1721 Nov 19 09:25 4x5matrix.dts
-rw-r--r-- 1 pi pi 1049 Nov 19 10:17 rainpspkbd.dtbo
-rw-r--r-- 1 pi pi 1722 Nov 19 10:16 rainpspkbd.dts
pi@rain-psp:~/rain-psp/software/keyboard $ sudo cp rainpspkbd.dtbo /boot/overlays/
pi@rain-psp:~/rain-psp/software/keyboard $ sudo dtoverlay rainpspkbd
pi@rain-psp:~/rain-psp/software/keyboard $ lsinput
```
...

```
/dev/input/event4
bustype : BUS_HOST
vendor  : 0x0
product : 0x0
version : 0
name    : "RAINPSPKBD"
bits ev : EV_SYN EV_KEY EV_MSC EV_REP
pi@rain-psp:~/rain-psp/software/keyboard $ input-events 4
/dev/input/event4
bustype : BUS_HOST
vendor  : 0x0
product : 0x0
version : 0
name    : "RAINPSPKBD"
bits ev : EV_SYN EV_KEY EV_MSC EV_REP

waiting for events
10:22:26.733609: EV_MSC MSC_SCAN 3
10:22:26.733609: EV_KEY KEY_KP1 (0x4f) pressed
10:22:26.733609: EV_SYN code=0 value=0
10:22:26.883573: EV_MSC MSC_SCAN 3
10:22:26.883573: EV_KEY KEY_KP1 (0x4f) released
10:22:26.883573: EV_SYN code=0 value=0
10:22:28.383627: EV_MSC MSC_SCAN 3
10:22:28.383627: EV_KEY KEY_KP1 (0x4f) pressed
10:22:28.383627: EV_SYN code=0 value=0
10:22:28.523544: EV_MSC MSC_SCAN 3
10:22:28.523544: EV_KEY KEY_KP1 (0x4f) released
10:22:28.523544: EV_SYN code=0 value=0
timeout, quitting

````

Inching closer...

Trying to understand how the keymap works...

The key we are getting is the number 1 from the keypad.  In the mapping, it looks like this:

`0x00030004f`

Does it break down like this?
```
it's HEX    col     row     key-code
0x          00      03      004f
```

Using this reference:

https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h

It looks like that break-down is correct (at least for the keycode part).  Let's try changing it to the regular number 1 (instead of keypad 1) and see what happens.

```
keycode decimal hex
KEY_1   2       2
```

Now reformat as above:
`0x00030002`

It works!

OK, what's next?  I think it makes sense to try and pair-down the overlay so that it's only implementing the actual current electrical connections (row 0, column 0).  If we can do that and get it to complile and run w/o errors, we can move-on to connecting the remaining rows and columns and mapping everything out.


That worked.  Now I have an overlay file that defines one row GPIO, one column GPIO (i.e., one key) that output's the value `1` when pressed and compiles and installs with no errors.

I think the next step is to wire-up the remaining rows and columns, which means picking the GPIO pins.  Since some are already allocated and documented, I think I'm going to start by expanding that documentation.

Pins picked, and overlay updated with mappings for every key I recognize (the keycaps have some weird ones...).  I also didn't try to do anything with the modifiers yet (one step at a time).

New overlay compiled, but threw an error when I tried to install it:

```
Nov 19 15:08:23 rain-psp.local kernel: matrix-keypad RAINPSPKBD: matrix_keypad_map_key: invalid keymap entry 0x4000013 (row: 4, col: 0, rows: 4, cols: 12)
Nov 19 15:08:23 rain-psp.local kernel: matrix-keypad RAINPSPKBD: failed to build keymap
Nov 19 15:08:23 rain-psp.local kernel: matrix-keypad: probe of RAINPSPKBD failed with error -22
```

I left some keys out because I wasn't sure what they should be mapped to, but maybe I can't do that?  I'll try filling them all in with some key value and try again.

Now all the keys have a mapping, but getting this error:

```
Nov 19 15:15:07 rain-psp.local kernel: matrix-keypad RAINPSPKBD: matrix_keypad_map_key: invalid keymap entry 0x4000013 (row: 4, col: 0, rows: 4, cols: 12)
Nov 19 15:15:07 rain-psp.local kernel: matrix-keypad RAINPSPKBD: failed to build keymap
Nov 19 15:15:07 rain-psp.local kernel: matrix-keypad: probe of RAINPSPKBD failed with error -22
```

It's funcking reversed...

The row goes first and the column goes second.  My original notes were correct, and the documentation I was referencing is wrong...

With that reversed, the overlay installs w/o error.  Now it's time to do some wiring...

...well shit.  While no error is thrown loading the overlay, the keyboard isn't listed when running `lsinput`, and the one connected key no longer works...

Turns out I managed to have the overlay loaded twice (probably forgot to unload between tests).  After removing both and adding it back, I get another error:

```
Nov 19 15:34:51 rain-psp.local kernel: matrix-keypad RAINPSPKBD: matrix_keypad_map_key: invalid keymap entry 0x100019 (row: 0, col: 16, rows: 4, cols: 12)
Nov 19 15:34:51 rain-psp.local kernel: matrix-keypad RAINPSPKBD: failed to build keymap
Nov 19 15:34:51 rain-psp.local kernel: matrix-keypad: probe of RAINPSPKBD failed with error -22

```

I'm guessing I just messed something up while trying to flip the row/col arrangement so I'll go back a double-check everythying.

Of course, the rows and columns need to be in hex just like the keycodes!  Columns 10 and 11 converted to 0a and 0b and now `lsinput` shows the keyboard again.  ...however now it is spitting out letters like crazy (in particular the letter `p`).  This might just be because I haven't wired-up the rest of the GPIO's, but it could also be related to a conflict with something else using some of the GPIO pins I picked...

Either way the next step is to power things down and start wiring-up the rest of the keyboard.


## 11202021

Tried connecting all the keyboard lines today.  Results are mixed.

For the second, third and forth rows, everything works up to the fifth column (F, V, lower).  The first row doesn't work at all, and beyond the fifth column, pressing any key results in all of the rest of the keys in that row getting registered.

hjk
.

The command `input-events 0` shows the real values of the key scanning result (as opposed to what is displayed on the screen).

This is all very weird.  I don't know if it's a problem with the overlay, the wiring, the matrix or the GPIO pins I selected.  The possibilities are varied enough that I'm not exactly sure where to begin...


## 11222021

After thinking about where to start I decided to start with the missing top row.  It seems like a distinct problem from the half-working rows, and I have at least a hunch as to where to begin troubleshooting.

After double-checking all the wiring I've decided to move the row connection to a different GPIO, starting with GPIO 20 on pin 38.  This should rule-out any issue with the pin selection.

Switching to GPIO 20 seems to have helped.  Now I'm seeing input from the top row, and it looks good up to the fifth column like the other rows, so that's progress.

Now it's time to take a closer look at the fifth-column problem.

Closer examination shows that the problem isn't happening all the way across each row, but limited to four keys starting with the sixth key in the column:

```
tyui
ghjk
bmn/
[space][raise][left]
```

Beyond these keys each row more-or-less functions normally (more on that later).

> It might help if I used a consistent numbering scheme for the rows and columns, and since I'm probably not going to change the way Linux counts them, I'm going to start indexing them at zero.

Let's start by looking at the GPIOs used by the problematic columns 5-8:

```
column  pin gpio  notes

5       24  8
6       26  7
7       29  5
8       31  6
```

Nothing jumping out when I look into these pin selections...

Somthing I did just notice however for the affected rows is that when the problem keys are pressed, the entire row of keys is registered in order (not just the keys to the right of the problem key).  I don't know what light this sheds yet but it's another clue.

> unrelated side-note: shift (and I assume other "standard" modifiers) works out of the box!

Noticed that column 5 had a key defined for row 3 (which there isn't one).  Not sure if this will matter, but figured it was worth a shot.

No difference.

For lack of other ideas I moved column 5 to another GPIO (from 8 to 26) and the problem appears resolved for that column...

So clearly there are pins that don't work correctly with the matrix keyboard driver, but it's not clear from the documentation I've found as to *why*...  I can keep swapping the additional columns but there's three more and I'm not sure I can find three more unused gpios...

Well, this worked for all but columns 7 and 8.  I moved them to GPIO's 0 and 1 but the problem persists.

Looks like I need to figure out why this happens on some pins.


## 11242021

Today I'm going to try and move the remaining two malfunctioning columns to another set of pins.  This will sadly mean I won't have a PWM pin available to control the LCD brightness, but I need to prioritize typing over that for now.  Hopefully I will figure out why I can't use the original pins and I can relocate these to free-up a PWM.

First I'm moving column 7 to GPIO 13 (pin 33).

That worked, now to move column 8 to ... GPIO 2 (pin 3).

That didn't worked.

Let's take a look at all the pins that don't work and figure out what they have in common.

```
pin gpio    notes
3   2       no pull-up I2C1 SDA, SMI SA3, DPI VSYNC, AVEOUT VSYNC, AVEIN VSYNC
5   3       no pull-up
7   4       GPCLK0, SMI SA1, DPI D0, AVEOUT VID0, AVEIN VID0, JTAG TDI 
24  8       SPI0 CE0, SMI SD0, DPI D4, AVEOUT VID4, AVEIN VID4
26  7       SPI0 CE1, SMI SWE_N/SRW_N, DPI D3, AVEOUT VID3, AVEIN VID3
27  0       
28  1
29  5
31  6
```

...ok I got bored with that.  Looks like there are pins that are just off-limits (3 and 5, no pull-up) and others that are probably bad because they are "overloaded" with other functions thatn GPIO (I2C, SPI, etc.).  I *thought* I had disabled all of those interfaces but maybe I need to do more?

Not sure why I didn't notice this before but pin 11 (GPIO 17) is open, let's try that for column 8.

That worked!

Now to test *all* the keys again.

```
~~j produces m~~
~~m produces nothing ~~
~~/ produces nothing KEY_LEFTSHIFT (0x2a)~~
, produces nothing (no events)
```

I was able to fix all but the last problem by fixing small mistakes in the overlay.  The last one however was electrical, a solder joint that had come undone (probably while I was heating the column connections) that just needed to be resoldered.

All keys working!

The next step is to get the PLANCK-specific modifiers working.  As-is, the keyboard can't even make numbers (and there's no escape key), so it's pretty limited.  I also noticed that the wiring is very crammed so I'm making a new part to go under the keyboard tray to make a little more room in there.

First journal entry using the custom keyboard.

Trying to figure out how to add mappings for when the PLANCK keys LOWER and RAISE are pressed.  I've never used a "real" PLANCK so maybe I have it wrong, but my plan is to make holding the RAISE key swap-out an alternate keymap that adds some of the missing keys (for example, replacing the first row with numbers instead of QWERTY...etc.).  Maybe this isn't how LOWER and RAISE are supposed to work, but for now that's what we're going to do with them...

RAIN


## 11262021

Taking another shot at the [qmk kernel module](https://github.com/qmk/qmk_kernel_module) now that I've reached a point where I know the electrical connections are sound and I really need to get the keyboard "layers" working.

Using these instructions from a friend on the fediverse (zen), I was able to get it to compile this time:

```
# sudo apt install raspberrypi-kernel raspberrypi-kernel-headers git bc bison flex libssl-dev evtest input-utils

And reboot your system if the kernel was upgraded.

Next, you have to clone recursively a git repository with submodules:

$ git clone --recursive https://github.com/qmk/qmk_kernel_module; cd qmk_kernel_module

And you have to fix line 30 of Makefile [github.com] , because looks like path to kernel headers was changed. Simply replace line:

KDIR := /lib/modules/$(shell uname -r)/build

with:

KDIR := /usr/src/linux-headers-$(shell uname -r)/

And then you will be able to compile kernel module using command make KEYBOARD=clueboard (see setup.sh [github.com] file for other commands to install kernel module into the system).
```

Now that it compiles, I need to create a keyboard config that matches my keyboard.


## 11302021

It doesn't compile (I thought I added that to the journal but it seems to be missing...?)

Chatting more with Zen, it looks like there's additional changes to the makefile as we as a need to recompile the Linux kernal to enable `input-polldev` module.  It's been a very long time since I've needed to recomplile a Linux kernel (and I'm not sure I've ever done it on an ARM SBC) so this should be interesting.

> based on [this guide](https://www.raspberrypi.com/documentation/computers/linux_kernel.html#building)

First, edit /etc/apt/sources.list and make sure that the `deb-src` line isn't commented-out.

```
sudo apt update
sudo apt install git bc bison flex libssl-dev make
git clone --depth=1 --branch rpi-5.10.y https://github.com/raspberrypi/linux
cd linux
KERNEL=kernel
make bcmrpi_defconfig
sudo apt install libncurses5-dev
make menuconfig
```

Navigate to Device Drivers -> Input device support and select Polled input device skeleton

Save the changes, then:

```
make zImage modules dtbs
```

## 12012021

Still compiling...

```
sudo make modules_install
sudo cp arch/arm/boot/dts/*.dtb /boot/
sudo cp arch/arm/boot/dts/overlays/*.dtb /boot/overlays/
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
```

That's the end of the instructions, so I guess it's time to reboot....

...and we're back!

Now to re-try building the QMK kernel module.

```
make KEYBOARD=rainpsp && sudo make KEYBOARD=rainpsp install
make
```

Holy shit, it actually compiled this time!

```
sudo make install
sudo modprobe qmk
lsmod | grep qmk
```

Output:

```
qmk                    28672  0
input_polldev          16384  1 qmk
```

So far so good... now to try loading the keyboard overlay?

```
sudo make KEYBOARD=rainpsp load
lsinput
```

Output:

```
pi@rain-psp:~/qmk_kernel_module $ sudo make KEYBOARD=rainpsp load
  GEN      keyboard-default
  GEN      keyboard-default
* Loading rainpsp overlay
pi@rain-psp:~/qmk_kernel_module $ lsinput
/dev/input/event0
   bustype : BUS_HOST
   vendor  : 0x3a8
   product : 0x68
   version : 1
   name    : "RAIN-PSP Keyboard"
   phys    : "qmk/input0"
   bits ev : EV_SYN EV_KEY EV_MSC EV_REP

```

At this point the single key mapping (row 0, col 0) emits the letter `q` as expected.  I thought I could test the function of the LOWER/RAISE keys but of course they won't work until I add a mapping for them...

I haven't found any documentation explaining the QMK-specific keycodes, so I'm just sort of guessing by referencing the [planck.dts](https://github.com/qmk/qmk_kernel_module/blob/master/keyboards/planck.dts) file.  From what I can guess, the "code" for the LOWER/RAISE keys is `MO()` with an argument of `1` for LOWER and `2` for RAISE...?

I'm going to try mapping these and see what happens...

After figuring out that I had the row and column arguments swapped, it loads and appears to work:

Output from `input-events 0` when pressing the 0,0 key (alone, +LOWER, +RAISE):

```
waiting for events
09:57:38.466226: EV_KEY KEY_Q (0x10) pressed
09:57:38.466226: EV_MSC MSC_SCAN 16
09:57:38.466226: EV_SYN code=0 value=0
09:57:38.626206: EV_KEY KEY_Q (0x10) released
09:57:38.626206: EV_MSC MSC_SCAN 16
09:57:38.626206: EV_SYN code=0 value=0
09:57:40.036226: EV_KEY KEY_Q (0x10) pressed
09:57:40.036226: EV_MSC MSC_SCAN 16
09:57:40.036226: EV_SYN code=0 value=0
09:57:40.216284: EV_KEY KEY_Q (0x10) released
09:57:40.216284: EV_MSC MSC_SCAN 16
09:57:40.216284: EV_SYN code=0 value=0
09:57:42.586205: EV_KEY KEY_U (0x16) pressed
09:57:42.586205: EV_MSC MSC_SCAN 22
09:57:42.586205: EV_SYN code=0 value=0
09:57:42.766208: EV_KEY KEY_U (0x16) released
09:57:42.766208: EV_MSC MSC_SCAN 22
09:57:42.766208: EV_SYN code=0 value=0
09:57:47.446215: EV_KEY KEY_W (0x11) pressed
09:57:47.446215: EV_MSC MSC_SCAN 17
09:57:47.446215: EV_SYN code=0 value=0
09:57:47.626212: EV_KEY KEY_W (0x11) released
09:57:47.626212: EV_MSC MSC_SCAN 17
09:57:47.626212: EV_SYN code=0 value=0
```

Now the next step is to complete the keymap in the overlay...

I found a website that makes it easy to see what keys belong where on the [planck keyboard](http://www.keyboard-layout-editor.com/##@@_a:7%3B&=Tab&=Q&=W&=E&=R&=T&=Y&=U&=I&=O&=P&=Back%20Space%3B&@=Esc&=A&=S&=D&=F&=G&=H&=J&=K&=L&=%2F%3B&='%3B&@=Shift&=Z&=X&=C&=V&=B&=N&=M&=,&=.&=%2F%2F&=Return%3B&@=&=Ctrl&=Alt&=Super&=%2F&dArr%2F%3B&_w:2%3B&=&=%2F&uArr%2F%3B&=%2F&larr%2F%3B&=%2F&darr%2F%3B&=%2F&uarr%2F%3B&=%2F&rarr%2F).  Since that's the basis for RAIN-PSP's keyboard we'll start there.

I still don't understand how you access more than three layers, but that should be enough for now so I'm not going to worry about it too much.

Link to [layer 2](http://www.keyboard-layout-editor.com/##@@_a:7%3B&=%60&=1&=2&=3&=4&=5&=6&=7&=8&=9&=0&=Back%20Space%3B&@=DEL&=A&=S&=D&=F&=G&=H&=-&=%2F=&=%5B&=%5D&=%5C%3B&@=Shift&=Z&=X&=C&=V&=B&=N&=M&=,&=HOME&=END&=Return%3B&@=&=Ctrl&=Alt&=Super&=%2F&dArr%2F%3B&_w:2%3B&=&=%2F&uArr%2F%3B&=%2F&larr%2F%3B&=%2F&darr%2F%3B&=%2F&uarr%2F%3B&=%2F&rarr%2F)

(looks like those links don't work right...)

This is my second journal entry using the custom keyboard.  All the keys work now including multiple layers (required for numbers, etc.).  Now that I can use all the keys I'm getting a feel for the ortholinear layout.  It's going to take some getting used to, but it's not bad, especially if you hold your hands in proper form.

I'm noticing a few mapping errors although they don't feel unnatural; maybe I'll just swap some keycaps...


## 12032021

Now that the keyboard is finished (or at least finished enough) I'm trying to decide how to prioritize the remaining work.

At a high-level the work falls into three categories:

1. Case
2. Electronics
3. Software

All three have reached a "proof of concept" level of maturity so the next step will be to design their 1.0 form and then implement.  Of the three the software is the least mature, but at the same time it is the one for where there is plenty of existing work to draw from.

The key missing piece of the electronics is the portable power supply.  The final version of this is a ways off, so far in fact that I probably won't include it in the 1.0 release of the machine.  I'll be satisfied if I can get the electronics to a point where everything works using a 5VDC external supply (that way if I really *need* portability I can use any commodity 5v battery with suitable current capacity).  To do the power supply right I'm going to have to design it myself, and that is going to take some time getting back into KiCAD, hunting-down the ideal components, etc.

Given that, finalizing the electronics outside of the portable PS will help with establishing the final position of several of the electronic components (notably the LCD), which is a prerequisite to finalizing the 1.0 case design, so that's probably the place to start.

Spent a little time drawing some wiring diagrams on the board and it occurs to me there may be some dependencies with nailing-down case design parts.  Hmm...


## 12072021

While I noodle on some of the overall wiring questions I think it's safe to solder some leads to the LCD so I can add software brightness control and remove the need for the USB power connection.  This will let me move the LCD to the center of the display cover and I can try creating a bezel to clean things up.  This will also let the display lid close without having to unplug the other end of the USB power cable.

The LCD has solder pads labled 5V, GND and PWM.  There are two GND pads (one by the USB port and another by the PWM pad) but a continuity test shows them to be connected so I'm going to use the one by the USB port.


```
LCD         Rpi0w
5V      ->  4 (5V) 
GND     ->  6 (GND)
PWM     ->  12
```

Looks like pin 12 is the only PWM open (`PWM0`, `GPIO18`), so we'll try that first.

Controlling brightness from the command line (from the [Waveshare docs](https://www.waveshare.com/w/upload/5/56/PWM_control_backlight_manual.pdf)):

```
gpio -g pwm 18 1024     # ???
gpio -g mode 18 pwm    	#set the pin as PWM
gpio pwmc 1000          # ???
gpio -g pwm 18 X		# X ranges between 400-500?
```

I can't seem to find this `gpio` command, I might have to resort to Python to test this...

Using the [gpiozero](https://gpiozero.readthedocs.io/en/stable/) module, I was able to control the backlight using Python as so:

```
sudo apt install python3-gpiozero
python3
from gipozero import PWMOutputDevice
backlight = PWMOutputDevice(18,initial_value=0)
backlight.value = 1
backlight.value = .5
backlight.value = 0
quit()
```

Valid values are 0-1 and are inversely proportional to brightness (i.e.: 0 is brightest).

I thought I might have to change the PWM duty cycle based on the command line examples from the docs, but doing so made the screen flicker so I left it along (the default for gpiozero is 100hz).

I'm not sure this is the best way to control the backlight (I imagine there is something simpler), ultimately I'll probably want to tie it to a keyboard command.  For now this confirms that it works, and the wiring is right, so I'll worry about the software details later.

One significant problem with using `gpiozero` is that it only drives the PWM pin while the Python program is runnning, so it's not terribly useful as say a CLI utility, etc.


## 12172021

Once I got the power and backlight wired-up to the LCD I spent some time working on a basic bezel to clean things up, but it didn't quite fit in all the places.  Looks like I'm going to have to spend more time to get something that works, and if I'm going to spend the time I should really solve the hinge in a way that cleans all the wiring up an fills the final gap between the display and the keyboard.  That's going to take awhile, and require reprinting a number of parts so for now I put the display lid back together as-is so I could safely power the machine back up and work on other things in the meantime.

The "other thing" at the top of my mind today is bringing additional cluster nodes online.  Right now I have a single node running [Armbian](https://www.armbian.com/) from an SD card which is connected to the rpi0w via serial.  I don't really want to move the serial connection around to configure each node, so ideally I'd like to prep SD cards for each node that will either "just work" when they are booted or if not that have something that I can ssh into from the existing cluster node for configuration.

Currently the existing node's IP is configured via DHCP from an external DHCP server connected to the Clusterboard's ethernet port (just a connection to the onboard switch).  This is nice because it allows the nodes on the Clusterboard to connect directly to other devices on the network but I don't think this is an option in the long run if for no other reason than it makes it impossible to boot the machine when it's not connected to a network with a DHCP server...  I think the right configuration is to have the nodes on the clusterboard configured with static addresses, however this makes it hard to connect them to the Internet for installing software, etc. so I'm just not 100% sure yet.  The original RAIN MARK II setup used the ethernet port on the Clusterboard to connect to a "head node" which served as a bridge between the Clusterboard LAN and a larger network connected to a second interface (WiFi).  Since the rpi0w doesn't have an ethernet port, this isn't an option in the current configuration so I'm not sure what's the best way to go about this.

One thing I didn't like about the previous setup was surprises related to updates being applied to nodes in the cluster, so I would be just as happy to have them not connected to the Internet and instead install the software from a single local source, but I'm not sure how best to do that.  I can think of hard ways to do it but I'd prefer to do something smarter than just having a big directory of binaries that get copied to each node.  Hmm...

For now it might make sense to give the Clusterboard nodes static IP addresses that are valid addresses for the network they are connected to via the Clusterboard's ethernet port.  This allows the nodes to communicate with eachother across the Clusterboard switch regardless of whether or not the Clusterboard is connected to the larger LAN (and Internet), while preserving the ability to communicate with the nodes from other hosts on the network when it is connected.

After weighting the options, I think it's just going to be easiest/most reliable to burn Armbian on to a few SD cards, boot them up one at a time, watch for them to DHCP an address from the LAN's router and then ssh into each to configure them.  There's certainly more automated ways to do it, but I need to be thoughtful about how and where I'm spending time.  This will get the nodes online, and then I can give them static addresses which will work both on and off the LAN, and I can start experimenting with running software on the cluster (and in particular, benchmarking it now that I have a reasonable cooling system setup).

```
slot    name            DHCP ip         mac                 static ip
0       rain-psp-0      10.1.10.133     02:ba:cf:05:0d:71   10.1.10.50/255.255.255.0
1
2
3
4
5       rain-psp-5      10.1.10.241                         10.1.10.55
6       rain-psp-6      10.1.10.145                         10.1.10.56
```

OK, that's three nodes on-line, let's see what we can do with them.

Looks like we need to install `libnss-mdns` and `libnss-mymachines` before the cluster nodes will see eachother by hostname (even when mdns is enabled in `armbian-config`?).

Next create an ssh key on the head node: `ssh-keygen -t rsa`
Then copy the key to each node: `ssh-copy-id -i ~/.ssh/id_rsa.pub user@host`

Let's try `cssh` and `csftp` to see if we can make managing the cluster a little easier...

```
sudo apt install clusterssh

```

Oh nevermind, cssh is a GUI thing and for now we are textmode only.

Let's start with [IPython](https://ipython.readthedocs.io/en/stable/interactive/index.html), I really want to run HPL but I need to dig up my notes and I don't have them handy at the moment.

```
sudo apt install python3-dev
python3 -m venv ./venvs/ipython
source ./venvs/ipython/bin/activate
pip install wheel
pip install ipython
pip install ipyparallel
```

So far so good.

Now using this guide to see if we can get the cluster running across multiple nodes:

### References

https://ipyparallel.readthedocs.io/en/latest/tutorial/process.html
https://ipython.readthedocs.io/en/stable/interactive/tutorial.html
https://ericdraken.com/cluster-computer-gotchas/
https://www.mpich.org/downloads/
https://mpitutorial.com/tutorials/running-an-mpi-cluster-within-a-lan/
https://forum.armbian.com/topic/9402-ethernet-not-working-on-sopine-module/page/2/


## 12202021

Started working on a CLI program to monitor the cluster.

## 12212021

Taking a whack at getting [HPL](https://www.netlib.org/benchmark/hpl/) running.  I really wish I could find my notes from before because I remember it being a bit of a struggle, but I've found a few other maniacs on the Internet running this on ARM clusters now so maybe it won't be quite so bad.

* https://www.anthonymorast.com/blog/2019/10/31/setting-up-a-raspberry-pi-cluster-to-use-mpi/
* https://www.howtoforge.com/tutorial/hpl-high-performance-linpack-benchmark-raspberry-pi/
* https://www.netlib.org/benchmark/hpl/

### Setup & test openmpi

* On the head node:
	+ `sudo apt install openmpi-bin openmpi-common libopenmpi-dev libatlas-base-dev gfortran`
	+ Create `machinefile`
	+ Copy test program to the identical path on each machine
	+ Run the test program: `mpiexec -n 10 --machinefile machinefile ./hello_mpi`
* On the other nodes:
	+ `sudo apt install openmpi-bin openmpi-common`

### Build HPL

* Download & extract HPL
* Create an architecture-specific makefile
* Compile
	+ `make arch=aarch64-linux`

No matter what I do, I can't seem to get past this error:

```
make[2]: Entering directory '/home/jason/hpl/src/auxil/aarch64-linux'
ar r /home/jason/hpl/lib/aarch64-linux /libhpl.a  HPL_dlacpy.o           HPL_dlatcpy.o          HPL_fprintf.o HPL_warn.o             HPL_abort.o            HPL_dlaprnt.o HPL_dlange.o HPL_dlamch.o
ar: /home/jason/hpl/lib/aarch64-linux: file format not recognized
```

Holy shit, I think I found it.  Look closely above, notice something about the third line?

`ar r /home/jason/hpl/lib/aarch64-linux /libhpl.a `

There is a space in the path, which explains why `libhpl.a` is missing from the last line:

`ar: /home/jason/hpl/lib/aarch64-linux: file format not recognized`

It took me a minute to figure out where this space was coming from, it turns out there was a space at the end of line 64 of the architecture makefile:

`ARCH         = aarch64-linux`

With this removed, we get past that error.

A few more errors cropped-up but they were much easier to solve, and after some tweaking I was able to get a [architecture makefile](./software/hpl/aarch64-linux) that compiles!

Runs locally using the stock HPL.dat with this command:

`mpiexec --machinefile -n 4 ./xhpl`

This results in about 2.5 GFLOP (this is probably wrong)s.  

To run it using the other cluster nodes we need to move the compiled `xhpl` binary to the other nodes.  With this we should be able to run with this command:

`mpiexec --machinefile ~/machinefile -n 10 ./xhpl`

But no, because we need to meet some of the missing dependencies.  That should be as easy as running a few `apt` commands:

`sudo apt install openmpi-bin openmpi-common libopenmpi-dev libatlas-base-dev gfortran`

After that I was able to run the job across the three nodes of the cluster.  The results are pretty poor right now, but I've done zero tuning and one node is stuck at 648Mhz, so that's a thing...


28377   295

With some tweaking on the config file based on [this guide](http://www.crc.nd.edu/~rich/CRC_Summer_Scholars_2014/HPL-HowTo.pdf) I'm starting to work the cluster reasonably hard and seeing core temps creep up.  General consensus is that 80c is as high as you want to go, and running at full-tilt for an extended time seems to hit only around 60c on the two fully-loaded (4 threads) modules so the cooling system must be doing OK.

Helpful links (so I don't loose them):

* https://www.calculatorsoup.com/calculators/math/scientific-notation-converter.php
* https://www.anthonymorast.com/blog/2019/10/31/setting-up-a-raspberry-pi-cluster-to-use-mpi/
* http://www.crc.nd.edu/~rich/CRC_Summer_Scholars_2014/HPL-HowTo.pdf
* https://www.howtoforge.com/tutorial/hpl-high-performance-linpack-benchmark-raspberry-pi/
* https://www.netlib.org/benchmark/hpl/
* https://gist.github.com/Levi-Hope/27b9c32cc5c9ded78fff3f155fc7b5ea


## 12222021

Adding more nodes today.

```
slot    name            DHCP ip         mac                 static ip
0       rain-psp-0      10.1.10.133     02:ba:cf:05:0d:71   10.1.10.50/255.255.255.0
1       rain-psp-1      10.1.10.184                         10.1.10.51/255.255.255.0 
2
3       rain-psp-3      10.1.10.188                         10.1.10.53
4       rain-psp-4      10.1.10.243                         10.1.10.54/255.255.255.0
5       rain-psp-5      10.1.10.241                         10.1.10.55
6       rain-psp-6      10.1.10.145                         10.1.10.56
```

### New node setup

On the head node:

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
8. Install packages
    + `sudo apt update`
    + `sudo apt install -y libnss-mdns libnss-mymachines openmpi-bin openmpi-common libopenmpi-dev libatlas-base-dev gfortran`
9. Install HPL
    + From new node:
        + `mkdir ~/hpl/bin/aarch64-linux`
    + From head node:
        + `cd ~/hpl/bin/aarch64-linux``
        + `scp * new-host-name.local:/home/jason/hpl/bin/aarch64-linux/`
10. Add new node to `machinefile`
