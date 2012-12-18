function [d dp dv] = ModelWrapper(vt, v, hbt, hbp, par, nipar)
%MODELWRAPPER Summary of this function goes here
%   Detailed explanation goes here

[mt mpart mvlv mvlvtemp mplv] = Model.Circulation(par,nipar);
%[mt mpart mvlv] = funccirc(par,nipar);

% Compare arterial pressure
ipart = interp1(mt,mpart,hbt,'linear','extrap');
dp = hbp'-ipart;

% Compare lv pressure
%[temp mint] = BloodPressure.DeterminePeak(hbt,hbp);
%lastindex = find(hbt>mint,1,'first');
%iplv = interp1(mt,mplv,hbt(1:lastindex),'linear','extrap');
%dplv = hbp(1:lastindex)'-iplv;
%figure; plot(hbt(1:lastindex),hbp(1:lastindex),'b-',hbt(1:lastindex),iplv,'r-',hbt,ipart,'g:');

% Compare volume
vtimeshift = par(end);
vt = vt+vtimeshift;
ivlv = interp1(mt,mvlv,vt,'linear','extrap');
dv = v-ivlv;

%Join dp and dv
factor1 = length(dp)/length(dv);
dv = dv.*factor1;
%factor2 = length(dp)/length(dplv);
%dplv = dplv.*factor2;
d = [dv;dp']; %dplv';

%% Plotting
%{
figure;
plot(mt,mpart,hbt,hbp,hbt,dp);
legend('mpart','hbp','dp')
figure;
plot(mt,mvlv,vt,v,vt,dv);
legend('mvlv','v','dv')
%}
end