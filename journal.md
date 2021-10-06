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

Ran into some snags printing the bottom case (broke the printer) so I'll have to re-print that and the display top before I can test the fit for interference with the keys
