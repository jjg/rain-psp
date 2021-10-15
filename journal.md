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


