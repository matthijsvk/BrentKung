% Read txt into cell A

fid = fopen(['./spicefiles/',inputfile,'.sp'],'r');
i = 1;
tline = fgetl(fid);
SPfile{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    SPfile{i} = tline;
end
fclose(fid);

captabFound = 0;
i = 1;
sizeSPfile = size(SPfile);
for i = 1:sizeSPfile(2)
    if (findstr(SPfile{i}, '.options captab') > 0) %#ok<*FSTR>
        if(findstr(SPfile{i}, '*') > 0)
        else
            captabFound = 1;
            break;
        end
    end
end


if(captabFound)
    fid = fopen(['./spicefiles/',inputfile,'.lis'],'r');
    i = 1;
    tline = fgetl(fid);
    Lisfile{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        Lisfile{i} = tline;
    end
    fclose(fid);
    

    sizeLisfile = size(Lisfile);
    for i=1:sizeLisfile(2)
        if ( findstr(Lisfile{i}, 'capacitance table') > 0)
            
            break;
        end
    end
    
    
    for j = 1:sizeLisfile(2)
        if ( findstr(Lisfile{j}, '***** job concluded') > 0)
            break;
        end
    end
    
    while(i<j)
        disp(Lisfile{i})
        i = i+1;
    end
end