%% Simulate data over a range of supply voltages
clear all;
close all;
clc;

pathIndex = 15; %critical path (from sweepCP.m)
supplyarray = 0.92:0.005:0.95;
delayarray = zeros(size(supplyarray));
energyarray = zeros(size(supplyarray));
DCpowerarray = zeros(size(supplyarray));
EDParray = zeros(size(supplyarray));

displayOn = 0;
for j=1:numel(supplyarray)
    supply = supplyarray(j);
    Adder16b;
    delayarray(j) = delay*1e12;
    energyarray(j) = SwitchingEnergyWC*1e15;
    DCpowerarray(j) = DCpower*1e9;
    EDParray(j) = delay * 1e12 * SwitchingEnergyWC*1e15;
    
    disp(['supply:  ',num2str(supply)])
    disp(['delay:   ',num2str(delayarray(j))])
    disp(['energy:  ',num2str(energyarray(j))])
    disp(['DCpower: ',num2str(DCpowerarray(j))])
    disp(['EDP:     ',num2str(EDParray(j))])
end

figure
XY= [delayarray;energyarray]'
plot(delayarray,energyarray);
xlabel('delay (ps)') % x-axis label
ylabel('switching energy (fJ)') % y-axis label
title('Delay vs energy at different supply voltages')
% add labels to the points
for K = 1 : numel(supplyarray)
  thisX = XY(K,1);
  thisY = XY(K,2);
  labelstr = sprintf('%.2fps @ %.2f fJ', thisX, thisY);
  text(thisX, thisY, labelstr);
end
%% Generate LaTeX document

% homepath = pwd;
% cd Report/figures
% system('pdflatex Brent-Kung_tex.tex');
% cd ..
% system('pdflatex Template_report.tex');
% cd(homepath)

disp(delayarray)

if min(delayarray) > 650%e-12
    display('Warning, your project does not yet meet')
    display('the requirements in terms of speed')
else
    v_650ps = interp1(delayarray, supplyarray, 650);
    e_650ps = interp1(supplyarray, energyarray, v_650ps);
    p_650ps = interp1(supplyarray, DCpowerarray, v_650ps);
    display(' ')
    display(' ')
    display(' ')
    display(' ')
    display(['Your project has supply voltage of ', num2str(v_650ps), ' V,'])
    display(['a delay of                         ', num2str(min(delayarray)), ' ps,'])
    display(['a worst case switching energy of   ', num2str(e_650ps), ' fJ,'])
    display(['a DC power consumption of          ', num2str(p_650ps), ' nW.'])
    display(' ')
    display('Please add this to your report')
end

close all
