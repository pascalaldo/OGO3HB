function [Rp Rart Cart] = DetermineRpRartCart(hbt, hbp, vt, v, ppnr)
%DETERMINERPRARTCART Summary of this function goes here
%   Detailed explanation goes here

[tpeak2 tmin2] = BloodPressure.DeterminePeak(hbt,hbp);
hbp = hbp./7.50061683; % Convert from mmHg to kPa

%figure(1);plot(hbt,hbp,'b-',[tpeak2 tpeak2],[0 30],'r:',[tmin2 tmin2],[0 30],'g:');
tpeak2ind = find(hbt >= tpeak2,1,'first');
tmin2ind = find(hbt >= tmin2,1,'first');

vsys = interp1(vt,v,hbt(1:tmin2ind))';
dtsys = hbt(2:(tmin2ind+1))'-hbt(1:tmin2ind)';
qart = sum(vsys.*dtsys)/(hbt(tmin2ind)-hbt(1)); % [ml/s]
part = sum(hbp(1:tmin2ind).*dtsys)/(hbt(tmin2ind)-hbt(1)); % [kPa]
Rp = part/qart;
Rp = 1000*Rp; % Convert from s to ms: [kPa.ms/ml]

Rart = 0.07*Rp; % Rule of thumb

pdia = hbp(tpeak2ind:end);
tdia = hbt(tpeak2ind:end)';
tdia = tdia-(tdia(1));
tdia = tdia.*1000; % [ms]

curve = fit(tdia,pdia,'exp1','StartPoint',[18 -0.100]);
c = coeffvalues(curve);
Cart = -1/(c(2)*Rp); % [ms]

f1 = figure(2);
plot(tdia,pdia,'b:' ,tdia,c(1).*exp(c(2).*tdia),'r-');
saveas(f1,sprintf('FitResults\\%d\\rfit_%d.fig',ppnr,ppnr));
close(f1);

end

