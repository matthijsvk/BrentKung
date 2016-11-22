**********************************
**** buffer dchain
**********************************

* Simulation setup
*------------------
*Some simulation options
.options post nomod
.option opts fast parhier=local

*Add the 45nm CMOS library. Notice how the path is generated by MATLAB
.lib '/users/start2016/r0364010/Master2/DDIS/DDIS1/Resources/Technology/tech_wrapper.lib ' tt

*Add the .vec file
.vec '/users/start2016/r0364010/Master2/DDIS/DDIS1/m2sfiles/switchableInverter.vec'

.tran 0.001n 10n *Do a transient simulation, final time = 10ns
.probe v i

.param supply = 1

* Voltage sources
*-----------------
Vdd vdd vss supply
Vss vss 0 0 

* Simulated circuit
*-------------------
* input: 1 single-sized inverter
Xin in0 out0 vdd vss MYNOT multfac=1
Cap0 out0 vss 10f

* design: # inverters, size, Vsupply
* for minimum delay -> fanout=4, # stages = ln(C_l/C_in) = ln(100) = 4.6 -> 5
    Xnotchain 1 in1 out1 vdd vss MYNOT multfac=1
    Cap1 out1 vss 10f
    Xnotchain 2 in2 out2 vdd vss MYNOT multfac=4
    Cap2 out2 vss 10f
    Xnotchain 3 in3 out3 vdd vss MYNOT multfac=16
    Cap3 out3 vss 10f
    Xnotchain 4 in4 out4 vdd vss MYNOT multfac=64
    Cap4 out4 vss 10f
    Xnotchain 5 in5 out5 vdd vss MYNOT multfac=256
    Cap5 out5 vss 10f
    
