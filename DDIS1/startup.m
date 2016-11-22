!source ~micasusr/design/scripts/hspice_2012.06.rc

clc
clear all

basepath = pwd;

cd(basepath)

hspicepath = strcat(basepath, '/Resources/HspiceToolbox/');
mat2spicepath = strcat(basepath, '/Resources/mat2spice/');
mat2spicepath2 = strcat(basepath, '/Resources/mat2spice/bus/');
auxiliaryMatlabScriptspath = strcat(basepath, '/auxiliaryMatlabScripts/');
addpath( hspicepath );
addpath( mat2spicepath );
addpath( mat2spicepath2 );
addpath( auxiliaryMatlabScriptspath );

clear all
clc
