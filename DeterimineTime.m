function [tcycle, tact] = DeterimineTime(hbt, hbp)
%This function determines tcycle and tact bases on a selected pressure
%curve and it's corresponding time period.

%Determine tcylce solemnly by using time period.
tcycle = hbt(length(hbt)) - hbt(1);

%Determine tact defined by time between peaks of pressure curve by using
%pressure curve and time period.
indexfirstpeak = find(hbp == max(hbp),1,'first');