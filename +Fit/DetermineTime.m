function [tcycle tact] = DetermineTime(hbt, hbp)
%This function determines tcycle and tact bases on a selected pressure
%curve (hbp) and it's corresponding time period (hbt).

%% IMPORTANT: PREVIOUS METHOD TO DETERMINE TACT WAS BASED ON WRONG ASSUMPTIONS.
% TO UNDERSTAND CHANGES PLEASE TAKE A CLOSE LOOK AT WIGGERS DIAGRAM
% AND THE PERIOD DURING SYSTOLIS. TO SEE THE CHANGE, THE RESULT CAN BE
% PLOTTED (SEE END OF CODE).
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

%tact = hbt(isp) - hbt(ifp) - hbt(1);
%tact = tact*1000;

%% Determine tact defined by time between start and first local minimum by using hbt and hbp
%Select first part 10% of hbp (fphbp)
fphbp = hbp(1:round((0.1*length(hbp))));
%Determine index of start
ibp = round(mean(find(fphbp == min(fphbp))));

%Select part of the curve from first peak to steapest slope of second peak
sphbp = hbp(ifp:ifp+msphbp);
%Select index of first local minimum
ilmin = round(mean(find(sphbp == min(sphbp)))) + ifp;

%Define tact [ms]
tact = hbt(ilmin) - hbt(ibp) - hbt(1);
tact = tact*1000;

%% Feedback mechanisme - Plotting result for checking
%{
figure;
hold on
plot(hbt,hbp)
plot(hbt(ibp),hbp(ibp),'r*')
plot(hbt(ilmin),hbp(ilmin),'r*')
plot(hbt(ibp:ilmin),hbp(ibp:ilmin),'r')
%}
%{
figure;
hold on
plot(hbt,hbp)
plot(hbt(ifp),hbp(ifp),'r*')
plot(hbt(isp),hbp(isp),'r*')
plot(hbt(ifp:isp),hbp(ifp:isp),'r')
%}