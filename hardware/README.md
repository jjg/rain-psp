# RAIN PSP Hardware

RAIN PSP consists of off-the-shelf electronics combined with 3D printable chassis components as well as some custom electronics.

The current design revolves around the [Pine64 Clusterboard](https://wiki.pine64.org/wiki/Clusterboard).  This board provides a network of seven four-core ARM SoCs and Gigabit Ethernet interconnect.  A Raspberry Pi serves as a terminal for one of the nodes in the cluster, driving the keyboard and LCD display and  providing the user means to interact with the cluster.

In addition to the computational components, peripherals such as keyboard, display, power supply, etc. are documented under this directory.

## Wiring

The wiring harness is WIP but for now this documents some of the important connections.

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

