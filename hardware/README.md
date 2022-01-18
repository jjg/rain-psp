# RAIN PSP Hardware

RAIN PSP consists of off-the-shelf electronics combined with 3D printable chassis components as well as some custom electronics.

## Components

* 1x [PINE64 Clusterboard](https://pine64.com/product/clusterboard-with-7-sopine-compute-module-slots/)
* 7x [SOPine Compute Module](https://pine64.com/product/sopine-a64-compute-module/)
* 1x [Clusterboard Power Supply](https://pine64.com/product/clusterboard-us-power-supply/)
* 1x [Raspberry Pi Zero W](https://www.raspberrypi.com/products/raspberry-pi-zero-w/)
* 1x [Waveshare 7" HDMI LCD](https://www.waveshare.com/wiki/7inch_HDMI_LCD_(C))
* 8x 16GB SD card
* 3x 40mm 5vdc cooling fan
* 40x Cherry MX Blue keyswitch
* 7x 12mm illuminated momentary pushbutton
* 1x 12mm illuminated pushbutton
* 2x 1" 8-32 hex head screw
* 2x 8-32 hex nut

The current design revolves around the [Pine64 Clusterboard](https://wiki.pine64.org/wiki/Clusterboard).  This board provides a network of seven four-core ARM SoCs and Gigabit Ethernet interconnect.  A Raspberry Pi serves as a terminal for one of the nodes in the cluster, driving the keyboard and LCD display and  providing the user means to interact with the cluster.

In addition to the computational components, peripherals such as keyboard, display, power supply, etc. are documented under this directory.

## Wiring

The wiring harness is WIP but for now this documents some of the important connections.

### Clusterboard

```
Clusterboard        Device                  Notes
1 (VCC5V)       ->  rpi0 2                  (head node only)
2 (Heartbeat)   ->  power LED -> GND
3 NC
4 NC
5 (PWR_ON)      ->  power button -> GND
6 (GND)         ->  rpi0 14 GND             (head node only)
7 (UART0-RX)    ->  rpi0 10 UART RX         (head node only)
8 (UART0-TX)    ->  rpi0 8 UART TX          (head node only)
10 - 20 NC
```

### Raspberry Pi Zero W

```
Pin     GPIO        Device          Notes
1                                           
2                   Clusterboard    5v supply (pin 1)
3       2                                   
4                   LCD             red, 5v output to LCD 
5       3                                
6                   LCD             green, LCD GND
7       4                                   
8       14          Clusterboard    brown, UART TX (pin 8)
9                                           
10      15          Clusterboard    orange, UART RX (pin 7)
11      17          Keyboard        yellow, col 8
12      18          LCD             white, backlight (PWM)
13      27          Keyboard        orange, row 1
14                  Clusterboard    blue, GND (pin 6)
15      22          Keyboard        yellow, row 2
16      23          Keyboard        green, row 3
17                                          
18      24          Keyboard        blue, col 0
19      10          Keyboard        purple, col 1
20                                          
21      9           Keyboard        white, col 2
22      25          Keyboard        white, col 3
23      11          Keyboard        black, col 4
24      8                                    
25                                          
26      7                                   
27      0                                   
28      1                                   
29      5                                   
30                                          
31      6                                   
32      12          Keyboard        green, col 9
33      13          Keyboard        orange, col 7
34                                          
35      19          Keyboard        blue, col 10
36      16          Keyboard        purple, col 11
37      26          Keyboard        brown, col 5
38      20          Keyboard        red, row 0
39                                          
40      21          Keyboard        red, col 6
```

## References

* https://elinux.org/RPi_BCM2835_GPIOs
