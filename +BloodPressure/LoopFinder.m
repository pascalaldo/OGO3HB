function [t p] = LoopFinder(time, values, pointInTime)
%%function to determine which loop corresponds to the selected imagedata

pointInPressure = pointInTime*200; %%measurement was 200 frames/second

%% parameters
marginMinimum = 25;
marginLoop = 100;

%% Searching for minimums.
i = 1 + marginMinimum;
j = 1;
%%the program sees in a random point all points in a range from the random 
%%point minus the value of marginMinimum till the random point plus
%%the value of marginMinimum.
%%the program creats a totalscore. If the totalscore has a value larger
%%dan
%%marginMinumum multiplied with a factor. The random point is a minimum. a
%%list with minimal values is created.
minimums = zeros(round(length(values)/50));
while i <= (length(values)-marginMinimum)
    totalscore = 0;
    while j <= marginMinimum
        currentValue = values(i);
        if values(i-j) > currentValue
            totalscore = totalscore+1;
        end
        if values(i+j) > currentValue
            totalscore = totalscore+1;
        end
        j = j+1;
    end
    if totalscore > marginMinimum*1.9
        minimums(i) = i;
    end
    j = 1;
    i = i+1;
end
minimums = minimums(minimums~=0);

%% Searching for startpoints and endpoints of bloodpressureloops.
%%create a list with zeros. This list had the same length as minimums.
%%if the list is empty, determine if the minimum added with a constant
%%marginLoop is smaller than the maximum of the minimumlist. If this is
%%true, splitValues gets the value of the minimum.
%%another condition is: if the list isn't empty, determine if the minimum added 
%%with a constant marginLoop is larger than the maximum of the minimumlist. 
%%If this is true, splitValues gets the value of the minimum.
splitValues = zeros(length(minimums));
i = 1;
while i <= length(minimums);
    if isempty(splitValues) == 1 && minimums(i) + marginLoop < max(minimums)
        splitValues = minimums(i); 
    end
    if isempty(splitValues) ~= 1 && minimums(i) - marginLoop > max(splitValues(:))
        splitValues(i) = minimums(i);
    end
	i = i+1;
end
splitValues = splitValues(splitValues~=0);

%% connect the time with the bloodpressureloops.
i = 1;
loopStart = 0;
loopStop = 0;
while i <= length(splitValues)-1
    if splitValues(i) > pointInPressure && loopStart == 0;
        loopStart = splitValues(i-1);
        loopStop = splitValues(i);
    end
    i = i+1;
end

p = values(loopStart:loopStop);
t = time(loopStart:loopStop);
t = t-min(t);
end

