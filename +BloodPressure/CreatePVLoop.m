function CreatePVLoop(tv, v, tp, p, ppnr)
%CREATEPVLOOP Summary of this function goes here
%   Detailed explanation goes here

[temp mint] = BloodPressure.DeterminePeak(tp,p);
lastindex = find(tv>mint,1,'first');
[tpn pn] = BloodPressure.Interpolate(tp, p,tv);

v = [v; v(1)];
pn = [pn; pn(1)];

figure('Name', sprintf('Proefpersoon %d', ppnr));
plot(v,pn,'Color',[1 .5 0],'Marker','x','LineStyle','-','MarkerSize',8,'MarkerEdgeColor','k');
hold on;
plot(v(1:lastindex),pn(1:lastindex),'rx-','LineWidth',2,'MarkerSize',8,'MarkerEdgeColor','k');
plot([v(lastindex) v(lastindex) v(1) v(1)],[pn(lastindex) 5 5 pn(1)], 'Color', [.4 .4 .4], 'LineStyle', ':');
axis([(min(v)-20) max(v)+20 0 150]);
xlabel('Volume Linker Ventrikel (mL)');
ylabel('Arteriële Druk (mmHg)');
title(sprintf('PV Loop Proefpersoon %d', ppnr), 'FontWeight', 'BOLD');
hold off;
end

