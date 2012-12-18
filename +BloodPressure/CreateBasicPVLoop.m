function [pn v] = CreateBasicPVLoop(tv, v, tp, p, ppnr)
%CREATEPVLOOP Summary of this function goes here
%   Detailed explanation goes here

%figure;plot(tp,p);
[tpn pn] = BloodPressure.Interpolate(tp, p,tv);

v = [v; v(1)];
pn = [pn; pn(1)];

%{
figure('Name', sprintf('Proefpersoon %d', ppnr));
plot(v,pn,'Color',[1 .5 0],'Marker','x','LineStyle','-','MarkerSize',8,'MarkerEdgeColor','k');
hold on;
plot(v,pn,'rx-','LineWidth',2,'MarkerSize',8,'MarkerEdgeColor','k');
axis([(min(v)-20) max(v)+20 0 150]);
xlabel('Volume Linker Ventrikel (mL)');
ylabel('Arteriële Druk (mmHg)');
title(sprintf('PV Loop Proefpersoon %d', ppnr), 'FontWeight', 'BOLD');
hold off;
%}

end

