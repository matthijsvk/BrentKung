# BrentKung
This repository contains files for the course 'Design of Digital Integrated Systems', a Master 2 course at KU Leuven, Belgium.
The project goal is to optimize a Brent-Kung adder as much as possible, in terms of speed and power. The end goal is to have as low switching and DC power consumption as possible, while keeping the delay under 650ps.

To do this, a SPICE implementation of the adder is made and tested using matlab scripts. HSPICE allows integration of matlab commands into SPICE files, making writing and testing much quicker and less involved.

My circuit reduced the original circuit in terms of switching energy from 236.8059 fJ to 86.265 fJ, in terms of DC power consumption from 3.4763 nW to 1.0202 nW, all while reducing the worst-case delay from 1140.7355ps to 649.9ps.

This was done through chaning the architecture and sizing.

-  See the folder DDIS1/m2sfiles/ for the SPICE circuits. Matlab Test files for the circuit can be found in DDIS1/.
-  For top-level testing of a circuit, use sweepCP.m, this does tests over all paths of te circuit to determine worst-case performance. 
-  This file uses Adder16b.m, which calculates energy, delay etc for one test case.
-  Use GenerateOverview.m to calculate the required supply voltage while still fulfilling the delay constraint of 650ps
- You can find a report wit extensive explanations and a circuit image in DDIS1/Report
