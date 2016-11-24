function m2s = m2s_run(m2s,globals);function m2s_outstr = m2s_arg2str(m2s_instr);m2s_outstr = m2s_instr;for m2s_I=1:length(m2s_instr);if isnumeric(m2s_instr{m2s_I});if length(m2s_instr{m2s_I})>1m2s_outstr{m2s_I} = mat2str(m2s_instr{m2s_I},8);m2s_outstr{m2s_I} = m2s_outstr{m2s_I}(2:end-1);else;m2s_outstr{m2s_I} = num2str(m2s_instr{m2s_I},8);end;elseif islogical(m2s_instr{m2s_I});m2s_outstr{m2s_I} = num2str(m2s_instr{m2s_I});end;end;end;function m2s_outstr=m2s_cell2str(m2s_instr);m2s_outstr=cell2mat(cellfun(@(m2s_x) [m2s_x sprintf('\n')],m2s_instr,'UniformOutput',0));m2s_outstr=m2s_outstr(1:end-1);end;function varargout = m2s_emptyfn(varargin);throwAsCaller(MException('M2S:FnErr','function called before it has been initialized with $include, $insert or $import'));end;
m2s_file_DDIS_Design_VanKeirsbilck_Matthijs();
function m2s_file_DDIS_Design_VanKeirsbilck_Matthijs(); m2s.DDIS_Design_VanKeirsbilck_Matthijs.currentline = 0;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s.DDIS_Design_VanKeirsbilck_Matthijs.currentline=m2s.DDIS_Design_VanKeirsbilck_Matthijs.currentline+1;m2s.DDIS_Design_VanKeirsbilck_Matthijs.outstr{m2s.DDIS_Design_VanKeirsbilck_Matthijs.currentline}=sprintf(m2s_format,m2s_args{:});end;
m2s_write('******************************',{});
m2s_write('**** 16b Brent-Kung adder ****',{});
m2s_write('******************************',{});
m2s_write('.param supply = %s',{globals.supply});
m2s_write('.param halfsupply = %s',{globals.supply/2});
m2s_write('',{});
m2s_write('',{});
m2s_write('* Some simulation options',{});
m2s_write('*-------------------------',{});
m2s_write('.options post nomod',{});
m2s_write('.option opts fast parhier=local',{});
m2s_write('',{});
m2s_write('.lib ''%s '' tt',{ strcat(pwd, '/Resources/Technology/tech_wrapper.lib') });
m2s_write('.tran 0.005n 36n',{});
m2s_write('* .vec ''%s''',{ strcat(pwd, '/m2sfiles/Adder16b.vec')});
m2s_write('.vec ''%s''',{ strcat(pwd, strcat('/m2sfiles/Adder16b',strcat(num2str(globals.pathIndex),'.vec')))});
m2s_write('',{});
m2s_write('',{});
m2s_write('.probe i',{});
m2s_write('',{});
m2s_write('.param supply = %s * 0.933 for power@650ps, 1V for speed',{globals.supply});
m2s_write('',{});
m2s_write('Vdd vdd vss supply',{});
m2s_write('Vdd2 vdd2 vss supply',{});
m2s_write('Vss vss 0 0 ',{});
m2s_write('',{});
m2s_write('',{});
m2s_write('* Sizing Parameters',{});
m2s_write('* ------------------',{});
nandnorFactor=1;                           %make NAND and NOR  faster
nMosFactor=1;
pMosFactor=1;                  %1.6 speed, 1.0 power, 1.0 balance       % size of PMOS vs NMOS  
seriesFactor=2.6;                %5.3 speed, 1.8 power, 2.5 balance               
m2s_write('',{});
criticalPathBaseFactor=1;      %1.27 speed, 1.3 power, 1.5 balance
criticalPath1Factor=1.89;         %1.27 speed, 1.3 power, 1.5 balance
criticalPath2Factor=1;
bufFactor=1; 
m2s_write('',{});
DotOperatorFactor=1;               % scale the dot operators
DotOperatorInvertedFactor=1;
DotOperatorSimpleNormalFactor=1;
DotOperatorSimpleInvertedFactor=1;
DotOperatorSimpleIHNLFactor=1;      
DotOperatorSimpleNHILFactor=1;
m2s_write('',{});
XORFactor=1;
inverterFactor=1;
m2s_write('',{});
length=45e-9;                  %transistor length
m2s_write('',{});
 if (globals.pathIndex == 15)
   disp(pMosFactor); disp(seriesFactor);disp(criticalPathBaseFactor);disp(criticalPath1Factor);disp(criticalPath2Factor);
 end
