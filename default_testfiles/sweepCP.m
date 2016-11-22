%% Simulate data over a range of supply voltages
clear;
close all;
clc;


%pathIndexArray = 6:16;
pathIndexArray = [9 15];
delayarray = zeros(size(pathIndexArray));
energyarray = zeros(size(pathIndexArray));
DCpowerarray = zeros(size(pathIndexArray));

displayOn = 0;
for j=1:length(pathIndexArray)
    pathIndex = pathIndexArray(j);
    Adder16b;
    delayarray(j) = delay;
    energyarray(j) = SwitchingEnergyWC;
    DCpowerarray(j) = DCpower;
end

delayarray*1e12
[largestDelay, delayindex] = max(delayarray);
[largestEnergy, energyindex] = max(energyarray);
[largestDC, DCindex] = max(DCpowerarray);

disp(['Worst Case delay            = ' num2str(largestDelay*1e12),' ps'])
disp(['at: s',num2str(delayindex)]);
disp(['Worst Case Switching energy = ',num2str(largestEnergy*1e15),' fJ'])
disp(['Worst Case DC power         = ',num2str(largestDC*1e9),' nW'])

[y,i]=sort(delayarray);
disp(['five most critcal paths are: ',num2str(i(end-4:end))])