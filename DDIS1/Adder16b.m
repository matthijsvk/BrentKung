%% initiate the simulation

% clear all;
% close all;
% clc;
inputfile = 'Adder16b_BrentKung_Speed511ps';
clear transientsim
clear acsim
close all

if (exist('supply', 'var') == 0)
    supply = 1; 
end

if (exist('pathIndex', 'var') == 0)  % for running GenerateOverview.m
    pathIndex = 15
end

globals.pathIndex = pathIndex;
globals.supply = supply;

tic;
runSpice;
toc

%type(['spicefiles/',inputfile, '.err0']);
%% calculate the characteristics

vdd = globals.supply;

%- delay calculation -
%---------------------
time        = evalsig(transientsim, 'TIME');
b0          = evalsig(transientsim, 'b_buff0');

b0Crossing  = findPositiveZeroCrossings(time,b0-vdd/2);
%close all;
%figure;hold on;
%plot(time,b0);
for i = 0:16
    signal = evalsig(transientsim, [ 's',num2str(i)]);
    sCrossP{i+1} = findPositiveZeroCrossings(time, signal-vdd/2);
    sCrossN{i+1} = findNegativeZeroCrossings(time, signal-vdd/2);
%    if (i == pathIndex)
%        plot(time,signal);
%    end
    sum{i+1} = signal;
end
%legend('b0','s11','s15');

delay = (sCrossP{pathIndex+1}(1) - b0Crossing(1));

%- Power calculations -
%----------------------
I_vdd   = evalsig(transientsim, 'I_vdd');
n = 3; % amount of patterns simulated
Charge = zeros(n,1);
for i = 1:n
    if i == 1
        begintime = 0;
        endtime = 4e-9*i-0.2e-9;
    else
        begintime = 4e-9*(i-1)-0.2e-9;
        endtime = 4e-9*i-0.2e-9;
    end
    if begintime == 0
        beginindex = 1;
    else
        beginindex = getElementNumber(time,begintime);
    end
    endindex = getElementNumber(time,endtime);
    Charge(i) = trapz(time(beginindex:endindex),I_vdd(beginindex:endindex));
end

Energy = -Charge*vdd;
SwitchingEnergyWC = Energy(3); % energy of the switching event
DCpower = Energy(2)/4e-9; % power = energy/time


%- Output generation -
%---------------------
if( exist('displayOn','var') == 0)
    displayOn = 1;
end

if(displayOn)
    disp(' ');
    disp(['Worst Case delay from standard            = 954.8071 ps'])
    %disp(' ')
    disp(['Worst Case Switching energy from standard = 275.3986 fJ'])
    disp(' ');
    disp(['Worst Case delay  spec      = 650 ps'])
    disp(' ');
    disp(['Worst Case delay            = ' num2str(delay*1e12),' ps'])
    %disp(' ')
    disp(['Worst Case Switching energy = ',num2str(SwitchingEnergyWC*1e15),' fJ'])
    %disp(' ')
    disp(['DC power consumption        = ',num2str(DCpower*1e9),' nW'])
    
    type(['spicefiles/',inputfile, '.err0'])
end
