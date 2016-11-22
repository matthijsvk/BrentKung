******************************
**** 16b Brent-Kung adder ****
******************************
.param supply = 0.937
.param halfsupply = 0.4685


* Some simulation options
*-------------------------
.options post nomod
.option opts fast parhier=local

.lib '/users/start2016/r0364010/Master2/DDIS/DDIS1/Resources/Technology/tech_wrapper.lib ' tt
.tran 0.005n 36n
* .vec '/users/start2016/r0364010/Master2/DDIS/DDIS1/m2sfiles/Adder16b.vec'
.vec '/users/start2016/r0364010/Master2/DDIS/DDIS1/m2sfiles/Adder16b15.vec'


.probe i

.param supply = 0.937

Vdd vdd vss supply
Vdd2 vdd2 vss supply
Vss vss 0 0 


* Sizing Parameters
* ------------------






* Actual circuit
*----------------
    xNOTa0  a0  aN0     vdd vss MYNOT
    xNOTaN0 aN0 a_buff0 vdd vss MYNOT
    xNOTb0  b0  bN0     vdd vss MYNOT
    xNOTbN0 bN0 b_buff0 vdd vss MYNOT
    xNOTa1  a1  aN1     vdd vss MYNOT
    xNOTaN1 aN1 a_buff1 vdd vss MYNOT
    xNOTb1  b1  bN1     vdd vss MYNOT
    xNOTbN1 bN1 b_buff1 vdd vss MYNOT
    xNOTa2  a2  aN2     vdd vss MYNOT
    xNOTaN2 aN2 a_buff2 vdd vss MYNOT
    xNOTb2  b2  bN2     vdd vss MYNOT
    xNOTbN2 bN2 b_buff2 vdd vss MYNOT
    xNOTa3  a3  aN3     vdd vss MYNOT
    xNOTaN3 aN3 a_buff3 vdd vss MYNOT
    xNOTb3  b3  bN3     vdd vss MYNOT
    xNOTbN3 bN3 b_buff3 vdd vss MYNOT
    xNOTa4  a4  aN4     vdd vss MYNOT
    xNOTaN4 aN4 a_buff4 vdd vss MYNOT
    xNOTb4  b4  bN4     vdd vss MYNOT
    xNOTbN4 bN4 b_buff4 vdd vss MYNOT
    xNOTa5  a5  aN5     vdd vss MYNOT
    xNOTaN5 aN5 a_buff5 vdd vss MYNOT
    xNOTb5  b5  bN5     vdd vss MYNOT
    xNOTbN5 bN5 b_buff5 vdd vss MYNOT
    xNOTa6  a6  aN6     vdd vss MYNOT
    xNOTaN6 aN6 a_buff6 vdd vss MYNOT
    xNOTb6  b6  bN6     vdd vss MYNOT
    xNOTbN6 bN6 b_buff6 vdd vss MYNOT
    xNOTa7  a7  aN7     vdd vss MYNOT
    xNOTaN7 aN7 a_buff7 vdd vss MYNOT
    xNOTb7  b7  bN7     vdd vss MYNOT
    xNOTbN7 bN7 b_buff7 vdd vss MYNOT
    xNOTa8  a8  aN8     vdd vss MYNOT
    xNOTaN8 aN8 a_buff8 vdd vss MYNOT
    xNOTb8  b8  bN8     vdd vss MYNOT
    xNOTbN8 bN8 b_buff8 vdd vss MYNOT
    xNOTa9  a9  aN9     vdd vss MYNOT
    xNOTaN9 aN9 a_buff9 vdd vss MYNOT
    xNOTb9  b9  bN9     vdd vss MYNOT
    xNOTbN9 bN9 b_buff9 vdd vss MYNOT
    xNOTa10  a10  aN10     vdd vss MYNOT
    xNOTaN10 aN10 a_buff10 vdd vss MYNOT
    xNOTb10  b10  bN10     vdd vss MYNOT
    xNOTbN10 bN10 b_buff10 vdd vss MYNOT
    xNOTa11  a11  aN11     vdd vss MYNOT
    xNOTaN11 aN11 a_buff11 vdd vss MYNOT
    xNOTb11  b11  bN11     vdd vss MYNOT
    xNOTbN11 bN11 b_buff11 vdd vss MYNOT
    xNOTa12  a12  aN12     vdd vss MYNOT
    xNOTaN12 aN12 a_buff12 vdd vss MYNOT
    xNOTb12  b12  bN12     vdd vss MYNOT
    xNOTbN12 bN12 b_buff12 vdd vss MYNOT
    xNOTa13  a13  aN13     vdd vss MYNOT
    xNOTaN13 aN13 a_buff13 vdd vss MYNOT
    xNOTb13  b13  bN13     vdd vss MYNOT
    xNOTbN13 bN13 b_buff13 vdd vss MYNOT
    xNOTa14  a14  aN14     vdd vss MYNOT
    xNOTaN14 aN14 a_buff14 vdd vss MYNOT
    xNOTb14  b14  bN14     vdd vss MYNOT
    xNOTbN14 bN14 b_buff14 vdd vss MYNOT
    xNOTa15  a15  aN15     vdd vss MYNOT
    xNOTaN15 aN15 a_buff15 vdd vss MYNOT
    xNOTb15  b15  bN15     vdd vss MYNOT
    xNOTbN15 bN15 b_buff15 vdd vss MYNOT


