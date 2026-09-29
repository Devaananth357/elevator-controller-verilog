\# Elevator Controller in Verilog



A parameterized elevator controller designed in Verilog and implemented using Vivado. The controller handles multiple floor requests, remembers pending requests, and controls movement and door timing.



\## Features



\- Configurable number of floors (`N`)

\- Pending floor request storage

\- Direction-based travel

\- Configurable travel and door-open cycles

\- Button edge detection so a held button is counted once

\- Simulation, synthesis, implementation, timing, and power analysis



\## Files



\- `elevator\_controller.v` — controller RTL

\- `elevator\_controller\_tb.v` — simulation testbench

\- `Timing\_constraints.xdc` — clock timing constraint

\- `Images/` — simulation and Vivado result screenshots



\## Parameters



| Parameter         | Default | Purpose          		 |

| ----------------- | ------- | -------------------------------- |

| `N`               | 8       | Number of floors                 |

| `Open\_Door\_cycle` | 3       | Door-open timer setting          |

| `Travel\_Cycle`    | 4       | Clock cycles per floor of travel |



Floors are numbered from `0` to `N-1`. Each bit of `floor\_request` corresponds to one floor.



\## How to run



1\. Create a Vivado RTL project and add `elevator\_controller.v` as a design source.

2\. Add `elevator\_controller\_tb.v` as a simulation source.

3\. Run behavioral simulation with `elevator\_controller\_tb` as the simulation top.

4\. Add `Timing\_constraints.xdc`, select your target FPGA, and run synthesis and implementation.



\## Results



!\[Multi-floor simulation waveform](Images/fig\_1a\_multi\_floor\_waveform.jpg)



!\[Held-button simulation waveform](Images/fig\_1b\_held\_button\_waveform.jpg)



!\[Synthesis schematic](Images/fig\_3\_synthesized\_schematic.jpg)



!\[Timing summary](Images/fig\_7\_timing\_summary.jpg)



!\[Power analysis](Images/fig\_8\_power\_analysis.jpg)

