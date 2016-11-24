% inputfilestring = strcat(pwd,'/spicefiles/',inputfile,'.sp');
% outputdirectory = strcat(pwd,'/spicefiles/');
% 
% hspicestring = ['source ~micasusr/design/scripts/hspice.rc && hspice -i ', inputfilestring, ' -o ', outputdirectory];
% result = system(hspicestring);
% 
% clear inputfilestring
% clear outputdirectory
% clear hspicestring

name_tempfolder = 'temp_m2s';
system(['mkdir ~/', name_tempfolder]);
system(['cp ',pwd, '/spicefiles/* ~/',name_tempfolder]);

inputfilestring = strcat('~/',name_tempfolder,'/',inputfile,'.sp');
outputdirectory = strcat('~/',name_tempfolder);

hspicestring = ['export SNPSLMD_LICENSE_FILE=27020@saturn && source ~micasusr/design/scripts/hspice.rc && hspice -i ' ...
    , inputfilestring, ' -o ', outputdirectory];

% hspicestring = ['export SNPSLMD_LICENSE_FILE=27020@saturn && source ~micasusr/design/scripts/hspice.rc && hspice -i ', inputfilestring];

result = system(hspicestring);

system(['cp ~/',name_tempfolder, '/* ', pwd, '/spicefiles']);

clear inputfilestring
clear outputdirectory
clear hspicestring
clear name_tempfolder