Xadder a_buff0 a_buff1 a_buff2 a_buff3 a_buff4 a_buff5 a_buff6 a_buff7 a_buff8 a_buff9 a_buff10
+ a_buff11 a_buff12 a_buff13 a_buff14 a_buff15 b_buff0 b_buff1 b_buff2 b_buff3 b_buff4 b_buff5 b_buff6 b_buff7 b_buff8 b_buff9 b_buff10
+ b_buff11 b_buff12 b_buff13 b_buff14 b_buff15 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 vdd vss ADDER

   
    xNOT1  s1 sN1 vdd2 vss MYNOT multfac = 16
    xNOT2  s2 sN2 vdd2 vss MYNOT multfac = 16
    xNOT3  s3 sN3 vdd2 vss MYNOT multfac = 16
    xNOT4  s4 sN4 vdd2 vss MYNOT multfac = 16
    xNOT5  s5 sN5 vdd2 vss MYNOT multfac = 16
    xNOT6  s6 sN6 vdd2 vss MYNOT multfac = 16
    xNOT7  s7 sN7 vdd2 vss MYNOT multfac = 16
    xNOT8  s8 sN8 vdd2 vss MYNOT multfac = 16
    xNOT9  s9 sN9 vdd2 vss MYNOT multfac = 16
    xNOT10  s10 sN10 vdd2 vss MYNOT multfac = 16
    xNOT11  s11 sN11 vdd2 vss MYNOT multfac = 16
    xNOT12  s12 sN12 vdd2 vss MYNOT multfac = 16
    xNOT13  s13 sN13 vdd2 vss MYNOT multfac = 16
    xNOT14  s14 sN14 vdd2 vss MYNOT multfac = 16
    xNOT15  s15 sN15 vdd2 vss MYNOT multfac = 16
    xNOT16  s16 sN16 vdd2 vss MYNOT multfac = 16



