function [Rp Rart Cart] = DetermineRpRartCart(hbt, hbp, vt, v)
%DETERMINERPRARTCART Summary of this function goes here
%   Detailed explanation goes here

tpeak2 = BloodPressure.DeterminePeak(hbt,hbp);
plot(hbt,hbp,'b-',[tpeak2 tpeak2],[0 200],'r:');
tpeak2ind = find(hbt >= tpeak2,1,'first');

vs = interp1(vt,v,hbt(tpeak2ind:end));
qart = ;

end

