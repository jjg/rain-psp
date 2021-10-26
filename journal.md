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