* Brent-Kung Adder subcircuit
*-----------------------------
.SUBCKT ADDER a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 vdd vss
    xGenProp0 a0 b0 gen0 prop0 vdd vss GenProp      multfac=1 
    xGenProp1 a1 b1 gen1 prop1 vdd vss GenProp      multfac=1 
    xGenProp2 a2 b2 gen2 prop2 vdd vss GenProp      multfac=1 
    xGenProp3 a3 b3 gen3 prop3 vdd vss GenProp      multfac=1 
    xGenProp4 a4 b4 gen4 prop4 vdd vss GenProp      multfac=1 
    xGenProp5 a5 b5 gen5 prop5 vdd vss GenProp      multfac=1 
    xGenProp6 a6 b6 gen6 prop6 vdd vss GenProp      multfac=1 
    xGenProp7 a7 b7 gen7 prop7 vdd vss GenProp      multfac=1 

    xGenProp8 a8 b8 gen8 prop8 vdd vss GenProp
    xGenProp9 a9 b9 gen9 prop9 vdd vss GenProp
    xGenProp10 a10 b10 gen10 prop10 vdd vss GenProp
    xGenProp11 a11 b11 gen11 prop11 vdd vss GenProp
    xGenProp12 a12 b12 gen12 prop12 vdd vss GenProp
    xGenProp13 a13 b13 gen13 prop13 vdd vss GenProp
    xGenProp14 a14 b14 gen14 prop14 vdd vss GenProp
    xGenProp15 a15 b15 gen15 prop15 vdd vss GenProp

    xDotOperator_a_0 gen0 gen1 prop1 gen1_0 vdd vss DotOperatorSimpleNormalIn                           multfac=1 
    xDotOperator_a_1 gen2 prop2 gen3 prop3 gen3_2 prop3_2 vdd vss DotOperatorNormalIn                   multfac=1 
    xDotOperator_a_2 gen4 prop4 gen5 prop5 gen5_4 prop5_4 vdd vss DotOperatorNormalIn                   multfac=1 
    xDotOperator_a_3 gen6 prop6 gen7 prop7 gen7_6 prop7_6 vdd vss DotOperatorNormalIn                   multfac=1 

    xDotOperator_a_4 gen8 prop8 gen9 prop9 gen9_8 prop9_8 vdd vss DotOperatorNormalIn
    xDotOperator_a_5 gen10 prop10 gen11 prop11 gen11_10 prop11_10 vdd vss DotOperatorNormalIn
    xDotOperator_a_6 gen12 prop12 gen13 prop13 gen13_12 prop13_12 vdd vss DotOperatorNormalIn
    xDotOperator_a_7 gen14 prop14 gen15 prop15 gen15_14 prop15_14 vdd vss DotOperatorNormalIn

    xDotOperator_b_0 gen1_0 gen3_2 prop3_2 gen3_0 vdd vss DotOperatorSimpleInvertedIn                   multfac=1 
    XBUF3    gen3_0 gen3_0buf vdd vss MYBUF multfac=1  * buffer so crit path drives less
    
    xDotOperator_b_1 gen5_4 prop5_4 gen7_6 prop7_6 gen7_4 prop7_4 vdd vss DotOperatorInvertedIn         multfac=1 

    xDotOperator_b_2 gen9_8 prop9_8 gen11_10 prop11_10 gen11_8 prop11_8 vdd vss DotOperatorInvertedIn
    xDotOperator_b_3 gen13_12 prop13_12 gen15_14 prop15_14 gen15_12 prop15_12 vdd vss DotOperatorInvertedIn

    xDotOperator_c_0 gen3_0 gen7_4 prop7_4 gen7_0 vdd vss DotOperatorSimpleNormalIn multfac=1

    XBUF7  gen7_0 gen7_0buf vdd vss MYBUF multfac=1  * buffer so crit path drives less

    xDotOperator_c_1 gen11_8 prop11_8 gen15_12 prop15_12 gen15_8 prop15_8 vdd vss DotOperatorNormalIn

    xDotOperator_d_0 gen7_0 gen15_8 prop15_8 gen15_0 vdd vss DotOperatorSimpleInvertedIn

    xDotOperator_l_1 gen7_0 gen11_8 prop11_8 gen11_0 vdd vss DotOperatorSimpleNormalHighInvertedLow     multfac=1.7 

    xDotOperator_m_1 gen3_0buf gen5_4 prop5_4 gen5_0 vdd vss DotOperatorSimpleInvertedHighNormalLow
    xDotOperator_m_2 gen7_0 gen9_8 prop9_8 gen9_0 vdd vss DotOperatorSimpleInvertedIn                   multfac=1 
    xDotOperator_m_3 gen11_0 gen13_12 prop13_12 gen13_0 vdd vss DotOperatorSimpleInvertedHighNormalLow  multfac=1.7 

    xDotOperator_n_1 gen1_0 gen2 prop2 gen2_0 vdd vss DotOperatorSimpleNormalHighInvertedLow
    xDotOperator_n_2 gen3_0buf gen4 prop4 gen4_0 vdd vss DotOperatorSimpleNormalIn
    xDotOperator_n_3 gen5_0 gen6 prop6 gen6_0 vdd vss DotOperatorSimpleNormalHighInvertedLow
    xDotOperator_n_4 gen7_0buf gen8 prop8 gen8_0 vdd vss DotOperatorSimpleNormalHighInvertedLow
    xDotOperator_n_5 gen9_0 gen10 prop10 gen10_0 vdd vss DotOperatorSimpleNormalIn                      multfac=1
    xDotOperator_n_6 gen11_0 gen12 prop12 gen12_0 vdd vss DotOperatorSimpleNormalIn                     multfac=1 
    xDotOperator_n_7 gen13_0 gen14 prop14 gen14_0 vdd vss DotOperatorSimpleNormalHighInvertedLow        multfac=1.7 

    xXOR_0 prop0 vss    s0 vdd vss MYXOR        multfac=1 
    xXOR_1 prop1 gen0   s1 vdd vss MYXOR        multfac=1 
    xXOR_2 prop2 gen1_0 s2 vdd vss MYNOTXOR     multfac=1 
    xXOR_3 prop3 gen2_0 s3 vdd vss MYXOR        multfac=1  
    xXOR_4 prop4 gen3_0buf s4 vdd vss MYXOR     multfac=1 
    xXOR_5 prop5 gen4_0 s5 vdd vss MYNOTXOR     multfac=1 
    xXOR_6 prop6 gen5_0 s6 vdd vss MYNOTXOR     multfac=1 
    xXOR_7 prop7 gen6_0 s7 vdd vss MYXOR        multfac=1 
    xXOR_8 prop8 gen7_0buf s8 vdd vss MYNOTXOR     multfac=1
    xXOR_9 prop9 gen8_0 s9 vdd vss MYXOR        multfac=1.6
    xXOR_10 prop10 gen9_0 s10 vdd vss MYXOR     multfac=1
    xXOR_11 prop11 gen10_0 s11 vdd vss MYNOTXOR multfac=1.1
    xXOR_12 prop12 gen11_0 s12 vdd vss MYXOR    multfac=1
    xXOR_13 prop13 gen12_0 s13 vdd vss MYNOTXOR multfac=1.2
    xXOR_14 prop14 gen13_0 s14 vdd vss MYNOTXOR multfac=1.2
    xXOR_15 prop15 gen14_0 s15 vdd vss MYXOR    multfac=2
    xXOR_16 vss   gen15_0 s16 vdd vss MYXOR     multfac=1
    
