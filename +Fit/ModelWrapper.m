function [d dp dv] = ModelWrapper(vt, v, hbt, hbp, par, nipar)
%MODELWRAPPER Summary of this function goes here
%   Detailed explanation goes here

[mt mpart mvlv] = Model.Circulation(par,nipar);
%[mt mpart mvlv] = funccirc(par,nipar);

% Compare pressure
ipart = interp1(mt,mpart,hbt,'linear','extrap');
dp = hbp'-ipart;

% Compare volume
vtimeshift = par(end);
vt = vt+vtimeshift;
ivlv = interp1(mt,mvlv,vt,'linear','extrap');
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