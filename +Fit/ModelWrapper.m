function [dp dv] = ModelWrapper(vt, v, hbt, hbp, tcycle, par)
%MODELWRAPPER Summary of this function goes here
%   Detailed explanation goes here

[mt mpart mvlv] = Model.Circulation(par);

% Find the last cycle
lci = (find(mt > (max(mt)-tcycle), 1, 'first')-1);
mt = mt(lci:end);
mt = (mt-mt(1))./1000; % Convert from ms to s
mpart = mpart(lci:end).*7.50061683; % Convert from kPa to mmHg
mvlv = mvlv(lci:end);

% Compare pressure
ipart = interp1(mt,mpart,hbt);
dp = hbp'-ipart;

% Compare volume
ivlv = interp1(mt,mvlv,vt);
dv = v-ivlv;

%% Plotting
%{
figure;
plot(mt,mpart,hbt,hbp,hbt,dp);

figure;
plot(mt,mvlv,vt,v,vt,dv);
%}

end

