function output = getIndexNumber(timevector, timespot)
    output = 0;
    for i=2:length(timevector)
        if(timevector(i-1) < timespot && timevector(i) >timespot )
            output = i;
        end
    end
    if output == 0
        error('timespot outside of range')
    end
end
