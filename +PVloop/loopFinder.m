function [dataLoop] = loopFinder(pointInTime,Nexfin)

if isempty(Nexfin) ~= 1
    signals = readNexfin('part',Nexfin);
else signals = readNexfin('part');
end
segment = signals.BP;
segmentTime = signals.tBP;
pointInPressure = pointInTime*200;

%% parameters
marginMinimum = 25;
marginLoop = 100;

%% Searching for minimums.
i = 1 + marginMinimum;
j = 1;
minimums = zeros(round(length(segment)/50));
while i <= (length(segment)-marginMinimum)
    totalscore = 0;
    while j <= marginMinimum
        currentValue = segment(i);
        if segment(i-j) > currentValue
            totalscore = totalscore+1;
        end
        if segment(i+j) > currentValue
            totalscore = totalscore+1;
        end
        j = j+1;
    end
    if totalscore > marginMinimum*1.8
        minimums(i) = i;
    end
    j = 1;
    i = i+1;
end
minimums = minimums(minimums~=0);

%% Searching for starts/ends of loops.
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

%% connect the time with the loops.
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

dataLoop.pressure = segment(loopStart:loopStop);
dataLoop.time = segmentTime(loopStart:loopStop);
end

