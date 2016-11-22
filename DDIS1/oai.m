%% Setup and run the simulation
clear transientsim
clear acsim
inputfile = 'oai';
runSpice;

%% Plot the output and calculate the delay
plotsig(transientsim, 'in1,in2,in3;out');  %The transient simulation is stored in transientsim, make a plot

time        = evalsig(transientsim, 'TIME');
n1          = evalsig(transientsim, 'in1');
n2          = evalsig(transientsim, 'out');
n1Crossing  = findPositiveZeroCrossings(time, n1 - globals.supply/2); %Calculate the time when the n1 crosses vdd/22
n2Crossing  = findNegativeZeroCrossings(time, n2 - globals.supply/2);


delay = (n2Crossing(2:end-1) - n1Crossing(2:end-1))*1e12; % in ps
disp(' ');
disp(strcat(num2str(delay),' ps'))
disp(' ');
displayNodalCapacitance; % Show the capacitance table if calculated.


% calculate energy consumption
I_vdd =  evalsig(transientsim, 'I_vdd');
vdd = evalsig(transientsim, 'vdd');
nb_cycles = 2.5; %hard coded, see figure
% energy = power * time = I * vdd * time(1 cycle)
energy = abs(I_vdd' * vdd * time(end)) / nb_cycles;

% calculate leakage power -> vin must be set to 0 in spice file!!
% I_vdd =  evalsig(transientsim, 'i_vdd');
% vdd = evalsig(transientsim, 'v_vdd');
% leakage_power = abs(I_vdd' * vdd)/size(I_vdd,1)

%% Print the results of the .vec
type(['spicefiles/', inputfile, '.err0'])



