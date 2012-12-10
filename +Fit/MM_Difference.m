function [Difference] = MM_Difference(originalData,fittedData)
error = 0;                                                   % this is the starting error, that starts accumulating the difference between the data
i=1;                                                         % position in the list of the data
if length(fittedData) <= length(originalData)                % makes sure that the data with the lowest length is chosen
    while i<=length(fittedData)                              % while loop that checks the difference between the data
        error = error+(originalData(i)-fittedData(i))^2;     % keeps accumulating the absolute difference
        i = i+1;
    end
else
    while i<=length(originalData)
        error = error+(originalData(i)-fittedData(i))^2;
        i = i+1;
    end
end
Difference = error;
end

