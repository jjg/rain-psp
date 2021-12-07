# RAIN PSP Hardware

RAIN PSP consists of off-the-shelf electronics combined with 3D printable chassis components as well as some custom electronics.

The current design revolves around the [Pine64 Clusterboard](https://wiki.pine64.org/wiki/Clusterboard).  This board provides a network of seven four-core ARM SoCs and Gigabit Ethernet interconnect.  A Raspberry Pi serves as a terminal for one of the nodes in the cluster, driving the keyboard and LCD display and  providing the user means to interact with the cluster.

In addition to the computational components, peripherals such as keyboard, display, power supply, etc. are documented under this directory.

## Wiring

The wiring harness is WIP but for now this documents some of the important connections.

### Clusterboard

```
Clusterboard        Device                  Notes
1 (VCC5V)       ->  rpi0 4                  (head node only)
2 (Heartbeat)   ->  power LED -> GND
3 NC
4 NC
5 (PWR_ON)      ->  power button -> GND
6 (GND)         ->  rpi0 6 GND              (head node only)
7 (UART0-RX)    ->  rpi0 10 UART RX         (head node only)
8 (UART0-TX)    ->  rpi0 8 UART TX          (head node only)
10 - 20 NC
```

### Raspberry Pi Zero W

```
Pin     GPIO        Device                  Notes
1                                           3v3 
2                   Clusterboard pin 1      5v (supply from Clusterboard)
3       2                                   Was keyboard column 8, but it malfunctioned?
4                   LCD 5v                  5v (supplied to LCD) 
5       3
6                   LCD GND                 GND
7       4                                   This was keyboard row 0, but it malfunctioned? 
8       14          Clusterboard pin 8      brown, UART TX
9                                           GND
10      15          Clusterboard pin 7      orange, UART RX
11      17          Keyboard col 8          yellow
12      18          LCD PWM                 white, backlight brightness
13      27          Keyboard row 1          orange
14                  Clusterboard pin 6      blue, GND
15      22          Keyboard row 2          yellow
16      23          Keyboard row 3          green
17                                          3v3
18      24          Keyboard col 0          blue
19      10          Keyboard col 1          purple
20                                          GND
21      9           Keyboard col 2          white
22      25          Keyboard col 3          white
23      11          Keyboard col 4          black
24      8                                   This was keyboard column 5 but malfunctioned? 
25                                          GND
26      7                                   This was keyboard column 6 but malfunctioned? 
27      0                                   This was keyboard column 7 but malfunctioned?
28      1                                   This was keyboard column 8 but malfunctioned?
29      5                                   This was keyboard column 7 but malfunctioned?
30                                          GND
31      6                                   This was keyboard column 8 but malfunctioned?
32      12          Keyboard col 9          green
33      13          Keyboard col 7          orange (was backlight brightness (PWM))
34                                          GND
35      19          Keyboard col 10         blue
36      16          Keyboard col 11         purple
37      26          Keyboard col 5          brown
38      20          Keyboard row 0          red
39                                          GND
40      21          Keyboard col 6          red
```

## References

* https://elinux.org/RPi_BCM2835_GPIOs
