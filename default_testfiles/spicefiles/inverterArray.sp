**********************************
**** INVERTER: simple example
**********************************

* Simulation setup
*------------------
*Some simulation options
.options post nomod
.option opts fast parhier=local

*Add the 45nm CMOS library. Notice how the path is generated by MATLAB
.lib '/users/start2016/r0364010/Master2/DDIS/DDIS1/Resources/Technology/tech_wrapper.lib ' tt

*Add the .vec file
.vec '/users/start2016/r0364010/Master2/DDIS/DDIS1/m2sfiles/inverterArray.vec'

.tran 0.001n 5n *Do a transient simulation, final time = 5ns
.probe v i

.param supply = 1


* Voltage sources
*-----------------
Vdd vdd vss supply
Vss vss 0 0 


* Simulated circuit
*-------------------

    Xnot0 in0 out0 vdd vss MYBUF
    Cap0 out0 vss 10f
    Xnot1 in1 out1 vdd vss MYBUF
    Cap1 out1 vss 10f
    Xnot2 in2 out2 vdd vss MYBUF
    Cap2 out2 vss 10f
    Xnot3 in3 out3 vdd vss MYBUF
    Cap3 out3 vss 10f
    Xnot4 in4 out4 vdd vss MYBUF
    Cap4 out4 vss 10f
    Xnot5 in5 out5 vdd vss MYBUF
    Cap5 out5 vss 10f
    Xnot6 in6 out6 vdd vss MYBUF
    Cap6 out6 vss 10f
    Xnot7 in7 out7 vdd vss MYBUF
    Cap7 out7 vss 10f
    Xnot8 in8 out8 vdd vss MYBUF
    Cap8 out8 vss 10f
    Xnot9 in9 out9 vdd vss MYBUF
    Cap9 out9 vss 10f
    Xnot10 in10 out10 vdd vss MYBUF
    Cap10 out10 vss 10f
    Xnot11 in11 out11 vdd vss MYBUF
    Cap11 out11 vss 10f
    Xnot12 in12 out12 vdd vss MYBUF
    Cap12 out12 vss 10f
    Xnot13 in13 out13 vdd vss MYBUF
    Cap13 out13 vss 10f
    Xnot14 in14 out14 vdd vss MYBUF
    Cap14 out14 vss 10f
    Xnot15 in15 out15 vdd vss MYBUF
    Cap15 out15 vss 10f


* Subcircuits
*-------------
.SUBCKT MYNOT input output vdd vss multfac='1'
xM1 output input vss vss MOSN w='multfac*120e-9' l='45e-9'
xM2 output input vdd vdd MOSP w='multfac*2*120e-9' l='45e-9'
.ENDS MYNOT

.SUBCKT MYBUF input output vdd vss
Xnot1         input out1   vdd vss MYNOT
Xnot2         out1  output vdd vss MYNOT
.ENDS MYBUF

.END


