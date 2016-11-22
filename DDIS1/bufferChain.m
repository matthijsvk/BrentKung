%% Setup and run the simulation
clear transientsim
clear acsim
inputfile = 'bufferChain';
runSpice;

%% Plot the output and calculate the delay
plotsig(transientsim, 'in0, out');  %The transient simulation is stored in transientsim, make a plot

time        = evalsig(transientsim, 'TIME');
n1          = evalsig(transientsim, 'in0');
n2          = evalsig(transientsim, 'out');
n1Crossing  = findPositiveZeroCrossings(time, n1 - globals.supply/2); %Calculate the time when the n1 crosses vdd/2
n2Crossing  = findNegativeZeroCrossings(time, n2 - globals.supply/2);

delay = (n2Crossing(1) - n1Crossing(1))*1e12;
disp(' ');
disp(strcat(num2str(delay),' ps'))

I_vdd       = evalsig(transientsim,'I_vdd');
begintime   = 1.99e-9;
endtime     = 5.99e-9;
beginindex  = getElementNumber(time,begintime);
endindex    = getElementNumber(time,endtime);
ChargeConsumption = - trapz(time(beginindex:endindex), I_vdd(beginindex:endindex));
EnergyConsumption = ChargeConsumption*globals.supply;
disp([num2str(EnergyConsumption*1e15), ' fJ'])

%% Print the results of the .vec
type(['spicefiles/', inputfile, '.err0'])
