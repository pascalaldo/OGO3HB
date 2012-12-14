function [tcycle tact] = DetermineTime(hbt, hbp)
%This function determines tcycle and tact bases on a selected pressure
%curve (hbp) and it's corresponding time period (hbt).

%% Determine tcylce solemnly by using hbt (and applying a correction [s] -> [ms])
tcycle = hbt(length(hbt)) - hbt(1);
tcycle = tcycle*1000;

%% Determine tact defined by time between peaks of hbp by using hbp and hbt.
%Determine the mean index of the first peak (ifp)
ifp = round(mean(find(hbp == max(hbp))));

%Select a part of hbp (phbp) without left side of first peak
phbp = hbp(ifp:length(hbp));
%Determine differentials of phbp (dphbp)
dphbp = diff(phbp);
%Determine index of maximum steap near second peak (msphbp)
msphbp = round(mean(find(dphbp == max(dphbp))));

%Select a part of phbp without right side of first peak 
%(and a part of the left side of the second peak) (pphbp).
pphbp = phbp(msphbp:length(phbp));
%Determine the index of the second peak (impphbp)
impphbp = round(mean(find(pphbp == max(pphbp))));
%Determine the mean index of the first peak (isp)
isp = impphbp + ifp + msphbp;

tact = hbt(isp) - hbt(ifp) - hbt(1);
tact = tact*1000;

%% Feedback mechanisme - Plotting result for checking
%hold on
%plot(hbt,hbp)
%plot(hbt(ifp),hbp(ifp),'r*')
%plot(hbt(isp),hbp(isp),'r*')
%plot(hbt(ifp:isp),hbp(ifp:isp),'r')