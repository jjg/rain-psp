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
2                                           5v
3       2
4                   Clusterboard pin 1      5v (supplied from Clusterboard) 
5       3
6                   Clusterboard pin 6      GND
7       4           Keyboard row 1?
8       14          Clusterboard pin 8      UART TX
9                                           GND
10      15          Clusterboard pin 7      UART RX
11      17
12      18
13      27          Keyboard row 2?
14                                          GND
15      22          Keyboard row 3?
16      23          Keyboard row 4?
17                                          3v3
18      24          Keyboard col 1?
19      10          Keyboard col 2?
20                                          GND
21      9           Keyboard col 3?
22      25          Keyboard col 4?
23      11          Keyboard col 5?
24      8           Keyboard col 6?
25                                          GND
26      7           Keyboard col 7?
27      0
28      1
29      5           Keyboard col 8?
30                                          GND
31      6           Keyboard col 9?
32      12          Keyboard col 10? 
33      13          LCD                     Backlight brightness (PWM)
34                                          GND
35      19          Keyboard col 11?
36      16          Keyboard col 12?
37      26
38      20
39                                          GND
40      21
```
