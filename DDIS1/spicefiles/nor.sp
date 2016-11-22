**********************************
**** NOR: simple example
**********************************

* Simulation setup
*------------------
*Some simulation options
.options post nomod
.option opts fast parhier=local
.options captab

*Add the 45nm CMOS library. NORice how the path is generated by MATLAB
.lib '/users/start2016/r0364010/Master2/DDIS/DDIS1/Resources/Technology/tech_wrapper.lib ' tt

*Add the .vec file
.vec '/users/start2016/r0364010/Master2/DDIS/DDIS1/m2sfiles/nor.vec'

.tran 0.001n 10n *Do a transient simulation, final time = 5ns
.probe v i

.param supply = 1


* Voltage sources -> inputs are now provided in the .vec files, so disable them here
*-----------------
* name pin1 pin2 type 
* pulseparameters:(init, pulsedVal, delay, rise, fall, pulse width, period)
*Vin1 in1  vss pulse 0 supply 0.99p 20p 20p 2n 3n
*Vin2 in2  vss pulse 0 supply 0.99p 20p 20p 1n 2n

Vdd vdd vss supply
Vss vss 0 0 


* Simulated circuit
*-------------------
*Creation of a NOR gate in the circuit

* many NOR gates:
XNOR1 in1 in2 out vdd vss MYNOR multfac=1

 * add a capacitor
Cap out vss 10f



* Subcircuits
*-------------
.SUBCKT MYNOR input1 input2 output vdd vss multfac='1'
*    drain  gate   src  bulk
xMn1 output input1 vss  vss MOSN w='multfac*120e-9' l='45e-9'
xMn2 output input2 vss  vss MOSN w='multfac*120e-9' l='45e-9'

xMp1 sp1    input1 vdd  vdd MOSP w='multfac*2*2*1*120e-9' l='45e-9' * double b/c pMos, anoter b/c for NOR gate nMOS in parallel, and we want equal delays
xMp2 output input2 sp1  vdd MOSP w='multfac*2*2*1*120e-9' l='45e-9' * factor 1.5 b/c series has extra node, so extra cap
.ENDS MYNOR

.END
