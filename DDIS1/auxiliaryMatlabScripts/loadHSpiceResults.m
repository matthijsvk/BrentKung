if( result == 0)
    spicefilestring = strcat(pwd,'/spicefiles/');
    
    transientFileString = strcat(spicefilestring,inputfile,'.tr0');
    if(exist(transientFileString,'file') == 2)
        transientsim = loadsig(transientFileString);
    end
    
    acFileString = strcat(spicefilestring,inputfile,'.ac0');
    if(exist(acFileString,'file') == 2)
        acsim = loadsig(acFileString);
    end
else
    lisstring = [pwd, '/spicefiles/', inputfile, '.lis'];
    type(lisstring)
    error('Hspice failed')
end

clear result
clear transientFileString
clear acFileString
clear spicefilestring