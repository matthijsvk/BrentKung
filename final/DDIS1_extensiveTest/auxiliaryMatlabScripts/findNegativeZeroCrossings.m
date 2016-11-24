function crossings = findNegativeZeroCrossings(time,function1)

crossings = zeros(0,1);
signFunction1 = sign(function1);
for i = 2:length(function1)
    if(signFunction1(i-1) == 1 && signFunction1(i) == -1)
        crossings(end+1,1) =  interp1(function1(i-1:i),time(i-1:i),0);  %#ok<AGROW>
    elseif (signFunction1(i-1) == 0)
        if (signFunction1(i-2) ~= signFunction1(i) && signFunction1(i-2) == 1)
            crossings(end+1,1) = time(i-1);
        end
    end
end

end