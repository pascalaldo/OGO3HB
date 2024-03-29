function [Surface] = RiemannsumPV(x,nipar)
[te1 te2 te3 x y] = Model.Circulation(x,nipar);
plot(x,y)

%% Parameters
total = 0;
minValue = min(x);
maxValue = max(x);
numBins = 50;

%% Binning of the data
binEdges = linspace(minValue, maxValue, numBins+1);
[h,whichBin] = histc(x, binEdges);
binLength = zeros(1,numBins);
for i = 1:numBins
    flagBinMembers = (whichBin == i);
    binMembers     = y(flagBinMembers);
    pressureTop    = binMembers(binMembers>sum(binMembers)/length(binMembers));
    pressureBottom = binMembers(binMembers<sum(binMembers)/length(binMembers));
    binLength(i)   = mean(pressureTop) - mean(pressureBottom);
    if isempty(pressureTop) || isempty(pressureBottom)
        binLength(i) = binLength(i-1); % Fix for empty bins
    end
end

%% Calculate the total surface
stepSize = (maxValue-minValue)/numBins;
i = 1;
total = 0;
while i <= numBins
    total = total + stepSize*binLength(i);
    hold on
    plot((minValue+stepSize*(i-1)),binLength(i));
    i = i+1;
end
Surface = total;
end