* load: 100 inverters
    Xnotload6 out5 out6 vdd vss MYNOT multfac=1
    Cap6 out6 vss 10f
    Xnotload7 out6 out7 vdd vss MYNOT multfac=1
    Cap7 out7 vss 10f
    Xnotload8 out7 out8 vdd vss MYNOT multfac=1
    Cap8 out8 vss 10f
    Xnotload9 out8 out9 vdd vss MYNOT multfac=1
    Cap9 out9 vss 10f
    Xnotload10 out9 out10 vdd vss MYNOT multfac=1
    Cap10 out10 vss 10f
    Xnotload11 out10 out11 vdd vss MYNOT multfac=1
    Cap11 out11 vss 10f
    Xnotload12 out11 out12 vdd vss MYNOT multfac=1
    Cap12 out12 vss 10f
    Xnotload13 out12 out13 vdd vss MYNOT multfac=1
    Cap13 out13 vss 10f
    Xnotload14 out13 out14 vdd vss MYNOT multfac=1
    Cap14 out14 vss 10f
    Xnotload15 out14 out15 vdd vss MYNOT multfac=1
    Cap15 out15 vss 10f
    Xnotload16 out15 out16 vdd vss MYNOT multfac=1
    Cap16 out16 vss 10f
    Xnotload17 out16 out17 vdd vss MYNOT multfac=1
    Cap17 out17 vss 10f
    Xnotload18 out17 out18 vdd vss MYNOT multfac=1
    Cap18 out18 vss 10f
    Xnotload19 out18 out19 vdd vss MYNOT multfac=1
    Cap19 out19 vss 10f
    Xnotload20 out19 out20 vdd vss MYNOT multfac=1
    Cap20 out20 vss 10f
    Xnotload21 out20 out21 vdd vss MYNOT multfac=1
    Cap21 out21 vss 10f
    Xnotload22 out21 out22 vdd vss MYNOT multfac=1
    Cap22 out22 vss 10f
    Xnotload23 out22 out23 vdd vss MYNOT multfac=1
    Cap23 out23 vss 10f
    Xnotload24 out23 out24 vdd vss MYNOT multfac=1
    Cap24 out24 vss 10f
    Xnotload25 out24 out25 vdd vss MYNOT multfac=1
    Cap25 out25 vss 10f
    Xnotload26 out25 out26 vdd vss MYNOT multfac=1
    Cap26 out26 vss 10f
    Xnotload27 out26 out27 vdd vss MYNOT multfac=1
    Cap27 out27 vss 10f
    Xnotload28 out27 out28 vdd vss MYNOT multfac=1
    Cap28 out28 vss 10f
    Xnotload29 out28 out29 vdd vss MYNOT multfac=1
    Cap29 out29 vss 10f
    Xnotload30 out29 out30 vdd vss MYNOT multfac=1
    Cap30 out30 vss 10f
    Xnotload31 out30 out31 vdd vss MYNOT multfac=1
    Cap31 out31 vss 10f
    Xnotload32 out31 out32 vdd vss MYNOT multfac=1
    Cap32 out32 vss 10f
    Xnotload33 out32 out33 vdd vss MYNOT multfac=1
    Cap33 out33 vss 10f
    Xnotload34 out33 out34 vdd vss MYNOT multfac=1
    Cap34 out34 vss 10f
    Xnotload35 out34 out35 vdd vss MYNOT multfac=1
    Cap35 out35 vss 10f
    Xnotload36 out35 out36 vdd vss MYNOT multfac=1
    Cap36 out36 vss 10f
    Xnotload37 out36 out37 vdd vss MYNOT multfac=1
    Cap37 out37 vss 10f
    Xnotload38 out37 out38 vdd vss MYNOT multfac=1
    Cap38 out38 vss 10f
    Xnotload39 out38 out39 vdd vss MYNOT multfac=1
    Cap39 out39 vss 10f
    Xnotload40 out39 out40 vdd vss MYNOT multfac=1
    Cap40 out40 vss 10f
    Xnotload41 out40 out41 vdd vss MYNOT multfac=1
    Cap41 out41 vss 10f
    Xnotload42 out41 out42 vdd vss MYNOT multfac=1
    Cap42 out42 vss 10f
    Xnotload43 out42 out43 vdd vss MYNOT multfac=1
    Cap43 out43 vss 10f
    Xnotload44 out43 out44 vdd vss MYNOT multfac=1
    Cap44 out44 vss 10f
    Xnotload45 out44 out45 vdd vss MYNOT multfac=1
    Cap45 out45 vss 10f
    Xnotload46 out45 out46 vdd vss MYNOT multfac=1
    Cap46 out46 vss 10f
    Xnotload47 out46 out47 vdd vss MYNOT multfac=1
    Cap47 out47 vss 10f
    Xnotload48 out47 out48 vdd vss MYNOT multfac=1
    Cap48 out48 vss 10f
    Xnotload49 out48 out49 vdd vss MYNOT multfac=1
    Cap49 out49 vss 10f
    Xnotload50 out49 out50 vdd vss MYNOT multfac=1
    Cap50 out50 vss 10f
    Xnotload51 out50 out51 vdd vss MYNOT multfac=1
    Cap51 out51 vss 10f
    Xnotload52 out51 out52 vdd vss MYNOT multfac=1
    Cap52 out52 vss 10f
    Xnotload53 out52 out53 vdd vss MYNOT multfac=1
    Cap53 out53 vss 10f
    Xnotload54 out53 out54 vdd vss MYNOT multfac=1
    Cap54 out54 vss 10f
    Xnotload55 out54 out55 vdd vss MYNOT multfac=1
    Cap55 out55 vss 10f
    Xnotload56 out55 out56 vdd vss MYNOT multfac=1
    Cap56 out56 vss 10f
    Xnotload57 out56 out57 vdd vss MYNOT multfac=1
    Cap57 out57 vss 10f
    Xnotload58 out57 out58 vdd vss MYNOT multfac=1
    Cap58 out58 vss 10f
    Xnotload59 out58 out59 vdd vss MYNOT multfac=1
    Cap59 out59 vss 10f
    Xnotload60 out59 out60 vdd vss MYNOT multfac=1
    Cap60 out60 vss 10f
    Xnotload61 out60 out61 vdd vss MYNOT multfac=1
    Cap61 out61 vss 10f
    Xnotload62 out61 out62 vdd vss MYNOT multfac=1
    Cap62 out62 vss 10f
    Xnotload63 out62 out63 vdd vss MYNOT multfac=1
    Cap63 out63 vss 10f
    Xnotload64 out63 out64 vdd vss MYNOT multfac=1
    Cap64 out64 vss 10f
    Xnotload65 out64 out65 vdd vss MYNOT multfac=1
    Cap65 out65 vss 10f
    Xnotload66 out65 out66 vdd vss MYNOT multfac=1
    Cap66 out66 vss 10f
    Xnotload67 out66 out67 vdd vss MYNOT multfac=1
    Cap67 out67 vss 10f
    Xnotload68 out67 out68 vdd vss MYNOT multfac=1
    Cap68 out68 vss 10f
    Xnotload69 out68 out69 vdd vss MYNOT multfac=1
    Cap69 out69 vss 10f
    Xnotload70 out69 out70 vdd vss MYNOT multfac=1
    Cap70 out70 vss 10f
    Xnotload71 out70 out71 vdd vss MYNOT multfac=1
    Cap71 out71 vss 10f
    Xnotload72 out71 out72 vdd vss MYNOT multfac=1
    Cap72 out72 vss 10f
    Xnotload73 out72 out73 vdd vss MYNOT multfac=1
    Cap73 out73 vss 10f
    Xnotload74 out73 out74 vdd vss MYNOT multfac=1
    Cap74 out74 vss 10f
    Xnotload75 out74 out75 vdd vss MYNOT multfac=1
    Cap75 out75 vss 10f
    Xnotload76 out75 out76 vdd vss MYNOT multfac=1
    Cap76 out76 vss 10f
    Xnotload77 out76 out77 vdd vss MYNOT multfac=1
    Cap77 out77 vss 10f
    Xnotload78 out77 out78 vdd vss MYNOT multfac=1
    Cap78 out78 vss 10f
    Xnotload79 out78 out79 vdd vss MYNOT multfac=1
    Cap79 out79 vss 10f
    Xnotload80 out79 out80 vdd vss MYNOT multfac=1
    Cap80 out80 vss 10f
    Xnotload81 out80 out81 vdd vss MYNOT multfac=1
    Cap81 out81 vss 10f
    Xnotload82 out81 out82 vdd vss MYNOT multfac=1
    Cap82 out82 vss 10f
    Xnotload83 out82 out83 vdd vss MYNOT multfac=1
    Cap83 out83 vss 10f
    Xnotload84 out83 out84 vdd vss MYNOT multfac=1
    Cap84 out84 vss 10f
    Xnotload85 out84 out85 vdd vss MYNOT multfac=1
    Cap85 out85 vss 10f
    Xnotload86 out85 out86 vdd vss MYNOT multfac=1
    Cap86 out86 vss 10f
    Xnotload87 out86 out87 vdd vss MYNOT multfac=1
    Cap87 out87 vss 10f
    Xnotload88 out87 out88 vdd vss MYNOT multfac=1
    Cap88 out88 vss 10f
    Xnotload89 out88 out89 vdd vss MYNOT multfac=1
    Cap89 out89 vss 10f
    Xnotload90 out89 out90 vdd vss MYNOT multfac=1
    Cap90 out90 vss 10f
    Xnotload91 out90 out91 vdd vss MYNOT multfac=1
    Cap91 out91 vss 10f
    Xnotload92 out91 out92 vdd vss MYNOT multfac=1
    Cap92 out92 vss 10f
    Xnotload93 out92 out93 vdd vss MYNOT multfac=1
    Cap93 out93 vss 10f
    Xnotload94 out93 out94 vdd vss MYNOT multfac=1
    Cap94 out94 vss 10f
    Xnotload95 out94 out95 vdd vss MYNOT multfac=1
    Cap95 out95 vss 10f
    Xnotload96 out95 out96 vdd vss MYNOT multfac=1
    Cap96 out96 vss 10f
    Xnotload97 out96 out97 vdd vss MYNOT multfac=1
    Cap97 out97 vss 10f
    Xnotload98 out97 out98 vdd vss MYNOT multfac=1
    Cap98 out98 vss 10f
    Xnotload99 out98 out99 vdd vss MYNOT multfac=1
    Cap99 out99 vss 10f
    Xnotload100 out99 out100 vdd vss MYNOT multfac=1
    Cap100 out100 vss 10f
    Xnotload101 out100 out101 vdd vss MYNOT multfac=1
    Cap101 out101 vss 10f
    Xnotload102 out101 out102 vdd vss MYNOT multfac=1
    Cap102 out102 vss 10f
    Xnotload103 out102 out103 vdd vss MYNOT multfac=1
    Cap103 out103 vss 10f
    Xnotload104 out103 out104 vdd vss MYNOT multfac=1
    Cap104 out104 vss 10f
    Xnotload105 out104 out105 vdd vss MYNOT multfac=1
    Cap105 out105 vss 10f
    Xnotload106 out105 out106 vdd vss MYNOT multfac=1
    Cap106 out106 vss 10f