.ENDS ADDER


* Other subcircuits
*-------------------
.SUBCKT MYNAND inputA inputB output vdd vss multfac='1'
    xM1 output inputA int   vss MOSN w='multfac*120e-9 * 1 *2.6 *1 ' l=4.5e-08 
    xM2 int    inputB vss   vss MOSN w='multfac*120e-9 * 1 *2.6 *1 ' l=4.5e-08 
    xM3 output inputA vdd   vdd MOSP w='multfac*120e-9 * 1 *1 '   l=4.5e-08 
    xM4 output inputB vdd   vdd MOSP w='multfac*120e-9 * 1 *1 '   l=4.5e-08 
.ENDS MYNAND

.SUBCKT MYNOR input1 input2 output vdd vss multfac='1'
*    drain  gate   src  bulk
    xMn1 output input1 vss  vss MOSN w='multfac*120e-9 * 1 *1  '                            l=4.5e-08 
    xMn2 output input2 vss  vss MOSN w='multfac*120e-9 * 1 *1  '                            l=4.5e-08 
    xMp1 sp1    input1 vdd  vdd MOSP w='multfac*120e-9 * 1 *2.6 *1 ' l=4.5e-08  * double b/c pMos, anoter b/c for NOR gate nMOS in parallel, and we want equal delays
    xMp2 output input2 sp1  vdd MOSP w='multfac*120e-9 * 1 *2.6 *1 ' l=4.5e-08  * factor 1.5 b/c series has extra node, so extra cap
.ENDS MYNOR

.SUBCKT MYNOT input output vdd vss multfac='1'
    xM1 output input vss    vss MOSN w='multfac*120e-9 * 1 *1 '                       l=4.5e-08 
    xM2 output input vdd    vdd MOSP w='multfac*1 *120e-9 *1 '          l=4.5e-08 
.ENDS MYNOT

.SUBCKT MYXOR inputA inputB  output vdd vss multfac='1'
      *    drain  gate   src  bulk
       xMNA output1  inputA  vss        vss MOSN w='multfac*120e-9* 1 *1 '                 l=4.5e-08 
       xMPA output1  inputA  vdd        vdd MOSP w='multfac*1 *120e-9*1 '    l=4.5e-08 

       xMNB output  inputB  output1     vss MOSN w='multfac*120e-9* 1 *1 '                 l=4.5e-08 
       xMPB output  inputB  inputA      vdd MOSP w='multfac*1 *120e-9*1 '    l=4.5e-08 

       xMNtrans inputB  output1  output vss MOSN w='multfac*120e-9* 1 *1 '                 l=4.5e-08 
       xMPtrans output  inputA  inputB  vdd MOSP w='multfac*1 *120e-9*1 '    l=4.5e-08 
 .ENDS MYXOR

 .SUBCKT MYXNOR inputA inputB output vdd vss multfac='1' 
    xXOR_0 inputA inputB outputInv      vdd vss MYXOR multfac=multfac
    xNOT_1 outputInv output             vdd vss MYNOT multfac=multfac
.ENDS SUBCKT MYXNOR

 .SUBCKT MYNOTXOR inputA inputB output vdd vss multfac='1'
    xNOT_1 inputB inputBInv             vdd vss MYNOT multfac=multfac*2
    xXOR_0 inputA inputBInv output      vdd vss MYXOR multfac=multfac
.ENDS SUBCKT MYXNOR
    
