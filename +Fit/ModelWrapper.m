function [d dp dv] = ModelWrapper(vt, v, hbt, hbp, par, nipar)
%MODELWRAPPER Summary of this function goes here
%   Detailed explanation goes here

[mt mpart mvlv] = Model.Circulation(par,nipar);
%[mt mpart mvlv] = funccirc(par,nipar);
tcycle = nipar(2);
vtimeshift = 0;%par(end);
ptimeshift = 0;%par(end-1);

% Find the last cycle
lci = (find(mt > (max(mt)-tcycle), 1, 'first')-1);
mt = mt(lci:end);
mt = (mt-mt(1))./1000; % Convert from ms to s
mpart = mpart(lci:end).*7.50061683; % Convert from kPa to mmHg
mvlv = mvlv(lci:end);

% Apply shift
mtv = mt+vtimeshift;
mtp = mt+ptimeshift;

% Compare pressure
ipart = interp1(mtp,mpart,hbt,'linear','extrap');
dp = hbp'-ipart;

% Compare volume
ivlv = interp1(mtv,mvlv,vt,'linear','extrap');
dv = v-ivlv;

%Join dp and dv
factor = length(dp)/length(dv);
dv = dv.*factor;
d = [dp';dv];

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