* Subcircuits
*-------------
* xor-> ( (b*a')' * (b'*a)' )' using NAND gates
.SUBCKT MYXOR input control output   vdd vss multfac='1'    
      * first calculate inverses with NAND: 
      * MYNAND in1     in2     out     vdd vss multfac='1'
        XinvA  input   input   outinvA vdd vss MYNAND multfac=multfac 
        XinvB  control control outinvB vdd vss MYNAND multfac=multfac 
        * (b*a')'
        Xnand1 outinvA control outnand1 vdd vss MYNAND multfac=multfac 
        * (b'*a)'
        Xnand2 outinvB input   outnand2 vdd vss MYNAND multfac=multfac 
        * combine
        XnandOut outnand1 outnand2 output vdd vss MYNAND multfac=multfac 
.ENDS MYXOR

.SUBCKT MYNAND input1 input2 output vdd vss multfac='1'
*    drain  gate   src  bulk
xMn1 dn1    input1 vss  vss MOSN w='multfac*1.5*120e-9' l='45e-9' * extra factor b/c series -> extra node that has capacitance
xMn2 output input2 dn1  vss MOSN w='multfac*1.5*120e-9' l='45e-9'

xMp1 output input1 vdd  vdd MOSP w='multfac*120e-9' l='45e-9' * not *2 b/c pMOS in parallel for NAND -> only half size needed
xMp2 output input2 vdd  vdd MOSP w='multfac*120e-9' l='45e-9'
.ENDS MYNAND

.SUBCKT MYNOT input output vdd vss multfac='1'
xM1 output input vss vss MOSN w='multfac*120e-9' l='45e-9'
xM2 output input vdd vdd MOSP w='multfac*2*120e-9' l='45e-9'
.ENDS MYNOT

.SUBCKT MYBUF input output vdd vss
Xnot1         input out1   vdd vss MYNOT
Xnot2         out1  output vdd vss MYNOT
.ENDS MYBUF


.END