.SUBCKT MYAOI A B C Out vdd vss multfac='1'
    xM3 Out     A  np1      vdd MOSP w='multfac * 2.6 *1 *120e-9' l=4.5e-08 
    xM1 np1     B  vdd      vdd MOSP w='multfac * 1 * 120e-9' l=4.5e-08 
    xM2 np1     C  vdd      vdd MOSP w='multfac * 1 * 120e-9' l=4.5e-08 
    
    xM5 Out     A  vss      vss MOSN w='multfac * 120e-9 * 1 '                             l=4.5e-08 
    xM7 nn1     B  vss      vss MOSN w='multfac * 120e-9 * 2.6 * 1 '              l=4.5e-08 
    xM6 Out     C  nn1      vss MOSN w='multfac * 120e-9 * 2.6 * 1 '              l=4.5e-08 
.ENDS MYAOI

.SUBCKT MYOAI A B C Out vdd vss multfac='1'
    xM1 np1     B  vdd      vdd MOSP w='multfac * 120e-9 * 1 *2.6 ' l=4.5e-08 
    xM2 Out     C  np1      vdd MOSP w='multfac * 120e-9 * 1 *2.6 ' l=4.5e-08 
    xM3 Out     A  vdd      vdd MOSP w='multfac * 120e-9 * 1 '                 l=4.5e-08 
    
    xM5 Out     A  nn1      vss MOSN w='multfac * 120e-9 * 1 *2.6 '                l=4.5e-08 
    xM6 nn1     C  vss      vss MOSN w='multfac * 120e-9 * 1 '                l=4.5e-08 
    xM7 nn1     B  vss      vss MOSN w='multfac * 120e-9 * 1 '                l=4.5e-08 
.ENDS MYOAI

.SUBCKT GenProp A B Gen Prop vdd vss multfac='1'
    xNAND A B NGen           vdd vss MYNAND multfac=multfac
    xNOT NGen Gen           vdd vss MYNOT  multfac=multfac*2
    xXOR A B Prop           vdd vss MYXOR  multfac=multfac
.ENDS Genprop

.SUBCKT DotOperatorNormalIn Gen1 Prop1 Gen2 Prop2 NGenOut NPropOut vdd vss multfac='1'
    xAOI Gen2 Prop2 Gen1 NGenOut        vdd vss MYAOI multfac='multfac  * 1 '
    xNAND Prop1 Prop2 NPropOut          vdd vss MYNAND multfac='multfac * 1 '
.ENDS DotOperator

.SUBCKT DotOperatorInvertedIn Gen1 Prop1 Gen2 Prop2 GenOut PropOut vdd vss multfac='1'
    xOAI Gen2 Prop2 Gen1 GenOut         vdd vss MYOAI multfac='multfac * 1 '
    xNOR Prop1 Prop2 PropOut            vdd vss MYNOR multfac='multfac * 1 '
.ENDS DotOperatorInverted

.SUBCKT DotOperatorSimpleNormalIn Gen1 Gen2 Prop2 GenOut vdd vss multfac='1'
    xAOI Gen2 Prop2 Gen1 GenOut      vdd vss MYAOI multfac='multfac * 1 '
.ENDS DotOperatorSimple

.SUBCKT DotOperatorSimpleInvertedIn Gen1 Gen2 Prop2 GenOut vdd vss multfac='1'
    xOAI Gen2 Prop2 Gen1 GenOut         vdd vss MYOAI multfac='multfac * 1 '
.ENDS DotOperatorSimpleInverted

.SUBCKT DotOperatorSimpleNormalHighInvertedLow Gen1 Gen2 Prop2 GenOut vdd vss multfac='1'
    xNOT1 Gen2 Gen2Inv                  vdd vss MYNOT multfac='multfac * 1 ' 
    xNOT2 Prop2 Prop2Inv                vdd vss MYNOT multfac='multfac * 1 '
    xOAI Gen2Inv Prop2Inv Gen1 GenOut   vdd vss MYOAI multfac='multfac * 1 ' 
.ENDS DotOperatorSimpleInverted

.SUBCKT DotOperatorSimpleInvertedHighNormalLow Gen1 Gen2 Prop2 GenOut vdd vss multfac='1'
    xNOT1 Gen2 Gen2Inv                  vdd vss MYNOT multfac='multfac * 1 '
    xNOT2 Prop2 Prop2Inv                vdd vss MYNOT multfac='multfac * 1 '
    xAOI Gen2Inv Prop2Inv Gen1 GenOut   vdd vss MYAOI multfac='multfac * 1 ' 
.ENDS DotOperatorSimpleInverted

.SUBCKT MYBUF input output vdd vss multfac='1'
Xnot1         input out1   vdd vss MYNOT multfac=multfac 
Xnot2         out1  output vdd vss MYNOT multfac=multfac 
.ENDS MYBUF

.END
