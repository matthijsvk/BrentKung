%% Simulate delay for all paths
clear;
close all;

startIndex = 9;
%pathIndexArray = startIndex:16;
pathIndexArray = [ 9 15 ] %only simulate most important paths

delayarray = zeros(size(pathIndexArray));
energyarray = zeros(size(pathIndexArray));
DCpowerarray = zeros(size(pathIndexArray));
EDParray = zeros(size(pathIndexArray));

displayOn = 0;

for j=1:length(pathIndexArray)
    pathIndex = pathIndexArray(j);
    Adder16b;
    delayarray(j) = delay*1e12;
    energyarray(j) = SwitchingEnergyWC*1e15;
    DCpowerarray(j) = DCpower*1e9;
    EDParray(j) = delayarray(j) * energyarray(j);
end

delayarray
energyarray
EDParray
DCpowerarray

[largestDelay, delayIndex] = max(delayarray);
[largestEnergy, energyIndex] = max(energyarray);
[largestDC, DCindex] = max(DCpowerarray);
[largestEDP, EDPindex] = max(EDParray);

disp(['Worst Case delay =            ' num2str(largestDelay),' ps'])
%disp(['at: s',num2str(startIndex-1 + delayIndex)]);
disp(['Worst Case Switching energy = ',num2str(largestEnergy),' fJ'])
disp(['Worst Case DC power =         ',num2str(largestDC),' nW'])
disp(['Worst Case EDP =              ',num2str(largestEDP), ' ps*fJ'])


[y,i]=sort(delayarray);
if length(i)>=5  % this only works if pathIndex contains succcessive numbers
    disp(['five most critical paths are: ',num2str(startIndex-1 + i(end-4:end))])
elseif length(i)>=3
    disp(['three most critical paths are: ',num2str(startIndex-1 + i(end-2:end))])
else
    disp(['most critical path is: ',num2str(startIndex-1 + i(end))])
end