m2s_write('',{});
m2s_write('* Actual circuit',{});
m2s_write('*----------------',{});
 n = 16;
 for j = 0:n-1
m2s_write('    xNOTa%s  a%s  aN%s     vdd vss MYNOT',{j,j,j});
m2s_write('    xNOTaN%s aN%s a_buff%s vdd vss MYNOT',{j,j,j});
m2s_write('    xNOTb%s  b%s  bN%s     vdd vss MYNOT',{j,j,j});
m2s_write('    xNOTbN%s bN%s b_buff%s vdd vss MYNOT',{j,j,j});
 end
m2s_write('',{});
m2s_write('',{});
m2s_write('Xadder %s %s %s vdd vss ADDER',{xbus('a_buff',0:15),xbus('b_buff',0:15),xbus('s',0:16)});
m2s_write('',{});
m2s_write('   ',{});
 for i = 1:16
m2s_write('    xNOT%s  s%s sN%s vdd2 vss MYNOT multfac = 16',{i,i,i});
 end
m2s_write('',{});
m2s_write('',{});
m2s_write('',{});
m2s_write('* Brent-Kung Adder subcircuit',{});
m2s_write('*-----------------------------',{});
m2s_write('.SUBCKT ADDER a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 vdd vss',{});
m2s_write('    xGenProp0 a0 b0 gen0 prop0 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xGenProp1 a1 b1 gen1 prop1 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xGenProp2 a2 b2 gen2 prop2 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xGenProp3 a3 b3 gen3 prop3 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xGenProp4 a4 b4 gen4 prop4 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xGenProp5 a5 b5 gen5 prop5 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xGenProp6 a6 b6 gen6 prop6 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xGenProp7 a7 b7 gen7 prop7 vdd vss GenProp      multfac=%s ',{criticalPathBaseFactor});
m2s_write('',{});
m2s_write('    xGenProp8 a8 b8 gen8 prop8 vdd vss GenProp',{});
m2s_write('    xGenProp9 a9 b9 gen9 prop9 vdd vss GenProp',{});
m2s_write('    xGenProp10 a10 b10 gen10 prop10 vdd vss GenProp',{});
m2s_write('    xGenProp11 a11 b11 gen11 prop11 vdd vss GenProp',{});
m2s_write('    xGenProp12 a12 b12 gen12 prop12 vdd vss GenProp',{});
m2s_write('    xGenProp13 a13 b13 gen13 prop13 vdd vss GenProp',{});
m2s_write('    xGenProp14 a14 b14 gen14 prop14 vdd vss GenProp',{});
m2s_write('    xGenProp15 a15 b15 gen15 prop15 vdd vss GenProp',{});
m2s_write('',{});
m2s_write('    xDotOperator_a_0 gen0 gen1 prop1 gen1_0 vdd vss DotOperatorSimpleNormalIn                           multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xDotOperator_a_1 gen2 prop2 gen3 prop3 gen3_2 prop3_2 vdd vss DotOperatorNormalIn                   multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xDotOperator_a_2 gen4 prop4 gen5 prop5 gen5_4 prop5_4 vdd vss DotOperatorNormalIn                   multfac=%s ',{criticalPathBaseFactor});
m2s_write('    xDotOperator_a_3 gen6 prop6 gen7 prop7 gen7_6 prop7_6 vdd vss DotOperatorNormalIn                   multfac=%s ',{criticalPathBaseFactor});
m2s_write('',{});
m2s_write('    xDotOperator_a_4 gen8 prop8 gen9 prop9 gen9_8 prop9_8 vdd vss DotOperatorNormalIn',{});
m2s_write('    xDotOperator_a_5 gen10 prop10 gen11 prop11 gen11_10 prop11_10 vdd vss DotOperatorNormalIn',{});
m2s_write('    xDotOperator_a_6 gen12 prop12 gen13 prop13 gen13_12 prop13_12 vdd vss DotOperatorNormalIn',{});
m2s_write('    xDotOperator_a_7 gen14 prop14 gen15 prop15 gen15_14 prop15_14 vdd vss DotOperatorNormalIn',{});
m2s_write('',{});
m2s_write('    xDotOperator_b_0 gen1_0 gen3_2 prop3_2 gen3_0 vdd vss DotOperatorSimpleInvertedIn                   multfac=%s ',{criticalPathBaseFactor});
m2s_write('    XBUF3    gen3_0 gen3_0buf vdd vss MYBUF multfac=%s  * buffer so crit path drives less',{bufFactor});
m2s_write('    ',{});
m2s_write('    xDotOperator_b_1 gen5_4 prop5_4 gen7_6 prop7_6 gen7_4 prop7_4 vdd vss DotOperatorInvertedIn         multfac=%s ',{criticalPathBaseFactor});
m2s_write('',{});
m2s_write('    xDotOperator_b_2 gen9_8 prop9_8 gen11_10 prop11_10 gen11_8 prop11_8 vdd vss DotOperatorInvertedIn',{});
m2s_write('    xDotOperator_b_3 gen13_12 prop13_12 gen15_14 prop15_14 gen15_12 prop15_12 vdd vss DotOperatorInvertedIn',{});
m2s_write('',{});
m2s_write('    xDotOperator_c_0 gen3_0 gen7_4 prop7_4 gen7_0 vdd vss DotOperatorSimpleNormalIn multfac=%s',{criticalPathBaseFactor});
m2s_write('',{});
m2s_write('    XBUF7  gen7_0 gen7_0buf vdd vss MYBUF multfac=%s  * buffer so crit path drives less',{bufFactor});
m2s_write('',{});
m2s_write('    xDotOperator_c_1 gen11_8 prop11_8 gen15_12 prop15_12 gen15_8 prop15_8 vdd vss DotOperatorNormalIn',{});
m2s_write('',{});
m2s_write('    xDotOperator_d_0 gen7_0 gen15_8 prop15_8 gen15_0 vdd vss DotOperatorSimpleInvertedIn',{});
m2s_write('',{});
m2s_write('    xDotOperator_l_1 gen7_0 gen11_8 prop11_8 gen11_0 vdd vss DotOperatorSimpleNormalHighInvertedLow     multfac=%s ',{criticalPath1Factor});
m2s_write('',{});
m2s_write('    xDotOperator_m_1 gen3_0buf gen5_4 prop5_4 gen5_0 vdd vss DotOperatorSimpleInvertedHighNormalLow',{});
m2s_write('    xDotOperator_m_2 gen7_0 gen9_8 prop9_8 gen9_0 vdd vss DotOperatorSimpleInvertedIn                   multfac=%s ',{criticalPath2Factor});
m2s_write('    xDotOperator_m_3 gen11_0 gen13_12 prop13_12 gen13_0 vdd vss DotOperatorSimpleInvertedHighNormalLow  multfac=%s ',{criticalPath1Factor});
m2s_write('',{});
m2s_write('    xDotOperator_n_1 gen1_0 gen2 prop2 gen2_0 vdd vss DotOperatorSimpleNormalHighInvertedLow',{});
m2s_write('    xDotOperator_n_2 gen3_0buf gen4 prop4 gen4_0 vdd vss DotOperatorSimpleNormalIn',{});
m2s_write('    xDotOperator_n_3 gen5_0 gen6 prop6 gen6_0 vdd vss DotOperatorSimpleNormalHighInvertedLow',{});
m2s_write('    xDotOperator_n_4 gen7_0buf gen8 prop8 gen8_0 vdd vss DotOperatorSimpleNormalHighInvertedLow',{});
m2s_write('    xDotOperator_n_5 gen9_0 gen10 prop10 gen10_0 vdd vss DotOperatorSimpleNormalIn                      multfac=%s',{criticalPath2Factor});
m2s_write('    xDotOperator_n_6 gen11_0 gen12 prop12 gen12_0 vdd vss DotOperatorSimpleNormalIn                     multfac=%s ',{criticalPath2Factor});
m2s_write('    xDotOperator_n_7 gen13_0 gen14 prop14 gen14_0 vdd vss DotOperatorSimpleNormalHighInvertedLow        multfac=%s ',{criticalPath1Factor});
m2s_write('',{});
m2s_write('    xXOR_0 prop0 vss    s0 vdd vss MYXOR        multfac=%s ',{XORFactor});
m2s_write('    xXOR_1 prop1 gen0   s1 vdd vss MYXOR        multfac=%s ',{XORFactor});
m2s_write('    xXOR_2 prop2 gen1_0 s2 vdd vss MYNOTXOR     multfac=%s ',{XORFactor});
m2s_write('    xXOR_3 prop3 gen2_0 s3 vdd vss MYXOR        multfac=%s  ',{XORFactor});
m2s_write('    xXOR_4 prop4 gen3_0buf s4 vdd vss MYXOR     multfac=%s ',{XORFactor});
m2s_write('    xXOR_5 prop5 gen4_0 s5 vdd vss MYNOTXOR     multfac=%s ',{XORFactor});
m2s_write('    xXOR_6 prop6 gen5_0 s6 vdd vss MYNOTXOR     multfac=%s ',{XORFactor});
m2s_write('    xXOR_7 prop7 gen6_0 s7 vdd vss MYXOR        multfac=%s ',{XORFactor});
m2s_write('    xXOR_8 prop8 gen7_0buf s8 vdd vss MYNOTXOR     multfac=%s',{XORFactor});
m2s_write('    xXOR_9 prop9 gen8_0 s9 vdd vss MYXOR        multfac=%s',{XORFactor*1.5});
m2s_write('    xXOR_10 prop10 gen9_0 s10 vdd vss MYXOR     multfac=%s',{XORFactor});
m2s_write('    xXOR_11 prop11 gen10_0 s11 vdd vss MYNOTXOR multfac=%s',{XORFactor});
m2s_write('    xXOR_12 prop12 gen11_0 s12 vdd vss MYXOR    multfac=%s',{XORFactor});
m2s_write('    xXOR_13 prop13 gen12_0 s13 vdd vss MYNOTXOR multfac=%s',{XORFactor*1.2});
m2s_write('    xXOR_14 prop14 gen13_0 s14 vdd vss MYNOTXOR multfac=%s',{XORFactor*1.2});
m2s_write('    xXOR_15 prop15 gen14_0 s15 vdd vss MYXOR    multfac=%s',{XORFactor*2});
m2s_write('    xXOR_16 vss   gen15_0 s16 vdd vss MYXOR     multfac=%s',{XORFactor});
m2s_write('    ',{});
m2s_write('.ENDS ADDER',{});
m2s_write('',{});
m2s_write('',{});
m2s_write('* Other subcircuits',{});
m2s_write('*-------------------',{});
m2s_write('.SUBCKT MYNAND inputA inputB output vdd vss multfac=''1''',{});
m2s_write('    xM1 output inputA int   vss MOSN w=''multfac*120e-9 * %s *%s *%s '' l=%s ',{nMosFactor,seriesFactor,nandnorFactor,length});
m2s_write('    xM2 int    inputB vss   vss MOSN w=''multfac*120e-9 * %s *%s *%s '' l=%s ',{nMosFactor,seriesFactor,nandnorFactor,length});
m2s_write('    xM3 output inputA vdd   vdd MOSP w=''multfac*120e-9 * %s *%s ''   l=%s ',{pMosFactor,nandnorFactor,length});
m2s_write('    xM4 output inputB vdd   vdd MOSP w=''multfac*120e-9 * %s *%s ''   l=%s ',{pMosFactor,nandnorFactor,length});
m2s_write('.ENDS MYNAND',{});
m2s_write('',{});
m2s_write('.SUBCKT MYNOR input1 input2 output vdd vss multfac=''1''',{});
m2s_write('*    drain  gate   src  bulk',{});
m2s_write('    xMn1 output input1 vss  vss MOSN w=''multfac*120e-9 * %s *%s  ''                            l=%s ',{nMosFactor,nandnorFactor,length});
m2s_write('    xMn2 output input2 vss  vss MOSN w=''multfac*120e-9 * %s *%s  ''                            l=%s ',{nMosFactor,nandnorFactor,length});
m2s_write('    xMp1 sp1    input1 vdd  vdd MOSP w=''multfac*120e-9 * %s *%s *%s '' l=%s  * double b/c pMos, anoter b/c for NOR gate nMOS in parallel, and we want equal delays',{pMosFactor,seriesFactor,nandnorFactor,length});
m2s_write('    xMp2 output input2 sp1  vdd MOSP w=''multfac*120e-9 * %s *%s *%s '' l=%s  * factor 1.5 b/c series has extra node, so extra cap',{pMosFactor,seriesFactor,nandnorFactor,length});
m2s_write('.ENDS MYNOR',{});
m2s_write('',{});
m2s_write('.SUBCKT MYNOT input output vdd vss multfac=''1''',{});
m2s_write('    xM1 output input vss    vss MOSN w=''multfac*120e-9 * %s *%s ''                       l=%s ',{nMosFactor,inverterFactor,length});
m2s_write('    xM2 output input vdd    vdd MOSP w=''multfac*%s *120e-9 *%s ''          l=%s ',{pMosFactor,inverterFactor,length});
m2s_write('.ENDS MYNOT',{});
m2s_write('',{});
m2s_write('.SUBCKT MYXOR inputA inputB  output vdd vss multfac=''1''',{});
m2s_write('      *    drain  gate   src  bulk',{});
m2s_write('       xMNA output1  inputA  vss        vss MOSN w=''multfac*120e-9* %s *%s ''                 l=%s ',{nMosFactor,XORFactor,length});
m2s_write('       xMPA output1  inputA  vdd        vdd MOSP w=''multfac*%s *120e-9*%s ''    l=%s ',{pMosFactor,XORFactor,length});
m2s_write('',{});
m2s_write('       xMNB output  inputB  output1     vss MOSN w=''multfac*120e-9* %s *%s ''                 l=%s ',{nMosFactor,XORFactor,length});
m2s_write('       xMPB output  inputB  inputA      vdd MOSP w=''multfac*%s *120e-9*%s ''    l=%s ',{pMosFactor,XORFactor,length});
m2s_write('',{});
m2s_write('       xMNtrans inputB  output1  output vss MOSN w=''multfac*120e-9* %s *%s ''                 l=%s ',{nMosFactor,XORFactor,length});
m2s_write('       xMPtrans output  inputA  inputB  vdd MOSP w=''multfac*%s *120e-9*%s ''    l=%s ',{pMosFactor,XORFactor,length});
m2s_write(' .ENDS MYXOR',{});
m2s_write('',{});
m2s_write(' .SUBCKT MYXNOR inputA inputB output vdd vss multfac=''1'' ',{});
m2s_write('    xXOR_0 inputA inputB outputInv      vdd vss MYXOR multfac=multfac',{});
m2s_write('    xNOT_1 outputInv output             vdd vss MYNOT multfac=multfac',{});
m2s_write('.ENDS SUBCKT MYXNOR',{});
m2s_write('',{});
m2s_write(' .SUBCKT MYNOTXOR inputA inputB output vdd vss multfac=''1''',{});
m2s_write('    xNOT_1 inputB inputBInv             vdd vss MYNOT multfac=multfac*2',{});
m2s_write('    xXOR_0 inputA inputBInv output      vdd vss MYXOR multfac=multfac',{});
m2s_write('.ENDS SUBCKT MYXNOR',{});
m2s_write('    ',{});
m2s_write('.SUBCKT MYAOI A B C Out vdd vss multfac=''1''',{});
m2s_write('    xM3 Out     A  np1      vdd MOSP w=''multfac * %s *%s *120e-9'' l=%s ',{seriesFactor,pMosFactor,length});
m2s_write('    xM1 np1     B  vdd      vdd MOSP w=''multfac * %s * 120e-9'' l=%s ',{pMosFactor,length});
m2s_write('    xM2 np1     C  vdd      vdd MOSP w=''multfac * %s * 120e-9'' l=%s ',{pMosFactor,length});
m2s_write('    ',{});
m2s_write('    xM5 Out     A  vss      vss MOSN w=''multfac * 120e-9 * %s ''                             l=%s ',{nMosFactor,length});
m2s_write('    xM7 nn1     B  vss      vss MOSN w=''multfac * 120e-9 * %s * %s ''              l=%s ',{seriesFactor,nMosFactor,length});
m2s_write('    xM6 Out     C  nn1      vss MOSN w=''multfac * 120e-9 * %s * %s ''              l=%s ',{seriesFactor,nMosFactor,length});
m2s_write('.ENDS MYAOI',{});
m2s_write('',{});
m2s_write('.SUBCKT MYOAI A B C Out vdd vss multfac=''1''',{});
m2s_write('    xM1 np1     B  vdd      vdd MOSP w=''multfac * 120e-9 * %s *%s '' l=%s ',{pMosFactor,seriesFactor,length});
m2s_write('    xM2 Out     C  np1      vdd MOSP w=''multfac * 120e-9 * %s *%s '' l=%s ',{pMosFactor,seriesFactor,length});
m2s_write('    xM3 Out     A  vdd      vdd MOSP w=''multfac * 120e-9 * %s ''                 l=%s ',{pMosFactor,length});
m2s_write('    ',{});
m2s_write('    xM5 Out     A  nn1      vss MOSN w=''multfac * 120e-9 * %s *%s ''                l=%s ',{nMosFactor,seriesFactor,length});
m2s_write('    xM6 nn1     C  vss      vss MOSN w=''multfac * 120e-9 * %s ''                l=%s ',{nMosFactor,length});
m2s_write('    xM7 nn1     B  vss      vss MOSN w=''multfac * 120e-9 * %s ''                l=%s ',{nMosFactor,length});
m2s_write('.ENDS MYOAI',{});
m2s_write('',{});
m2s_write('.SUBCKT GenProp A B Gen Prop vdd vss multfac=''1''',{});
m2s_write('    xNAND A B NGen           vdd vss MYNAND multfac=multfac',{});
m2s_write('    xNOT NGen Gen           vdd vss MYNOT  multfac=multfac*2',{});
m2s_write('    xXOR A B Prop           vdd vss MYXOR  multfac=multfac',{});
m2s_write('.ENDS Genprop',{});
m2s_write('',{});
m2s_write('.SUBCKT DotOperatorNormalIn Gen1 Prop1 Gen2 Prop2 NGenOut NPropOut vdd vss multfac=''1''',{});
m2s_write('    xAOI Gen2 Prop2 Gen1 NGenOut        vdd vss MYAOI multfac=''multfac  * %s ''',{DotOperatorFactor});
m2s_write('    xNAND Prop1 Prop2 NPropOut          vdd vss MYNAND multfac=''multfac * %s ''',{DotOperatorFactor});
m2s_write('.ENDS DotOperator',{});
m2s_write('',{});
m2s_write('.SUBCKT DotOperatorInvertedIn Gen1 Prop1 Gen2 Prop2 GenOut PropOut vdd vss multfac=''1''',{});
m2s_write('    xOAI Gen2 Prop2 Gen1 GenOut         vdd vss MYOAI multfac=''multfac * %s ''',{DotOperatorInvertedFactor});
m2s_write('    xNOR Prop1 Prop2 PropOut            vdd vss MYNOR multfac=''multfac * %s ''',{DotOperatorInvertedFactor});
m2s_write('.ENDS DotOperatorInverted',{});
m2s_write('',{});
m2s_write('.SUBCKT DotOperatorSimpleNormalIn Gen1 Gen2 Prop2 GenOut vdd vss multfac=''1''',{});
m2s_write('    xAOI Gen2 Prop2 Gen1 GenOut      vdd vss MYAOI multfac=''multfac * %s ''',{DotOperatorSimpleNormalFactor});
m2s_write('.ENDS DotOperatorSimple',{});
m2s_write('',{});
m2s_write('.SUBCKT DotOperatorSimpleInvertedIn Gen1 Gen2 Prop2 GenOut vdd vss multfac=''1''',{});
m2s_write('    xOAI Gen2 Prop2 Gen1 GenOut         vdd vss MYOAI multfac=''multfac * %s ''',{DotOperatorSimpleInvertedFactor});
m2s_write('.ENDS DotOperatorSimpleInverted',{});
m2s_write('',{});
m2s_write('.SUBCKT DotOperatorSimpleNormalHighInvertedLow Gen1 Gen2 Prop2 GenOut vdd vss multfac=''1''',{});
m2s_write('    xNOT1 Gen2 Gen2Inv                  vdd vss MYNOT multfac=''multfac * %s '' ',{DotOperatorSimpleNHILFactor});
m2s_write('    xNOT2 Prop2 Prop2Inv                vdd vss MYNOT multfac=''multfac * %s ''',{DotOperatorSimpleNHILFactor});
m2s_write('    xOAI Gen2Inv Prop2Inv Gen1 GenOut   vdd vss MYOAI multfac=''multfac * %s '' ',{DotOperatorSimpleNHILFactor});
m2s_write('.ENDS DotOperatorSimpleInverted',{});
m2s_write('',{});
m2s_write('.SUBCKT DotOperatorSimpleInvertedHighNormalLow Gen1 Gen2 Prop2 GenOut vdd vss multfac=''1''',{});
m2s_write('    xNOT1 Gen2 Gen2Inv                  vdd vss MYNOT multfac=''multfac * %s ''',{DotOperatorSimpleIHNLFactor});
m2s_write('    xNOT2 Prop2 Prop2Inv                vdd vss MYNOT multfac=''multfac * %s ''',{DotOperatorSimpleIHNLFactor});
m2s_write('    xAOI Gen2Inv Prop2Inv Gen1 GenOut   vdd vss MYAOI multfac=''multfac * %s '' ',{DotOperatorSimpleIHNLFactor});
m2s_write('.ENDS DotOperatorSimpleInverted',{});
m2s_write('',{});
m2s_write('.SUBCKT MYBUF input output vdd vss multfac=''1''',{});
m2s_write('Xnot1         input out1   vdd vss MYNOT multfac=multfac ',{});
m2s_write('Xnot2         out1  output vdd vss MYNOT multfac=multfac ',{});
m2s_write('.ENDS MYBUF',{});
m2s_write('',{});
m2s_write('.END',{});
m2s_write('',{});
end
end